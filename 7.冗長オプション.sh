#!/bin/bash

# より詳細な情報を求めるオプション


#---------------------------------------------------------------------

# 例: コマンド -v --verbose

# デフォルト
verbose=0

while [[ $# -gt 0 ]]
do
  case "$1" in

  -v|--verbose|-vv|-vvv)
    ((++verbose)) # 1増やす
    [[ $1 = -vv ]] && ((++verbose)) # さらに
    [[ $1 = -vvv ]] && ((++verbose,++verbose)) # さらにさらに
    shift 1
    ;;

  # オプションでもその引数でもないもの(オペランド)
  *) # その他なんでもマッチ
    operand[${#operand[@]}]=$1 # 配列に追加
    shift 1
    ;;

  esac
done


#---------------------------------------------------------------------

if [ $verbose = 1 ]; then
  echo "長い説明"
elif [ $verbose = 2 ]; then
  echo "長さが長い説明"
elif [ $verbose -ge 3 ]; then
  echo "長さも説明も冗長な解説というかデバッグ情報"
fi

