#!/bin/bash
loginfo() { echo "[INFO] $@"; }
logerror() { echo "[ERROR] $@" 1>&2; }

python3 src/script.py "home" "book"
rm -rf node_modules/gitbook-plugin-tbfed-pagefooter
gitbook install
python3 src/script.py "home" "powered"
python3 src/script.py "home" "gitalk"
gitbook build ./ _book
# python3 src/script.py "home" "index"

# 稳定版本越新，放到最前面 (0.5.0 是最新最稳定的版本，0.6.0 是正在更新的版本，就可以放到 0.5.0 后面)
# versions=("0.5.0" "0.4.0" "master" "0.6.0")
versions=("0.5.0" "master")
# 获取最新版本 ${versions[0]} 生存master
rm -rf docs/master/*
cp -r docs/${versions[0]}/* docs/master

# for循环遍历
for version in ${versions[*]}
do
    loginfo "==========================================================="
    loginfo "开始", ${version}, "版本编译"

    echo "cp book.json docs/${version}"
    cp book.json docs/${version}

    # 替换 book.json 的编辑地址
    echo "python3 src/script.py ${version} book"
    python3 src/script.py ${version} "book"

    echo "cp -r node_modules docs/${version}"
    rm -rf docs/${version}/node_modules
    cp -r node_modules docs/${version}

    echo "gitbook install docs/${version}"
    gitbook install docs/${version}

    echo "python3 src/script.py ${version} powered"
    python3 src/script.py ${version} "powered"

    echo "python3 src/script.py ${version} gitalk"
    python3 src/script.py ${version} "gitalk"

    echo "gitbook build docs/${version} _book/docs/${version}"
    gitbook build docs/${version} _book/docs/${version}
done

# rm -rf /opt/apache-tomcat-9.0.17/webapps/test_book
# cp -r _book /opt/apache-tomcat-9.0.17/webapps/test_book
