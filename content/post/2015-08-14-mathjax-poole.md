---
layout: post
title: "Using MathJax"
tags: [MathJax, jekyll, Markdown]
slug: mathjax-poole
date: 2015-08-14
comments: true
---

I had some trouble rendering correctly the mathematical equations in my [previous post](https://www.maxturgeon.ca/blog/2015-08-06-pcev/): at first I could only see the untransformed markup, then the text simply disappeared, without being transformed, and finally the equations appeared, but coloured orange. As you can see, everything now looks fine, but to fix this I ended up learning a bit more about how markdown, HTML, CSS and javacript all work together to create the website you are currently visiting. The purpose of this post is to share some of what I learned, so that future visitors can be spared some of the pain that accompanied the learning.

<!--more-->

As a disclaimer, I want to say that some of the following material is already well covered elsewhere on the web (e.g. take a look at [Chris Poole's blog post](https://christopherpoole.github.io/using-mathjax-on-github-pages/)). Indeed, the only thing I had to figure out on my own is how to fix the orange font. In any case, I hope the extra background can be useful -- it certainly was for me.

### MathJax

First of all, what is [MathJax](https://www.mathjax.org/)? It is an open-source Javascript engine that renders some text into mathematical equations. As such there are two main components:

1. Delimiters, which tell the engine where to start and stop reading.

2. Markup language, which tells the engine *how* to display the equations.

The main strengths of MathJax are that it works with pretty much all browsers and that it understands both [LaTex](http://www.latex-project.org/) and [MathML](http://www.w3.org/Math/), two of the most widely used equation markup languages. In other words, MathJax allows us to use the familiar LaTex macros directly inside our HTML document, and the Internet browser will automatically know how to interpret them.

How can we use it? We simply need to add a few lines in the header of our html document, which will tell the browser where to find the necessary Javascript code. You can provide a custom implementation of MathJax (it's open-source!), but the simplest way is to point directly to the latest stable implementation, like this:

```html
<head>

<!-- Some html code -->

    <script type="text/javascript"
            src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
    
<!-- Some more html code -->

</head>
```

If you want to change a few things to the script, but you only want these changes to apply to a given webpage, you can also add some custom Javascript between the <code>&lt;script&gt;</code> tags. For example, if you want to change the color to yellow, you can do it like this:

```html
<script type="text/javascript"
        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">

    MathJax.Hub.Config({ styles: {
        ".MathJax": {
            color: "#FFCC00"
        }
    }
    })

</script>
```

How does MathJax know where to start and stop rendering the math equations? There are delimiters, of course! By default, MathJax supports three kinds: <code> \[ ... \] </code> for block mathematics, <code> \( ... \) </code> for inline mathematics, and <code> \$\$ ... \$\$ </code> for both (depending on the relation between the markup and the surrounding text, it will be displayed inline or as a block). Note, however, that the familiar LaTex-way of displaying inline equations (using single dollar signs) is **not** supported by default, since dollar signs are frequently used in plain text. If you want to change this default behaviour, have a look at the [documentation](http://docs.mathjax.org/en/latest/tex.html#tex-and-latex-math-delimiters). 

### MathJax and Markdown

If you are writing your HTML from scratch, then the above is all you need to add nicely displayed math equations to your webpage. However, if you are using Markdown (as I am), there are a few extra things you need to think about. 

For those unfamiliar with it, [Markdown](http://daringfireball.net/projects/markdown/) is a lightweight markup language whose main purpose is to be easily **writable** and **readable** by humans in a basic text editor. In order to use it for your website, you also need some piece of software that will parse the Markdown and output HTML code. Since MathJax works directly on the HTML file, the main point is to make sure that the parsing will not change the equation markup. There are two things to keep in mind when choosing the parser:

1. You will most certainly need to escape backslashes. In other words, the MathJax delimiters will need to be written as ``` \\[ ... \\] ``` and ```\\( ... \\)```. As another example, since the line-breaks in a block equation are usually written using two backslashes ``` \\ ```, you will need to escape both and thus use four: ```\\\\```.

2. Some parsers will change frequently-used symbols to HTML tags. For example, as [Chris Poole mentions](http://christopherpoole.github.io/using-mathjax-on-github-pages/), [discount](http://www.pell.portland.or.us/~orc/Code/discount/) will change ```x^2``` to ```x<sup>2</sup>```, and therefore MathJax will not be able to render the equation properly.

So which software should you use? From what I've seen online, a safe choice when using MathJax is [kramdown](http://kramdown.gettalong.org/). It is free, open-source, supported by GitHub, and can also be used as a converter to other document markup languages (e.g. LaTex, which can then be rendered as a PDF document). This is the parser I use.

### And now, for something completely different...

So I followed all the instructions above. Since this website is built using [jekyll](http://jekyllrb.com/), I changed the ```_config.yml``` so that all Markdown files are converted using kramdown. However, my equations were all orange, whereas I wanted them black, like the surrounding font. I Googled quite a bit, trying to find a solution to the problem. I tried to force the colour in the Javascript (as explained above), but to no avail. 

However, on a slower browser (i.e. on my cell phone), I could observe the following sequence of events:

1. I could see the LaTex markup.

2. Then it was displayed as equations, *in black*.

3. Finally the black equations were coloured *in orange*.

I think this sequence of events was a strong indication that the problem was not with the Markdown converter or with MathJax, but with the CSS files.

I don't know much CSS and HTML (although I know more now than when this problem first came up!), so when I decided to set up a personal website, I decided to use the template [hyde from poole](http://hyde.getpoole.com/). The main *advantage* of this template is that it is provides the foundation you need for a jekyll-powered website. The main *disadvantage* is that I don't know yet exactly how all its pieces fit together.

So what happened? Hyde comes with a CSS file named ```syntax.css```, which assigns the colour orange to a few custom IDs (corresponding to what they call *literal numbers*). I don't know how, but I imagine that these IDs are used by kramdown or MathJax, and therefore the equations were eventually formatted in orange. To fix the problem I simply removed the line in my header which was calling this CSS file. If you have a better explanation of what is going on, please let me know!