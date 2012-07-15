# RETTER - Flyweight diary workflow. [![Build Status](https://secure.travis-ci.org/hibariya/retter.png?branch=master)](http://travis-ci.org/hibariya/retter)

手軽さを追求した記事作成ツール。

* CLIでの操作を前提としています
* どこ（cwd）にいてもすぐに記事をMarkdownで編集できます
* オフラインで簡単にプレビューできます
* だいたいどこでも動作します（Heroku, GitHub Pages, Dropbox などで、静的HTMLまたはRackアプリとして）
* RSSフィードを吐きます
* トラックバック、**コメント**などの機能は外部のサービスを使う必要があります
* コールバックを設定することでさらに手数を減らすことができます

# Quick Start

*ruby-1.9.2* or later is required.

**Install:**

~~~~
  gem install retter
~~~~

**Generate a new site:**

~~~~
  $ retter new my_sweet_diary
~~~~

**Quick settings:**

~~~~
  $ export EDITOR=vim
  $ export RETTER_HOME=`pwd`/my_sweet_diary
~~~~

**Writing article:**

~~~~
  $ retter
~~~~

`retter` opens `$EDITOR`. Write an article with Markdown.

**Preview:**

~~~~
  $ retter preview
~~~~

`preview` opens the draft article by your default browser.

**Generate HTML:**

~~~~
  $ retter rebind
~~~~

`bind` and `rebind` binds the draft article. And re-generates actual html web pages. All html pages will be overwritten.

**Browse offline:**

~~~~
  $ retter open
~~~~

`open` sub-command opens your (static) website by your default browser.

**Show Articles list:**

~~~~
  $ retter list
  [e0] 2011-11-09
    my sweet article title
~~~~

**Re-writing an article:**

~~~~
  $ retter edit e0
  ... abbr ...
  $ retter preview e0
~~~~

**How to Deploy**

examle:

~~~~
  $ cd $RETTER_HOME
  $ git add .
  $ git commit -m 'Entry written'
  $ git push [your_git_remote] master
~~~~

To publish, use the git command. Or, upload the file to your server.

# Environment variables

**Important**

retter requires `$EDITOR` variable.

## $RETTER_HOME

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

You have to cd to the directory, If you don't set `$RETTER_HOME` variable.

~~~~
  $ cd path/to/my_sweet_diary
  $ retter
~~~~

# Using shortcuts

~~~~
  $ retter commit # Shortcut of `git add . ; git commit -m 'Retter commit'`
  $ retter home   # Open a new shell at $RETTER_HOME
  (retter) git push [remote] [branch] # heroku, github pages, etc..
~~~~

# Command options

Date is specify-able in `edit` `preview` sub-command.

~~~~
  $ retter edit 20110101    # edit
  $ retter preview 20110101 # preview
~~~~

Relative date is available too.

~~~~
  $ retter edit yesterday
  $ retter edit today
  $ retter edit tommorow

  $ retter edit '3 days ago'
  $ retter edit 3.days.ago
  $ retter edit 3.days.since
  $ retter edit 1.week.ago
  $ retter edit 3.weeks.ago
  $ retter edit 3.months.ago
  $ retter edit 3.years.ago
~~~~

And file name.

~~~~
  $ retter edit today.md
  $ retter edit 20110101.md
  $ retter preview 20110101.md
~~~~

# Callbacks

Some command (edit bind rebind commit) will call callback if you defined callbacks.

In Retterfile:

~~~~
  after [command], [invoke command or proc]
~~~~

## Example1: Auto preview

In Retterfile:

~~~~ruby
  after :edit do
    ident = ARGV.pop || 'today'
    preview ident if yes?("Preview now? [yes/no]")
  end
~~~~

## Example2: Auto deploying

In Retterfile:

~~~~ruby
  after :rebind, :commit # git commit

  after :commit do       # deploy
    system "cd #{config.retter_home}"
    system 'git push origin master'
  end
~~~~

## Skipping callback

`--silent` option skips those callback.

## Run callback

`callback` sub-command runs only callback proccess.

~~~~
  $ retter callback --after edit
~~~~

# Install DISQUS (Comment tool)

## Prepare

1. Create DISQUS Account
2. Add new site for retter

## Install

First, Add your `disqus_shortname` to Retterfile.

in Retterfile

~~~~ruby
disqus_shortname 'your_disqus_shortname'
~~~~

Second, Edit templete and paste `render_disqus_comment_form`.

in layouts/article.html.haml

~~~~haml
-# abbrev
#comments= render_disqus_comment_form
-# abbrev
~~~~

# Code Highlight

Pygments is available.
To use, add a following line to Retterfile.

```ruby
renderer Retter::Renderers::PygmentsRenderer
```

# Remove caches

When change the renderer, you have to remove cache files.

```
  $ retter clean
```

# Built-in themes

Retter has some themes.
You can switch the theme by replacing stylesheet.

## Default

~~~~haml
    %link{href: '/stylesheets/default.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Default](http://hibariya.github.com/images/theme_samples/retter_default.jpg)

## Orange

~~~~haml
    %link{href: '/stylesheets/orange.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Orange](http://hibariya.github.com/images/theme_samples/retter_orange.jpg)

# HTML Layout

To customize layout, edit following files.

~~~~
layouts
  |-- article.html.haml # Article page
  |-- entries.html.haml # Entries list page
  |-- entry.html.haml   # Entry (by day) page
  |-- index.html.haml   # Front page
  |-- profile.html.haml # Profile page
  `-- retter.html.haml  # Basic layout
~~~~

# Skipping page binding

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

# Other template engines

If you want change the template engine, remove existing template and create new template (e.g. retter.html.haml to retter.html.erb).

# LICENSE

The MIT License

Copyright (c) 2011 hibariya, uzura29

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
