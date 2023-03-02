# 式と型

GDB内では[bison](https://www.gnu.org/software/bison/)を使ってDのサブセットをパースし評価を行っている。

そのため簡単な式評価やプリミティブな型情報の取得も可能だが、コンパイラ内部のような複雑な
意味解析を行っているわけではないので等価に表現できないことに注意する必要がある。

## 式・プロパティ

* ふつうにできるケース (castとかpow演算子とかsizeofとか)

```console
(gdb) print cast(ubyte) -1
$1 = 255
(gdb) print 2 ^^ 2
$2 = 4
(gdb) print int.sizeof
$3 = 4
```

* かっこならいけるケース (値に対するsizeof)

```console
(gdb) print 4.sizeof
Invalid number "4.sizeof".
(gdb) print (4).sizeof
$5 = 4
```

* ぜんぜんだめなケース (連想配列リテラルとかスライスとか)

```console
(gdb) print [1:1]
A syntax error in expression, near `:1]'.
(gdb) print ([1:1])
A syntax error in expression, near `:1])'.
(gdb) print "hoge"[1 .. $]
A syntax error in expression, near `. $]'.
(gdb) print ("hoge"[1 .. $])
A syntax error in expression, near `. $])'.
```

## 型

いくつかのプリミティブな型は `ptype` を使うことででD固有の型情報を取得できる。
たとえば以下のように整数リテラルに `_` が入っていたりサフィックスに `UL` をつけているものを判定できる。

```console
(gdb) ptype 0x0_1
type = int
(gdb) ptype 0UL
type = ulong
```

`typeof` を使うこともできる。

```console
(gdb) ptype typeof(1UL)
type = ulong
(gdb) ptype typeof(cast(ubyte) 1)
type = ubyte
```
