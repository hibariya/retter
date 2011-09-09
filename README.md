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

`retter` command open $EDITOR. You can write an article with Markdown.
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


