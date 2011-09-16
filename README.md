# RETTER (レッター) Lightweight diary workflow.

コマンドラインで簡単に起動してブラウザですぐに確認できて柔軟にデプロイできる記事作成支援コマンド。

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

**retter requires `$EDITOR` variable.**

~~~~
  $ echo "export EDITOR=vim" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

ファイルシステム上のどこに居ても `retter` コマンドを使って編集から公開まで行えるよう、 事前に `$RETTER_HOME` 環境変数を設定しておくことができます。

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

### Write an article, and publish it.

`retter` コマンドは設定されているエディタを起動します。Markdownで記事を書くことができます。

`retter` opens `$EDITOR`. Write an article with Markdown. That article will be the draft.

~~~~
  $ retter
~~~~

`preview` で書きかけの最新記事をブラウザで確認することができます（デフォルトブラウザが起動します）。

`preview` opens the draft article by your default browser.

~~~~
  $ retter preview
~~~~

`bind`, `rebind` は下書きの記事をその日の記事として保存し、すべてのHTMLを再生成します。

`bind` and `rebind` binds the draft article. And re-generates actual html web pages. All html pages will overwrite.

~~~~
  $ retter bind
~~~~


記事を公開（サーバにデプロイ）するには、すべてのファイルを git リポジトリにコミットしリモートサーバに push するか、単純にファイルをアップロードします。

To publish, use the git command.

~~~~
  $ retter commit              # shortcut of `git add . ; git commit -m 'Retter commit'`
  $ git push [remote] [branch] # heroku, github pages, etc..
~~~~

Or, upload the file to your server.

### Command callbacks

作業をさらに単純化するために、いくつかのコマンドにコールバックが設定できます。

Callback is enabled in `edit`, `bind`, `rebind` and `commit` sub-command.

In Retterfile:

~~~~ruby
  # Syntax:
  #   after [command], [invoke command or proc]

  after :rebind, :commit

  after :commit do
    system "cd #{config.retter_home}"
    system 'git push origin master'
  end
~~~~

`--silent` option skip the callback.

### Edit article (specific date).

過去や未来の日付を指定して記事を編集・プレビューするには、 `--date` オプションを用います。

`--date` option is available in `edit` `preview` sub-command.

~~~~
  retter edit --date=20110101
  retter preview --date=20110101
~~~~

### Browse offline

生成されるすべてのページは静的HTMLです。`open` でサーバにデプロイしたものとほぼ同じようにオフラインでも閲覧することができます。rackでもOK。

`open` sub-command opens your (static) website by your default browser.

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

