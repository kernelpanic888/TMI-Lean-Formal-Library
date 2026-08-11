# Certified System Steward / adversarial review AR-02

## Decision

The provider no longer recursively deletes through the public target name.
It opens the target, moves that exact directory into a private `0700`
quarantine with `renameatx_np(..., RENAME_EXCL)`, verifies the moved identity,
and erases it through held directory descriptors.

```text
named target = d
  -> exclusive rename(target, quarantine/token)
  -> identity(quarantine/token) = d
  -> erase(fd(d))
  -> original name absent
```

If the original name reappears, the replacement is not touched and the runtime
rejects the transition instead of advancing canonical `HEAD`.

## Threat matrix

| Scene | Runtime decision | Evidence |
|---|---|---|
| `..` or absolute target | reject in passport and provider | target never enters `ActionField` |
| target is a symlink | reject before execution | component walk uses `O_NOFOLLOW` |
| symlink inside admitted cache | unlink the link, never traverse it | `fstatat(..., AT_SYMLINK_NOFOLLOW)` |
| quarantine path is a symlink | reject before target movement | quarantine is opened with `O_NOFOLLOW` |
| quarantine is not private | reject before target movement | owner and mode `0700` are mandatory |
| destination token already exists | retry with a new token | `RENAME_EXCL` never overwrites |
| public target name reappears | reject transition, preserve replacement | deletion continues only through quarantined identity |
| nested mount / other device | reject | every opened directory retains root `st_dev` |
| foreign-owner target | reject | every traversed directory matches effective uid |
| directory identity changes | reject | `st_dev + st_ino` checked across open, rename and removal |
| plan or protected kernel changes | reject before apply | second observation must match intent |
| postcondition fails | do not advance canonical `HEAD` | failure record only |

## External shoulders

- [MITRE CWE-367](https://cwe.mitre.org/data/definitions/367.html) defines the
  time-of-check/time-of-use weakness and recommends binding checks more closely
  to use, rechecking results and limiting interleaving.
- [Apple volume capability documentation](https://developer.apple.com/documentation/foundation/urlresourcevalues/volumesupportsexclusiverenaming)
  identifies filesystem support for the `RENAME_EXCL` operation.
- [macOS `renameatx_np(2)`](https://www.manpagez.com/man/2/renamex_np/osx-10.12.3.php)
  specifies that `RENAME_EXCL` returns `EEXIST` rather than replacing an existing
  destination.
- [macOS `unlinkat(2)`](https://manp.gs/mac/2/unlink) removes an entry relative
  to an already opened directory descriptor.
- [macOS `fstatat(2)`](https://manp.gs/mac/2/stat) supplies descriptor-relative,
  no-follow metadata.

## Red boundary

The public source-name race no longer redirects deletion to a replacement.
This does not prove the kernel, filesystem, compiler or endpoint honest. A
malicious concurrent process with the same uid can still attempt to discover
and mutate the private quarantine namespace. Closing that stronger threat model
requires privilege separation, a sandboxed helper or an OS delete-by-handle
capability. Independent adversarial review remains required before production
status.
