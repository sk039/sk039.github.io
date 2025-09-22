+++
title = "ebpf 学习笔记"
date = 2022-09-05
[taxonomies]
categories = ["ebpf"]
tags = ["ebpf"]
+++

## 介绍

![ebpf架构](62831cc15717714b077372c9bcce12e71dfa78.png)


深入浅出eBPF｜你要了解的七个核心问题：

https://www.51cto.com/article/711018.html

eBPF 系列一：Hello eBPF

https://vvl.me/2021/01/eBPF-1-Hello-eBPF/

BPF之路一bpf系统调用

https://www.anquanke.com/post/id/263803

## eBPF 程序中向用户态程序传递信息

1. bpf_trace_printk()

   `bpf_trace_printk` 是一个 BPF 的辅助函数, 其作用是打印输出，由于运行在内核中，所以打印输出并不是标准输出，而是内核调试文件 `/sys/kernel/debug/tracing/trace_pipe`

   <eBPF-2-实战之编程接口、bcc与bpftrace> lesson1: hello word

   https://blog.csdn.net/weixin_43988498/article/details/125113777


2. map

   **BPF 进阶笔记（二）：BPF Map 类型详解：使用场景、程序示例**

   https://arthurchiao.art/blog/bpf-advanced-notes-2-zh/

   eBPF 系列三：eBPF map

   https://vvl.me/2021/02/eBPF-3-eBPF-map/

   **BPF ring buffer**

   https://nakryiko.com/posts/bpf-ringbuf/#bpf-ringbuf-vs-bpf-perfbuf

   边缘网络 eBPF 超能力：eBPF map 原理与性能解析

   https://segmentfault.com/a/1190000041224609

   map 性能建议：

   - 一般来说 eBPF 程序作为数据面更多是查询，常用的 map 的查询性能：array > percpu array > hash > percpu hash > lru hash > lpm。map 查询对 eBPF 性能有不少的影响，比如：lpm 类型 map 的查询在我们测试发现最大影响 20% 整体性能、lru hash 类型 map 查询影响 10%。
   特别注意，array 的查询性能比 percpu array 更好，hash 的查询性能也比 percpu hash 更好，这是由于 array 和 hash 的 lookup helper 层面在内核有更多的优化。对于数据面读多写少情况下，使用 array 比 percpu array 更优（hash、percpu hash 同理），而对于需要数据面写数据的情况使用 percpu 更优，比如统计计数。
   - 尽可能在一个 map 中查询到更多的数据，减少 map 查询次数。
   - 尽可能使用 array map，在控制面实现更复杂的逻辑，如分配一个 index，将一些 hash map 查询转换为 array map 查询。
   - eBPF map 也可以指定 numa 创建，另外不同类型的 map 也会有一些额外的 flags 可以用来调整特性，比如：lru hash map 有 no_common_lru 选项来优化写入性能。

   揭秘 BPF map 前生今世
   
   https://www.ebpf.top/post/map_internal/
   
   ![map 加载流程](map_load_process.png)

