# RETTER (レッター) Lightweight diary workflow.

コマンドラインで簡単に起動してブラウザですぐに確認できてデプロイがちょう楽そうな日記作成支援コマンドをつくる予定。

## Installation

*ruby-1.9.2* or later is required.

~~~~
  gem install retter
~~~~

## Usage

To create new site, use `new` subcommand.

~~~~
  $ retter new my_sweet_diary
~~~~

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

`retter` command open `$EDITOR`. You can write an article with Markdown.
The article will be draft.

~~~~
  $ cd /path/to/my_sweet_diary # You can skip this step if you already set $RETTER_HOME.
  $ retter
~~~~

`preview` sub-command open the draft article by your default browser.

~~~~
  $ retter preview
~~~~

`bind` and `rebind` sub-command save the draft article.
And generate actual web pages.

~~~~
  $ retter bind
~~~~

`open` sub-command open your web site by your default browser.

~~~~
  $ retter open
~~~~

You can use rack, if you needed.

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

