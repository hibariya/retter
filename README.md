# RETTER - A diary workflow for shell users. [![Build Status](https://drone.io/github.com/hibariya/retter/status.png)](https://drone.io/github.com/hibariya/retter/latest)

## Quick Start

```
  $ gem install retter
  $ retter new my-sweet-diary # Create a new site named `my-sweet-diary'.
  $ cd my-sweet-diary
  $ retter edit               # Write a first article w/ $EDITOR.
  $ retter preview            # Open an article you write w/ $BROWSER.
  $ retter build              # Generate static html files on publish branch (default: master).
  $ git remote add origin git@github.com:USERNAME/USERNAME.github.io.git
  $ git push origin master    # Publish static html files on GitHub pages.
```

## Required

* Ruby-1.9.1 or later
* $EDITOR variable
* $BROWSER variable
* Git-1.7.9.5 or later

## $RETTER\_ROOT variable

You can use all retter commands anywhere if you set `$RETTER_ROOT` variable.
So, `export RETTER_ROOT=site-directory; retter edit` is same as `cd site-directory && retter edit`.

## Retterfile

Retterfile is the configuration file for your site.

Default configuration:

```ruby
configure api_revision: 1 do |config|
  config.url            = 'http://retter.example.com/' # Website's root URL.
  config.title          = 'my-sweet-diary'
  config.description    = 'my-sweet-diary'             # Website's description (It'll be shown on /about.html and /entries.rss)
  config.author         = 'hibariya'

  config.publisher do                                  # Processing for `retter publish` command.
    # system 'git push origin master'                  # Uncomment it if you want to do `git push origin master` via `retter publish`.
  end
end
```

**`$RETTER_HOME` variable is deprecated.** Please use `$RETTER_ROOT`.


### Hooks

Hooks will be invoked after running commands.

```ruby
configure api_revision: 1 do |config|
  # <snip...>

  # Print `Well done :)` after running `retter edit`.
  config.after :edit do
    puts 'Well done :)'
  end

  # Ask invoking `retter publish` automatically after running `retter build`.
  config.after :build do
    invoke :publish if yes?('Publish now? [yes/no]')
  end
end
```

## Manage articles

Use `retter list` and `retter edit`.

```
  $ retter list            # Listing all articles on $RETTER_ROOT.
  [e0] 2014-01-11
    First article
    Second article
  [e1] 2014-01-13
    Third article
  $ retter edit e1         # Editing articles on 2014-01-13.
  $ retter edit 2014-01-11 # Editing articles on 2014-01-11.
  $ retter edit            # Editing articles on Date.today.
```

If you want remove articles of the day, You have to remove file by yourself.

```
  $ cd $RETTER_ROOT
  $ rm source/retters/20140111.md # Removing articles on 2014-01-11.
```

### Edit and preview (w/ livereload)

To preview, invoke run `retter preview`.

```
  $ retter edit    # Edit article.
  $ retter preview # Invoke preview server and open last edited articles with $BROWSER.
```

Retter detects updates of markdown articles automatically until preview server is stopped.

In other shell:

```
  $ retter edit # Edit article (once again).
                # And $BROWSER will reload automatically.
```

### Markdown structure

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

# Install DISQUS (Comment service)

## Prepare

1. Create DISQUS Account
2. Add new site for retter

## Install

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

`retter migrate`  attempts to migrate  to new version.

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
