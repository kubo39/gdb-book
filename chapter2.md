# 基本操作

まず非常に簡単なプログラムでGDBの基本操作を試してみよう。

以下のプログラムをデバッグオプションつきでビルドする。

```d
int fib(int n)
{
    if (n < 2) return n;
    else return fib(n - 1) + fib(n - 2);
}

void main()
{
    auto result = fib(10);
    assert(result == 55);
}
```

DMDでデバッグオプションを付与する場合はコマンドラインに `-g` を加える。

```console
$ dmd -g fibonacci.d
```

実際にデバッグ情報つきでビルドされているか確認するには `file` コマンドが便利である。 `with debug_info` が表示されているかで確認できる。

```console
$ file fibonacci
fibonacci: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=511fc1f6afbf4bb6bd93ba5e3d05da19edd82710, with debug_info, not stripped
```

次にGDBを起動してデバッグシンボルつきのバイナリを読み込む。

```console
$ gdb -q --nx fibonacci # 説明のため.gdbinitを読み込まないように
(...)
```

普通はデバッグ情報から `DW_AT_language` を読み取って自動でlanguageの設定をやってくれるのだけど、 `set langauge` で明示的に指定することも可能である。

```console
(gdb) show language
The current language is "auto; currently d".
(gdb) set language d
(gdb) show language
The current language is "d".
```

Cのプログラムから生成されたバイナリで `start` を使うと `main` 関数までで実行を中断するが、 `language d` が設定されている場合は `D main` まですすんでから中断する。

ここで行情報やソースコードの情報が取得できていることが確認できる。

```console
(gdb) start
Temporary breakpoint 1 at 0x43164: file ./fibonacci.d, line 33.
Starting program: /home/kubo39/dev/dlang/gdb-book/fibonacci
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at ./fibonacci.d:33
33          auto result = fib(10);
```

`step` でfib関数の中へ入ってみる。
ちゃんと関数の中に入っていることが確認できる。

```console
(gdb) step
fibonacci.fib(int) (n=10) at ./fibonacci.d:27
3	    if (n < 2) return n;
```

`next` や `finish` もちゃんと動くことが確認できる。

```console
(gdb) next
4	    else return fib(n - 1) + fib(n - 2);
(gdb) finish
Run till exit from #0  fibonacci.fib(int) (n=10) at ./fibonacci.d:28
0x0000555555586e92 in D main () at ./fibonacci.d:9
9	    auto result = fib(10);
Value returned is $1 = 55
```

今度は `breakpoint` 使ってみる。
再度プログラムを `start` した後に `breakpoint` をfib関数に設定する。

```console
(gdb) break fibonacci.d:fibonacci.fib(int)
Breakpoint 4 at 0x555555592c97: file ./fibonacci.d, line 27.
```

そのままプログラムを実行するコマンド `run` を使うと `breakpoint` で設定した箇所で実行を中断する。

```console
(gdb) run
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /home/kubo39/dev/dlang/gdb-book/fibonacci
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 2, fibonacci.fib(int) (n=10) at ./fibonacci.d:27
27          if (n < 2) return n;
```

GDBは `quit` コマンドで終了する。

```console
(gdb) quit
(...)
Debugger finished
```
