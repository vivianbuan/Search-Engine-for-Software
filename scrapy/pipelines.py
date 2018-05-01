# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import csv

class DomainscraperPipeline(object):
    unique = set()
    dict_list =[]  #list of dictionaries who has two keys: domain and time referenced

    ########################################################################
    # A must-have function for item pipeline to process the item return
    # by parse function of spider.
    #
    #########################################################################
    def process_item(self, item, spider):

        #parser_items works as generator and must return or yield a Request or a dict-like data structure
        item = item["domain"]

        #add new dictionary into list. Set time referenced to be 1
        if item not in self.unique:
            self.unique.add(item)
            info = {"domain": item, "time referenced": 1}
            self.dict_list.append(info)
        #increment time referenced by 1
        else:
            for dict in self.dict_list:
                if item == dict["domain"]:
                    dict["time referenced"] += 1
        return item

    ########################################################################
    # Function to be called automatically when spider closed.
    # Will write all dictionaries in dict_list into a csv file
    # Could change to any data format based on what indexer needs
    #########################################################################
    def close_spider(self,spider):
        with open('StackOverflow.csv', 'w') as csv_file:
            fieldNames=["domain","time referenced"]
            writer = csv.DictWriter(csv_file,fieldnames=fieldNames)
            for dict in self.dict_list:
                #for key, value in dict.items():
                writer.writerow(dict)
