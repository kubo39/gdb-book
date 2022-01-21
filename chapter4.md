# ウォッチポイント

ウォッチポイントは普通のGDBの使い方ではあるが、これもD言語対応してる機能となっている。

ウォッチポイントはブレークポイントと似たようなものであるが、監視している変数の内容が変わったタイミングで停止する。
breakpointと違って変化した後に止まるので注意が必要である。

まず以下のようなコードを用意してデバッグ情報つきでコンパイルしておく。

```d
struct S
{
    int x;
    float y;
}

void main()
{
    auto s = S();
    s.x = 42;
    s.y = 1.41;
    s.x++;
}
```

```console
$ dmd -g watch.d
```

`watch -location` で変数を監視して内容が変わったら停止する、といった使い方をする。

```console
$ gdb -q --nx watch
Reading symbols from watch...
(gdb) start
Temporary breakpoint 1 at 0x430e8: file ./watch.d, line 33.
Starting program: /home/kubo39/dev/dlang/gdb-book/watch
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at ./watch.d:33
33          auto s = S();
(gdb) watch -location s
Hardware watchpoint 2: -location s
(gdb) continue
Continuing.

Hardware watchpoint 2: -location s

Old value = {x = -13019, y = 4.59163468e-41}
New value = {x = 0, y = 4.59163468e-41}
0x00005555555970ed in D main () at ./watch.d:33
33          auto s = S();
(gdb) c
Continuing.

Hardware watchpoint 2: -location s

Old value = {x = 0, y = 4.59163468e-41}
New value = {x = 0, y = nan(0x400000)}
D main () at ./watch.d:34
34          s.x = 42;
(gdb) c
Continuing.

Hardware watchpoint 2: -location s

Old value = {x = 0, y = nan(0x400000)}
New value = {x = 42, y = nan(0x400000)}
D main () at ./watch.d:35
35          s.y = 1.41;
(gdb) print s.x
$1 = 42
```

`disable`を使って一時的にwatchpointを無効にすることなどができる。
この例であればdisableを使った後continueしても `s.x++` の変更は検知せずにバイナリの実行が終了する。

```console
(gdb) info watchpoints
Num     Type           Disp Enb Address            What
2       hw watchpoint  keep y                      -location s
        breakpoint already hit 3 times
(gdb) disable 2
(gdb) c
Continuing.
[Inferior 1 (process 5588) exited normally]
```
