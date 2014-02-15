# RETTER - A diary workflow for shell users. [![Build Status](https://drone.io/github.com/hibariya/retter/status.png)](https://drone.io/github.com/hibariya/retter/latest)

## Required

* Ruby-1.9.1 or later
* $EDITOR variable
* $BROWSER variable

## Quick Start

```
  $ gem install retter
  $ retter new my-diary       # Create a new site named `my-sweet-diary'.
  $ cd my-diary
  $ retter edit               # Write a first article w/ $EDITOR.
  $ retter preview            # Open an article you write w/ $BROWSER.
  $ retter build              # Generate static html files on publish branch (default: master).
  $ git remote add origin git@github.com:USERNAME/USERNAME.github.io.git
  $ git push origin master    # Publish static html files on GitHub pages.
```

## List, edit and preview

`retter list` lists all articles.

```
  $ retter list
  [e0] 2014-01-11
    First article
    Second article
  [e1] 2014-01-13
    Third article
```

`retter edit [KEYWORD]` opens a source with $EDITOR.

```
  $ retter edit e1         # Editing source on 2014-01-13.
  $ retter edit 2014-01-11 # Editing source on 2014-01-11.
  $ retter edit            # Editing source on Date.today.
```

### Edit and preview (with livereload)

To preview, run `retter preview`.

```
  $ retter edit # Edit and save
  $ retter preview # Invoke preview server and open last edited article with $BROWSER.
```

`retter preview` detects file updates automatically.

In other shell:

```
  $ retter edit # Edit and save
                # And $BROWSER will reload automatically.
```

## $RETTER_ROOT variable

You can use all retter commands everywhere if you set `$RETTER_ROOT` variable.
So, if `$RETTER_ROOT` is set, `retter edit` and `cd $RETTER_ROOT && retter edit` are same.

**`$RETTER_HOME` variable is deprecated.** Please use `$RETTER_ROOT`.

## Configure with $RETTER_ROOT/Retterfile

Retterfile is the configuration file for your site.

Default configuration is below:

```ruby
  configure api_revision: 1 do |config|
    # Website's root URL, title, description and author. URL is needed by feed generator.
    config.url         = 'http://retter.example.com/'
    config.title       = 'my-diary'
    config.description = 'my first diary'
    config.author      = 'hibariya'

    # Processing for `retter publish` command.
    config.publisher do
      # Uncomment it if you want to do `cd $RETTER_ROOT && git push origin master` via `retter publish`.
      # run 'git push origin master'
    end
  end
```

### Hooks

Hooks will be invoked after running commands.

```ruby
  # Print `Well done :)` after running `retter edit`.
  config.after :edit do
    puts 'Well done :)'
  end

  # Ask invoking `retter publish` after running `retter build`.
  config.after :build do
    invoke :publish if yes?('Publish now? [yes/no]')
  end
```

## Markdown structure

Following markdown file includes two articles.

```
# First article

Hi, first article.

# Second article

Hi, second article.
```

Header equal to h1 means start of an article. Like below:

```
+-- An Entry (A file) --+
|+-- An article -------+|
|| # First article     ||
||                     ||
|| Hi, first article.  ||
|+---------------------+|
|+-- An article -------+|
|| # Second article    ||
||                     ||
|| Hi, second article. ||
|+---------------------+|
+-----------------------+
```

Each article have its own URL.

## Directory structure

```
$RETTER_ROOT
  Retterfile
  source
    assets    # Asset files (stylesheets, javascripts, images and so on).
    retters   # Article markdown files.
    templates # Templates for static site.
  tmp         # Temporary files (caches, etc).
```

## Extract source branch

You can move all files (except public files) to `source` branch.

Migration example is below:

```
  $ cd $RETTER_ROOT
  $ git checkout -b source
  $ git rm -r assets entries *.{html,rss} # Removing public files from source branch
  $ git commit -m 'Remove all public files'

  $ git checkout master
  $ git rm -r Retterfile source           # Removing source files from master branch
  $ git commit -m 'Remove all source files'
```

## Install DISQUS (Comment service)

### Prepare

1. Create DISQUS Account
2. Add new site for retter

### Install

First, Add your `disqus_shortname` to Retterfile.

in Retterfile

```ruby
config.disqus_shortname = 'your_disqus_shortname'
```

Second, Edit templete and inject `= render_disqus_comment_form`.

in source/templates/entries/articles/show.html.haml

```haml
-# snip
#comments= render_disqus_comment_form
-# snip
```

## Migrate from Retter-0.2.5 or earlier

They're incompatible with retter-1.0.0.
Please migrate via `retter migrate`, or create new site.

### Migrate command

`retter migrate`  attempts to migrate to new version.

```
  $ cd $RETTER_ROOT
  $ retter migrate
  $ git add -A
  $ git add -u
  $ git commit -m 'Migrated'
  $ retter build
```

### Migrate only articles

If you can't migrate with `retter migrate`, you may want to migrate only articles. Like below.

```
  $ cd $RETTER_ROOT/../
  $ mv [site-name] old-[site-name]
  $ retter new [site-name]
  $ mv old-[site-name]/retters/* [site-name]/source/retters/
  $ # migrate git repository, and so on...
```

## Contributing

1. Fork it ( https://github.com/hibariya/retter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
