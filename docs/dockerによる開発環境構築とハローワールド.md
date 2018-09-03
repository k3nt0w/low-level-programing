# 【低レベルプログラミング】docker による実行環境構築とハローワールド 【その１】

お久しぶりです．

エンジニアとして強くなるために低水準言語をちゃんと理解したくなり，
最近[低レベルプログラミング](http://amzn.asia/d/0wGhnsd)を購入しました．

初心者には割と敷居が高い印象を受けましたが，知らない単語は調べつつ読み進めています．

そして忘れないためにも，この本から学んだことを記録として残していこうと思います．  
シリーズ化しますので続いてなかったら挫折したか死んだかのどっちかだと思ってください．

本記事の内容は全て以下の[レポジトリ](https://github.com/k3nt0w/low-level-programing)に push していますので，適宜参考にしてみてください．

また，この<font color=orange>記事の本文</font>も上のレポジトリに push しています．
もし間違いや読みにくい文章等がございましたら issue を立てるなり PR を上げるなりしていただけると泣いて喜びます．

よろしくお願いします．

## 目次

1. docker を用いた実行環境構築
2. 簡単なアセンブリを書いてハローワールド

本記事では実行環境構築に焦点をあて，
アセンブリの詳細な解説は次の記事で行います．

## 1. docker を用いた実行環境構築

この本では`Debian GNU\Linux 8.0`の環境を推奨されていますが，
いつも触っている Macbook で実行したいので Docker を使って環境を整えます．

まずは Dockerfile を作成します．
書籍の実行環境となるべく揃えたいのでイメージは`debian:8`を使用しましょう．

C 言語のコンパイラである gcc 等も後々必要になるようですが，最初はミニマムで進めていこうと思います．

```Dockerfile
FROM debian:8

RUN apt-get update \
  apt-get install -y binutils nasm gdb \
  apt-get install -y vim
```

それではこの Dockerfile から docker イメージを作成しましょう．

```sh
$ docker build -t low-level-programming .
```

これでイメージが作成されました．
以上で実行環境構築は終了です．
ホントに docker は最高ですねー

## 2. 簡単なアセンブリを書いてハローワールド

早速ハローワールドを出力するアセンブリを書いてみましょう．
と，言っても書籍のコード丸写しです．

元コードは書籍の p28 のリスト 2-4 です．

```avrasm
section .data
message: db 'hello, world!', 10

section .text
global _start

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, message
  mov rdx, 14
  syscall

  mov rax, 60
  xor rdi, rdi
  syscall
```

現状，高級言語しか知らない自分には本当に何が書いてあるかわからないです笑

冒頭でも書きましたが，このコードの解説は次の記事で行います．

では，アセンブル<a href="#1">\*1</a>して実行してみましょう．

先ほど作った実行環境にアセンブリを保存しているワーキングディレクトリをマウントします．

```sh
$ docker run -it -v $(pwd):/work low-level-programming bash
```

あとはコンパイルして実行するのみです．

```sh
$ cd work
$ nasm -felf64 hello.asm -o hello.o
$ ld -o hello hello.o
$ ./hello
```

はい，以下のようにちゃんとハローワールドが出力できましたね．

```sh
root@97e9cd2fd7da:/work# ./hello
hello, world!
```

## まとめ

- 手を動かすために docker で実行環境を整えました．
- アセンブリで`hello, world!`を出力しました．

以上です．

次回は本記事で書いたハローワールドを読み解いていきます．

### 参考

本記事の内容は以下の記事を大いに参考にしています．
有益な記事ありがとうございました．

[書籍「低レベルプログラミング」アセンブリ実行 Docker 環境の構築](https://qiita.com/nirasan/items/0cd03c24a8e6d0e5f8be)

<span id="1" style="font-size:small">1: アセンブラを機械語にコンパイルすること</span>
