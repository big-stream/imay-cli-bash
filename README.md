# imay-cli-bash

imay-cli-bash.shを見本に、コマンドっぽいシェルスクリプトを作ろう。


## なにこれ?

- シェルスクリプト(Bash)でコマンドツールを作るときの雛形
- 初心者のための解説コメント付き


## 自由にいいの?

- パブリックドメイン: [CC0 1.0][]を適用
- 自由にコピー改変し、目的のツール本体の処理を組み入れて、任意のライセンスを適用すべし


## よくわからないとき

「1.全体を関数で囲む.sh」から眺めて実行してみよう


### 基本用語

#### コマンドオプション

-(ハイフン)から始まる文字列をコマンドに渡して動作調整する、こんな感じ

    ./シェルスクリプト --help --output ファイル -v

#### 標準入力

直前のコマンドの出力を|(パイプ)で受け取って利用する、こんな感じ

    echo 'abc' | ./シェルスクリプト


[CC0 1.0]: https://creativecommons.org/publicdomain/zero/1.0/deed.ja

