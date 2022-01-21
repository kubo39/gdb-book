# リバースデバッギング

GDBはバージョン7.0からstepやcontinueのリバースデバッギングをサポートしている。

Glibc環境でD言語でプログラムを書いた場合、ユーザがスレッドを生成していない場合においてもデフォルトの状態ではdruntimeがGCのためにスレッドを使っており `libpthread.so` とリンクしてしまうために、そのままでは `reverse-step` や `reverse-next` を使うことができない。

規模の小さいプログラムでは `run` して `start` しなおしてもよいが、大きいプログラムの場合はこまめに `breakpoint` を設定するか `record` を設定しておいたほうがよいだろう。

第二章で使ったfibonacciプログラムにおいて `record` を使った場合は以下のように操作できる。

```console
(gdb) start
Temporary breakpoint 1 at 0x3ecd4: file fibonacci.d, line 33.
Starting program: /home/kubo39/dev/dlang/gdb-book/fibonacci
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at fibonacci.d:33
33	    auto result = fib(10);
(gdb) record
(gdb) step
fibonacci.fib(int) (n=10) at fibonacci.d:27
27	    if (n < 2) return n;
(gdb) n
28	    else return fib(n - 1) + fib(n - 2);
(gdb) reverse-next
27	    if (n < 2) return n;
```

この状態で `continue` すると以下のような表示が出て実行が停止する。

```console
(gdb) continue
Continuing.

No more reverse-execution history.
fibonacci.fib(int) (n=10) at fibonacci.d:28
28	    else return fib(n - 1) + fib(n - 2);
```

これを解除するためには `record stop` を使えばよい。

```console
(gdb) record stop
Process record is stopped and all execution logs are deleted.
(gdb) c
Continuing.
[Inferior 1 (process 30753) exited normally]
```

実際にはリバースデバッギングを行う際は[rr](https://rr-project.org/)を用いることになるであろう。

rrは記録と再生でコマンドが別れている。
バイナリの実行記録を保存する際は `rr record` コマンドを使う。

```console
$ rr record ./fibonacci
rr: Saving execution to trace directory `/home/kubo39/.local/share/rr/fibonacci-0'.
```

記録した実行のトレース結果は何度でも再生できる。
記録の再生には `rr replay` コマンドを使う。

gdbのように `record` を使わなくても `reverse-step` が使えていることが確認できる。
また、変数の内容も期待したとおりに戻っていることも確認できる。

```console
$ rr replay -- -q --nx
(...)
(rr) start
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Temporary breakpoint 1 at 0x5636f89ca164: file ./fibonacci.d, line 33.
Starting program: /home/kubo39/.local/share/rr/fibonacci-0/mmap_hardlink_3_fibonacci

Program stopped.
0x00007f6c37b57090 in ?? () from /lib64/ld-linux-x86-64.so.2
(rr) continue
Continuing.

Temporary breakpoint 1, D main () at ./fibonacci.d:33
33          auto result = fib(10);
(rr) step
fibonacci.fib(int) (n=10) at ./fibonacci.d:27
27          if (n < 2) return n;
(rr) p n
$1 = 10
(rr) step
28          else return fib(n - 1) + fib(n - 2);
(rr) p n
$2 = 10
(rr) step
fibonacci.fib(int) (n=9) at ./fibonacci.d:27
27          if (n < 2) return n;
(rr) p n
$3 = 9
(rr) reverse-step
28          else return fib(n - 1) + fib(n - 2);
(rr) p n
$4 = 10
```

rrはgdbのリバースデバッギング機能に比べ格段に高速に動作するので、基本的にはrrの使用を推奨する。
