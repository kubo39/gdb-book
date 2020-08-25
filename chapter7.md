# Tips

ここではtopicとして扱うには少々小さいテーマをまとめてTipsとして紹介する。

## `set confirm off`

CI環境でGDBを動かしたいときなどに使うことがある。

```console
$ gdb -n -ex 'set confirm off' -ex run -ex 'bt full' ex -q ./a.out
```
