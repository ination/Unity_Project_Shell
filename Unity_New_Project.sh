#!bin/bash

#--------------------------------------------------------------
#
# 功能 创建新的unity项目，同时创建项目的目录结构
# 使用说明
#    bash Unity_New_Project.sh -n projectname -p projectpath
#
# 参数说明
#    -n  projectname  项目名称
#    -p  projectpath  项目地址
#    -v  shellversion 脚本版本号
#    -h  help         帮助
#
# 作者 iNation
#
#--------------------------------------------------------------
function useage(){
  echo ""
  echo "@brief create new unity project and project direction"
  echo ""
  echo "@param -n projectname 项目名称"
  echo "@param -p projectpath 项目地址"
  echo "@param -v show version 脚本版本号"
  echo "@param -h help 帮助"
  echo ""
  echo "@example bash Unity_New_Project.sh -n projectname -p projectpath"
  echo ""
}

function shellversion(){
  echo "unity new project shell script verison 1.0"
  echo ""
}

project_name=""
project_path=""

param_pattern=":n:p:v:h"
while getopts $param_pattern opt
do
  case "$opt" in
  "n")
      project_name=$OPTARG
      echo "----- project_name is $project_name"
      echo ""
      ;;
  "p")
      project_path=$OPTARG
      echo "----- project_path is $project_path"
      echo ""
      ;;
  "v")
      shellversion
      exit 1
      ;;
  "h")
      useage
      exit 1
      ;;
  *) 
      echo "error ! unknown error while processing options"
      exit 2
      ;;
  esac

done

#判断项目名称
if [ $project_name = "" ];then
   echo "invalid param project_name"
   useage
   exit 2
fi

#判断项目目录
if [ $project_path = "" ];then
   echo "invalid param project_path"
   useage
   exit 2
fi

#生成项目pathname
path_name=""
if [ ${project_path:0-1:1} = "/" ];then
   path_name="$project_path$project_name"
else
   path_name="$project_path/$project_name"
fi
echo "----- path_name is $path_name"

#判断项目path是否存在
if [ -d ./$path_name ];then
   echo "$project_name is exist in $project_path"
   echo ""
   exit 3
fi

#创建项目
echo ""
echo "----- begin create $path_name"
/Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -createProject $path_name -quit

echo "----- end create $path_name"

#在assets目录中生成项目目录
assetDir="$path_name/Assets"

curdir="$(pwd)"

cd $assetDir
echo "----- cd $assetDir"

game_asset_dir_of_asset="GameAssets"
asset_subdirs=("Editor" "ThirdLibraries" "$game_asset_dir_of_asset" "Plugins" "Resources" "Scenes" "Scripts" "StreamingAssets")

for i in ${!asset_subdirs[*]}
do
  asset_subdir=${asset_subdirs[$i]}
  if [ ! -d ./$asset_subdir ]; then
    mkdir $asset_subdir
    echo "  --- create $asset_subdir in Assets Dir"
  fi
done

#在GameAssets中生成子项目目录
cd $game_asset_dir_of_asset
echo "  --- cd $game_asset_dir_of_asset"

game_asset_subdirs=("Models" "Textures" "Materials" "Prefabs" "Animations" "Sounds")
for i in ${!game_asset_subdirs[*]}
do
  game_asset_subdir=${game_asset_subdirs[$i]}
  if [ ! -d ./$game_asset_subdir ]; then
    mkdir $game_asset_subdir
    echo "  --- create $game_asset_subdir in $game_asset_dir_of_asset Dir"
  fi
done
cd ..

#返回目录
cd $curdir
echo "----- cd $curdir"

#完成
echo "complete."
