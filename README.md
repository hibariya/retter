# RETTER (レッター) Flyweight diary workflow.

手軽さを追求した記事作成ツール。以下のような特徴があります。

* CLIでの操作を前提としています
* どこ（cwd）にいてもすぐに記事を編集できます（Markdown）
* オフラインで簡単にプレビューできます
* だいたいどんなサーバ上でも動作します（静的HTMLまたはRackアプリとして）
* RSSフィードを吐きます
* トラックバック、コメントなどの機能はありません
* コールバックを設定することでさらに手数を減らすことができます

## インストール - Installation

*ruby-1.9.2* or later is required.

~~~~
  gem install retter
~~~~

## 使い方 - Usage

### 新規サイト生成 - New site

`retter new`で新しいサイトのひな形を生成し、依存ライブラリをインストールし、gitリポジトリを初期化します。

~~~~
  $ retter new my_sweet_diary
~~~~

生成するファイルはHAMLテンプレート、設定ファイル、デフォルトのCSS、Rackアプリ用の設定などです。

### 初期設定 - Settings

#### $EDITOR

**retter requires `$EDITOR` variable.**

Retterで記事を編集する際には任意のエディタが起動します。そのためには`$EDITOR`環境変数が設定されている必要があります。
大抵の場合は設定されていると思いますが、もし設定されていなければ`~/.bash_profile`や`~/.zshenv`などに追記する必要があります。

~~~~
  $ echo "export EDITOR=vim" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

#### $RETTER_HOME

ファイルシステム上のどこに居ても`retter`コマンドを使って編集から公開まで行えるよう、 事前に`$RETTER_HOME`環境変数を設定します。

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

作業ディレクトリにRetterfileがある場合は、そのディレクトリが`$RETTER_HOME`に指定されているものとして動作します。

### 記事を書く - Write an article

`retter`コマンドは設定されているエディタを起動します。今のところMarkdown形式で記事を書くことができます。

`retter` opens `$EDITOR`. Write an article with Markdown.

~~~~
  $ retter
~~~~

記事をひと通り書き終えたり確認したくなったら、エディタの機能で記事を保存して終了してください。
保存された記事は、その段階ではまだ下書きの状態です。

### プレビュー - Preview

下書きの記事を確認するには`preview`サブコマンドを使います（デフォルトブラウザが起動します）。

`preview` opens the draft article by your default browser.

~~~~
  $ retter preview
~~~~

気に入らない箇所を見つけたらページを閉じて、また`retter`コマンドで記事を編集します。
満足のいく文章が出来上がるまで編集とプレビューを繰り返しましょう。


### 記事の生成 - Bind

下書きが完成したら、記事をそのサイトのページとして生成します。
`bind`, `rebind` は下書きの記事をその日の記事として保存し、すべてのHTMLを再生成します。

`bind` and `rebind` binds the draft article. And re-generates actual html web pages. All html pages will be overwritten.

~~~~
  $ retter bind
~~~~

### サイト全体の確認 - Browse Offline

生成されるすべてのページは静的HTMLですから、オフラインでも自分のマシンで全体的な見栄えを確認できます。
`open`サブコマンドはデフォルトブラウザを起動してサイトのトップページを開きます。

`open` sub-command opens your (static) website by your default browser.

~~~~
  $ retter open
~~~~

デプロイ先のサーバではRackアプリとして起動しているということであれば、rackupで確認しましょう。

~~~~
  $ retter home # `home` opens a new shell in $RETTER_HOME.
  (retter) bundle exec rackup
~~~~

### 記事の公開 - Publish

記事をインターネット上に公開するには、必要なすべてのファイルを git リポジトリにコミットしリモートサーバに push、または単純にファイルをアップロードします。

To publish, use the git command. Or, upload the file to your server.

#### Basic flow

最も原始的な方法は、gitコマンドを直接使う方法です。

~~~~
  $ cd $RETTER_HOME
  $ git add .
  $ git commit -m 'commit message'
  $ git push [remote] [branch]     # heroku, github pages, etc..
~~~~

#### Using shortcut commands

いくつかのショートカットを使い、コミットメッセージを書くことを省略したりすることができます。

~~~~
  $ retter commit # Shortcut of `git add . ; git commit -m 'Retter commit'`
  $ retter home   # Open a new shell at $RETTER_HOME
  (retter) git push [remote] [branch] # heroku, github pages, etc..
~~~~

後述するコールバックを設定しておくことで、さらに手数を減らすことも可能です。

### 特定の日付の記事を編集する - Edit article (specific date).

昨日、明日、過去や未来の日付を指定して記事を編集・プレビューするには、 `--date` オプションを用います。

`--date` option is available in `edit` `preview` sub-command.

~~~~
  retter edit --date 20110101
  retter preview --date 20110101
~~~~

### コールバック - Callbacks

コールバックはいくつかのサブコマンド（edit bind rebind commit）の実行直後に自動的に実行されます。
コールバックを定義しておくことで、手数の多い割に代わり映えのしない作業を自動化することができます。

Callback is enabled in `edit`, `bind`, `rebind` and `commit` sub-command.

#### Syntax

~~~~ruby
  after [command], [invoke command or proc]
~~~~

#### HTMLの生成時、デプロイまでの作業を自動化する - Auto deploying

以下のような内容を Retterfile に記述しておくことで、rebind または bind が実行されると即座に公開までの処理も実行されます。

In Retterfile:

~~~~ruby
  after :rebind, :commit # git commit

  after :commit do       # deploy
    system "cd #{config.retter_home}"
    system 'git push origin master'
  end
~~~~

もし毎回デプロイするのが煩わしい場合は、`--silent`オプションを付けることでコールバックを回避できます。
その場合は`retter rebind`ではなく`retter rebind --silent`を実行することになります。

`--silent` option skip the callback.

#### エディタを終了したとき即座にプレビューする - Auto preview

記事を編集しエディタを終了したあとブラウザでプレビューしたい場合は、`edit`へのコールバックを設定できます。

~~~~ruby
  after :edit do
    preview if yes?("Preview now? [yes/no]")
  end
~~~~

もしもコールバックを毎回実行したくない場合、`--silent`を指定する以外に、上記のようには確認プロンプトを表示させるという方法もあります。

### 組込みテーマ - Pre-installed themes

スタイルシートを変更することでテーマを変更できます。HTMLのヘッダを変更するには `layouts/retter.html.haml` を編集します。
スタイルシートの指定を変更し、`retter rebind`コマンドを実行するとすべてのページが更新されます。

#### Default

~~~~haml
    %link{href: '/stylesheets/default.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Default](http://hibariya.github.com/images/theme_samples/retter_default.jpg)

#### Orange

~~~~haml
    %link{href: '/stylesheets/orange.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Orange](http://hibariya.github.com/images/theme_samples/retter_orange.jpg)

### HTMLの修正 - HTML Layout

HTMLのレイアウト自体を変更するには`layouts/`ディレクトリ以下のHAMLファイルを修正します。
これらのファイルを変更したとしても、`retter rebind`コマンドを実行するまでは反映されません。

~~~~
layouts
  |-- entries.html.haml
  |-- entry.html.haml
  |-- index.html.haml
  |-- profile.html.haml
  `-- retter.html.haml
~~~~

`retter.html.haml`はHTML宣言を含めた全体のHTMLが含まれています。
`entry.html.haml`を変更することで記事のレイアウトを変更することができます。
その他のファイルは実際のURLと名前が対応しています。

## LICENSE

The MIT License

Copyright (c) 2011 hibariya

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
