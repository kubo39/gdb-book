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
