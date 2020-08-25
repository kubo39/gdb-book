# はじめに

## 準備

gdbのインストールをしておく。

筆者の環境は以下のようになっている。

```console
$ gdb --version
GNU gdb (Ubuntu 8.2-0ubuntu1~18.04) 8.2
Copyright (C) 2018 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

次にD言語のコンパイラを用意する。
ここではリファレンスコンパイラであるDMDの入手方法を記載しているが、GDCあるいはLDCを使ってもかまわない。

```console
$ curl -fsS https://dlang.org/install.sh | bash -s dmd
```

執筆時点でのD言語環境は以下のとおりである。

```console
$ dmd --version
DMD64 D Compiler v2.093.1
Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved written by Walter Bright
```
