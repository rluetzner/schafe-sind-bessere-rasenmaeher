---
title: ".NET Framework and Code Coverage from the Terminal with OpenCover"
date: 2024-04-12T20:56:12+01:00
draft: false
categories: ["tech"]
tags: [".net","terminal","foss"]
license: cc-by-nc-sa
---

> This is a condensed version of https://sbytestream.pythonanywhere.com/blog/Code-Coverage-For-NUnit . Many thanks Siddharth Barman, I wouldn't have gotten this far without you.
>
> Be advised that the [OpenCover](https://github.com/opencover/opencover/) project has been archived and is no longer actively developed. There are FOSS alternatives available, but this is what I got working, so I'll stick with it until it breaks.

I've managed to move most of my development workflows to the terminal. However, one of the last few things that's been missing in my toolbelt, was gathering code coverage. Anything that uses `dotnet` (i.e. .NET Core 2 and newer) is easy. Besides, I have a CI that solves this for me.

But I also have a few legacy[^legacy] projects that rely on Windows. CI support is sadly still _in progress_ for those. For the longest time I thought, that there would be no way around VisualStudio [^visual-studio] when it comes to unit tests and code coverage.

So far, I had managed to get Neovim working on Windows and had even figured out how to sync my config files using chezmoi (Windows uses a different config path). I've set up a few shortcuts and aliases in my PowerShell profile to build these legacy projects.

```PowerShell

New-Alias lg lazygit.exe
New-Alias vi nvim.exe
New-Alias vim nvim.exe

function msbuild {
  & "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" "/t:clean,build" "/p:Configuration=Debug" "/verbosity:m" "/property:NoWarnings=True" "/m:4" "/clp:Summary;ErrorsOnly" "/restore" "$args"
}
```

The `$args` allow me to use the `msbuild` function with any `*.sln` or `*.csproj` file.

Now, let's install a few things with Chocolatey.

{{< aside >}}
If you don't know about Chocolatey, you're missing out.

It's a package manager for Windows that makes it much easier to grab and install software than downloading installers or binaries off the internet. It also helps you keep things nice and updated.

Check it out [here](https://chocolatey.org/).
{{</ aside >}}

We'll install three things:

- [`nunit`](https://nunit.org/), which is what I'm using as a testing framework,
- [`opencover`](https://github.com/OpenCover/opencover), which we'll use to generate an XML file with code coverage metrics and
- [`reportgenerator`](https://github.com/danielpalme/ReportGenerator), which will allow us to visualize the results in a nice and human readable way.

```powershell
choco install nunit opencover reportgenerator.portable
```

For code coverage to work, `opencover` needs to wrap the test method calls in our test project's `*.dll`, so it knows to record what's going on.[^opencover] For this I added another function to my `profile.ps1`.

> `OpenCover.Console.exe`, `nunit3-console.exe`, `msbuild.exe` and `ReportGenerator.exe` are on my `PATH`, so I can call the executables directly without having to specify a long path. Chocolatey was able to solve some of this automatically, but I remember having to add at least one of the paths manually.

```powershell
function opencover {
  & "OpenCover.Console.exe" "-targetargs:$args" "-target:nunit3-console.exe" "-output:C:\Temp\code-coverage.xml"
}
```

Basically, we tell it to run `nunit3-console.exe` under the hood and call that with `$args` (i.e. the test project DLL). The output will end up in `C:\Temp\code-coverage.xml`, from which we'll generate a report. We'll do this with yet another function.


```powershell
function coverage-report {
  & "ReportGenerator.exe" "-reports:C:\Temp\code-coverage.xml" "-targetdir:C:\Temp\report"
  C:\Temp\report\index.html
}
```

`coverage-report` takes the XML and generates a web page for us, that we can look at with our favorite browser. The first line of this function generates the web page, and the second line calls the `index.html` file directly, which will open up the page in the default browser.

And that is all the setup we need. Here's a quick example of how I use it.

```powershell
msbuild Stuff.sln
opencover .\Stuff.Tests\bin\Debug\Stuff.Tests.dll
coverage-report
```

Feel free to let me know if you've learned something new or want to share how you're doing things.

[^legacy]: When I say _legacy_, I mean it! There's stuff that's .NET Framework 3.5, 4.0, 4.5, 4.6, 4.6.1, etc. And then there's projects that are .NET Core 2.1 or 3.0 or .NET Standard 2.0. And let's not stop there. Of course there are project dependencies that tie all this madness together into some weird Frankenstein's .NET monster.  
All of that is a very long way of saying: forget `dotnet build`, forget `dotnet msbuild` and especially forget `dotnet test` -- which would allow me to easily hook in code coverage adapters.

[^visual-studio]: I feel like it's still the easiest and most convenient way to develop .NET on Windows, but I'm trying my damndest to move away from anything Microsoft.

[^opencover]: The reality is of course a bit more complicated. I kinda understand what's going on, but I can't explain it well enough and it'd be out of scope of this article anyway.
