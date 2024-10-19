---
title: "Plug & Backup -- with Rsync, Gotify and udev rules"
date: 2024-10-19T19:07:46+01:00
draft: false
categories: ["tech"]
tags: ["linux", "backup", "rsync", "gotify", "udev"]
license: cc-by-nc-sa
---

This is gonna be a step-by-step reconstruction of how my backup script evolved over various iterations.

If you're just interested in the top-level steps, you can take a look at the section headings.

## Starting out with rsync

I'm a big fan of [Restic](https://restic.net) for backups. It's one of the first tools I install on a new system.

In this particular case however, I decided to use good old `rsync` instead. I'm backing up the data for all my self-hosted stuff on my Raspberry Pi, including photos, documents and movies / TV shows I ripped from my physical media. There's a certain charm in just plugging the backup disk into any PC and accessing the files directly.

At it's inception, the script pretty much looked something like this.

```bash
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

rsync -avP /home/pi/ /mnt/backup/home/
```

I'm not going to explain `rsync` and all it's options, because that's out of scope for this post. It's also not really helpful. You decide what you want to use as a backup tool and it doesn't need to be `rsync` at all.

Now, let's quickly go over the steps involved in backing up my data.

1. Plug in portable USB disk.
2. `ssh` into the Pi.
3. Run `lsblk` to figure out which `/dev/sdX` I want to mount.
4. Run `sudo mount /dev/sdX /mnt/backup`.
5. Run `./local-backup.sh`.
6. Check in after a few hours and see if the script is done.
7. Run `sudo umount /mnt/backup`.
8. Unplug the disk.

Easy, right?

In hindsight I'm a bit embarrassed to admit that I stopped here for quite some time. Any backup is better than no backup and ideas for improvement came to me bit by bit over time.

## Introducing Gotify

[Gotify](https://gotify.net/) is _"a simple server for sending and receiving messages"_. I specifically want to highlight that it makes sending push notifications to your phone (or other clients) exceedingly easy.

I discovered _Gotify_ while looking for something else entirely, but was immediately taken by how simple it is to set up and use.

I don't host my own _Gotify_ instance, but you easily could. I'm using the instance hosted by [AdminForge](https://push.adminforge.de/) and I'm very happy with it. The people behind _AdminForge_ are hosting a ton of great services and are also active on the [Fediverse](https://kanoa.de/@adminforge). Check them out if you want.

In the steps I've listed above, Gotify -- or rather `gotify-cli` helps me specifically with 

> 6. Check in after a few hours and see if the script is done.

So let's adjust the script a bit.

```bash
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

rsync -avP /home/pi/ /mnt/backup/home/

gotify-cli p -t Local-Backup "Backup is done."
```

{{< aside >}}
You'll need to run `gotify-cli init` first to login to the server you're using.
{{</ aside >}}

Sweet. Now I get a push notification on my phone. Let's revise the steps.

1. Plug in portable USB disk.
2. `ssh` into the Pi.
3. Run `lsblk` to figure out which `/dev/sdX` I want to mount.
4. Run `sudo mount /dev/sdX /mnt/backup`.
5. Run `./local-backup.sh`.
6. Get notified that the backup is done.
7. `ssh` into the Pi.
8. Run `sudo umount /mnt/backup`.
9. Unplug the disk.

Well, it's now 9 steps instead of 8, but it got a bit more convenient. If you're observant, you'll have noticed that _and see if the script is done_ implies that it very well could still be running and I'd have to check in multiple times. And step 6 doesn't really require me to do anything but notice the notification on my phone.

What's next?

## Unmount the disk

This seemed like the logical next step. No need to log onto the server again.

```bash
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

rsync -avP /home/pi/ /mnt/backup/home/

sudo umount /mnt/backup

gotify-cli p -t Local-Backup "Backup is done and disk is unmounted."
```

I also adjusted the notification message, so I have a reminder that I can just unplug the disk.

Let's look at our steps.

1. Plug in portable USB disk.
2. `ssh` into the Pi.
3. Run `lsblk` to figure out which `/dev/sdX` I want to mount.
4. Run `sudo mount /dev/sdX /mnt/backup`.
5. Run `./local-backup.sh`.
6. Get notified that the backup is done and disk is unmounted.
7. Unplug the disk.

## Finding the right disk by UUID

I added some code to make the script safer with `findmnt`. This ensures that I don't accidentally copy tons of data onto the same disk and run out of space.

While I added the code, I realized that I can also use this to mount the disk if it is unmounted. I usually work with the `sdX` devices when I mount disks manually, but you can also find the right device in `/dev/disk/by-uuid/`. The easiest way to figure out which disk you want is to run `ls -l /dev/disk/by-uuid/`, because it will show you to which devices the UUIDs are symlinked.

```bash
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

if ! findmnt /mnt/backup; then
        sudo mount /dev/disk/by-uuid/1989f5f5-b0f6-4dfa-8677-63d20bdc044d /mnt/backup/
fi

rsync -avP /home/pi/ /mnt/backup/home/

sudo umount /mnt/backup

gotify-cli p -t Local-Backup "Backup is done and disk is unmounted."
```

That leaves us with the following steps.

1. Plug in portable USB disk.
2. `ssh` into the Pi.
3. Run `./local-backup.sh`.
4. Get notified that the backup is done and disk is unmounted.
5. Unplug the disk.

Now we're talking. This is pretty usable and I ran this for a very long time.

There's a good reason for that, because the next step -- while obvious -- took some work and experimentation. Let's get to it.

## Automating away the rest with a udev rule and a service

Linux is amazing. While Windows as an OS will do it's damndest to hide information from you, Linux just gives you access to everything.

With full knowledge of what's going on with the systems, we can find out when a specific device is plugged in. That's where `udev` comes in.

As far as I understand, `udev` is responsible for creating the device files in `/dev` when a device is detected. But it also allows you to define additional rules as to what should happen when a device is added, removed, etc.

We want this for a rule like this: _if this specific USB disk is connected, run our local-backup.sh script_.

Now there's one thing to look out for with `udev`. You can't run a long running processes, because it would block other kernel operations. But we can assume that backing up 4TB of data might take some time -- even if `rsync` will only copy changed files.

What we can do instead of running the script itself, is to start a `systemd` service. That only takes a few milliseconds and will run happily in the background.

So let's write all this out.

### /home/pi/.config/systemd/user/local-backup.service

```bash
[Unit]
Description = Back up files to a local disk

[Service]
Type = simple
ExecStart = /bin/bash -c "cd %h; /usr/bin/sleep 10; ./local-backup.sh"
StandardOutput = journal
StandardError = inherit

[Install]
WantedBy = default.target
```

Make sure to run `systemctl --user daemon-reload`, so `systemd` is aware of the new service.

Two things to note.

1. We use `cd %h` to change to the home directory. `%h` is a builtin variable for the user's home directory in `systemd`.
2. We `sleep 10` to make sure that the disk is ready and our `mount` command won't fail, because we're too quick.

### /home/pi/run-backup-service.sh

```bash
#!/bin/bash

# Take care! This doesn't work without setting the XDG_RUNTIME_DIR env variable.
/usr/bin/sudo -u pi XDG_RUNTIME_DIR=/run/user/$(id -u pi) systemctl --no-block --user start local-backup.service
```

### /etc/udev/rules.d/99-backup-disk.rules

```bash
ATTR{idVendor}=="0bc2", ATTR{idProduct}=="2344", ACTION=="add", RUN+="/home/pi/run-backup-service.sh"
```

How did I figure out these cryptic `idVendor` and `idProduct` values?

```bash
udevadm info -a -n /dev/sdc | grep '{id'
```

Don't worry that this command will show you multiple matches. If you remove the `grep` command it will tell you the following.

```bash
udevadm info -a -n /dev/sdc

Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.
```

To enable this rule, you'll need to run `sudo udevadm control --reload-rules && sudo udevadm trigger`.

{{< aside >}}
I tried running the `systemctl start` command from `run-backup-service.sh` directly in the `udev` rule, but it didn't work and I wasn't willing to put endless work into it.
It works with the script and I'm happy enough with that.
{{</ aside >}}

## Finishing touches -- add a trap for errors

As a bonus, I added a `trap` to the backup script. If anything goes wrong, it should send out a notification so I know I need to check for errors.

This is the final version of my backup script. I'm adding comments, so you should be able to copy and adjust it as needed.

```bash
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Add a trap for errors. If anything goes wrong, we want to be notified.
trap 'gotify-cli p -t Local-Backup "Something went wrong."' EXIT

# Check if /mnt/backup is already mounted, otherwise look for our backup disk
# and mount it by UUID.
if ! findmnt /mnt/backup; then
        sudo mount /dev/disk/by-uuid/1989f5f5-b0f6-4dfa-8677-63d20bdc044d /mnt/backup/
fi

# Backup all the stuff.
rsync -avP /home/pi/ /mnt/backup/home/

# We're done. Unmount the disk.
sudo umount /mnt/backup

# Unset the trap. If we didn't do this, we'd get an error notification, even
# when the script exits successfully.
trap "" EXIT

# Send the "All OK" notification, so we know we can unplug the disk.
gotify-cli p -t Local-Backup "Backup is done and disk is unmounted."
```

## Conclusion

So let's look at our remaining steps.

1. Plug in portable USB disk.
2. Get notified that the backup is done and disk is unmounted.
3. Unplug the disk.

Pretty good, don't you think?

Let me know if this helped you or not. 🙂
