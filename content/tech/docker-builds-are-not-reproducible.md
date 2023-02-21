---
title: "Docker builds are not reproducible"
date: 2022-10-16T21:30:08+02:00
draft: false
categories: ["tech"]
tags: ["docker"]
license: cc-by-nc-sa
---

> **TL;DR**
> 
> If your Docker build depends on installing packages from an external package repository, you might be in for a surprise.
>
> A possible solution is to copy cached layers from an existing machine to a new one.

I'll probably out myself as an absolute idiot, but Docker builds are far from reproducible.

Recently I had to setup a new Jenkins node at work and to verify that everything works correctly, I ran our build process. To my surprise the build step creating and exporting a Docker image failed.

After some research I realized that although the base image was still available (we're using SUSE Linux 15.2) some of the package repos no longer exist. The build step wasn't failing on the other Jenkins nodes because all Docker build steps were **cached**.

I ran through a couple of options.

1. The best option to my mind would be to push the created image (or even the cached intermediary layers) to an internal registry. This would fix the problem for newer releases, but we often have to build older versions of our software and backporting this fix everywhere would be a real pain.
2. Another option I attempted, but failed, was to export the intermediary layers on one of the existing Jenkins nodes and import them on the new one. They will however not be picked up by the build cache, so the problem still persists.
3. The final option, which seemed overkill, was to pack all overlay folders into a tarball and extract that on the new machine. I honestly didn't expect this to work, but the Docker build cache detected the layers as existing and suddenly the build finished successfully.

In hindsight it should have been obvious that something like this would happen eventually. Being relatively new to the Linux world, I didn't expect packages to vanish from a repository or -- even worse -- the entire package repository to be gone. SUSE is a weird one at that, as it feels to me like other distributions keep their package repositories around for much longer, even when they run out of support. That might however also be a wrong assumption on my part.
