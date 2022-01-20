# 逆修飾

GDBでは名前の逆修飾もサポートしている。
通常作業言語をDに選択していればデフォルトで逆修飾機能がはたらく。

```console
(gdb) demangle -l d -- _Dmain
D main
```

GDB 11.2ではD言語のdemangleは[DMD 2.077以降の新しいマングリングルール](https://dlang.org/blog/2017/12/20/ds-newfangled-name-mangling/)に準拠している。

以下のログでは `segv.bar` が正しくdemangleできていることが確認できる。

```console
$ gdb -q --nx segv
Reading symbols from segv...
(gdb) start
Temporary breakpoint 1 at 0x42f08: file ./segv.d, line 33.
Starting program: /home/kubo39/dev/dlang/gdb-book/segv
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Temporary breakpoint 1, D main () at ./segv.d:33
33          bar();
(gdb) cont
Continuing.

Program received signal SIGSEGV, Segmentation fault.
segv.bar() () at ./segv.d:28
28          *tmp = 42;
(gdb) bt
#0  segv.bar() () at ./segv.d:28
#1  0x0000555555596f0d in D main () at ./segv.d:33
```

ちなみにdemangleのコードはGDBとbinutilsで共通なので, `addr2line`, `c++filt`, `nm`, `objdump` といったツール群でもdemangleが可能である。
ただし現時点でこれらのツールは `-C` や `--demangle=auto` では勝手にdemangeしてくれないので、addr2line/nm/objdumpでは `--demangle=dlang` を、c++filtは `-s dlang` もしくは `--format=dlang` を、という感じで明示的にオプションを渡す必要がある。

DMDでうまくいかないんだけど...という場合は `ddemangle` というツールを使うとだいたい最新のマングリングルールに追従しているはずなのでうまいことdemangleできるかもしれない。

コンパイラによってmanglingが変わる場合に生成したバイナリがどのコンパイラでコンパイルされたか知りたい、という状況もある。
ちゃんとしたコンパイラならDWARFの `DW_AT_producer` というセクションにどのコンパイラで生成されたのかという情報が作成され、 `readelf -wi` もしくは `objdump -g` を使って確認ができる。

```console
)$ LANG=C readelf -wi fibonacci| grep DW_AT_producer
    <c>   DW_AT_producer    : Digital Mars D v2.098.1
    <184>   DW_AT_producer    : (indirect string, offset: 0x1505): GNU C11 7.5.0 -mtune=generic -march=x86-64 -g -O2 -O3 -std=gnu11 -fgnu89-inline -fmerge-all-constants -frounding-math -fstack-protector-strong -fPIC -ftls-model=initial-exec -fstack-protector-strong
```
