#define _DARWIN_C_SOURCE

#include <sys/stat.h>
#include <sys/types.h>

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PROVIDER_ID "macos-openat-quarantine-v2"
#define QUARANTINE_DIRECTORY ".certified-system-steward-quarantine"
#define MAX_QUARANTINE_ATTEMPTS 16

static void fail(const char *message) {
  fprintf(stderr, "CSS_PROVIDER_BLOCKED: %s: %s\n", message, strerror(errno));
  exit(1);
}

static void fail_plain(const char *message) {
  fprintf(stderr, "CSS_PROVIDER_BLOCKED: %s\n", message);
  exit(1);
}

static int same_identity(const struct stat *left, const struct stat *right) {
  return left->st_dev == right->st_dev && left->st_ino == right->st_ino;
}

static int safe_component(const char *component) {
  return component[0] != '\0' && strcmp(component, ".") != 0 && strcmp(component, "..") != 0;
}

static int open_directory_at(int parent_fd, const char *name, dev_t root_device, struct stat *identity) {
  int child_fd = openat(parent_fd, name, O_RDONLY | O_DIRECTORY | O_NOFOLLOW | O_CLOEXEC);
  if (child_fd < 0) fail("openat rejected a directory component");
  if (fstat(child_fd, identity) != 0) fail("fstat failed for an opened directory");
  if (!S_ISDIR(identity->st_mode)) fail_plain("opened target is not a directory");
  if (identity->st_dev != root_device) fail_plain("target crosses the workspace filesystem");
  if (identity->st_uid != geteuid()) fail_plain("target is not owned by the current user");
  return child_fd;
}

static int open_quarantine(int root_fd, dev_t root_device) {
  if (mkdirat(root_fd, QUARANTINE_DIRECTORY, 0700) != 0 && errno != EEXIST) {
    fail("quarantine directory could not be created");
  }

  struct stat named_identity;
  if (fstatat(root_fd, QUARANTINE_DIRECTORY, &named_identity, AT_SYMLINK_NOFOLLOW) != 0) {
    fail("quarantine directory could not be inspected");
  }
  if (!S_ISDIR(named_identity.st_mode)) fail_plain("quarantine path is not a directory");
  if (named_identity.st_dev != root_device) fail_plain("quarantine crosses the workspace filesystem");
  if (named_identity.st_uid != geteuid()) fail_plain("quarantine is not owned by the current user");
  if ((named_identity.st_mode & 0777) != 0700) fail_plain("quarantine permissions must be 0700");

  struct stat opened_identity;
  int quarantine_fd = open_directory_at(root_fd, QUARANTINE_DIRECTORY, root_device, &opened_identity);
  if (!same_identity(&named_identity, &opened_identity)) fail_plain("quarantine identity changed while opening");
  return quarantine_fd;
}

static void remove_directory_contents(int directory_fd, dev_t root_device) {
  int scan_fd = dup(directory_fd);
  if (scan_fd < 0) fail("dup failed for directory scan");
  DIR *directory = fdopendir(scan_fd);
  if (directory == NULL) fail("fdopendir failed");

  errno = 0;
  struct dirent *entry;
  while ((entry = readdir(directory)) != NULL) {
    const char *name = entry->d_name;
    if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0) continue;

    struct stat before;
    if (fstatat(directory_fd, name, &before, AT_SYMLINK_NOFOLLOW) != 0) {
      if (errno == ENOENT) continue;
      fail("fstatat failed inside cleanup target");
    }

    if (S_ISDIR(before.st_mode)) {
      struct stat opened;
      int child_fd = open_directory_at(directory_fd, name, root_device, &opened);
      if (!same_identity(&before, &opened)) fail_plain("directory identity changed before traversal");
      remove_directory_contents(child_fd, root_device);

      struct stat current;
      if (fstatat(directory_fd, name, &current, AT_SYMLINK_NOFOLLOW) != 0) {
        close(child_fd);
        fail("directory disappeared before removal");
      }
      if (!same_identity(&opened, &current)) {
        close(child_fd);
        fail_plain("directory identity changed before removal");
      }
      if (close(child_fd) != 0) fail("close failed for child directory");
      if (unlinkat(directory_fd, name, AT_REMOVEDIR) != 0) fail("unlinkat failed for child directory");
    } else {
      struct stat current;
      if (fstatat(directory_fd, name, &current, AT_SYMLINK_NOFOLLOW) != 0) {
        if (errno == ENOENT) continue;
        fail("entry disappeared before removal");
      }
      if (!same_identity(&before, &current)) fail_plain("entry identity changed before removal");
      if (unlinkat(directory_fd, name, 0) != 0) {
        if (errno == ENOENT) continue;
        fail("unlinkat failed for target entry");
      }
    }
    errno = 0;
  }
  if (errno != 0) fail("readdir failed");
  if (closedir(directory) != 0) fail("closedir failed");
}

static void make_quarantine_name(char *destination, size_t capacity, const struct stat *identity) {
  uint32_t nonce = arc4random();
  int written = snprintf(
      destination,
      capacity,
      "css-%llu-%llu-%ld-%08x",
      (unsigned long long)identity->st_dev,
      (unsigned long long)identity->st_ino,
      (long)getpid(),
      nonce);
  if (written < 0 || (size_t)written >= capacity) fail_plain("quarantine token is too long");
}

static int move_to_quarantine(
    int parent_fd,
    const char *final_name,
    int quarantine_fd,
    const struct stat *target_identity,
    char *quarantine_name,
    size_t quarantine_name_capacity) {
  int moved = 0;
  for (int attempt = 0; attempt < MAX_QUARANTINE_ATTEMPTS; attempt += 1) {
    make_quarantine_name(quarantine_name, quarantine_name_capacity, target_identity);
    if (renameatx_np(parent_fd, final_name, quarantine_fd, quarantine_name, RENAME_EXCL) == 0) {
      moved = 1;
      break;
    }
    if (errno != EEXIST) fail("exclusive rename into quarantine failed");
  }
  if (!moved) fail_plain("could not allocate an exclusive quarantine token");

  struct stat quarantined_identity;
  if (fstatat(quarantine_fd, quarantine_name, &quarantined_identity, AT_SYMLINK_NOFOLLOW) != 0) {
    fail("quarantined target could not be inspected");
  }
  if (!same_identity(target_identity, &quarantined_identity)) {
    fail_plain("exclusive rename moved a different target identity");
  }

  struct stat replacement;
  if (fstatat(parent_fd, final_name, &replacement, AT_SYMLINK_NOFOLLOW) == 0) return 1;
  if (errno != ENOENT) fail("original target name could not be checked after quarantine");
  return 0;
}

static void remove_quarantine_if_empty(int root_fd) {
  if (unlinkat(root_fd, QUARANTINE_DIRECTORY, AT_REMOVEDIR) == 0) return;
  if (errno == ENOENT || errno == ENOTEMPTY || errno == EBUSY) return;
  fail("empty quarantine directory could not be removed");
}

int main(int argc, char **argv) {
  if (argc != 3) fail_plain("usage: macos-safe-remove WORKSPACE_ROOT RELATIVE_TARGET");
  const char *root = argv[1];
  const char *relative = argv[2];
  if (root[0] != '/' || relative[0] == '/' || relative[0] == '\0' || strlen(relative) >= PATH_MAX) {
    fail_plain("root or relative target is malformed");
  }

  char path_copy[PATH_MAX];
  memcpy(path_copy, relative, strlen(relative) + 1);
  char *components[PATH_MAX / 2];
  size_t component_count = 0;
  char *cursor = path_copy;
  char *component;
  while ((component = strsep(&cursor, "/")) != NULL) {
    if (!safe_component(component)) fail_plain("relative target contains an unsafe component");
    if (component_count >= PATH_MAX / 2) fail_plain("relative target has too many components");
    components[component_count++] = component;
  }
  if (component_count == 0) fail_plain("relative target is empty");

  const char *final_name = components[component_count - 1];
  if (strcmp(final_name, ".lake") != 0 && strcmp(final_name, "node_modules") != 0) {
    fail_plain("final target is not an admitted cache class");
  }

  int root_fd = open(root, O_RDONLY | O_DIRECTORY | O_NOFOLLOW | O_CLOEXEC);
  if (root_fd < 0) fail("workspace root could not be opened");
  struct stat root_identity;
  if (fstat(root_fd, &root_identity) != 0) fail("workspace root could not be identified");
  if (!S_ISDIR(root_identity.st_mode)) fail_plain("workspace root is not a directory");
  if (root_identity.st_uid != geteuid()) fail_plain("workspace root is not owned by the current user");

  int quarantine_fd = open_quarantine(root_fd, root_identity.st_dev);
  int parent_fd = root_fd;
  for (size_t index = 0; index + 1 < component_count; index += 1) {
    struct stat ignored;
    int next_fd = open_directory_at(parent_fd, components[index], root_identity.st_dev, &ignored);
    if (parent_fd != root_fd && close(parent_fd) != 0) fail("close failed while walking target");
    parent_fd = next_fd;
  }

  struct stat named_identity;
  if (fstatat(parent_fd, final_name, &named_identity, AT_SYMLINK_NOFOLLOW) != 0) {
    fail("cleanup target could not be inspected before quarantine");
  }
  struct stat target_identity;
  int target_fd = open_directory_at(parent_fd, final_name, root_identity.st_dev, &target_identity);
  if (!same_identity(&named_identity, &target_identity)) fail_plain("target identity changed before quarantine");

  char quarantine_name[NAME_MAX + 1];
  int source_reappeared = move_to_quarantine(
      parent_fd,
      final_name,
      quarantine_fd,
      &target_identity,
      quarantine_name,
      sizeof(quarantine_name));

  remove_directory_contents(target_fd, root_identity.st_dev);

  struct stat current_identity;
  if (fstatat(quarantine_fd, quarantine_name, &current_identity, AT_SYMLINK_NOFOLLOW) != 0) {
    fail("quarantined target disappeared before final removal");
  }
  if (!same_identity(&target_identity, &current_identity)) {
    fail_plain("quarantined target identity changed before final removal");
  }
  if (close(target_fd) != 0) fail("close failed for target directory");
  if (unlinkat(quarantine_fd, quarantine_name, AT_REMOVEDIR) != 0) {
    fail("unlinkat failed for quarantined target directory");
  }
  if (parent_fd != root_fd && close(parent_fd) != 0) fail("close failed for parent directory");
  if (close(quarantine_fd) != 0) fail("close failed for quarantine directory");
  remove_quarantine_if_empty(root_fd);
  if (close(root_fd) != 0) fail("close failed for workspace root");

  printf(
      "{\"removed\":true,\"quarantined\":true,\"sourceReappeared\":%s,\"provider\":\"%s\"}\n",
      source_reappeared ? "true" : "false",
      PROVIDER_ID);
  return 0;
}
