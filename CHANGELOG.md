# 0.2.1

## Features

* Multiple template engine support.

## Bugfix

* Fix cache bugs.
** Retter creates cache directory if not exists.

# 0.2.0

## Features

Pygments Support.

Pygments syntax highlight is now available.
To use, add a following line to Retterfile.

```ruby
renderer Retter::Renderers::PygmentsRenderer
```

## Improves

* Improved boot overhead of all command.
* Improved wait time for rebind (bind) command by cache.

# 0.0.1

It's first release.
