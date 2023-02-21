---
title: "I toot with the power of cURL"
date: 2022-11-01T20:56:12+01:00
draft: false
categories: ["tech"]
tags: ["mastodon","curl"]
license: cc-by-nc-sa
---

I spent the last two days trying to make a simple script that toots a static message on Mastodon. The idea came to me, because my instance admin is determined to welcome all new users to the instance. He's been using the same message for a while, but when asked he admited that he puts them together manually every time.

As I'm not familiar with administrating a Mastodon instance, I offered to help in automating the part of the process sending out a welcome toot. Here's my journey including the pitfalls.

You can find the working script [here](https://codeberg.org/RollenspielMonster/rollenspiel.social/src/branch/master/simple-toot).

## Starting out, i.e. registering a new client application

I asked my good friend [Startpage](https://startpage.com) for advice and promptly crashlanded on the Mastondon API documentation. If I were a more determined person I might have stayed there (and saved myself a bit of trouble), but I'm lazy. So I went looking further and found [this article from leancrew.com](https://leancrew.com/all-this/2018/08/autotooting-with-mastodon/).

I quickly scanned the article (which I found way too long to actually read) for the necessary cURL commands. The first one I found was this (adjusted to my use-case):

```bash
# Register a new client application.
# Works like a charm.
curl -X POST \
    -F "client_name=simple-toot" \
    -F "redirect_uris=urn:ietf:wg:oauth:2.0:oob" \
    -F "scopes=write" \
    -F "website=https://rollenspiel.social" \
    https://rollenspiel.social/api/v1/apps
```

The output is an easy to understand JSON that contains the desired client ID and secret values.

## Getting an access token -- the wrong way

The next step in the process is to retrieve an access token from the server. Seemingly that is another simple POST request:

```bash
# WARNING! This code uses deprecated parameters.

curl -X POST \
    -F "client_id=<CLIENT-ID>" \
    -F "client_secret=<CLIENT-SECRET>" \ 
    -F "scope=write" \
    -F "grant_type=password" \
    -F "username=<USERNAME>" \
    -F "password=<PASSWORD>" \
    https://rollenspiel.social/oauth/token
```

This however does not work. At this point I was confident enough (again) with cURL's syntax to attempt reading the [Mastodon API docs](https://docs.joinmastodon.org/methods/apps/oauth/#obtain-a-token) directly. It was also getting pretty late and I wanted to get this done as quickly as possible, so I scanned the documentation for interesting keywords. I discovered that `grant_type=password` no longer exists and it should read `grant_type=client_credentials` instead. Or so I thought. More on that later.

I also had to add the same `redirect_uri` I used when registering the client app in the first step.

The updated request therefore looked something like this:

```bash
# WARNING! This code will work, but it is not what we want.
# Check below for the right code and an explanation why.

curl -X POST \
    -F "client_id=<CLIENT-ID>" \
    -F "client_secret=<CLIENT-SECRET>" \ 
    -F "scope=write" \
    -F "grant_type=client_credentials" \
    -F "redirect_uri=urn:ietf:wg:oauth:2.0:oob" \
    -F "username=<USERNAME>" \
    -F "password=<PASSWORD>" \
    https://rollenspiel.social/oauth/token
```

This completed successfully and returned a JSON containing the desired access token element.

## Sending a toot without the proper permissions or WHY THE F*!= ISN'T THIS WORKING???

The last step, now that we have the user-specific access token for our app, is to actually toot a message. The leancrew.com article I used as a tutorial resorted to using Python here, but I wanted to keep this as simple as possible.

> I still ended up with Python in the script, because I figured it would be the safest way to parse a value from a JSON string.
>
> `jq` is also an option, but the chance that `python` is already installed is basically 100% and at least in my experience `jq` has to be installed manually at some point.

This should work:

```bash
# This will work in the end, but not right now!

TEXT="this is
a multiline
text.
it
should
work
(hopefully)."

curl -s -X POST \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -F "status=${TEXT}" \
	-F "visibility=direct" \
    https://rollenspiel.social/api/v1/statuses
```

This however kept returning the following error:

```text
HTTP Error 422: This method requires an authenticated user.
```

What the hell? I received an access token without error, why shouldn't it work.

I tried adding quotes to the `$ACCESS_TOKEN` variable, but then the error message stated that the access token wasn't valid. So the syntax and the token itself weren't the problem.

At this point I gave up for the day. I took all the information I had until now and put it into a [toot](https://rollenspiel.social/@mforester/109264958526719952).

## Learning to read (again) or getting an access token -- the right way

When I came back the next day I went straight for the Mastodon API docs again. I had gotten a few answers to my toot, but neither a solution nor an explanation.

What bugged me was that the different errors from before told me that I had a valid access token. But for whatever reason -- even though I had specifically requested a 'write' scope -- the access token didn't have the necessary permissions to toot in my name.

After just a few minutes I found this exact piece of information in the documentation of the POST request I used earlier.

> **grant_type (REQUIRED)** -- _string_ -- Set equal to `authorization_code` if code is provided in order to gain user-level access. Otherwise, set equal to `client_credentials` to obtain app-level access only.

_User-level access_? Be still my heart!

As it turns out there was another step missing. A step that (at least for me) brought it all into focus.

At the very top of the [docs page](https://docs.joinmastodon.org/methods/apps/oauth/#obtain-a-token) where I was looking was a GET request to prompt the user to authorize a given client app. That is also what I've seen other apps, e.g. Tusky, do. It also gets rid of the username and password, which not only cleans up the script, but also makes it a bit safer in my opinion. If it never even knows the user's credentials there's nothing harmful it could do with them.

So the final piece of the puzzle looks like this:

```bash
echo "https://rollenspiel.social/oauth/authorize?response_type=code&client_id=${CLIENT_ID}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=write"

read -p "Enter the authorization code: " AUTH_CODE
```

The user has to open up a specific URL in their browser, log in and authorize the app to access their account. As I've seen in other CLI tools (e.g. RClone) I simply prompt the user to paste the authorization code.

With this we can get _user-level_ access by modifying the POST request we used earlier to receive an access token:

```bash
curl -s -X POST \
        -F "client_id=${CLIENT_ID}" \
        -F "client_secret=${CLIENT_SECRET}" \
        -F "scope=write" \
        -F "grant_type=authorization_code"\
        -F "code=${AUTH_CODE}" \
        -F "redirect_uri=urn:ietf:wg:oauth:2.0:oob" \
        https://rollenspiel.social/oauth/token
```

Notice that the `username` and `password` are gone. We use `grant_type=authorization_code` and hand over the code the user pasted earlier.

This returns an access token that has the necessary permissions. The toot command from earlier now works without any modifications.

## Wrap-up

The entire process goes something like this:

1. Register a new client app with the server, i.e. receive a client id and secret.
2. Prompt the user to visit a URL and authorize the tool to access their account. The user has to copy and paste an authorization code.
3. Get an access token using the authorization code from the previous step.
4. Toot!

Steps 1-3 are one-time only. As long as we have an access token, there's no reason to go through this process again.

Again, look up the final script [here](https://codeberg.org/RollenspielMonster/rollenspiel.social/src/branch/master/simple-toot) and feel free to use it and/or send in any improvements.
