+++
title = "Path canonicalization is unergonomic"
date = "2025-01-20"

[taxonomies]
tags = ["rust"]
+++

Rust programmers attach great importance to correctness and this is to be celebrated, but there are sometimes downsides.

Path canonicalization has become prevalent in the Rust community, for reasons which I will explain.  It is a solution to a very real problemm but I  suggest that it is not a good solution, and there is a better alternative.  I argue for increasing ergonomics at no cost in correctness.

I will discuss [what path canonicalization is](#what), [why it is in widespread use](#why), [what is unergonomic about this approach](#ergonomics), and [a more ergonomic alternative](#an-alternative).

# What

Path canonicalization is use of [`std::fs::canonicalize`](https://doc.rust-lang.org/std/fs/fn.canonicalize.html), which (to quote the documentation) returns the canonical, absolute form of a path with all intermediate components normalized and symbolic links resolved.

That is, relative paths are made absolute (with reference to the current working directory, or `cwd`), and any symbolic links along the path are resolved to their ultimate destination, with reference to the filesystem.  "Ultimate" here acknowledges that symbolic links can refer to other symbolic links.  The resolution is ruthless in expunging all such links from the resulting path.

# Why


By far the biggest reason: Breakage in parent
Using Parent in path probably means your code is broken. It should probably be deprecated.

For a thorough description of the problem, see Rob Pike's seminal paper [Getting Dot-Dot Right](https://9p.io/sys/doc/lexnames.html).

# Lorem Ipsum 1

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ligula purus, cursus consectetur pretium in, varius eu dui. Suspendisse ut eros ac nunc rhoncus hendrerit. Nam feugiat augue ut magna scelerisque suscipit. Mauris quis pulvinar tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean nec diam molestie tellus dictum fermentum at quis neque. Aliquam vehicula eu mauris ac semper.

Phasellus bibendum lobortis feugiat. Proin venenatis nisi purus, vitae suscipit dui eleifend nec. Maecenas tristique dolor et convallis mattis. In in cursus ante, sed facilisis sapien. Integer id nisi ut ipsum aliquet iaculis id et felis. Proin consectetur, dui a aliquet ultrices, dui augue faucibus enim, ut faucibus nisl velit at massa. Maecenas porttitor dapibus libero sit amet eleifend. In et ornare lectus. Suspendisse lacus urna, fringilla nec libero vitae, pharetra egestas augue. Duis vitae justo sed elit euismod molestie ut quis mauris. Mauris ut leo sed orci vehicula mollis. Nam blandit est et mauris volutpat suscipit. Vestibulum sagittis lorem eu dui eleifend, et pharetra ante aliquet. Vestibulum a dui nec diam egestas fermentum. Suspendisse pulvinar sapien et efficitur vehicula. Integer in iaculis lacus.

Praesent faucibus malesuada faucibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Morbi ultricies eu urna eget pretium. Sed quam leo, semper quis elementum vel, ultricies non neque. Donec hendrerit congue risus. Nullam porttitor luctus purus ut tincidunt. Nulla odio ex, facilisis sed rutrum eget, suscipit nec eros. Quisque fermentum blandit felis, eu congue elit tristique sit amet. Vivamus faucibus lacinia pulvinar. Aenean luctus vestibulum suscipit. Sed ac sapien augue.

Morbi imperdiet ligula lacinia, ultrices sem a, convallis arcu. Sed ultricies arcu id urna mollis, vitae tempus lorem porttitor. Morbi nec arcu faucibus, placerat metus et, tristique dui. Pellentesque metus ante, auctor a imperdiet non, suscipit nec ipsum. Sed sem dui, sagittis id arcu quis, cursus lobortis ligula. Sed fermentum quam vitae nisi tincidunt condimentum. Proin volutpat, sapien non porttitor aliquet, nulla massa ultrices lectus, et porta nunc arcu vitae magna. Nunc rhoncus a nibh sit amet rutrum.

Sed sagittis auctor mauris. Sed vehicula suscipit enim sed cursus. Pellentesque a mollis tortor. Sed pulvinar rhoncus lorem, eget rutrum turpis hendrerit id. Nulla laoreet blandit eros non sagittis. Nullam luctus turpis nulla, nec porta dolor finibus ac. Vestibulum non ipsum enim. Quisque at est ultrices, luctus lacus non, eleifend eros. Nulla imperdiet porttitor lorem ut bibendum. Sed erat arcu, convallis eget ipsum in, viverra tempus urna.

# Ergonomics
Nix, stow, symlinks as an abstraction, the benefit of relative paths.

# Lorem Ipsum 2

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ligula purus, cursus consectetur pretium in, varius eu dui. Suspendisse ut eros ac nunc rhoncus hendrerit. Nam feugiat augue ut magna scelerisque suscipit. Mauris quis pulvinar tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean nec diam molestie tellus dictum fermentum at quis neque. Aliquam vehicula eu mauris ac semper.

Phasellus bibendum lobortis feugiat. Proin venenatis nisi purus, vitae suscipit dui eleifend nec. Maecenas tristique dolor et convallis mattis. In in cursus ante, sed facilisis sapien. Integer id nisi ut ipsum aliquet iaculis id et felis. Proin consectetur, dui a aliquet ultrices, dui augue faucibus enim, ut faucibus nisl velit at massa. Maecenas porttitor dapibus libero sit amet eleifend. In et ornare lectus. Suspendisse lacus urna, fringilla nec libero vitae, pharetra egestas augue. Duis vitae justo sed elit euismod molestie ut quis mauris. Mauris ut leo sed orci vehicula mollis. Nam blandit est et mauris volutpat suscipit. Vestibulum sagittis lorem eu dui eleifend, et pharetra ante aliquet. Vestibulum a dui nec diam egestas fermentum. Suspendisse pulvinar sapien et efficitur vehicula. Integer in iaculis lacus.

Praesent faucibus malesuada faucibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Morbi ultricies eu urna eget pretium. Sed quam leo, semper quis elementum vel, ultricies non neque. Donec hendrerit congue risus. Nullam porttitor luctus purus ut tincidunt. Nulla odio ex, facilisis sed rutrum eget, suscipit nec eros. Quisque fermentum blandit felis, eu congue elit tristique sit amet. Vivamus faucibus lacinia pulvinar. Aenean luctus vestibulum suscipit. Sed ac sapien augue.

Morbi imperdiet ligula lacinia, ultrices sem a, convallis arcu. Sed ultricies arcu id urna mollis, vitae tempus lorem porttitor. Morbi nec arcu faucibus, placerat metus et, tristique dui. Pellentesque metus ante, auctor a imperdiet non, suscipit nec ipsum. Sed sem dui, sagittis id arcu quis, cursus lobortis ligula. Sed fermentum quam vitae nisi tincidunt condimentum. Proin volutpat, sapien non porttitor aliquet, nulla massa ultrices lectus, et porta nunc arcu vitae magna. Nunc rhoncus a nibh sit amet rutrum.

Sed sagittis auctor mauris. Sed vehicula suscipit enim sed cursus. Pellentesque a mollis tortor. Sed pulvinar rhoncus lorem, eget rutrum turpis hendrerit id. Nulla laoreet blandit eros non sagittis. Nullam luctus turpis nulla, nec porta dolor finibus ac. Vestibulum non ipsum enim. Quisque at est ultrices, luctus lacus non, eleifend eros. Nulla imperdiet porttitor lorem ut bibendum. Sed erat arcu, convallis eget ipsum in, viverra tempus urna.

# An alternative

Real parent

# Lorem Ipsum 3

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ligula purus, cursus consectetur pretium in, varius eu dui. Suspendisse ut eros ac nunc rhoncus hendrerit. Nam feugiat augue ut magna scelerisque suscipit. Mauris quis pulvinar tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean nec diam molestie tellus dictum fermentum at quis neque. Aliquam vehicula eu mauris ac semper.

Phasellus bibendum lobortis feugiat. Proin venenatis nisi purus, vitae suscipit dui eleifend nec. Maecenas tristique dolor et convallis mattis. In in cursus ante, sed facilisis sapien. Integer id nisi ut ipsum aliquet iaculis id et felis. Proin consectetur, dui a aliquet ultrices, dui augue faucibus enim, ut faucibus nisl velit at massa. Maecenas porttitor dapibus libero sit amet eleifend. In et ornare lectus. Suspendisse lacus urna, fringilla nec libero vitae, pharetra egestas augue. Duis vitae justo sed elit euismod molestie ut quis mauris. Mauris ut leo sed orci vehicula mollis. Nam blandit est et mauris volutpat suscipit. Vestibulum sagittis lorem eu dui eleifend, et pharetra ante aliquet. Vestibulum a dui nec diam egestas fermentum. Suspendisse pulvinar sapien et efficitur vehicula. Integer in iaculis lacus.

Praesent faucibus malesuada faucibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Morbi ultricies eu urna eget pretium. Sed quam leo, semper quis elementum vel, ultricies non neque. Donec hendrerit congue risus. Nullam porttitor luctus purus ut tincidunt. Nulla odio ex, facilisis sed rutrum eget, suscipit nec eros. Quisque fermentum blandit felis, eu congue elit tristique sit amet. Vivamus faucibus lacinia pulvinar. Aenean luctus vestibulum suscipit. Sed ac sapien augue.

Morbi imperdiet ligula lacinia, ultrices sem a, convallis arcu. Sed ultricies arcu id urna mollis, vitae tempus lorem porttitor. Morbi nec arcu faucibus, placerat metus et, tristique dui. Pellentesque metus ante, auctor a imperdiet non, suscipit nec ipsum. Sed sem dui, sagittis id arcu quis, cursus lobortis ligula. Sed fermentum quam vitae nisi tincidunt condimentum. Proin volutpat, sapien non porttitor aliquet, nulla massa ultrices lectus, et porta nunc arcu vitae magna. Nunc rhoncus a nibh sit amet rutrum.

Sed sagittis auctor mauris. Sed vehicula suscipit enim sed cursus. Pellentesque a mollis tortor. Sed pulvinar rhoncus lorem, eget rutrum turpis hendrerit id. Nulla laoreet blandit eros non sagittis. Nullam luctus turpis nulla, nec porta dolor finibus ac. Vestibulum non ipsum enim. Quisque at est ultrices, luctus lacus non, eleifend eros. Nulla imperdiet porttitor lorem ut bibendum. Sed erat arcu, convallis eget ipsum in, viverra tempus urna.
