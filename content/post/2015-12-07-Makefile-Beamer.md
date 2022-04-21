---
layout: post
title: "Makefile and Beamer presentations"
tags: [linux, Latex, Beamer]
slug: makefile-beamer
date: 2015-12-07
comments: true
---

I have been wondering about Makefiles for some time now, and recently I finally got around learning about them so that I could use ```make``` to regenerate all the different versions of a manuscript I'm working on. And I thought I would take the opportunity to explain how they can be useful for Beamer presentations.

<!--more-->

The setting is as follows: let's say you are preparing slides using Latex/Beamer. You are including pauses in your slides, e.g. you are stopping after each bullet point. This is useful if you want to focus the attention of the audience on a specific point of your slides, or if you don't want to reveal the punchline too soon. On the other hand, if you want to print the slides, you want to remove these pauses. This is why the beamer class has the option ```handout```. Now, the question is, how do I generate these two files from the same presentation?

There is a few possibilities that come to mind:

  - You can have two Latex files, one for the slides and one for the handout. However, if you make changes to one, it can become difficult to know if you've also made the changes to the other. 
  - You can have one Latex file, that you then always compile twice: once with the ```handout``` option, once without.
  
Another possibility is to have *three* Latex files: one with the text, and two that only contain headers (one with option ```handout``` and one without). This is usually what I do. 

Where the Makefile can become useful is in *automating* the compilation of both the handout and the slides. Moreover, if for example you only change the header file for the handout, you don't want to have to recompile the slides. 

The setting is going to be as follows: say you have a presentation in a file ```talk.tex```. You also have two separate files for the headers: ```talk_slides.tex``` and ```talk_handout.tex```. The latter looks something like:

```latex
\documentclass[handout]{beamer}
\input{talk.tex}
```

### Makefile 

Now let's talk about the Makefile. In general, there are three components to it: 

  - targets;
  - dependencies for each target;
  - a set of instructions to be executed when a dependency has been modified.
  
The point is that, once you have a Makefile in your directory, you simply use the function ```make``` to run the instructions.

The syntax of the Makefile is thus as follows:

```sh
targets: dependencies
  instructions
```

Note that you need a hard tab at the beginning of the instructions, or otherwise you will get a missing operator error (although you can circumvent this [using semi-colons if you want](https://stackoverflow.com/a/14109796/2836971)).
  
Let's look at one example: one target we are interested in is ```talk_handout.pdf```, the output when compiling ```talk_handout.tex``` with ```pdflatex```. We want to recompile it when either ```talk_handout.tex``` or ```talk.tex``` is changed. Therefore in the Makefile, we would write

```sh
talk_handout.pdf: talk_handout.tex talk.tex
  pdflatex talk_handout
```

And of course you would have something similar for the target ```talk_slides.pdf```. 

### Special targets

There is two important special targets that I want to discuss: ```all``` and ```.PHONY```. By default, the function ```make``` will build the first target when you call it without an argument, and to build a specific target you would write ```make target```. But what if you want to build multiple targets at the same time? Instead of running separate commands ```make target1```, ```make target2```, etc., you can use the special target ```all```, whose dependencies are all the other targets you would like to build at the same time. For example, with our Beamer presentation, you would have

```sh
all: talk_handout.pdf talk_slides.pdf
```

Next, ```.PHONY```. When you compile Latex files, you get several auxiliary files which can useful to speed up a future compilation. But sometimes you also want to remove them; the Makefile can also help you automating this. You can create a target ```clean```, with or without dependencies, and with the instructions to remove these auxiliary files:

```sh
clean: 
  rm *.aux *.blg *.out *.bbl *.log
```

You can then clean your directory by simply calling ```make clean```. 

The issue, though, is that the ```clean``` target is special, in that it doesn't correspond to a file in your directory. To make sure ```make``` knows this, you can make ```clean``` a dependency of the special target ```.PHONY```. 


Therefore, our Makefile for the Beamer presentation is now

```sh
all: talk_handout.pdf talk_slides.pdf

.PHONY: clean
clean: 
  rm *.aux *.blg *.out *.bbl *.log
  
talk_handout.pdf: talk_handout.tex talk.tex
  pdflatex talk_handout
  
talk_slides.pdf: talk_slides.tex talk.tex
  pdflatex talk_slides
```

Voila! This is all you need for this project. Save the above script in a file named ```Makefile``` or ```makefile```, and you simply run the command ```make``` to recompile your pdf documents whenever you change something.

### More advanced concepts

The above Makefile is unnecessary long and also repetitive: for example the word ```talk``` appears in multiple places, and if we want to change it (e.g. we want to reuse this Makefile for another presentation), we need to change it everywhere. The solution is simply to create a variable that will hold the name of the presentation. Therefore to reuse the Makefile we only need to change one line:

```sh
FILE = talk

all: $(FILE)_handout.pdf $(FILE)_slides.pdf

.PHONY: clean
clean: 
  rm *.aux *.blg *.out *.bbl *.log
  
$(FILE)_handout.pdf: $(FILE)_handout.tex $(FILE).tex
  pdflatex $(FILE)_handout
  
$(FILE)_slides.pdf: $(FILE)_slides.tex $(FILE).tex
  pdflatex $(FILE)_slides
```

Moreover, since we are essentially using the same instructions for both ```talk_slides.pdf``` and ```talk_handout.pdf```, it would be nice if we only had to write it once. For this purpose, we can use the special macro ```$@```, which stands for the target name. We can then rewrite our Makefile as

```sh
FILE = talk

all: $(FILE)_handout.pdf $(FILE)_slides.pdf

.PHONY: clean
clean: 
  rm *.aux *.blg *.out *.bbl *.log
  
$(FILE)_handout.pdf $(FILE)_slides.pdf: $(FILE)_slides.tex $(FILE)_handout.tex $(FILE).tex
  pdflatex $@
```

So we have two targets on the same line, and only one set of instructions. One possible issue is that now ```talk_slides.tex``` is a dependency for ```talk_handout.pdf``` and vice-versa, and therefore both the slides and the handout will be recompiled whenever there is a change. This is not too problematic, since most changes will be made to ```talk.tex``` which is already a dependency for both the slides and the handout.

**Edit (2015/12/08)**: This actually doesn't work, because the target is a PDF document and ```pdflatex``` is expecting a Latex file (or a file without an extension). If someone knows how to fix this, you can post the solution in the comments below!

There is much more to learn about Makefiles, and I think the easiest way is to try it out and whenever I need something new, either look at the [official documentation](http://www.gnu.org/software/make/manual/make.html) or [stackoverflow](http://stackoverflow.com/questions/tagged/makefile). 

### Workflow 

Having been through the process of learning about Makefiles, I thought I would take advantage of all this and build a workflow for my Beamer presentations. What I want is the following:

  - All the files related to a presentation will be in a single directory, and only these files.
  - I want to follow the convention that the directory will be ```talk/```, the main text will be in ```talk.tex```, and I will have two extra Latex files with the headers, ```talk_handout.tex``` and ```talk_slides.tex```. The file ```talk.tex``` will follow my personal Beamer template.
  - I want a Makefile in the directory, and the first line will contain the name of the presentation: ```FILE = talk```.
  - Finally, I want to do all this (creating the directory and the files) by using a single script.
  
This single script is as follows:

```sh
# First argument is the name of the talk
# other arguments are ignored
TALK=$1

mkdir $TALK
cd $TALK/

# Create the two header files
echo -e "\documentclass[handout]{beamer}\n\input{$TALK.tex}" > $TALK\_handout.tex

echo -e "\documentclass{beamer}\n\input{$TALK.tex}" > $TALK\_slides.tex

# Create the main file
# Note: the path corresponds to where my template is located
cp ~/.config/texstudio/templates/user/template_beamer.tex $TALK.tex

# Create the Makefile
echo -e "FILE = $TALK"'

all: $(FILE)_handout.pdf $(FILE)_slides.pdf

.PHONY: clean
clean: 
\trm *.aux *.blg *.out *.bbl *.log
  
$(FILE)_handout.pdf $(FILE)_slides.pdf: $(FILE)_slides.tex $(FILE)_handout.tex $(FILE).tex
\tpdflatex $@' > Makefile
```

Note that the functionality of this script is highly dependent on which type of shell you use. But a particular point to keep in mind is that, when creating the Makefile, I'm using both single and double quotes. This is because I want most of the variable names to be interpreted literally, *except the first line*, which will change depending on the name of the presentation. 

Now, I can put this script in a file called ```talkInit.sh```, put the file somewhere my interpreter can find, and then everytime I have a presentation to prepare, I simply type ```talkInit talk``` in the directory I want and everything should work fine!

If you have questions or comments, please feel free to add them below!