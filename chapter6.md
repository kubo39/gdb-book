# 逆修飾

**注意** この章は今後大幅に加筆・修正される予定である。

GDBでは名前の逆修飾もサポートしている。
通常作業言語をDに選択していればデフォルトで逆修飾機能がはたらく。

```console
(gdb) demangle -l d -- _Dmain
D main
```

筆者の環境ではまだGDBのdemangleは[DMD 2.077以降の新しいマングリングルール](https://dlang.org/blog/2017/12/20/ds-newfangled-name-mangling/)に準拠していないために新しめのDMDで生成したバイナリだとdemangleできないケースがある。例えば後方参照を含むシンボルはdemangleできない。
最新のGDBではすでに対応するパッチがとりこまれているので、将来的には問題なく使える予定にはなっている。

```console
(gdb) bt
#0  _D9scopesegv3barFNaNbNfxDFNfZvZxQi (dg=...) at scopesegv.d:10
#1  0x0000555555586fe9 in D main () at scopesegv.d:15
(gdb) demangle _D9scopesegv3barFNaNbNfxDFNfZvZxQi
Can't demangle "_D9scopesegv3barFNaNbNfxDFNfZvZxQi"
```

GDCでは古いマングリングルールなので正確にdemangleできている。

```console
(gdb) bt
#0  scopesegv.bar(const(void() @safe delegate)) (dg=...) at scopesegv.d:7
#1  0x00005555555548e2 in D main () at scopesegv.d:15
(gdb) set print demangle off
(gdb) bt
#0  _D9scopesegv3barFNaNbNfxDFNfZvZxDFNfZv (dg=...) at scopesegv.d:7
#1  0x00005555555548e2 in _Dmain () at scopesegv.d:15
(gdb) demangle _D9scopesegv3barFNaNbNfxDFNfZvZxDFNfZv
scopesegv.bar(const(void() @safe delegate))
```

demangleのコードはGDBとbinutilsで共通なので, `addr2line`, `c++filt`, `nm`, `objdump` といったツール群でもdemangleが可能である。
ただし現時点でこれらのツールは `-C` や `--demangle=auto` では勝手にdemangeしてくれないので、addr2line/nm/objdumpでは `--demangle=dlang` を、c++filtは `-s dlang` もしくは `--format=dlang` を、という感じで明示的にオプションを渡す必要がある。

DMDでうまくいかないんだけど...という場合は `ddemangle` というツールを使うとだいたい最新のマングリングルールに追従しているはずなのでうまいことdemangleできるかもしれない。

コンパイラによってmanglingが変わる場合に生成したバイナリがどのコンパイラでコンパイルされたか知りたい、という状況もある。
ちゃんとしたコンパイラならDWARFの `DW_AT_producer` というセクションにどのコンパイラで生成されたのかという情報が作成され、 `readelf -wi` もしくは `objdump -g` を使って確認ができる。

```console
$ readelf -wi gdc.bin| grep DW_AT_producer
    <c>   DW_AT_producer    : (indirect string, offset: 0x1a0): GNU D 8.2.0 -mtune=generic -march=x86-64 -g
$ LANG=C readelf -wi dmd.bin| grep DW_AT_producer
    <c>   DW_AT_producer    : Digital Mars D v2.093.1
    <184>   DW_AT_producer    : (indirect string, offset: 0x1505): GNU C11 7.5.0 -mtune=generic -march=x86-64 -g -O2 -O3 -std=gnu11 -fgnu89-inline -fmerge-all-constants -frounding-math -fstack-protector-strong -fPIC -ftls-model=initial-exec -fstack-protector-strong
```
