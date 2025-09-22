+++
title = "AOSP笔记"
date = 2022-08-30
[taxonomies]
categories = ["android"]
tags = ["aosp", "笔记"]
+++

## 图形子系统

Android 图形系统框架简介

https://segmentfault.com/a/1190000022114641

如何用Rust做Android UI渲染

https://tehub.com/a/8xvC7q4Nd1

Android 系统图形栈（一）： OpenGL ES 和 EGL 介绍

https://flyflypeng.tech/android/2017/09/04/Android%E7%B3%BB%E7%BB%9F%E5%9B%BE%E5%BD%A2%E6%A0%88OpenGLES%E5%92%8CEGL%E4%BB%8B%E7%BB%8D.html

Android 系统图形栈（二）：OpenGL ES 库和 EGL 库加载过程

https://flyflypeng.tech/android/2017/09/05/Android%E7%B3%BB%E7%BB%9F%E5%9B%BE%E5%BD%A2%E6%A0%88OpenGLES%E5%92%8CEGL%E5%BA%93%E7%9A%84%E5%8A%A0%E8%BD%BD%E8%BF%87%E7%A8%8B.html

## HAL层

https://flyflypeng.tech/android/2017/03/26/Android-HAL%E5%B1%82%E5%8E%9F%E7%90%86%E5%88%86%E6%9E%90.html

Android HAL 层原理分析

## Rust on Android

### 参考资料

https://source.android.com/docs/setup/build/rust/building-rust-modules/overview

Android Rust

https://blog.logrocket.com/integrating-rust-module-android-app/#rust

例子：

https://github.com/atkurtul/AndroidVulkanTriangle.git

https://github.com/sk039/rustonandroid.git

Integrating a Rust module into an Android app

https://medium.com/visly/rust-on-android-19f34a2fb43 Rust on Android

### cargo-ndk

https://lib.rs/crates/cargo-ndk

```bash
$ CARGO_ENCODED_RUSTFLAGS="-L$PWD/../build/libs/debug/aarch64/" cargo ndk -t arm64-v8a -o ./jniLibs build
```
注意：`-L` 与后面路径不能有空格

### cargo-apk

https://lib.rs/crates/cargo-apk


## a13 kvm

https://blog.esper.io/android-dessert-bites-5-virtualization-in-android-13-351789/

How Google will use virtualization in Android 13

https://android.googlesource.com/platform/packages/modules/Virtualization/+/HEAD/docs/getting_started/index.md

## 其他

### Anbox

### ffmpeg

Android绘制流程 —— View、Window、SurfaceFlinger

https://juejin.cn/post/6899010578145411085

Android之Surface/Window/View/SurfaceView区别

https://blog.csdn.net/u010164190/article/details/119489616

https://developer.android.com/ndk/reference/group/native-activity#group___native_activity_1ga774d0a87ec496b3940fcddccbc31fd9d

https://github.com/HausnerR/ffmpeg-android-example

一文读懂 Android FFmpeg 视频解码过程与实战分析

https://www.51cto.com/article/704012.html
