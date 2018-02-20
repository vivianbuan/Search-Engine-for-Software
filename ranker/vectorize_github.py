"""
A Python script to convert Github metadata in JSON format into a feature vector for ranking packages for a given query

To run this script, run the command:
python vectorize_github.py <path/to/github.json> <user query>
"""

import sys
import json
import pprint
import numpy as np
from bs4 import BeautifulSoup
from datetime import datetime
from gensim import corpora, models, similarities

def main():
	github_filepath = sys.argv[1]
	query = sys.argv[2]
	pp = pprint.PrettyPrinter(indent=4)
	package_list = []

	# Global package statistics for normalization
	total_collaborator_count = 0
	total_fork_count = 0
	total_inv_last_push = 0
	total_inv_last_update = 0
	total_star_count = 0
	total_watcher_count = 0

	# Corpora for text-based analytics
	homepage_content_documents = []
	readme_documents = []

	# Load Github metadata from JSON file
	with open(github_filepath) as f:
		github_dict = json.load(f)

	# Preprocess github metadata
	for key, value in github_dict.items():
		# If there is a readme.md, strip away all html tags
		if value["readMe"]:
			readMe_soup = BeautifulSoup(value["readMe"], "html.parser")
			value["readMe"] = readMe_soup.get_text(" ")
			github_dict[key] = value

		# If there is a homepage, strip away all html tags
		if value["homepage_content"]:
			homepage_soup = BeautifulSoup(value["homepage_content"], "html.parser")
			value["homepage_content"] = homepage_soup.get_text(" ")
			github_dict[key] = value
		else:
			value["homepage_content"] = "No homepage content!"
			github_dict[key] = value

		# Add in features inv_last_push and inv_last_update
		value["inv_last_push"] = 1.0 / float((datetime.utcnow() - datetime.strptime(value["last_push"], '%Y-%m-%d %H:%M:%S %Z')).days)
		value["inv_last_update"] = 1.0 / float((datetime.utcnow() - datetime.strptime(value["last_update"], '%Y-%m-%d %H:%M:%S %Z')).days)

		# Update global package statisitics
		total_collaborator_count += int(value["collaborators_cnt"])
		total_fork_count += int(value["fork_cnt"])
		total_inv_last_push += value["inv_last_push"]
		total_inv_last_update += value["inv_last_update"]
		total_star_count += int(value["star_cnt"])
		total_watcher_count += int(value["watcher_cnt"])

		if value["homepage_content"]:
			homepage_content_documents.append(value["homepage_content"])
		if value["readMe"]:
			readme_documents.append(value["readMe"])
			
		# Create list of packages for easier vectorization	
		package_list.append(value)

	# Text-based analytics
	stoplist = set('for a of the and to in'.split())

	# Remove common words and tokenize
	homepage_content_texts = [[word for word in document.lower().split() if word not in stoplist] for document in homepage_content_documents]
	readme_texts = [[word for word in document.lower().split() if word not in stoplist] for document in readme_documents]

	# Remove words that only appear once
	'''
	from collections import defaultdict
	frequency = defaultdict(int)
	for text in homepage_content_texts:
		for token in text:
			frequency[token] += 1

	homepage_content_texts = [[token for token in text if frequency[token] > 1] for text in homepage_content_texts]

	frequency = defaultdict(int)
	for text in readme_texts:
		for token in text:
			frequency[token] += 1

	readme_texts = [[token for token in text if frequency[token] > 1] for text in readme_texts]
	'''

	# Create the dictionary 
	homepage_content_dictionary = corpora.Dictionary(homepage_content_texts)
	readme_dictionary = corpora.Dictionary(readme_texts)

	query_vec_homepage_content = homepage_content_dictionary.doc2bow(query.lower().split())
	query_vec_readme = readme_dictionary.doc2bow(query.lower().split())

	homepage_content_corpus = [homepage_content_dictionary.doc2bow(text) for text in homepage_content_texts]
	readme_corpus = [readme_dictionary.doc2bow(text) for text in readme_texts]
	
	# Define LSI space using the corpus
	homepage_content_lsi = models.LsiModel(homepage_content_corpus, id2word=homepage_content_dictionary, num_topics=2)
	readme_lsi = models.LsiModel(readme_corpus, id2word=readme_dictionary, num_topics=2)

	# Convert corpus to 2D LSI space
	homepage_content_index = similarities.MatrixSimilarity(homepage_content_lsi[homepage_content_corpus])
	readme_index = similarities.MatrixSimilarity(readme_lsi[readme_corpus])

	query_vec_lsi_homepage_content = homepage_content_lsi[query_vec_homepage_content]
	query_vec_lsi_readme = readme_lsi[query_vec_readme]

	homepage_content_sims = homepage_content_index[query_vec_lsi_homepage_content]
	readme_sims = readme_index[query_vec_lsi_readme]

	# Sort the similarity scores
	#homepage_content_sims = sorted(enumerate(homepage_content_sims), key=lambda item: -item[1])
	#readme_sims = sorted(enumerate(readme_sims), key=lambda item: -item[1])

	'''
	Create the feature vectors for the github packages:
	Numerical features:
	1. Collaborator count
	2. Fork count
	3. Last push
	4. Last update
	5. Star count
	6. Watcher count

	Text-based features:
	7. Homepage Content
	8. Readme
	'''
	num_features = 8
	feature_vec = np.zeros((len(package_list), num_features))

	for idx, package in enumerate(package_list):
		# Populate feature vector
		feature_vec[idx,0] = float(package["collaborators_cnt"]) / float(total_collaborator_count)
		feature_vec[idx,1] = float(package["fork_cnt"]) / float(total_fork_count)
		feature_vec[idx,2] = package["inv_last_push"] / total_inv_last_push
		feature_vec[idx,3] = package["inv_last_update"] / total_inv_last_update
		feature_vec[idx,4] = float(package["star_cnt"]) / float(total_star_count)
		feature_vec[idx,5] = float(package["watcher_cnt"]) / float(total_watcher_count)
		feature_vec[idx,6] = 5.0*homepage_content_sims[idx]
		feature_vec[idx,7] = 5.0*readme_sims[idx]

		if package["name"] == "restberry":
			print(np.sum(feature_vec[idx,:]))

	# Gets the score of packages
	package_score = np.sum(feature_vec, axis=1)
	top_10_idx = np.argsort(-package_score)[:10]
	for idx in top_10_idx:
		print(package_list[idx]["name"], package_score[idx])


if __name__ == "__main__":
	main()