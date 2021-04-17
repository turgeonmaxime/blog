---
layout: post
title: "Installing multiple R versions"
slug: multiple-r-versions
date: 2017-04-01
comments: true
tags: [R, package, continuous-integration]
---

[Sahir Bhatnagar](https://sahirbhatnagar.com/) and I are currently wrapping up the first version of our package [casebase](https://sahirbhatnagar.com/casebase/). In short, it's an R package for survival analysis, where we use case-base sampling to fit smooth-in-time hazards. (I could write a post on this package, but there's no need: check out the [website](https://sahirbhatnagar.com/casebase/) and the four vignettes.) As part of our workflow, we perform continuous integration using [Travis CI](https://travis-ci.org/), and we test our package against both the current and development versions of R. Recently, some tests began to fail against the development version, and so I had to install R-devel on my local machine in order to debug our code. This blog post is a summary of how I did it.

To be fair, this is already documented online, and I made use of these resources; see the [official R installation docs](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Installation) and this [RStudio support post](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R). I'm writing yet another post simply as a reference for myself and my colleagues. But I also ran into a compilation error that I wanted to document here. That error was "caused" by following closely the (amazing) book [*R packages*](http://r-pkgs.had.co.nz/) by [Hadley Wickham](http://hadley.nz/). Stick around to learn what the problem was!

<!--more-->

## R-devel on Travis CI

First, if you want Travis to test your package against both the release and the development version of R, simply add the following to your `.travis.yml` file:

``` yml
r:
  - release
  - devel
```

This effectively creates what Travis' docs call a *build matrix*. Every time you push to your repository, Travis will run two jobs, corresponding to testing against both versions.

## Downloading R-devel

For what follows, I'm assuming a Unix-like machine (the [R installation docs](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Installing-R-under-Windows) explain how to do this on Windows) You can download the source code directly from [CRAN's website](https://cran.r-project.org/), under alpha and beta releases.

## Installing necessary tools

To have muliple versions concurrently running on your machine, you will have to install them from source. And to be able to do that, you need to make sure you have the appropriate tools. Again, the R docs provide all the [details you need](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Essential-and-useful-other-programs-under-a-Unix_002dalike); in short, you need compilers for C, C++ and FORTRAN 90, appropriate libraries, and some extra tools. Fortunately, these tools are available through the usual package management systems. Moreover, if you're already building R packages, you already have these tools installed. 

## Building R from source

Once you have all the necessary tools and you have downloaded R-devel, unarchive the tarball and change directory to the source directory. The next step is to decide where you want to install this version; let's call it `/path-to-r-devel/`. This information needs to be passed to the `prefix` argument of the configure file:

``` bash
./configure --prefix=/path-to-r-devel/ --enable-R-shlib
```

As mentionned in the RStudio support post linked to above, the option `--enable-R-shlib` is required if you want to make this version of R available to RStudio.

As soon as the configuration script finishes, you are ready to install R:

``` bash
make
sudo make install
```

## **Bonus**: A compilation error

During the configuration step, the C/C++ compilers are identified, and these are the ones used for building R itself. However, one of the last steps of the installation is to build *recommended* packages. If you have a `.R/Makevars` file on your machine, it could be used to select a *different* set of compilers. For example, if like me you've learned how to make `R` packages by following Hadley Wickham's book [*R packages*](http://r-pkgs.had.co.nz/), you may have added the following lines to `.R/Makevars`:

``` bash
CC=ccache clang -Qunused-arguments
CXX=ccache clang++ -Qunused-arguments
CCACHE_CPP2=yes
```

To be fair, he makes a very good case of why this would be a good idea: `clang++` gives better error messages than `g++`, and `ccache` will speed up compilation. However, I ran into an issue when trying to build the recommended package `mgcv`: to parallelize some of their computations, the authors of `mgcv` make use of OpenMP, which means it must be built with an OpenMP-enabled compiler. Once this has been figured out, the fix is easy: either go back to `g++`, or use the [OpenMP extension](https://clang-omp.github.io/) to `clang`. 

## Conclusion

That's it! The process is pretty straightforward, and if I ever need again to debug some code against R-devel, this is the process I will be going through.

As a final note, here's how to [set up RStudio to use your version of choice](https://support.rstudio.com/hc/en-us/articles/200486138-Using-Different-Versions-of-R). If you comments or questions, leave them below!
