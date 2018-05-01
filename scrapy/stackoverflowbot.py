# -*- coding: utf-8 -*-
import scrapy
from urllib.parse import urlparse
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor

class StackoverflowbotSpider(CrawlSpider):
    name = 'stackoverflowbot'
    allowed_domains = ['stackoverflow.com']
    start_urls = ['https://stackoverflow.com/questions?sort=votes']

    #Setting rules telling spider which page to follow and which url to call parse_items
    rules = (
        Rule(LinkExtractor(restrict_xpaths="//a[@rel='next']"), follow=True),
        Rule(LinkExtractor(allow=r"/questions/\d+",restrict_xpaths="//a[@class='question-hyperlink']"), callback='parse_items')
    )

    def parse_items(self, response):

        #Only parse the hrefs in answer section, get rid of ads and social networks like facebook and twitter
        urls = response.xpath('//div[@class="answer"]//a//@href').extract()
        for url in urls:
            if "http" in url and "stackoverflow.com" not in url:
                parsedurl = urlparse(url)
                domain = '{uri.scheme}://{uri.netloc}/'.format(uri=parsedurl)

                #return the dict to pipelines to further handling
                return {"domain":domain}
