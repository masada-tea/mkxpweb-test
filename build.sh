#!/bin/bash

# Install OS deps
# sudo apt install mm-common libtool rake ruby

# Fail immediately
set -e

# Set optimization level
export CFLAGS="-O3 -g0"
export CXXFLAGS="-O3 -g0"
export CPPFLAGS="-O3 -g0"
export LDFLAGS="-O3 -g0"

# Make deps folder
mkdir -p deps
cd deps

# Get libsigc++
if [ ! -d "libsigc++" ]
then
    wget https://github.com/libsigcplusplus/libsigcplusplus/releases/download/2.12.0/libsigc++-2.12.0.tar.xz -O libsigc++.tar.xz
    tar xf libsigc++.tar.xz && rm libsigc++.tar.xz
    mv libsigc++* libsigc++
fi

# Get pixman
if [ ! -d "pixman" ]
then
    wget https://www.cairographics.org/releases/pixman-0.42.0.tar.gz -O pixman.tar.gz
    tar xf pixman.tar.gz && rm pixman.tar.gz
    mv pixman* pixman
fi

# Get physfs
if [ ! -d "physfs" ]
then
    wget https://icculus.org/physfs/downloads/physfs-3.0.2.tar.bz2 -O physfs.tar.bz2
    tar xf physfs.tar.bz2 && rm physfs.tar.bz2
    mv physfs* physfs
fi

# Get mruby
if [ ! -d "mruby" ]
then
    wget https://github.com/mruby/mruby/archive/2.1.2.tar.gz -O mruby.tar.gz
    tar xf mruby.tar.gz && rm mruby.tar.gz
    mv mruby* mruby
    touch mruby/include/mruby/presym.h
fi

# Get mruby-onig-regexp (mruby 2.x 互換の古いコミットを固定)
if [ ! -d "mruby-onig-regexp" ]
then
    git clone https://github.com/mattn/mruby-onig-regexp.git
    git -C mruby-onig-regexp checkout 08decdc
fi


# Get emscripten
if [ ! -d "emsdk" ]
then
    echo "Downloading emscripten"
    git clone https://github.com/emscripten-core/emsdk.git
    cd emsdk
    git pull
    ./emsdk install 3.1.14
    ./emsdk activate 3.1.14
    cd ..
fi

# Activate emscripten
source emsdk/emsdk_env.sh

# Build libsigc++
if [ ! -f "libsigc++/sigc++/.libs/libsigc-2.0.a" ]
then
    cd libsigc++
    emconfigure ./autogen.sh
    emconfigure ./configure --enable-static --disable-shared
    emmake make clean
    emmake make -j4 || true
    cd ..
fi


# Build pixman
if [ ! -f "pixman/pixman/.libs/libpixman-1.a" ]
then
    cd pixman
    emconfigure ./configure --enable-static --disable-shared
    emmake make clean
    cd pixman
    emmake make -j4 libpixman-1.la
    cd ../..
fi


# Build physfs
if [ ! -f "physfs/libphysfs.a" ]
then
    cd physfs
    emcmake cmake .
    emmake make clean
    emmake make -j4 physfs-static
    cd ..
fi


# Build mruby
if [ ! -f "mruby/build/wasm32-unknown-gnu/lib/libmruby.a" ]
then
    cd mruby
    cp ../../extra/build_config.rb ../../extra/vm.c.patch ./
    patch -p0 --forward < vm.c.patch

    # mruby-onig-regexp を rake が clone する前に古いコミットで先占
    mkdir -p build/repos/wasm32-unknown-gnu
    git clone https://github.com/mattn/mruby-onig-regexp.git \
        build/repos/wasm32-unknown-gnu/mruby-onig-regexp
    git -C build/repos/wasm32-unknown-gnu/mruby-onig-regexp checkout 6f6b1a8

    make clean
    make
    cd ..
fi



# Done building deps
echo "Finished building dependencies"
cd ..

# Build mkxp
emcmake cmake .
emmake make -j4

# Done building
echo "Finished building MKXP"

# Copy to build directory
mkdir -p build
cp -R mkxp.html mkxp.wasm mkxp.js extra/*.webmanifest extra/js build/

# ==========================
# GAME_PROCESSING
# ==========================

cd build

# 毎回クリーンコピー
rm -rf gameasync
cp -R ../gameasync .

cd gameasync

# ① 大文字小文字の正規化（最重要）
find . -depth | while read f; do
    dir=$(dirname "$f")
    base=$(basename "$f")
    lower=$(echo "$base" | tr '[:upper:]' '[:lower:]')
    if [ "$base" != "$lower" ] && [ -e "$f" ]; then
        mv "$f" "$dir/$lower" 2>/dev/null || true
    fi
done

# ② MIDI → OGG
find Audio -name "*.mid" 2>/dev/null | while read f; do
    base="${f%.*}"
    timidity "$f" -Ow -o "${base}.wav" && \
    ffmpeg -i "${base}.wav" "${base}.ogg" -y && \
    rm -f "${base}.wav" "$f"
done

# ③ WAV → OGG
find Audio -name "*.wav" 2>/dev/null | while read f; do
    base="${f%.*}"
    ffmpeg -i "$f" "${base}.ogg" -y && rm -f "$f"
done

# ④ BMP → PNG
find Graphics -name "*.bmp" 2>/dev/null | while read f; do
    base="${f%.*}"
    ffmpeg -i "$f" "${base}.png" -y && rm -f "$f"
done

if [ ! -f "rgss.rb" ]; then
    cp ../../extra/rgss.rb .
fi

# ⑤ マッピング生成（正規化後に実行）
../../extra/make_mapping.sh

# Preload data
rm -rf preload ../preload
cp ../../extra/dump* .
for f in Data/*
do
    ./dump.sh "$f" > /dev/null
    echo "Processed file: $f"
done
rm dump*
mv preload ..

# Game processing done
cd ..

# Make deployable
mv mkxp.html index.html
touch .nojekyll


# Done
echo "Finished everything"
cd ..
