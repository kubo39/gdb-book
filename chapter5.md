# リバースデバッギング

GDBはバージョン7.0からstepやcontinueのリバースデバッギングをサポートしている。

Glibc環境でD言語でプログラムを書いた場合、ユーザがスレッドを生成していない場合においてもデフォルトの状態ではdruntimeがGCのためにスレッドを使っており `libpthread.so` とリンクしてしまうために、そのままでは `reverse-step` や `reverse-next` を使うことができない。

規模の小さいプログラムでは `run` して `start` しなおしてもよいが、大きいプログラムの場合はこまめに `breakpoint` を設定するか `record` を設定しておいたほうがよいだろう。

第二章で使ったfibonacciプログラムにおいて `record` を使った場合は以下のように操作できる。

```console
(gdb) start
Temporary breakpoint 1 at 0x32e88: file fibonacci.d, line 9.
Starting program: /home/kubo39/dev/dlang/gdb-book/fibonacci
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at fibonacci.d:9
9	    auto result = fib(10);
(gdb) record
(gdb) next
10	    assert(result == 55);
(gdb) reverse-next
fibonacci.fib(int) (n=2) at fibonacci.d:4
4	    else return fib(n - 1) + fib(n - 2);
```
