+++
title = "Path canonicalization is unergonomic"
date = "2025-01-20"

[taxonomies]
tags = ["rust"]
+++

# Why?
By far the biggest reason: Breakage in parent
Using Parent in path probably means your code is broken. It should probably be deprecated.

# Ergonomics
Nix, stow, symlinks as an abstraction, the benefit of relative paths.

# An alternative
Real parent
