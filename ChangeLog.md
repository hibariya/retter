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
