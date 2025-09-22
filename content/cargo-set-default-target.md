+++
title = "设置 Cargo 默认 target triple"
date = 2022-08-28
[taxonomies]
categories = ["rust"]
tags = ["cargo"]
+++

解决 rust-analyzer 因为 target 不匹配而无法正确使用的问题。

- 方法一： config.toml
源码（Cargo.toml 同级）目录下，创建 `.cargo/config.toml` ：

``` toml
[build]
target = "aarch64-linux-android"
```

https://doc.rust-lang.org/cargo/reference/config.html

- 方法二：CARGO_BUILD_TARGET 环境变量

```bash
export CARGO_BUILD_TARGET=aarch64-linux-android
```

https://doc.rust-lang.org/cargo/reference/environment-variables.html

