+++
title = "Rust笔记"
date = 2022-08-28
[taxonomies]
categories = ["rust"]
tags = ["笔记"]
+++

# rust

## 基础知识
Rust 程序设计语言 中文版：https://kaisery.github.io/trpl-zh-cn/

通过例子学Rust 中文版：https://rustwiki.org/zh-CN/rust-by-example/

Rust设计模式：http://chuxiuhong.com/chuxiuhong-rust-patterns-zh/

Rust语言圣经：https://course.rs  https://github.com/sunface/rust-course

Rust Crates 实践指南：https://mirrors.gitcode.host/zzy/rust-crate-guide/index.html

Cargo 手册：https://rustwiki.org/zh-CN/cargo/index.html

Rust的 Pin 与 Unpin ：https://folyd.com/blog/rust-pin-unpin/

### 宏编程

Rust宏小册：https://zjp-cn.github.io/tlborm/proc-macros

Rust过程宏（Procedural Macros）基础：https://cloud.tencent.com/developer/article/1832788

### 异步编程

Rust中的异步编程：https://huangjj27.github.io/async-book/

对于 Async Rust，最最重要的莫过于底层的异步运行时，它提供了执行器、任务调度、异步API等核心服务。简单来说，使用 Rust 提供的 `async/.await` 特性编写的异步代码要运行起来，就必须依赖于异步运行时，否则这些代码将毫无用处。

异步运行时：

- tokio
- async-std

Tokio异步编程: https://github.com/sunface/tokio-course

## web

https://github.com/flosse/rust-web-framework-comparison

### 前端

yew：https://github.com/yewstack/yew

### 后端

rocket: https://github.com/SergioBenitez/rocket

actix-web: https://github.com/actix/actix-web

### 客户端

reqwest: https://github.com/seanmonstar/reqwest

## 应用开发

### 命令行

Command line apps in Rust：

https://rust-cli.github.io/book/ 

https://suibianxiedianer.github.io/rust-cli-book-zh_CN/

TUI（terminal user interfaces）：https://github.com/fdehau/tui-rs

### GUI

Iced：https://github.com/iced-rs/iced

## ebpf

aya：https://github.com/aya-rs/aya

https://github.com/aya-rs/awesome-aya

https://github.com/aya-rs/book

## FAQ

