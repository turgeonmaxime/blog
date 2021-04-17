---
title: "R Notebook"
output:
  html_document: default
  html_notebook: default
---

Thanks to [Code for America](http://codeforamerica.org) for sharing the GeoJSON on their [Github page](https://github.com/codeforamerica/click_that_hood).

### Saskatoon


{% highlight r %}
library(leaflet)
library(magrittr)

stoon <- geojsonio::geojson_read("https://raw.githubusercontent.com/codeforamerica/click_that_hood/master/public/data/saskatoon.geojson",
                        what = "sp") 
labels <- sprintf("<strong>%s</strong>",
                  stoon$name) %>% 
    lapply(htmltools::HTML)

stoon %>%
    leaflet %>%
    addTiles %>%
    addPolygons(
        fillColor = 'blue',
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto"))
{% endhighlight %}



{% highlight text %}
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
{% endhighlight %}



{% highlight text %}
## Warning in normalizePath(f2): path[1]="./webshot77db5b443e54.png": No
## such file or directory
{% endhighlight %}



{% highlight text %}
## Warning in file(con, "rb"): cannot open file './
## webshot77db5b443e54.png': No such file or directory
{% endhighlight %}



{% highlight text %}
## Error in file(con, "rb"): cannot open the connection
{% endhighlight %}

### Montreal


{% highlight r %}
montreal <- geojsonio::geojson_read("https://raw.githubusercontent.com/codeforamerica/click_that_hood/master/public/data/montreal.geojson",
                        what = "sp") 
labels <- sprintf("<strong>%s</strong>",
                  montreal$name) %>% 
    lapply(htmltools::HTML)

montreal %>%
    leaflet %>%
    addTiles %>%
    addPolygons(
        fillColor = 'blue',
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto"))
{% endhighlight %}



{% highlight text %}
## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
{% endhighlight %}



{% highlight text %}
## Warning in normalizePath(f2): path[1]="./webshot77db1f59464a.png": No
## such file or directory
{% endhighlight %}



{% highlight text %}
## Warning in file(con, "rb"): cannot open file './
## webshot77db1f59464a.png': No such file or directory
{% endhighlight %}



{% highlight text %}
## Error in file(con, "rb"): cannot open the connection
{% endhighlight %}

