# 1.0.0

* Many API changes.
* Directory structure is changed (See README.md).
* Some commands are deprecated: `rebind`, `bind` and `open`.
* Some commands are removed: `commit`, `home`, `usage` and `clean`.
* Many command options are removed.
* New commands are added: `build`, `preview` and `publish`.
* Migration command `migrate` is added.

# 0.2.3

## clean sub command

`clean` sub command wraps cache clear method.

# 0.2.2

Sidebar added to built-in themes.

# 0.2.1

## Features

### Multiple template engine support.

To change, remove existing template and create new template (e.g. retter.html.haml -> retter.html.erb).

### Skipping page binding.

You can skip following pages bind.

* profile.html
* entries.html
* feed.rss

If you want, add `allow_binding` configuration to Retterfile.

```ruby
# skip all pages
allow_binding :none

# allow only entries.html and feed.html
allow_binding [:entries, :feed]
```

## Bugfix

### Fix cache bugs.

Retter creates cache directory if not exists.

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
