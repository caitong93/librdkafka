#!/bin/bash

set -e

# Slightly modified from:
# https://docs.travis-ci.com/user/reference/windows/#how-do-i-use-msys2
case $TRAVIS_OS_NAME in
    windows)
        [[ ! -f C:/tools/msys64/msys2_shell.cmd ]] && rm -rf C:/tools/msys64
        choco uninstall -y mingw
        choco upgrade --no-progress -y msys2
        export msys2='cmd //C RefreshEnv.cmd '
        export msys2+='& set MSYS=winsymlinks:nativestrict '
        export msys2+='& C:\\tools\\msys64\\msys2_shell.cmd -defterm -no-start'
        export mingw64="$msys2 -mingw64 -full-path -here -c "\"\$@"\" --"
        export msys2+=" -msys2 -c "\"\$@"\" --"
        $msys2 pacman --sync --noconfirm --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-cmake mingw-w64-x86_64-openssl mingw-w64-x86_64-cyrus-sasl
        ## Install more MSYS2 packages from https://packages.msys2.org/base here
        taskkill //IM gpg-agent.exe //F  || true  # https://travis-ci.community/t/4967
        export PATH=/C/tools/msys64/mingw64/bin:$PATH
        export MAKE=mingw32-make  # so that Autotools can find it
        ;;
esac
