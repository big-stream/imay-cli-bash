#!/bin/bash

# ファイル指定の例


#---------------------------------------------------------------------

# catやlsコマンドのように、ファイルをいくつか指定するコマンド
# オプションの引数ではなく、オペランドで指定するケース

while [[ $# -gt 0 ]] # $#は(未処理の)引数の数
do
  case "$1" in

  # 不明なオプションを禁止するなら
  -*)
    echo "不明なオプション: $1"
    exit 1 # エラーで終了
    ;;

  # オプションでもその引数でもないもの(オペランド)
  *) # その他なんでもマッチ
    operand[${#operand[@]}]=$1 # 配列に追加
    # この段階でファイルの存在確認をする場合
    [[ -f "$1" ]] || { echo "そんなファイルない: $1"; exit 1; }
    shift 1
    ;;

  esac
done


#---------------------------------------------------------------------

# オペランド必須の場合
[[ ${#operand[@]} -gt 0 ]] || { echo "ファイルの指定がない"; exit 1; }

ファイル入力()
{
  ls "$operand" # スペースの含むファイル名などに対応して""で囲む
}

for operand in "${operand[@]}"
do
  ファイル入力
done


#---------------------------------------------------------------------

# スクリプトは別のディレクトリから実行されるかもしれない
# カレントディレクトリの移動はファイルパスの扱いに注意

# スクリプトのフルパス
script=$( readlink -e ${BASH_SOURCE[0]} )
# スクリプトがあるディレクトリのフルパス
script_dir=${script%/*}

# ここから見た相対パスと
cd "$script_dir"
# ここから見た相対パスは違うかもしれない

