# SoftWare AGgregated and Organized (SWAGO)

<img align="right" width="178" height="120"
     title="SWAGO logo" src="/docs/img/logo.png">
     
The SoftWare AGgregated and Organized (SWAGO) is an open source search engine designed for software package search specifically. It was the result of a year-long project in [Berkeley's Master of Engineering Program Capstone](https://funginstitute.berkeley.edu/programs-centers/full-time-program/capstone-experience/).

Check out our site at [SWAGO](http://35.230.66.167/)

[<p align="center"><img width="380" align="center" src="/docs/img/video.png"></p>](https://www.youtube.com/watch?v=yN-QODt0xbk)

## Mission
The web has transformed many aspects of how software is written and maintained. For myriad tasks, free open source packages are available. However, the open sharing model has been so successful that developers are now inundated with a plethora of choices when deciding which package to use for a task. The task of searching for and comparing multiple different packages is not well supported on web search engines.

Our goal is to design a search engine that makes searching for software packages easier. Our final product demonstrates a minimum viable product that adopts a better organization of software package information extracted from Github and StackOverflow. The main features include a carousel display of related packages, side-by-side comparison of package information, and filter by license and languages.

To lean more details, check out our [final report](/docs/Final%20Report.pdf) and [presentation](/docs/Final%20Presentation.pdf).

## Navigate the Repo
<img align="right" width="450" title="system architecture" src="/docs/img/system_architecture.png">

The system architechture is as shown on the graph. There are 5 components of our system, the code regards each one of the component lies in individual branches.

* [Crawler](https://github.com/vivianbuan/Search-Engine-for-Software/tree/crawler)</br>
Contains python scripts that utilize Scrapy, Github APIs and StackOverflow API to crawl the data related to the project.
* [Feature Extraction](https://github.com/vivianbuan/Search-Engine-for-Software/tree/featureExtraction) </br>
Python scripts to convert crawled GitHub and StackOverflow objects into data structures appropriate for this project.
* [Indexer](https://github.com/vivianbuan/Search-Engine-for-Software/tree/indexer)</br>
Solr image, sample data and query command, and tutorials on setting up the server.
* [Ranker](https://github.com/vivianbuan/Search-Engine-for-Software/tree/ranker) </br>
Contains scripts for experimentation before the data was indexed. Also contains scripts used to scrape and index queries from Slant.co. For more information on the ranking algorithm, look at files inside the SOLR/solr-7.2.0 folder of the indexer branch.
* [User Interface](https://github.com/vivianbuan/Search-Engine-for-Software/tree/user_interface) </br>
Code for our front-end developed using Django.

## Authors
* [Joshua Choo](https://github.com/choo8)
* [Mengshi Feng](https://github.com/MSFeng)
* [Weiran(Vivian) Liu](https://github.com/vivianbuan)
* [Avery Nisbet](https://github.com/danisbet)
* [Yidan Zhang](https://github.com/zhangyd)

Last updated May 01, 2018
