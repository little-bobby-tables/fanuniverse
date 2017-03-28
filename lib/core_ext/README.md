# Core extensions

Core extensions add additional behavior to third-party gems
(including Rails) and Ruby Standard Library.

**If you need to override an existing method (not add a new one),
create a new module and #prepend it.** This gives you access
to the inheritance chain (`super`) and ensures that
the module shows up in a stacktrace when an error occurs.

## Adding new extensions

Just create a new file in *lib/core_ext*.
