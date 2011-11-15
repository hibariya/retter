# RETTER (レッター) Flyweight diary workflow.

手軽さを追求した記事作成ツール。以下のような特徴があります。

* CLIでの操作を前提としています
* どこ（cwd）にいてもすぐに記事を編集できます（Markdown）
* オフラインで簡単にプレビューできます
* だいたいどんなサーバ上でも動作します（Heroku, GitHub Pages, Dropbox などで、静的HTMLまたはRackアプリとして）
* RSSフィードを吐きます
* トラックバック、**コメント**などの機能は外部のサービスを使用できます
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

**Initial settings:**

~~~~
  $ export EDITOR=vim
  $ export RETTER_HOME=`pwd`/my_sweet_diary
~~~~

**Writing today's article:**

~~~~
  $ retter
~~~~

`retter` opens `$EDITOR`. Write an article with Markdown.

**Preview:**

~~~~
  $ retter preview
~~~~

`preview` opens the draft article by your default browser.

**Bind:**

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

**Deploy example:**

~~~~
  $ cd $RETTER_HOME
  $ git add .
  $ git commit -m 'Entry written'
  $ git push [your_git_remote] master
~~~~

To publish, use the git command. Or, upload the file to your server.

# Environment variables

**retter requires `$EDITOR` variable.**

Retterで記事を編集する際には任意のエディタが起動します。そのためには`$EDITOR`環境変数が設定されている必要があります。
大抵の場合は設定されていると思いますが、もし設定されていなければ`~/.bash_profile`や`~/.zshenv`などに追記する必要があります。

~~~~
  $ echo "export EDITOR=vim" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

## $RETTER_HOME

ファイルシステム上のどこに居ても`retter`コマンドを使って編集から公開まで行えるよう、 事前に`$RETTER_HOME`環境変数を設定することをおすすめします。

You can use `retter` command anywhere, If you set `$RETTER_HOME` variable.

~~~~
  $ echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.bash_profile
  $ . ~/.bash_profile
~~~~

作業ディレクトリにRetterfileがある場合は、そのディレクトリが`$RETTER_HOME`に指定されているものとして動作します。

# Using shortcuts

いくつかのショートカットを使い、コミットメッセージを書くことを省略したりすることができます。

~~~~
  $ retter commit # Shortcut of `git add . ; git commit -m 'Retter commit'`
  $ retter home   # Open a new shell at $RETTER_HOME
  (retter) git push [remote] [branch] # heroku, github pages, etc..
~~~~

# Specify a date

Date is specify-able in `edit` `preview` sub-command.

~~~~
  $ retter edit 20110101    # edit
  $ retter preview 20110101 # preview
~~~~

Relative date is available too.

~~~~
  $ retter edit yesterday    # 昨日
  $ retter edit today        # 今日
  $ retter edit tommorow     # 明日

  $ retter edit '3 days ago' # 3日前
  $ retter edit 3.days.ago   # 3日前
  $ retter edit 3.days.since # 3日後
  $ retter edit 1.week.ago   # 1週間前
  $ retter edit 3.weeks.ago  # 3週間前
  $ retter edit 3.months.ago # 3カ月前
  $ retter edit 3.years.ago  # 3年前
~~~~

And file name.

~~~~
  $ retter edit today.md
  $ retter edit 20110101.md
  $ retter preview 20110101.md
~~~~

# Callbacks

コールバックはいくつかのサブコマンド（edit bind rebind commit）の実行直後に自動的に実行されます。
コールバックを定義しておくことで、手数の多い割に代わり映えのしない作業を自動化することができます。

Callback is enabled in `edit`, `bind`, `rebind` and `commit` sub-command.

### Syntax

In Retterfile:

~~~~ruby
  after [command], [invoke command or proc]
~~~~

## Auto preview

記事を編集しエディタを終了したあとブラウザでプレビューしたい場合は、`edit`へのコールバックを設定できます。

In Retterfile:

~~~~ruby
  after :edit do
    preview ARGV.pop if yes?("Preview now? [yes/no]")
  end
~~~~

## Auto deploying

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

`--silent` option skip those callback.

## Run callback

`callback` sub-command runs only callback proccess.

~~~~
  $ retter callback --after edit
~~~~

## コメントシステム（DISQUS）の導入 - Install DISQUS

### Prepare

1. Create DISQUS Account
2. Add new site for retter

### Install

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

## 組込みテーマ - Pre-installed themes

スタイルシートを変更することでテーマを変更できます。HTMLのヘッダを変更するには `layouts/retter.html.haml` を編集します。
スタイルシートの指定を変更し、`retter rebind`コマンドを実行するとすべてのページが更新されます。

### Default

~~~~haml
    %link{href: '/stylesheets/default.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Default](http://hibariya.github.com/images/theme_samples/retter_default.jpg)

### Orange

~~~~haml
    %link{href: '/stylesheets/orange.css', media: 'screen', rel: 'stylesheet', type: 'text/css'}
~~~~

![Orange](http://hibariya.github.com/images/theme_samples/retter_orange.jpg)

## HTMLの修正 - HTML Layout

HTMLのレイアウト自体を変更するには`layouts/`ディレクトリ以下のHAMLファイルを修正します。
これらのファイルを変更したとしても、`retter rebind`コマンドを実行するまでは反映されません。

~~~~
layouts
  |-- article.html.haml
  |-- entries.html.haml
  |-- entry.html.haml
  |-- index.html.haml
  |-- profile.html.haml
  `-- retter.html.haml
~~~~

`retter.html.haml`はHTML宣言を含めた全体のHTMLが含まれています。
`entry.html.haml`を変更することで日別のページのレイアウトを変更することができます。
`article.html.haml`を変更することで個々の記事のレイアウトを変更することができます。
その他のファイルは実際のURLと名前が対応しています。

# LICENSE

The MIT License

Copyright (c) 2011 hibariya, uzura29

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
