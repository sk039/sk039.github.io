+++
title = "tmux nvim 真彩色设置"
date = 2022-08-28
[taxonomies]
categories = ["ide"]
tags = ["tmux", "nvim"]
+++

https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/

## Neovim 设置

Neovim has good support for true colors. According to [official doc](https://github.com/neovim/neovim/wiki/FAQ#how-can-i-use-true-color-in-the-terminal), to enable true color support, you need to add the following setting to `init.vim`:

```
set termguicolors
```

## Tmux 设置

```
set -g default-terminal "screen-256color"
# tell Tmux that outside terminal supports true color
set -ga terminal-overrides ",xterm-256color*:Tc"

# for tmux 3.2, you can use the following setting instead:
# set -as terminal-features ",xterm-256color:RGB"
```

## 验证

### nvim checkhealth

```bash
$ nvim
:checkhealth
```

### 终端打印色带

```bash
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

未开启真彩色：

![without true color](20181023012639.png)

开启真彩色：

![with true color](20181020165808.png)

