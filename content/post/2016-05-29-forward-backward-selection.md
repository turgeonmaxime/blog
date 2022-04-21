---
layout: post
title: "The Instability of Forward and Backward Selection"
author: "Maxime Turgeon"
tags: [Variable selection, subset selection, R]
slug: forward-backward-selection
date: 2016-05-29
comments: true
---

Classical statistics often assumes that the analyst knows which variables are important and which variables are not. Of course, this is a strong assumption, and therefore many variable selection procedures have been developed to address this problem. In this blog post, I want to focus on two subset selection methods, and I want to address their instability. In other words, I want to discuss how **small changes** in the data can lead to **completely different solutions**.

<!--more-->

For the sake of clarity, let's focus on a simple linear regression model with \\( p \\) covariates:

$$ E(Y \mid X_1, \ldots, X_p) = \beta_0 + \beta_1 X_1 + \ldots + \beta_p X_p.$$

As the analyst, we were given these \\( p \\) variables to analyse, but we don't necessarily know which ones are relevant in this model. Subset selection methods look at all possible \\( 2^p - 1 \\) models you can get from selecting a subset of these \\( p \\) variables and tries to find the most relevant model for the analysis. Graphically, we can arrange all these models in a [lattice](https://en.wikipedia.org/wiki/Lattice_(order)#Examples): the null model (containing only the intercept term \\( \beta_0 \\)) is at the bottom, the full model (containing all \\( p \\) variables) is at the top, and two nodes corresponding to two models are connected if they have all but one variable in common. For example, the following models are connected:

$$E(Y \mid X_1) = \beta_0 + \beta_1 X_1, \qquad E(Y \mid X_1, X_2) = \beta_0 + \beta_1 X_1 + \beta_2 X_2;$$

but the following models are **not** connected:

$$E(Y \mid X_1) = \beta_0 + \beta_1 X_1, \qquad E(Y \mid X_2) = \beta_0 + \beta_2 X_2.$$

By "subset selection" methods, I mean methods that search this lattice in a discrete fashion, i.e. they compare some of these models using a criterion.

## Information criteria

One such method is called the *all-subset selection*. This method is typically based on information criteria (but other criteria can be used). The idea is simple: for **all** possible models, compute a criterion and select the model that optimises this criterion. As you can imagine, this method becomes quickly impractical: with only 10 variables, we already have 1023 different possible models; with 20 variables, we have over a million possible models. For this reason, all-subset selection is not very popular.

## Forward and Backward selection

Instead I will focus on [Forward and Backward selection](https://en.wikipedia.org/wiki/Stepwise_regression), which are very popular approaches to model selection. Their distinguishing feature is that they are procedure that move through the lattice of all possible models until no "good" move is left. I will illustrate these methods using a well-known dataset on prostate cancer:


```r
library(lasso2)
data(Prostate)
```

Looking at the documentation for this dataset: 

```
These data come from a study that examined the correlation 
between the level of prostate specific antigen and a number 
of clinical measures in men who were about to receive a 
radical prostatectomy. 
It is data frame with 97 rows and 9 columns.
```

We will look at the mean cancer volume (on the log scale) as a function of the other 8 clinical features (so there are 255 possible models). 


```r
full_model <- lm(lcavol ~ ., data = Prostate)
summary(full_model)
```



```
## 
## Call:
## lm(formula = lcavol ~ ., data = Prostate)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.88603 -0.47346 -0.03987  0.55719  1.86870 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.260101   1.259683  -1.794   0.0762 .  
## lweight     -0.073166   0.174450  -0.419   0.6759    
## age          0.022736   0.010964   2.074   0.0410 *  
## lbph        -0.087449   0.058084  -1.506   0.1358    
## svi         -0.153591   0.253932  -0.605   0.5468    
## lcp          0.367300   0.081689   4.496 2.10e-05 ***
## gleason      0.190759   0.154283   1.236   0.2196    
## pgg45       -0.007158   0.004326  -1.654   0.1016    
## lpsa         0.572797   0.085790   6.677 2.11e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.6998 on 88 degrees of freedom
## Multiple R-squared:  0.6769,	Adjusted R-squared:  0.6475 
## F-statistic: 23.04 on 8 and 88 DF,  p-value: < 2.2e-16
```

As we can see, the prostate specific antigen (PSA) levels and capsular penetration (both on the log scale) are the most significant variables. 
In forward selection, we start with the null model (only the intercept) and we look at all available variables. Adding them one at a time, we decide which one is the most relevant to the model, and consider it part of our model. We then look at the remaining terms and decide if we can improve our model by adding one more variable. We stop when including another variable does not improve our model anymore.

We will use this approach with the Prostate dataset:


```r
null_model <- lm(lcavol ~ 1, data = Prostate)
forward_model <- step(null_model, scope=list(lower=null_model,
                                             upper=full_model),
                      direction = "forward")
```



```
## Start:  AIC=32.88
## lcavol ~ 1
## 
##           Df Sum of Sq     RSS     AIC
## + lpsa     1    71.938  61.421 -40.325
## + lcp      1    60.818  72.541 -24.184
## + svi      1    38.721  94.638   1.608
## + pgg45    1    25.079 108.280  14.671
## + gleason  1    24.936 108.423  14.799
## + age      1     6.751 126.608  29.839
## + lweight  1     5.026 128.333  31.152
## <none>                 133.359  32.878
## + lbph     1     0.100 133.259  34.806
## 
## Step:  AIC=-40.33
## lcavol ~ lpsa
## 
##           Df Sum of Sq    RSS     AIC
## + lcp      1   14.1428 47.278 -63.710
## + gleason  1    4.0221 57.399 -44.895
## + svi      1    2.9687 58.452 -43.131
## + pgg45    1    2.4747 58.946 -42.314
## + lbph     1    1.5111 59.910 -40.741
## + age      1    1.3852 60.036 -40.538
## <none>                 61.421 -40.325
## + lweight  1    0.6634 60.758 -39.379
## 
## Step:  AIC=-63.71
## lcavol ~ lpsa + lcp
## 
##           Df Sum of Sq    RSS     AIC
## + age      1   1.04027 46.238 -63.869
## <none>                 47.278 -63.710
## + lbph     1   0.56581 46.712 -62.878
## + gleason  1   0.29080 46.987 -62.309
## + pgg45    1   0.23395 47.044 -62.192
## + lweight  1   0.13281 47.145 -61.983
## + svi      1   0.08971 47.188 -61.895
## 
## Step:  AIC=-63.87
## lcavol ~ lpsa + lcp + age
## 
##           Df Sum of Sq    RSS     AIC
## + lbph     1   1.35942 44.878 -64.763
## <none>                 46.238 -63.869
## + pgg45    1   0.56984 45.668 -63.071
## + lweight  1   0.45131 45.787 -62.820
## + gleason  1   0.09938 46.138 -62.077
## + svi      1   0.09302 46.145 -62.064
## 
## Step:  AIC=-64.76
## lcavol ~ lpsa + lcp + age + lbph
## 
##           Df Sum of Sq    RSS     AIC
## <none>                 44.878 -64.763
## + pgg45    1   0.56707 44.311 -63.997
## + svi      1   0.31382 44.565 -63.444
## + gleason  1   0.09437 44.784 -62.967
## + lweight  1   0.09065 44.788 -62.959
```

The most important variable in the first stage was, no surprise, the PSA level. But we also ended up adding three mode variables: capsular penetration, age, and benign prostatic hyperplasia amount (also on the log scale). Therefore, this is the model selected using Forward selection.

Backward selection is very similar, but we start with the full model and decide which variable is the *least* relevant to the model. We then continue removing variables until doing so decreases significantly the quality of our model. Using this approach with the Prostate dataset:


```r
backward_model <- step(full_model, direction = "backward")
```



```
## Start:  AIC=-60.7
## lcavol ~ lweight + age + lbph + svi + lcp + gleason + pgg45 + 
##     lpsa
## 
##           Df Sum of Sq    RSS     AIC
## - lweight  1    0.0861 43.179 -62.507
## - svi      1    0.1792 43.272 -62.299
## - gleason  1    0.7486 43.842 -61.031
## <none>                 43.093 -60.701
## - lbph     1    1.1100 44.203 -60.234
## - pgg45    1    1.3403 44.433 -59.730
## - age      1    2.1058 45.199 -58.073
## - lcp      1    9.9002 52.993 -42.641
## - lpsa     1   21.8300 64.923 -22.946
## 
## Step:  AIC=-62.51
## lcavol ~ age + lbph + svi + lcp + gleason + pgg45 + lpsa
## 
##           Df Sum of Sq    RSS     AIC
## - svi      1    0.1752 43.354 -64.115
## - gleason  1    0.8357 44.015 -62.648
## <none>                 43.179 -62.507
## - pgg45    1    1.3195 44.499 -61.588
## - lbph     1    1.4818 44.661 -61.234
## - age      1    2.0198 45.199 -60.073
## - lcp      1    9.8752 53.054 -44.529
## - lpsa     1   23.1542 66.333 -22.862
## 
## Step:  AIC=-64.11
## lcavol ~ age + lbph + lcp + gleason + pgg45 + lpsa
## 
##           Df Sum of Sq    RSS     AIC
## <none>                 43.354 -64.115
## - gleason  1    0.9571 44.311 -63.997
## - lbph     1    1.3338 44.688 -63.175
## - pgg45    1    1.4298 44.784 -62.967
## - age      1    1.9355 45.290 -61.878
## - lcp      1   10.9352 54.289 -44.297
## - lpsa     1   24.9001 68.254 -22.093
```

The least relevant variable is the weight of the prostate. But we only ended up removing one more variable (seminal vesicle invasion), and therefore we can see that forward and backward selection **do not** lead to the same model. Which in itself can be a problem: which one should we choose?

## Perturbation and Instability

In a [1996 Annals of Statistics paper](https://projecteuclid.org/euclid.aos/1032181158), Leo Breiman described several undesirable properties that subset selection methods have. I will focus on only one of them: **instability**. By instability, I mean that small changes in the data can lead to the selection of a different model.

We will investigate this phenomenon through simulations. I will randomly select one observation and change its value for the response variable. I repeat this process 500 times, and I look at the percentage of time each variable was selected in the model. So I am only changing **one number** in the whole dataset.


```r
forward_pert <- replicate(500, expr = {
    sampleID <- sample(nrow(Prostate), size = 1)
    Prostate_pert <- Prostate
    Prostate_pert$lcavol[sampleID] <- - Prostate_pert$lcavol[sampleID]
    
    null_model <- lm(lcavol ~ 1, data = Prostate_pert)
    full_model <- lm(lcavol ~ ., data = Prostate_pert)
    forward_model <- step(null_model, scope=list(lower=null_model,
                                             upper=full_model),
                      direction = "forward", trace = 0)
    selected_vars <- names(forward_model$coefficients[-1])
    
    names(Prostate) %in% selected_vars
})

rownames(forward_pert) <- names(Prostate)
rowMeans(forward_pert)
```



```
##  lcavol lweight     age    lbph     svi     lcp gleason   pgg45 
##   0.000   0.006   0.486   0.456   0.066   1.000   0.044   0.054 
##    lpsa 
##   1.000
```

First, the good news: PSA levels and capsular penetration are **always** selected by forward selection. However, age and benign prostatic hyperplasia amount are selected only about 50% of the time. And remember that we're only changing one number!

We can also look at backward selection:


```r
backward_pert <- replicate(500, expr = {
    sampleID <- sample(nrow(Prostate), size = 1)
    Prostate_pert <- Prostate
    Prostate_pert$lcavol[sampleID] <- - Prostate_pert$lcavol[sampleID]
    
    full_model <- lm(lcavol ~ ., data = Prostate_pert)
    backward_model <- step(full_model, direction = "backward", trace=0)
    selected_vars <- names(backward_model$coefficients[-1])
    
    names(Prostate) %in% selected_vars
})

rownames(backward_pert) <- names(Prostate)
rowMeans(backward_pert)
```



```
##  lcavol lweight     age    lbph     svi     lcp gleason   pgg45 
##   0.000   0.016   0.772   0.662   0.068   1.000   0.482   0.528 
##    lpsa 
##   1.000
```

Here the problem is even worse: age is selected 80% of the time, benign prostatic hyperplasia amount is selected two times out of three, and both gleason score variables are selected only half the time.

## Penalization methods

This instability issue is common to every subset selection methods (stepwise selection is another such method). This is essentially a consequence of their *discrete* nature. 

Another approach to model selection is based on regularization/penalization procedures, such as [lasso](https://en.wikipedia.org/wiki/Lasso_(statistics)) and [elastic net](https://en.wikipedia.org/wiki/Elastic_net_regularization). These approaches search through the lattice of all possible models using one or two **continuous** parameters. As such, they are typically less sensitive to perturbations of the data. This was already pointed out by Breiman in his discussion of ridge regression (which is *not* a model selection method, but it is a regularization procedure).
