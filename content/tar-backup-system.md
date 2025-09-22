+++
title = "使用tar备份还原系统"
date = 2025-09-23
[taxonomies]
categories = ["linux"]
tags = ["linux", "tar"]
+++

[使用_tar_备份整个系统](https://wiki.archlinuxcn.org/wiki/%E4%BD%BF%E7%94%A8_tar_%E5%A4%87%E4%BB%BD%E6%95%B4%E4%B8%AA%E7%B3%BB%E7%BB%9F)


```bash
# -p、--acls 和 --xattrs 存储所有权限、ACL 和扩展属性。如果没有这些属性，许多程序会停止工作！
$ tar --acls --xattrs -cpf bak-rootfs.tar.gz /
```