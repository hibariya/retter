# RETTER (レッター) Lightweight diary workflow.

コマンドラインで簡単に起動してブラウザですぐに確認できてデプロイがちょう楽そうな日記作成支援コマンドをつくる予定。

## Installation

*ruby-1.9.2* or later is required.

~~~~
  gem install retter
~~~~

## Usage

### Create a new site.

use `new` sub-command.

~~~~
  $ retter new my_sweet_diary
~~~~

### Settings

**retter required $EDITOR variable.**

~~~~
  $ echo "export EDITOR=vim" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

### Write a article, and publish.

`retter` open `$EDITOR`. Write an article with Markdown.
The article will be draft.

~~~~
  $ retter
~~~~

`preview` open the draft article by your default browser.

~~~~
  $ retter preview
~~~~

`bind` and `rebind` binds the draft article.
And re-generates actual html web pages. All html pages will overwrite.

~~~~
  $ retter bind
~~~~


To publish, use the git command.

~~~~
  $ git add .
  $ git commit -m 'commit message'
  $ git push [remote] [branch]     # heroku, github pages, etc..
~~~~

Or, upload the file to your server.

### Edit specific date article.

`--date` option is available in `edit` `preview` sub-command.

~~~~
  retter edit --date=20110101
  retter preview --date=20110101
~~~~

### Browse offline

`open` sub-command open your (static) website by your default browser.

~~~~
  $ retter open    # visit file://path/to/my_sweet_diary/index.html
~~~~

Or, Use rack if needed.

~~~~
  $ cd /path/to/my_sweet_diary
  $ bundle exec rackup
~~~~

## LICENSE

The MIT License

Copyright (c) 2011 hibariya

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

