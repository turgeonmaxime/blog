---
layout: post
title: "What I (currently) do at the Saskatchewan Health Authority"
tags: [work, data science]
slug: what-i-currently-do
date: 2018-09-28
comments: true
---

During the summer of 2016, my wife and I moved to Saskatoon so that she could pursue her medical residency training at the University of Saskatchewan. At the point, I was only wrapping up the third year of my PhD, and so I wasn't necessary looking for a job. But one thing led to another, and I ended up applying for a new biostatistician position with the Saskatoon Health Region (SHR). 

The job description talked about being a connection point between the health care system and the Saskatchewan Centre for Patient-Oriented Research ([SCPOR](scpor.ca)), by providing both study design and methodological support for researchers. I thought I would be a good fit: McGill's focus on data analysis and report writing provided me the tools to do the job; meanwhile I could learn more about the health care system itself and use my academic background to provide effective consultation to researchers. 

<!--more-->

And clearly, the hiring committee saw it the same way: in early September 2016, I was hired, and I started my first "real" job. 

My role actually quickly changed and evolved away from providing support to SCPOR. There were two main reasons for this: 

  1. The work demand from SCPOR was simply never enough to fill up my entire schedule;
  2. As the only statistician within the organization, there were several opportunities for providing statistical support at the SHR.
  
As the sole "founding" member of the statistical team, I also had the luxury of using the tools I preferred and that I was the most comfortable with. Specifically, I right away started using [`R`](https://cran.r-project.org/) to perform all my analyses. In a different context, I may had had to use and learn SAS. As a consequence, I could focus on learning other things that were also relevant to my position. For example, I spent a good amount of time learning about databases, how to build them, but mostly how to *connect* to them and extract data. 

Just over a year ago, my team also grew: we hired two more statisticians, and all of a sudden we were three. Three statisticians to provide support to what is now the Saskatchewan Health Authority. I had the opportunity of being very much involved in the hiring process of my colleagues. I learned how to select which candidates will be called in for an interview, how to conduct an interview, which skills to look for and which skills can be learned on the job, how to check references, etc. Many important skills that they don't teach you in graduate school.

In what follows, I want to give a short overview of some of the work that we've been doing in Saskatoon. It's a very interesting mix of data science, research, knowledge translation and performance support.

## Clinical Quality Improvement Program

The [Clinical Quality Improvement Program](https://hqc.sk.ca/news-events/hqc-news/tag/cqip) (CQIP) is a relatively new initiative in Saskatchewan whereby physicians from all over the province receive training in quality improvement methodologies and implement an improvement project in their respective areas. My unit has been supporting our local physicians taking part in this initiative by providing coordination, helping secure the necessary operational approvals, consulting on their data needs, as well as providing support for study design and data analysis. 

For the data analysis, we follow this guiding principle: physicians will only be able to convinced their colleagues that their intervention was successful if they can back it up with sound methodology. This is because physicians are also typically well versed in research: they learned how to criticaly appraise research papers and most of them even conduct research. For this reason, one of my statistical colleagues has been providing critical statistical support to the participants. Over the last year, he has been involved in over a dozen such CQIP projects. The kind of support we typically can offer is very broad: we've provided help with survey design and analysis, guidance on statistical process control charts, multivariate analysis, etc. And the feedback received shows that physicians greatly appreciate the support we offer.

## Forecasting

One interesting service we started offering to our stakeholders is *forecasting*. I never learned about time series during my graduate training, so when we started receiving requests for forecasting, I started using the `R` package `prophet`. It was developed by Facebook, and the main purpose is to "forecast at scale", i.e. providing forecasts of reasonably good quality but quickly. I've found that this approach works reasonably well for volume predictions (e.g. number of daily ED visits, number of daily discharges, and at different levels within the health care system). One area where this approach hasn't work as well is in predicting wait lists for procedures. But by drastically cutting down analysis time for most of our requests, we can concentrate our efforts somewhere else.

As an example of operational problems we have addressed through forecasting, we were asked to provide suggestions for optimal periods of time to perform maintenance that required closing a certain number of beds; we then forecasted patient volumes and were able to identify periods of lower predicted volumes.

## Summary of CIHI reports

One recent addition to our workload is that we provide summaries of the reports published by Canadian Institute for Health Information (CIHI). These summaries are shared with the relevant directors, but also with the communications department. For these summaries, we really had to work on our knowledge translation skills. The goal is "simple": how to distill those reports into exactly the amount of information that's relevant for our stakeholders. Our approach has been two-pronged:

  1. Identify a small number of pieces of information (between 3 and 5) that is directly relevant to Saskatoon or Saskatchewan. 
  2. Create clear, uncluttered, and to-the-point graphs. 
  
In particular, one my colleagues has become very skilled in the latter. She knows which types of graph will best suit the data **and** the message, and she knows how to effectively use colour (in this case, less is definitely more). This is definitely a skill that one can develop, and judging by the feedback received, it's also a highly desirable skill.

## Performance Support

My interest in this area has grown over the last few years. When I was initially hired, I thought I would be mostly supporting research, but I really got interested in how good and sound data analysis can help inform operations in the health care system. One of the first project I was involved in was related to trying to understand the patient population in the emergency department. The idea was to have, for each day, an hourly census of patients at different stages of their ED journey (arrival, physician initial assessment, admission to an inpatient unit, and discharge from ED). For this project, I also had the opportunity to hone my Shiny skills and develop an interactive report summarising this information; for a mock version (i.e. with fake data), see https://turgeonmaxime.shinyapps.io/EDutilization/.

For another project, we provided analytical support for the VP Integrated Health Services in proposing service-level targets for length of stay reduction. The general idea was that we were trying to achieve an overall, organization-level target, but it wasn't clear if each service area should follow the same target or a different target. Using a predictive model developed by CIHI that tries to predict the length of stay of a patient based on demographic and diagnostic information, we were able to identify which service areas had the largest potential for improvements, and which were already in line with the Canadian average. In this way, we proposed service-level targets that would roll up to the overall organizational target. 

In a similar vein, we also provided an analysis of the time between when a patient is admitted to an inpatient unit and when they actually leave the emergency department. To support the executive director for acute services, we tried to estimate how much wait time reduction we could expect if patient flow was "optimal". The statistical trick we pulled was as follows: if we look at the distribution of wait times, we have a mix of patients who waited a few hours at most, until a bed was cleaned and prepared for them, and we have patients who can wait several hours until a bed is eventually freed. By fitting a mixture of gamma distributions, we were able to disentangle these two groups of patients and therefore estimate the wait times distribution under the optimality assumption. Again, this analysis helped us understand which areas have the largest potential gains, and which areas are probably already running under the optimality assumption.

## Epilogue--What I have learned over the past two years

I have grown tremendously and learned a lot on this job. First of all, and that's probably the case for most people going from academia to the industry: I learned how to clean data. In fact, I probably spend more than half my desk time every day cleaning and munging data (and mostly using the [`tidyverse`](https://www.tidyverse.org/)). And related to this, I have a much stronger respect for data collection and measurement. Enormous amounts of data are stored in administrative databases, and a lot of it is *manually* abstracted from medical charts. This represents a huge amount of work, and each hopsital has its own small army of coders. 

I also learned a lot about areas of statistics I didn't know much about (e.g. statistical process control and time series). But more generally, I gained a deeper understanding of some of the fundamental ideas of statistics. On this job, you have to: if you want to explain your results to a non-technical audience, you have to relate the statistical methodology and concepts to something they can understand. And you simply can't do it effectively if you don't have a strong understanding of the fundamentals. My training at McGill definitely had a strong impact on this (check out the [Biostatistics program](https://www.mcgill.ca/epi-biostat-occh/academic-programs/grad/biostatistics)!). One more time for the people at the back: there's nothing like being asked by a stakeholder "What is this telling me?". It forces you to go back to the fundamentals.

Finally, as a teaching assistant in graduate school, I knew I liked teaching, and I felt that I was doing a decent job of it. Now I also have tremendous pleasure mentoring my junior colleagues. And I hope that this can remain an important aspect of any future position I will hold.
