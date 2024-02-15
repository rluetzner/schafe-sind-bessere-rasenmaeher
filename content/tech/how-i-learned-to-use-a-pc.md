---
title: "How I learned to use a PC"
date: 2024-02-15T12:41:46+01:00
draft: false
categories: ["tech"]
tags: ["Autobiography", "Work", "Programming"]
---

{{< aside >}}
This is the 1st part of a series where I rant about how I ended up with Linux as my daily driver.

The other parts can be found here:

* How I learned how to use a PC
* [How I came to love Linux]({{< ref "how-i-came-to-love-linux" >}})
* [Gaming on Linux]({{< ref "gaming-on-linux" >}})
{{</ aside >}}

When I was 10, my mom decided that we too needed a PC in our household. She wasn't exactly sure what she'd do with it (probably write letters or something, but I can't remember seeing her do that particularly often), but it was _all the rage_, so we needed one too.

It was an Aldi PC from 1997. I can't remember much about the specs, but it **did** have Windows 95 and a CPU with 133MHz. I'm 1000% certain about this, because Resident Evil 2 on the PC required a CPU with 166MHz and it _kinda_ ran on the machine, but pretty much in slow-motion.

I was fascinated. In particular, this opened up a whole new world of gaming to me. Until then I had only gamed on GameBoy and the Super NES, so with the limited money I had, I started buying PC gaming magazines for their demo discs.

My mom was very protective of the _family_ PC, so I had to sneak in some gaming when nobody was at home. And it only got worse when I managed to break the OS for the first time. 😅

I had rented a game from the local library. I tried to install it, but the disk was already too full, so it gave me a warning. But the setup also gave little 10 year old me a way to ignore that warning and happily started to overwrite existing data on the disk. Needless to say, that the OS no longer booted after I restarted the PC.

While I didn't know how to fix it myself at that time, a school friend explained the process to me, when I told him what had happened. The (inevitable) next time I broke the OS, I went looking for the recovery floppy disk and the Windows 95 installation CD.

After a while I got frustrated with the slowness of the machine. Newer games, especially those using 3D graphics, wouldn't run at all or if they did, they ran very laggy. By that time I had seen some of the 486 PCs my stepdad used for his work, so I was familiar with the _Turbo_ button.

So I went looking and a close inspection of the PC tower did indeed turn up a switch. Sadly that switch was hooked up to the power supply and it determined the input voltage it was expecting. I flipped it from 230 Volts to 120 Volts and fried the power supply in a big black cloud of smoke. 😬

Being a kid, I kept my mouth shut and pretended not to know anything about it. My mom suspected that I had caused it, but couldn't prove it. And I'm pretty sure the PC Doctor we visited to get the machine repaired saw right through me, but she told my mom that this might just have happened during a thunderstorm. [^sorry]

I vividly remember this visit to the PC Doctor, because she took the time to explain and show every step of her analysis and repair. It was the first time I saw that a PC case could be opened up and parts of it could be replaced. It would still take a few years until I started customizing PCs and incrementally upgrading hardware parts, but this day laid the groundwork for that.

The only missing piece I needed to realize was that PC hardware was readily available at the consumer level. You didn't have to be a PC Doctor to buy a new power supply, graphics card or CPU.

I would be stuck with this PC for a few years, but with money I got for my confirmation [^confirmation], I could finally buy a PC for my own. Again, I can't remember the exact specs, but it had more than 1 GHz of computing power and an Nvidia GeForce 2 MX graphics card. It was a pre-built PC I got from the German retailer _Media Markt_. Over the years I would slowly replace part after part until only the tower remained.

At this point I knew a bit about PC hardware and what the individual pieces were doing. I also knew how to install software with GUI setups, find my way around the explorer and of course how to play games.

What I didn't know about was **networking**.

I have one specific memory of a small-scale LAN party [^small-scale], where we had to figure out how to _see each other_ on a network. I'm pretty sure that this was not entirely _before the internet_, but neither my friend nor I had spent much time on the internet. However, it definitely was _before WiFi_.

My friend's older brother ultimately helped us in setting everything up. He provided the hardware switch, network cables and helped with troubleshooting. In particular, he assigned static IPs to our network adapters and showed us how to use `ping`. Many years would pass, before I understood what that meant and why it fixed the issue, but only a day passed until it caused issues.

When I returned home from the LAN party and hooked everything back up, I noticed that I was no longer able to connect to the internet. I'm pretty sure I rewired everything countless times until I finally remembered that we messed around with the network adapter. Eventually I found my way to the dialog where I could revert this to _automatic_ (i.e. get an IP from the DHCP server).

So, where am I going with all this? Basically, I'm saying that the way I learned how to use a PC was by breaking it.

Breaking it again and again...and figuring out which issues are fixable and how to fix them.

I think that's a good enough introduction to explain [why I love Linux]({{< ref "how-i-came-to-love-linux" >}}).

[^sorry]: Mom, if you're reading this: I'm sorry I didn't say anything. 😅
[^confirmation]: The _confirmation_ is an optional catholic sacrament. The age isn't really set in stone, but people are usually 15 or 16, when this event happens. You basically _confirm_ the choice your parents made to baptize you as a catholic.
[^small-scale]: Small-scale as in: two people -- me included. 😅
