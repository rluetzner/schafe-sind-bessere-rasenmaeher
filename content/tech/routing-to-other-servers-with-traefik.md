---
title: "Routing to other servers with Traefik"
date: 2024-09-02T20:56:12+01:00
draft: false
categories: ["tech"]
tags: ["traefik","homelab"]
license: cc-by-nc-sa
---

I recently added [Immich](https://immich.app) to my homelab. To be precise: I added it to the 30 or so Docker containers that were already running on my Raspberry Pi 4 -- and it finally caused my already wobbly setup to collapse.

Immich comes with multiple containers, one of which is solely responsible for generating a local A.I. model to match people in photos. I tried a few ways to limit resources on the containers, but other services still kept crashing and the whole system became unresponsive. Oftentimes I couldn't even SSH into it anymore.

The easiest and quickest solution would have been to get rid of Immich. But Immich is just so much fun to use! Seriously, it makes me want to clean up my photo library which I've been meaning to do for years now. It is so much better than Nextcloud Photos, which I used before.

Luckily I still had a Pi 3 lying around, so I decided to finally look into how to route to other servers using Traefik.

As it turns out, it's actually pretty easy.

{{< aside >}}
I've been using Traefik for well over four years now, but I never really bothered to try and understand it's configuration. I copied a static config file when I started out and pretty much forgot about it's existence. Eventually I figured out the right Docker labels for Traefik to route to my services and I've been copying those around ever since.
{{</ aside >}}

Aside from it's _static_ configuration file, Traefik also allows us to define dynamic configuration parts either as Docker labels or in a file.

> The difference between _static_ and _dynamic_ is a bit muddy.  
> Basically the _static_ part is meant for things that rarely change, e.g. your `certsProvider` or `entrypoints`.  
> The _dynamic_ config is for pieces that can change frequently, e.g. `routers`.

First, we'll need to declare our dynamic config file in the _static_ configuration. Put this into your config file:

```yaml
providers:
  file:
    directory: /etc/traefik/
    watch: true
```

> I'm using a YAML format here, but Traefik also supports TOML. The transformation should be straightforward.

Now we can get started on our dynamic config. Let's create a file `dynamic.yml` with the following content:

```YAML
http:
  routers:
    forgejo-secure:
      tls: true
      rule: "Host(`forgejo.example.com`)"
      entrypoints: websecure
      service: forgejo

  services:
    forgejo:
      loadbalancer:
        servers:
          - url: "http://192.168.0.11:3000"
```

I'm using [Forgejo](https://forgejo.org) as an example, but you can of course use any other service and certainly define multiple routes in the same _dynamic_ config file.

Here are the things that are specific to my setup:

* You'll need to adjust `forgejo.example.com` to your domain and service. I'm using a subdomain, but you could also route via path segments.
* The `websecure` entrypoint is my HTTPS entrypoint defined in my _static_ config file.
* The name of the `forgejo` service on the router needs to match the service that's defined later on in the same file.
* My Pi 3 uses the IP `192.168.0.11`. This should be the IP of the server you want to route to.
* I've assigned port `3000` to Forgejo's web UI.

The last thing left to do is to tie this into your `docker-compose.yml` file:

```yaml
services:
  traefik:
    image: "traefik:latest"
    container_name: "traefik"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./config/traefik.yml:/traefik.yml:ro
      # This line here!!!
      - ./dynamic.yml:/etc/traefik/dynamic_conf.yml:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped
```

This literally took me longer to write than read up on and execute when I moved my services.

Another thing that came in to help was [Beszel](https://github.com/henrygd/beszel). Beszel is a **very** lightweight and simple monitoring service. It shows metrics for Docker containers too, which helped me identify a few services that I could move from my Pi 4 to the Pi 3 without stressing the less powerful system too much.

The end result is night and day. My Pi 4 is now noticeably more responsive, which is something all the remaining services benefit from. At the same time my Pi 3 is purring along nicely with things I use less frequently.

By the way, if you're wondering about my setup on the Pi 3, it's now running all the containers in their own separate networks with ports mapped and exposed on the host. I didn't think it'd be necessary to complicate things by putting in another reverse proxy on a host that's not directly exposed to the internet. I'm not afraid of attackers in my home network, but your security demands might vary. Keep that in mind.

Thanks for reading. 🙂
