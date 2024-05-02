---
title: "Weekly wrap-up - May 01"
date: 2024-05-03T21:09:38+02:00
draft: false
categories: ["weekly"]
tags: ["firewatch", "docker"]
license: cc-by-nc-sa
---

## Gaming

- Finished Firewatch.
- Played some Aliens: Infestation. Balls hard.

## Movies

- Cronenberg week with eXistenZ and Videodrome. First time watching Videodrome and I found it very hard to put down.

## Coding

- .NET 6, 7 and 8 do not support being emulated in QEMU, so no arm64 builds with emulation. Had to learn how to hook up my Raspberry Pi as an additional node.
- Turns out, it still wouldn't build, because the Pi was unable to pull the necessary NuGet packages. I went back to .NET 6 and 7 and it builds perfectly, so it seems like something broke in .NET 8.
