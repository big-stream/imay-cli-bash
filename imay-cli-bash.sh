#!/bin/bash
#
# imay-cli-bash.shは、コマンドの雛形シェルスクリプト(Bash)
#
# パブリック・ドメイン: CC0 1.0
# https://creativecommons.org/publicdomain/zero/1.0/deed.ja


# 全体を関数で囲っているので、どこでもlocal変数を使える
スクリプトスタート(){ # <- ファイル末尾で実行している
#===============================================================================


# スクリプトのフルパス
local script=$( readlink -e ${BASH_SOURCE[0]} )

# スクリプトがあるディレクトリのフルパス
local script_dir=${script%/*}

# --version: コマンドのバージョン
local version='1.2.3'


#-------------------------------------------------------------------------------

# エラーで終了させるとき呼び出す

# 引数1: エラーメッセージ
エラー()
{
  # 「エラー:」が色付き、 ${script##*/}はスクリプトのファイル名
  echo -e "\e[1;31mエラー:\e[m" "${script##*/}: $1" 1>&2 # 標準エラー出力
  # 終了ステータスを1以外にするなら引数2に指定
  [[ $2 ]] && exit $2 || exit 1
}


#-------------------------------------------------------------------------------

# コマンド情報を表示して終了するオプション

# --help: ヘルプメッセージ表示
ヘルプ()
{
cat << END
ファイル(未指定なら標準入力)を..するスクリプト

使い方:
  ${script##*/} [オプション]... [ファイル・ディレクトリ]...

オプション:
  -o, --output 出力ファイル
  -n, --number 0以上の自然数
  -v, --verbose, -vv, -vvv
	長い説明
その他オプション(引数なし):
  -d, --debug		デバッグ用
  -h, --help		このヘルプ
  -V, --version		バージョン情報
  -い, --依存		依存ライブラリ確認
  -ら, --ライセンス	ライセンス文書
  -☺ , --感謝
END
}

# --version: バージョン情報表示
バージョン()
{
  cat << END
$script $version
©  2018 だれだれ
ライセンス: なんとかライセンス (詳しくは ${script##*/} --ライセンス)
END
}

# --ライセンス: ライセンス文書表示
ライセンス()
{
  # 変えないとパブリック・ドメインになるよ
  cat << END
パブリック・ドメイン: CC0 1.0
https://creativecommons.org/publicdomain/zero/1.0/deed.ja
END
}

# --依存: 依存する外部コマンドがインストール済みか確認
commands=(sed grep) # 依存コマンドのリスト
依存コマンド確認()
{
  local no e
  for e in "${commands[@]}"
  do
    type -f $e 2>/dev/null || no[${#no[@]}]=$e
  done
  [[ $no ]] && エラー "インストールされていない依存コマンド:${no[*]}"
  echo "依存コマンドはインストール済み"
}


#-------------------------------------------------------------------------------

# オプションの検証

local number
numberオプション()
{
  number=$1
  # 自然数の正規表現 ^(0|[1-9][0-9]*)$
  [[ $number =~ ^(0|[1-9][0-9]*)$ ]] || エラー "オプション: --number: 0から始まる自然数を指定: $number"
}

local output
outputオプション()
{
  output=$1
  [[ -e $output ]] && エラー "ファイルが存在: $output"
}

local verbose=0
verboseオプション()
{
  ((++verbose)) # 1増やす
  [[ $1 = -vv ]] && ((++verbose)) # さらに
  [[ $1 = -vvv ]] && ((++verbose,++verbose)) # さらにさらに
}

local operand
オペランド()
{
  [[ -f $1 || -d $1 ]] || エラー "ファイル・ディレクトリでない: $1"
  operand[${#operand[@]}]=$1 # 配列に追加
}


#-------------------------------------------------------------------------------

# whileとcase文でオプション解析

# しくみ:
# shiftコマンドでぞれぞれの引数の番号をずらす(減らす)
# 「shift 1」で、引数2を引数1へ、引数3を引数2へ..

# 未処理の引数がある限り継続するwhile
while [[ $# -gt 0 ]] # $#は(未処理の)引数の数
do
  # 引数1($1)がどれかのパターンにマッチしたらその処理後、shiftで引数をずらす
  case "$1" in

  # 引数があるオプション
  -n|--number)
    [[ $2 ]] || エラー "$1には引数が必要"
    numberオプション "$2"
    shift 2 # 引数を2ずらす
    ;;
  -o|--output)
    [[ $2 ]] || エラー "$1には引数が必要"
    outputオプション "$2"
    shift 2
    ;;

  # 引数がないオプション
  -h|--help) # -hか--helpにマッチ
    ヘルプ
    exit 0 # ヘルプ表示してすぐ終了
    ;;
  -v|--verbose|-vv|-vvv)
    verboseオプション "$1"
    shift 1 # 引数を1ずらす
    ;;
  -V|--version)
    バージョン
    exit 0 
    ;;
  -ら|--ライセンス)
    ライセンス
    exit 0 
    ;;
  -い|--依存)
    依存コマンド確認 
    exit 0 
    ;;
  -☺|--感謝)
    echo "どういたしまして☺"
    exit 0 
    ;;
  "")
    shift 1 # 空の引数は無視
    ;;

  # 不明なオプションを禁止するなら
  -*) # 上記以外の-から始まるものにマッチ
    エラー "不明なオプション: $1"
    ;;

  # オプションでもその引数でもないもの(オペランド)
  *) # その他なんでもマッチ
    オペランド "$1"
    shift 1
    ;;
  esac
done

# 依存チェックするなら
依存コマンド確認 >/dev/null


#-------------------------------------------------------------------------------

# 指定されたオプションによって処理を分岐

# デフォルト
[[ $number ]] || number=1

[[ $number ]] && echo "--number: $number"

[[ $output ]] && echo "--output: $output"

[[ $verbose ]] && echo "--verbose: レベル$verbose"


#-------------------------------------------------------------------------------

# オペランド(ファイル)必須の場合
#[[ ${#operand[@]} -gt 0 ]] || エラー "ファイルの指定がない"

# オペランド(ファイル)か標準入力必須の場合
#[[ ${#operand[@]} -gt 0 || -p /dev/stdin ]] || エラー "標準入力かファイルの指定が必要"

# カレントディレクトリの移動はファイルパスの扱いに注意
# cd "$script_dir"


ファイル入力()
{
  cat "$operand" # スペースの含むファイル名などに対応して""で囲む
}

標準入力()
{
  cat
}

# オペランド優先
if [ ${#operand[@]} -gt 0 ]; then
  for operand in "${operand[@]}"
  do
    ファイル入力
  done
elif [ ! -p /dev/stdin ]; then
  echo "ファイル入力も標準入力もない"
else
  標準入力
fi


#===============================================================================
} # ここはスクリプトスタート関数の終わり

スクリプトスタート "$@" # 引数全部を関数に渡す

