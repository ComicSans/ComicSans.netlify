---
layout: post
title: "WSL or how to access linux on windows"
categories: [tools, windows]
---

In the last article I used the WSL (Windows Subsystem for Linux) to download GOG files. You can find information on installing WSL [here](https://docs.microsoft.com/windows/wsl/install-win10) or also [here on this blog]({% post_url 2019-09-02-lgogdownloader-windows-10 %})

But how can we interact between Windows and Linux?

<!--more-->

## How to call a linux command from within windows

The windows command prompt is what a shell is in the linux world. It lacks some aspect in this comparison but in the end both are a way to interact with the system. To "start" linux you can open a command prompt and enter ´´bash´´. That's because "bash.exe" is available.

You can use this in batch files, like here:

```bash
@echo off
bash.exe -c "sudo lgogdownloader --update-cache"
bash.exe -c "sudo lgogdownloader --download --directory /mnt/z/Backups/Games --language en+de --save-serials --use-cache --platform w+l+m"
z:
cd /Backups/Games
dir /B /S | findstr /i ".*\.old$"
```

This takes the example of the last post (remember: we wanted to download games from GOG to a network drive) and automates the process. When the downloads have finished it shows a list of updated files (lgogdownloader adds an ".old" to the file name).

## How to call a windows command from within a bash instance?

Simply add the ".exe" to the program you want to start. The windows PATH variable is automatically added to the bash environment. Try:

```bash
bash
notepad.exe
``` 

from a command prompt.