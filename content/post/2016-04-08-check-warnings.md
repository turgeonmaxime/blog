---
layout: post
title: "Removing all R CMD check warnings"
slug: check-warnings
date: 2016-04-08
comments: true
tags: [R, package, continuous-integration]
---

Making R packages is an important aspect of the statistician's work. Or at least it should be: it is quite annoying when a new method appears in the literature but no implementation is readily available. 

A favourite mantra of mine when making R packages is the following: **an R package is more than the sum of its functions**. A functioning R package needs to be able to interact properly with the R environment (through the ```NAMESPACE```); a good R package also needs great documentation; a great R package will also include a vignette to guide new users and explain how all the functions interact with one another.

The main reference for how to make R packages is [*Writing R extensions*](https://cran.r-project.org/doc/manuals/r-release/R-exts.html). Everything you need to know is there, if you know what you are looking for. Another, very useful reference is Hadley Wickam's [book on R packages](http://r-pkgs.had.co.nz/). This book explains the different components of an R package, and it also serves as an introduction to his [```devtools``` package](https://cran.r-project.org/package=devtools).

In what follows, I don't want to go over how to make an R package; the above references do a better job than I could hope to do. Rather, I want to share my experience about some of the most annoying part of making an R package: passing the ```R CMD check```. Removing the errors is the most important part, and what kind of errors you get really depends on the package (the log file is typically quite useful in figuring out what triggered the errors). On the other hand, you also want to minimize the number of warnings and notes, and most warnings you probably want to remove altogether. 

<!--more-->

### Distribution options

The first thing to do, perhaps even before starting to make the R package, is to decide how your package will be distributed. The simplest package you can make is probably one which *packages* all the functions you typically use in your daily life as a statistician. You don't necessarily need to share this package with anyone, so for example you may not care as much about good documentation. At the other extreme, if you plan on making a package that will be used by a large community and that is expected to interact with a large number of packages, you should first familiarize yourself with the rules governing the development of such packages ([Bioconductor](http://www.bioconductor.org/) is an example of such a package repository). 

Below I go over three popular distribution options. They all assume that you want to share your package with the public.

#### GitHub

All my packages, and all my lab's packages, are on [GitHub](https://github.com/). This website is a great way of sharing your development code, and it also allows for easy collaboration and bug reporting. You can also easily install a package hosted on GitHub using the function ```devtools::install_github```. If you are using this option, you are free to do as you please and ignore all warnings triggered by ```R CMD check```, but you should still strive for a package that works well for anyone who wishes to install it. 

#### CRAN

This is the most popular package repository for R, the [Comprehensive R Archive Network](https://cran.r-project.org/). It is maintained by a handful of dedicated statisticians. As a result, communicating with them can be [unpleasant and frustrating](http://emhart.info/blog/2015/05/28/raiders-of-cran/), although being polite and making the required changes can make the process smoother. 

A very nice service they offer is to run ```R CMD check``` on their servers using a Windows installation. They will then send you an email with the log files, so you can check if your package also works on Windows. The easiest way to do this is probably using the function ```devtools::build_win```.

#### Bioconductor

If you want to distribute your package through Bioconductor, you should start by familiarizing yourself with their [guidelines](http://www.bioconductor.org/developers/package-guidelines/). For example, they expect each package to have at least one vignette and each documentation page to have a runnable example. They also have strict guidelines for function and variable names. Believe me, you want to have the correct names when you *start* developing the package, not after everything is done!

***

Once you have decided how you will share your package, and that you have a functionning package, you also need to think about the data in your package (if any) and its ```NAMESPACE```.

### Data

There are two main types of data in an R package: *internal data*, used internally by your R package and not available to the user; and *external data*, available to the user and typically used in examples and vignettes. 

#### Internal data

This is useful, for example, if you need tables of pre-computed values for some of your functions. All internal data should be saved as an R image in the file ```R/sysdata.rda```. The objects in this file will retain their name, and the functions in your package can refer to them explicitely. It can also be a good idea to use the function ```tools::checkRdaFiles``` to determine what is the best compression type.

#### External data

If your package has a vignette, it can be useful to provide some data on which your package can be applied. This is probably the most useful form of documentation available in R. 

These objects should be saved in the directory ```data/```. Also, it is highly recommended that you document all datasets (see for example the [veteran data in the survival package](https://stat.ethz.ch/R-manual/R-devel/library/survival/html/veteran.html)).

Following these guidelines should prevent a few headaches. For example, if you have internal data saved in ```data/``` and that should not be available to the user, you will be wondering why ```R CMD check``` asks that you document them anyway...

### NAMESPACE

The ```NAMESPACE``` is probably the most subtle part of making an R package. Its main purpose is to dictate how your package interacts with other packages. It is not that important if you are only making a package for yourself, but it is **vital** if you plan to distribute your package in any way: you don't want your code to interfere with other packages, and vice versa.

In my experience, the most frustrating part of ```NAMESPACE``` is how it relates to the different object-oriented systems. In general, you should export any ```S3``` methods you create (the only exception being methods for [internal generics](https://stat.ethz.ch/R-manual/R-devel/library/base/html/InternalMethods.html)). On the other hand, if the method is for a generic that is *not* part of your package, then you also need to import the generic (via ```importFrom(package, generic)```).

The ```S4``` system is a little bit more complicated: you need to import classes you extend (via ```importClassesFrom(package, class)```) and generics for which you define methods (via ```importMethodsFrom(package, generic)```). Moreover, if you use the ```S4``` system, you will need to import the package ```methods```.

Finally, one annoying warning I typically do not see on my computer but always get when running ```R CMD check``` on a vanilla system (e.g. on Travis, or when CRAN is performing their tests) is that I forgot to import functions from some of the base packages (e.g. ```stats```, ```grDevices```, ```utils```). For example, if you use ```lm``` to perform linear regression, it is required that you add ```importFrom(stats, lm)``` to your ```NAMESPACE```. There is one alternative: you can be explicit in your code and replace ```lm``` by ```stats::lm```; in this case, the ambiguity in the name is resolved and no ```NAMESPACE``` directive is necessary.

### Extra tips

 - ```R CMD check``` requires consistency between the different methods of a generic. This means consistency in the parameters and their names: if the generic as signature ```foo(x, y, ...)```, your method needs all these parameters,and perhaps some new ones only required for a specific class ```bar```, which would give ```foo.bar(x, y, ..., z)```. This usually gives me a few headaches.
 
 - When the checks are performed in a "headless" fashion, i.e. solely through the terminal, some graphical features may not be available. This can cause headaches, and it has in the past for our lab. As a specific example, the R package ```rgl``` will not work on a vanilla session of Travis. We get the following warning:
 
``` bash
** testing if installed package can be loaded
Warning in rgl.init(initValue, onlyNULL) :
 RGL: unable to open X11 display
Warning: 'rgl_init' failed, running with rgl.useNULL = TRUE
```
 
 The solution we found was to set the following environment variable: ```RGL_USE_NULL=TRUE```. As the warning mentions, this is essentially what happens anyway when ```rgl_init``` fails. 
 
 - You should almost never use functions with side-effects in your package. Examples of such functions are ```library```, ```require```, ```options``` and ```data```. In the first two cases, you should use the ```NAMESPACE``` and ```DESCRIPTION``` files if your package needs specific functions from another package. If you want to use ```options``` to turn off warnings or errors, you should instead use R's [exception handling capabilities](http://www.r-bloggers.com/error-handling-in-r/). Finally, you never need to use ```data```; see the discussion about internal vs. external data above.
 
 - If you are sending your package to CRAN or Bioconductor, you are not allowed to use the triple colon ```:::``` to access "hidden" functions. In any case, you should **never** use ```:::``` or ```::``` to access functions from your package; this is simply unnecessary.
 
 
I hope these tips will help. Please share your own in the comments below!