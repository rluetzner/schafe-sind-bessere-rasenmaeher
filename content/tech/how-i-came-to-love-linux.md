---
title: "How I came to love Linux"
date: 2024-02-15T16:05:46+01:00
draft: false
categories: ["tech"]
tags: ["Autobiography", "Work", "Programming"]
---

{{< aside >}}
This is the 2nd part of a series where I rant about how I ended up with Linux as my daily driver.

The other parts can be found here:

* [How I learned how to use a PC]({{< ref "how-i-learned-to-use-a-pc" >}})
* How I came to love Linux
* [Gaming on Linux]({{< ref "gaming-on-linux" >}})

This whole series was inspired by [_From Windows Fidelity to Linux Liberty: My Computing Evolution_](https://www.sudoversity.fyi/posts/windows-fidelity-linux-liberty/), a blog post by [SudoMistress](https://www.sudoversity.fyi/about/).
{{</ aside >}}

I can't exactly remember the first time I heard about this mystical alternative OS _Linux_. I was probably 15 or 16 and I must have heard about it from my friend's older brother, who was studying computer science.

I decided to give it a go, but my first experience was pretty terrible. I can't remember which distro I used or what exactly went wrong, but my experiment didn't last much more than a few minutes. Definitely less than an hour.

None of my Windows knowledge could be reused. I wasn't afraid of `cmd.exe`, but installing packages purely from CLI? And none of my games work!?

So, I went back to Windows and apart from using [Knoppix](http://www.knoppix.org/) for recovery and troubleshooting, I didn't concern myself with Linux.

My second attempt was in 2016. I had just returned from attending [FOSDEM](https://fosdem.org/) in Brussels and fucking **everybody** was rocking Linux. Some absolute weirdos were even running their Thinkpads without a graphical UI -- coding directly in the terminal.

{{< aside >}}
Put a pin in that -- we'll get back to the weirdo part in a bit. 😅
{{</ aside >}}

We were still firmly in Windows-land at work back then, with .Net Framework, Windows Server, etc. But at home I decided to give Linux another chance.

So I read up on different distributions and ultimately settled on dual-booting [Fedora](https://fedoraproject.org/) next to my Windows installation. The installation went smoothly and the experience was mind blowing. Fedora felt really good and everything that had seemed daunting before, turned out to be really easy to learn. A whole lot could also be done right from the GUI, without ever touching the terminal.

I think I made it a week, before I broke it. 😅 [^broke-fedora]

Third time's the charm is what they say and boy are they right! 😅

But my third time was stretched out over a few years and required a specific trigger, that I'll talk about later.

I eventually bought a Raspberry Pi. The first model I bought was the Pi 2B and I don't really remember doing much with it. Nevertheless, I followed up with the Pi 3 and much later with a Pi 4.

There was one very specific email I got from Google in 2019 that caught me off guard.

> Hey, we've generated this cool video from a bunch of pictures you took on vacation.

I had seen these emails a few times in the past, but something was different this time: my wife (to-be) was pregnant.

We both hadn't really thought much about Big Tech abusing whatever info we gave them, but we were 1000% sure that they shouldn't know anything about our kid(s).

But I also wasn't willing to compromise on comfort. I still wanted to auto-upload all our pictures to a cloud in case something happened to our mobile devices.

I looked into different options and ultimately settled on self-hosting Nextcloud on my Pi 3. What started as a single service quickly grew to over 20 now and started my hobby as a self-hoster.

I also mentioned that back in 2016 my workplace was still firmly stuck in Windows-land, but that started changing quickly afterwards. The whole Dev team attended an on-site Go course, we started research into a new product and got a few more people on board for that.

The new product was built on top of a whole bunch of open source components, first and foremost Linux as an operating system.

For a while I remained an observer, but at the end of 2020[^git-commit] my boss approached me and asked if I would be interested in supporting the _other_ team with the new product. I was hesitant at first, mostly ashamed of my lack of knowledge about Linux, but I felt ready for a new challenge.

My first assignment was also far removed from the Linux OS. I was meant to write a suite of end-to-end tests in .Net Core. For the first few weeks I remained on Windows, coding away in Visual Studio and deploying my test suite to a bunch of Windows and Linux machines running as Jenkins agents.

But it didn't take too long until the first OS specific issues started to pop up. Eventually I gave in and decided to give the Windows Subsystem for Linux (WSL) a try. [^wsl]

WSL (at that time) was also terminal-only. And being forced to work only with the terminal in Linux, completely turned me around. My initial opinion was that "nobody can remember all these Linux commands" and "everything is so fucking hard to do".

{{< aside >}}
Let me say, that just because I've _turned around_, doesn't necessarily mean that these statements are wrong. Compared to PowerShell, Linux commands really are hard to remember and for the most part don't follow a discernible pattern.

**But** I simply started to write shit down! And eventually I remembered. Just like back in school. 😅
{{</ aside >}}

After a while I had built up enough confidence to help out with other tasks, which turned out to be writing Ansible playbooks.

Ansible is amazing! I immediately fell in love. And I think Ansible helped me understand why it is so valuable to be able to script everything.

Windows is GUI first, terminal _maybe_, whereas Linux is terminal first, GUI _maybe_.

That doesn't sound so bad at first, until you realize that you can't do _everything_ in Windows' GUI. You can't do _everything_ with PowerShell either. 😬 [^windows-core]

Linux being terminal first on the other hand means, that whatever you can think of, you can configure in the terminal. _Maybe_ there's a UI for that, but most likely it doesn't give you all the options.

And then there's _everything is a file_, which is a design choice I absolutely love. Need to persist a setting? Look for the right file and put it in there. Need to look up a value? Find the right file and take a look. [^on-windows-too]

Closing the circle, I also got more and more privacy-aware and started moving away from Big Tech wherever possible. Leaving Windows behind was the next logical step, so I finally took the plunge and [installed Linux at home]({{<  ref "gaming-on-linux"  >}}).

[^broke-fedora]: I actually remember exactly what I _broke_ and in hindsight it's so easy to resolve (and I've messed this up a few more times since) that I can't quite understand why I was so disheartened back then.  
The way I broke Fedora was by adding an entry to `/etc/fstab`. I had an external drive, which I figured out how to mount and I wanted Linux to mount it every time I started the machine. So I followed a guide on the internet and added an entry for the external drive in `/etc/fstab`.  
But when I rebooted the machine (without having the external drive attached) the OS wouldn't start up. I couldn't make heads nor tails of the error message I got (or maybe it was hidden by the boot splash screen?), so I abandoned this experiment.

[^git-commit]: I was actually **convinced** that it was 2019, before my first son was born, but I checked `git log --author='Robert'` and my first commit was on October 21st in 2020.

[^wsl]: I can't recall why I decided to go with WSL over a Linux VM, but I think getting rid of VMWare Workstation might have played a role in that. VSCode integrates very nicely with WSL, so I moved all development to my host OS and got rid of virtualization entirely. Well, except for WSL, but that was just another Window I had open.

[^windows-core]: Have you ever seen a Windows Core system??? It's supposed to be headless...and if you've configured PowerShell remoting that is _mostly_ accurate.  
Except, when you log onto the system with an RDP session or similar, you still get a desktop environment. There's a background and an actual PowerShell window (yes, with a titlebar and everything) that pops open.  
Even worse...what do you think happens when you run `notepad.exe stuff.txt` or `explorer.exe`?  
Remember that Windows is GUI first, so it doesn't have a terminal editors like Vim or Nano.  
And remember: I said "you can't do _everything_ with PowerShell either". 😩

[^on-windows-too]: I feel like with many tools getting the cross-platform treatment, this is starting to get traction on Windows as well.  
Just recently I had to setup a development VM on Windows. For the fun of it, I used [chezmoi](https://chezmoi.io) to deploy my dotfiles and _most_ of it worked pretty much out of the box. I had to symlink a specific path for my NeoVim configuration, but other than that, I had my comfortably configured dev environment -- on Windows!  
Talking about chezmoi feels like I should write about why this tool is so amazing sometime. 😅
