---
title: "Gaming on Linux"
date: 2024-02-16T12:59:46+01:00
draft: false
categories: ["tech"]
tags: ["Autobiography", "Gaming", "Programming"]
---

{{< aside >}}
This is the 3rd part of a series where I rant about how I ended up with Linux as my daily driver.

The other parts can be found here:

* [How I learned how to use a PC]({{< ref "how-i-learned-to-use-a-pc" >}})
* [How I came to love Linux]({{< ref "how-i-came-to-love-linux" >}})
* Gaming on Linux

This whole series was inspired by [_From Windows Fidelity to Linux Liberty: My Computing Evolution_](https://www.sudoversity.fyi/posts/windows-fidelity-linux-liberty/), a blog post by [SudoMistress](https://www.sudoversity.fyi/about/).
{{</ aside >}}

The final piece I needed to take the plunge on daily driving Linux was **gaming**.

Valve's Proton had been out for a bit, but it just started making big waves around the time when I got interested in making the switch. This was shortly **before** the Steam Deck was announced, which has since proven to be wildly successful and has probably been the biggest push for gaming on Linux.

I guess similar to a lot of people, I didn't wipe my Windows installation, but instead opted to dual boot a Linux distribution next to it. After a bit of internet research, I settled on [Pop!_OS](https://pop.system76.com/). I quickly learned that my desktop PC (henceforth referred to as _gaming rig_ 😅) was a bit ill matched with the available Linux drivers, specifically when it came to Nvidia GPUs.

{{< aside >}}
Remember we are somewhere in early 2021, a global pandemic is ongoing and, to make things worse, a whole bunch of morons are using GPUs for crypto-mining.

Don't you **dare** ask me why I didn't buy a new graphics card. They are still insanely expensive today. 😬
{{</ aside >}}

The two distributions that mainly come up as a recommendation for _gaming distro_ were Manjaro and Pop!_OS. At the time I opted for the more conservative _point release_ approach, instead of a distribution with rolling releases, so Pop!_OS won.

I still remember booting up the OS for the first time and having my mind blown that I can login and use the system after less than 30 seconds. And that is actually **use** the system, as in "start whatever you want, we're ready!"

{{< aside >}}
Holy shit Windows! What have you been smoking!

I have a pretty competent working laptop and it still takes me over two minutes to start _working_.

Surely someone else has observed this, right? You boot up the PC and eventually the splash screen will go away and allow you to log in -- but that doesn't mean you can actually work! You still need to wait another minute for Windows to load all the icons and don't you **dare** try and start anything before that. It'll be laggy as all hell.

This is amongst the things that annoys me the most today, when I'm forced to use Windows for work.
{{</ aside >}}

There was however a small problem to be solved: my WiFi adapter had no official support. Well, nevermind! I hooked up my phone (that's when I discovered USB-Tethering), searched the internet and relatively quickly found which exact model my WiFi dongle was and a [project on GitHub](https://github.com/cilynx/rtl88x2bu) where I could compile my own driver. I would not let myself be deterred this easily.

{{< aside >}}
I don't want to brag too much, but a little bragging is in order, I think. 😅

Running `make install` to compile and install missing drivers was only the first step. I've since compiled the Linux kernel and systemd from scratch to track down a [bug](https://github.com/systemd/systemd/issues/21466) I opened up in the systemd project. I actually got a response from [Lennart Poettering](https://github.com/poettering) himself -- very much _before_ I knew who that was. 😅
{{</ aside >}}

If I remember correctly, the first thing I installed on Pop!_OS was _Max Payne 3_[^max-payne3] right from Steam. I'm not sure if it really worked out of the box, or if I had to try a few different versions of Proton, but I **did** get it running fairly quickly and it worked like a charm. I played for a few hours until I remembered why I didn't particularly like the game[^not-liking-max-payne3].

Next on my list was _Shadow Tactics: Blades of the Shogun_. This was something I owned on GOG, rather than Steam and that's how I discovered [Lutris](https://lutris.net/). I logged in to my GOG account, installed the game, copied over the saves and -- it worked! Amazing stuff! Great game, too! 😅

Next up: _Hitman 3_ (the 2021 game from the rebooted _World of Assassination_ series). Being a [humongous Hitman fan]({{< ref "/posts/reminiscing-about-classic-violent-games" >}}), I got this as a present for my birthday.

Well, this posed a real challenge. The game was only available on the _Epic Games Store_ (EGS) and (as opposed to Max Payne 3) it was **brand-new**. And it showed.

Support for EGS has gotten better in the last few years, but setting something up in 2021 was pretty complicated. I found a few blog posts that described how to install EGS via Lutris, but that seemed like a badly nested, complicated mess. But after quite a bit of research, I found _Legendary_, a CLI tool that could be used to install games from EGS.

{{< aside >}}
Later on I would discover [Heroic Games Launcher](https://heroicgameslauncher.com/), which itself builds upon _Legendary_.
{{</ aside >}}

But getting the game installed was only the first step and for the life of me, I couldn't figure out how to run it. It kept crashing and I couldn't figure out what I needed to do to fix it. There was [Proton.db](https://protondb.com), but _Hitman 3_ wasn't on Steam (yet), so no help there.

I think I spent three evenings trying to get the game running. I was close to giving up.

My initial plan had been to give Linux gaming a quick try and duck and run if it didn't work out of the box. But I got used to Pop!_OS really quickly and now I had seen that gaming on Linux **was a real possibility**. In fact, I was so happy simply _being_ in the OS and _using_ it, that the thought of going back to Windows made me sad.

I was determined to give it one last shot. Sounds overly dramatic? Don't worry dear reader, I would rather not have played _Hitman 3_ than returned to Windows. 😁

And on the fourth evening, I finally did get the game running. I can't really remember what I needed to do, but it taught me WINE basics, hacky symlinking of Proton libs to make them available to _Legendary_ and messing around with a whole bunch of very specific environment variables people seem to know about.

I feel like I've been going on for ages now, but there are two more games I want to talk about, one of which I ultimately gave up on.

First up is _Resident Evil 2_ (hell yeah the 1998 **classic**, baby!). I [love this game]({{< ref "/posts/reminiscing-about-classic-violent-games" >}}) and after checking out some newer games, I wanted to see how well Linux can be used to play retro PC games.

But getting it working with Lutris was laughably easy, thanks to installation scripts provided by the Lutris community. So to make things worse, I wanted to _mod_ the game. There's an interesting mod called the [Resident Evil 2 Seamless HD Project](https://www.reshdp.com/re2/), which comes with upscaled textures and is a huge overhaul of the game. I also installed a whole bunch of other mods, improving the sound effects and FMV cutscenes.

This is where I learned how Lutris handles library files (DLLs) and how to override the defaults on a case-by-case basis. I also learned that _unzip_ (or possibly _7zip_) has an option to extract files _case insensitive_. This was necessary, because the mods came as zip archives with loads of files that needed to be overwritten. The problem with that was, that _Resident Evil 2_'s files were a wild mix of upper- and lowercase and the files inside the mod zip archives were a **different** wild mix of upper- and lowercase.

But I got it all working!!! And it took me two evenings!!! And it was amazing!!!!! 😁

Then for some reason or other, I was reminded of [_Nocturne_](https://www.pcgamingwiki.com/wiki/Nocturne).

**Nobody** remembers this game. Probably for good reasons, but I can't say, because I never got to play it.

I only ever owned a demo of this game, decades ago, from a PC gaming magazine and my gaming rig at that time couldn't run the demo (it was the 133MHz one of course and technically it wasn't even _my_ gaming rig).

Sadly, I still haven't managed to get this one working. I spent multiple evenings trying out different WINE runners for Lutris, obscure Lutris settings, looking at the debug output, installing countless different versions of the game, using different WINE prefixes and compatibility settings.

Oh well, not being able to run an obscure (most likely very bad) game from 1999 is a fight I'm willing to let go. Let me instead tell you about other battles that I **have** won. 🙂

* Disco Elysium
* Doom (well, **obviously** Linux can run the original Doom)
* Elden Ring
* Max Payne
* Max Payne 2
* Quake
* Shenzhen I/O
* Silent Hill 3 (modded in a similar way to Resident Evil 2)
* Spider-Man (2018, released 2022 for Windows)
* The Case of the Golden Idol
* TIS-100
* Wheelman (the one with Vin Diesel)
* X-Men Origins: Wolverine

I'm having trouble remembering all the games I've played on Linux, because it has gotten **so easy** to do. Most of the games from this list ran right out of the box. Some required a little bit of tinkering, but I'm very willing to take that.

As I've said before: I am **not** going back to Windows!

[^max-payne3]: I wanted to go for something rather _recent_, which turned out to be a game from 2012. Released almost **a decade** before my experiment. Damn I'm getting old. 😅

[^not-liking-max-payne3]: The cutscenes! Oh my God, just let me play the fucking game already!!!
