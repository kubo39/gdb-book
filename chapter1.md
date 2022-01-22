# はじめに

## 準備

### GDB

gdbのダウンロードおよびインストールを行う。

ビルドを行う際にCコンパイラ等が必要となるので各環境で用意しておく。

ここでは2022/01/20時点で最新版のGDB 11.2を使って以降の操作を行う。

```console
$ wget https://ftp.gnu.org/gnu/gdb/gdb-11.2.tar.gz
$ tar xvf gdb-11.2.tar.gz
$ cd gdb-11.2
```

ここからはインストール箇所によって説明を分けて行う。

まずmake installを行わない場合。

```
$ # data-directoryをインストールした場所参照にする
$ ./configure --with-gdb-data-directory=$HOME/gdb-11.2/gdb/data-directory
$ make
```

この場合、これ以降の説明は環境変数PATHを変更して行っているものとする。

```console
$ export PATH="$HOME/gdb-11.2/gdb:$PATH"
```

次にmake installは--prefixを指定する場合。/usr/localに入れる場合は未指定でもよい。

```console
$ # make installを行う際、既存のgdbのパスを上書きしたくない場合などは ./configure 時に--prefixを指定しておく
$ ./configure --prefix=/path/to/dir
$ make
$ make install
```

prefixを指定した場合は適宜PATHを通しておく。

最後にバージョン情報を表示してビルドが成功しているか確認する。

```console
$ gdb --version
GNU gdb (GDB) 11.2
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

### D言語

次にD言語のコンパイラを用意する。
ここではリファレンスコンパイラであるDMDの入手方法を記載しているが、GDCあるいはLDCを使ってもかまわない。

```console
$ curl -fsS https://dlang.org/install.sh | bash -s dmd
```

執筆時点でのD言語環境は以下のとおりである。

```console
$ dmd --version
DMD64 D Compiler v2.098.1
Copyright (C) 1999-2021 by The D Language Foundation, All Rights Reserved written by Walter Bright
```
