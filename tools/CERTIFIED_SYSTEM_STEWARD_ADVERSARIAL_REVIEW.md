# Certified System Steward / adversarial review AR-01

## Decision

The runtime no longer performs recursive deletion through a resolved pathname.
The macOS provider opens the workspace and every directory component with
`openat`, `O_DIRECTORY` and `O_NOFOLLOW`, then removes entries relative to held
directory descriptors with `unlinkat`.

## Threat matrix

| Scene | Runtime decision | Evidence |
|---|---|---|
| `..` or absolute target | reject in passport and provider | target never enters `ActionField` |
| target is a symlink | reject before execution | component walk uses `O_NOFOLLOW` |
| symlink inside admitted cache | unlink the link, never traverse it | `fstatat(..., AT_SYMLINK_NOFOLLOW)` |
| nested mount / other device | reject | every opened directory must retain root `st_dev` |
| foreign-owner target | reject | every traversed directory must match effective uid |
| directory identity changes | reject | `st_dev + st_ino` checked before traversal and removal |
| plan or protected kernel changes | reject before apply | second observation must match intent |
| postcondition fails | do not advance canonical `HEAD` | failure record only |

## External shoulders

- [MITRE CWE-367](https://cwe.mitre.org/data/definitions/367.html) defines the
  time-of-check/time-of-use weakness and recommends binding checks more closely
  to use, rechecking results and limiting interleaving.
- [macOS `unlinkat(2)`](https://manp.gs/mac/2/unlink) removes a directory entry
  relative to an already opened directory descriptor.
- [macOS `fstatat(2)`](https://manp.gs/mac/2/stat) supplies metadata relative to
  a directory descriptor and supports no-follow inspection.
- [macOS symbolic-link semantics](https://manp.gs/mac/7/symlink) distinguish
  calls that operate on links from calls that follow them.

## Red boundary

This provider narrows pathname races; it does not prove the kernel, filesystem,
compiler or endpoint honest. A final name can still change between identity
comparison and `unlinkat`; replacement with a non-empty directory fails closed,
but the remaining race requires a stronger quarantine/rename protocol or an
OS-enforced delete capability before production status.
