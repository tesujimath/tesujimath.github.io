+++
title = "Path canonicalization is unergonomic"
date = "2025-01-20"

[taxonomies]
tags = ["rust"]
+++

Rust programmers attach great importance to correctness and this is to be celebrated, but there are sometimes downsides.

Path canonicalization has become prevalent in the Rust community, for reasons which I will explain.  It is a solution to a very real problemm but I  suggest that it is not a good solution and there is a better alternative.  I argue for increasing ergonomics at no cost in correctness.

I will discuss [what path canonicalization is](#what), [why it is in widespread use](#why), [what is unergonomic about this approach](#ergonomics), and [a more ergonomic alternative](#an-alternative).

# What

Path canonicalization is use of [`std::fs::canonicalize`](https://doc.rust-lang.org/std/fs/fn.canonicalize.html) aka [`Path::canonicalize`](https://doc.rust-lang.org/std/path/struct.Path.html#method.canonicalize), which (to quote the documentation) returns the canonical, absolute form of a path with all intermediate components normalized and symbolic links resolved.

That is, relative paths are made absolute (with reference to the current working directory, or `cwd`), and any symbolic links along the path are resolved to their ultimate destination, with reference to the filesystem.  "Ultimate" here acknowledges that symbolic links can refer to other symbolic links.  The resolution is ruthless in expunging all such links from the resulting path.

Eager and early path canonicalization has become a common pattern in Rust programs.

# Why

By far the the biggest reason for eager and early path canonicalization is to mitigate breakage in finding a parent directory, or the containing directory of a file.

The Rust standard library method [`Path::parent`](https://doc.rust-lang.org/std/path/struct.Path.html#method.parent) determines this purely lexically, that is without reference to the filesystem.  Using this method on anything other than a canonicalized path could lead to an incorrect result.

The problem arises when the last component in the path is a symbolic link. In that case, the parent or containing directory must be determined from the ultimate target of the symbolic link.

For a thorough description of the problem, see Rob Pike's seminal paper [Getting Dot-Dot Right](https://9p.io/sys/doc/lexnames.html).

Here's a simple example. Suppose that we have a configuration file format that supports file inclusion, so `main.cfg` contains the text `include "included.cfg"`

Perhaps we have a symbolic link to such a configuration.

```
/absolute/path/to/cwd/
│
├── a/
│   └── main.cfg ⟶ ../b/main.cfg
│
└── b/
    ├── main.cfg
    └── included.cfg
```

How should the program process the configuration file `a/main.cfg`?

Here's the wrong way to do it.

```
Path::new("a/main.cfg")
    .parent()
    .unwrap()
    .join("included.cfg")

// returns "a/included.cfg", which doesn't exist
```

Here's a common solution to this problem.

```
        Path::new("a/main.cfg")
            .canonicalize()
            .unwrap()
            .parent()
            .unwrap()
            .join("included.cfg")

// returns "/absolute/path/to/cwd/b/included.cfg", which is correct but unergonomic
```

# Ergonomics

Ergonomics is about efficiency and comfort.  So what is unergonomic about using `Path::canonicalize()` to mitigate this potential problem?  Two things.

1. relative paths are discarded in favour of absolute paths

2. symbolic links are ruthlessly resolved and eliminated

## Relative Paths

Relative paths enjoy the benefits of portability and simplicity.  Who has the luxury of the same absolute path for home directories on all their systems, or their project directories?

## Symbolic Links

Symbolic links are arguably a filesystem abstraction.  Using symbolic links, a view can be constructed for many and varied reasons.  Violating this abstraction by peeking inside the links is rude at best.

Two examples of systems making extensive use of symbolic links are [Nix](https://nixos.org/) and [GNU Stow](https://www.gnu.org/software/stow/).

[Nix Home Manager](https://nix-community.github.io/home-manager/) brings the declarative and unified approach of Nix to managing one's home configuration, dotfiles, scripts, etc. Using Home Manager, all the usual dotfiles become symbolic links into the Nix store.  For example:

```
> ls -l .config/nushell/*.nu
.config/nushell/config.nu -> /nix/store/mkfxkxgjsb81ad68rgyx2bzgq51rvw6b-home-manager-files/.config/nushell/config.nu
.config/nushell/env.nu -> /nix/store/mkfxkxgjsb81ad68rgyx2bzgq51rvw6b-home-manager-files/.config/nushell/env.nu
```

It would be most uncomfortable if these Nix store paths became exposed to applications, or worse, stored in application configuration, not least because the paths in the Nix store depend on their content and so may be expected to change across Home Manager generations.

# An alternative

If the goal is both correctness _and_ ergonomics, what can be done?

One answer is to abandon the standard library [`Path::parent`](https://doc.rust-lang.org/std/path/struct.Path.html#method.parent) method and instead determine the parent directory of a file with reference to the filesystem.  Special handling is required only in the case where the final path component is a symbolic link.  Otherwise relative paths and symbolic links may be retained, as they do not affect the result.

This is exactly what my [`real_parent`](https://docs.rs/real_parent/) crate does.  With reference to the configuration example above:

```
Path::new("a/main.cfg")
    .real_parent()
    .unwrap()
    .join("included.cfg")

// returns "b/included.cfg", which is both correct and ergonomic
```

The `real_parent` Path extension method is reluctant to resolve symbolic links or relative paths unless this is required for correctness.


## History

The [`real_parent`](https://docs.rs/real_parent/) crate was originally created with the intention of [improving the ergonomics around path handling in Nushell](https://github.com/nushell/nushell/pull/13243). That PR was subsequently abandoned because it didn't fit that particular case after all.  (The Nushell developers have worked hard to maintain an illusion of `cwd` per thread, which is undeniably convenenient in a multi-threaded shell, if somewhat jarring for anyone familiar with the Linux process environment, in which a single `cwd` for each process is maintained by the operating system.)

The [`real_parent`](https://docs.rs/real_parent/) crate hasn't yet seen much use.  I welcome feedback from the community.
The best documentation of its behaviour in various edge cases is its extensive [test suite](https://github.com/tesujimath/real_parent/blob/main/tests/path_ext.rs).
