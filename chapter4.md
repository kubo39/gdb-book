# ウォッチポイント

ウォッチポイントは普通のGDBの使い方ではあるが、これもD言語対応してる機能となっている。

ウォッチポイントはブレークポイントと似たようなものであるが、監視している変数の内容が変わったタイミングで停止する。
breakpointと違って変化した後に止まるので注意が必要である。

まず以下のようなコードを用意してデバッグ情報つきでコンパイルしておく。

```d
void main()
{
    int y = 7;
    y++;
    y++;
}
```

`watch -location` で変数を監視して内容が変わったら停止する、といった使い方をする。

```console
(gdb) start
Temporary breakpoint 1 at 0x32de4: file watch.d, line 3.
Starting program: /home/kubo39/dev/dlang/gdb-book/watch
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at watch.d:3
3	    int y = 7;
(gdb) watch -location y
Hardware watchpoint 2: -location y
(gdb) info watchpoints
Num     Type           Disp Enb Address            What
2       hw watchpoint  keep y                      -location y
(gdb) continue
Continuing.

Hardware watchpoint 2: -location y

Old value = -9424
New value = 7
D main () at watch.d:4
4	    y++;
(gdb) continue
Continuing.

Hardware watchpoint 2: -location y

Old value = 7
New value = 8
D main () at watch.d:5
5	    y++;
```
