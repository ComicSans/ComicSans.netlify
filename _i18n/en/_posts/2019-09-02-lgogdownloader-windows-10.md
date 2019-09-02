---
layout: post
title: "How to keep GOG (Good Old Games) files updated locally on Windows 10"
categories: [gog, games, tools, windows]
---

Well, if you are like me and you like old games, you will know [GOG](https://www.gog.com). And if you are like me, you already collected a few games over recent years:

{% picture default /images/gog-list-of-games.png alt="list of games" %}

As you can see, if currently have 346 games in my collections. And I'd like to have a local copy of them on my NAS.

<!--more-->

It's tedious work to go to each game page, select download and click the download link. Even more if you'd like to keep multiple versions of the games for Mac OS, Linux and Windows.

Let me present you lgogdownloader, a linux program to download game files from gog.

Wait, "Linux" you said? Ain't this an article about Windows 10? Well, yes. But Windows 10 can run Linux programs by using the WSL, the "Windows Subsystem for Linux".

You will find information on how to enable this [here](https://docs.microsoft.com/windows/wsl/install-win10). The commands described in the linux subsystem will work for "normal" linux as well, of course.

To keep it simple: open a powershell with administrator privileges (right click "power shell" and select "run as administrator" and enter your password), then run:

```bash
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Restart when prompted.

Once you are back, go to the Microsoft Store and search for "Ubuntu". But any Debian like distro will do. Once it has sucessfully installed, start it to finish the installation.

Next we need the program itself. Run:

```bash
sudo apt-get update
sudo apt-get install lgogdownloader
```

Login with GOG:

```bash
lgogdownloader --login
```

Now update your game cache:

```bash
sudo lgogdownloader --update-cache
```

You can download your files like this:

```bash
sudo lgogdownloader --download --directory /mnt/z/Backups/Games --language en+de --save-serials --use-cache --platform w+l+m
```

The games will be saved on the drive with the letter Z: (which is a mapped network drive here, but it can be of course any path you like). For games that come in multiple languages, the german and the english language will be downloaded ("en+de") for all plattforms ("w+l+m" - Windows, Linux and Mac OS).

{% picture default /images/gog-lgogdownloader.png alt="list of games" %}