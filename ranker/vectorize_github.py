"""
A Python script to convert Github metadata in JSON format into a feature vector for ranking packages for a given query

To run this script, run the command:
python vectorize_github.py <path/to/github.json> <user query>
"""

import os
import sys
import json
import pprint
import pickle
import numpy as np
from bs4 import BeautifulSoup
from datetime import datetime
from urllib.parse import urlparse
from urllib.request import urlopen
from gensim import corpora, models, similarities

def main():
	github_filepath = sys.argv[1]
	query = sys.argv[2]
	pp = pprint.PrettyPrinter(indent=4)
	package_list = []

	# Global package statistics for normalization
	stats_dict = {}
	total_collaborator_count = 0
	total_fork_count = 0
	total_inv_last_push = 0
	total_inv_last_update = 0
	total_star_count = 0
	total_watcher_count = 0

	# Corpora for text-based analytics
	all_documents = {}
	homepage_content_documents = []
	readme_documents = []
	repo_documents = []

	# Load Github metadata from JSON file
	with open(github_filepath) as f:
		github_dict = json.load(f)

	# Check if Github metadata was previously preprocessed
	if os.path.isfile("./tmp/package_list") and os.path.isfile("./tmp/stats_dict.json") and os.path.isfile("./tmp/all_documents.json"):
		with open("./tmp/package_list", 'rb') as f:
			package_list = pickle.load(f)

		with open("./tmp/stats_dict.json", 'r') as f:
			stats_dict = json.load(f)

		with open("./tmp/all_documents.json", 'r') as f:
			all_documents = json.load(f)
	else:
		# Preprocess github metadata
		for key, value in github_dict.items():
			# If there is a readme.md, strip away all html tags
			if value["readMe"]:
				readMe_soup = BeautifulSoup(value["readMe"], "lxml")
				value["readMe"] = readMe_soup.get_text(" ")
				if not value["readMe"]:
					value["readMe"] = "No readMe!"
				github_dict[key] = value
			else:
				value["readMe"] = "No readMe!"
				github_dict[key] = value

			# If there is a homepage, strip away all html tags
			if value["homepage_content"]:
				homepage_soup = BeautifulSoup(value["homepage_content"], "lxml")
				value["homepage_content"] = homepage_soup.get_text(" ")
				if not value["homepage_content"]:
					value["homepage_content"] = "No homepage content!"
				github_dict[key] = value
			else:
				value["homepage_content"] = "No homepage content!"
				github_dict[key] = value

			# If there is a repo description, strip away all html tags
			if value["repo_description"]:
				repo_soup = BeautifulSoup(value["repo_description"], "lxml")
				value["repo_description"] = repo_soup.get_text(" ")
				if not value["repo_description"]:
					value["repo_description"] = "No repo description!"
				github_dict[key] = value
			else:
				value["repo_description"] = "No repo description!"
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
			if value["repo_description"]:
				repo_documents.append(value["repo_description"])
				
			# Create list of packages for easier vectorization	
			package_list.append(value)

		# Save package information into file
		with open("./tmp/package_list", 'wb') as f:
			pickle.dump(package_list, f)

		# Save global statistics into dict
		stats_dict["total_collaborator_count"] = total_collaborator_count
		stats_dict["total_fork_count"] = total_fork_count
		stats_dict["total_inv_last_push"] = total_inv_last_push
		stats_dict["total_inv_last_update"] = total_inv_last_update
		stats_dict["total_star_count"] = total_star_count
		stats_dict["total_watcher_count"] = total_watcher_count

		# Save global statistics into a file
		with open("./tmp/stats_dict.json", 'w') as f:
			json.dump(stats_dict, f)

		all_documents["homepage_content_documents"] = homepage_content_documents
		all_documents["readme_documents"] = readme_documents
		all_documents["repo_documents"] = repo_documents

		# Save all documents into a file
		with open("./tmp/all_documents.json", 'w') as f:
			json.dump(all_documents, f)

	# Text-based analytics
	stoplist = set('for a of the and to in'.split())

	# Remove common words and tokenize
	homepage_content_texts = [[word for word in document.lower().split() if word not in stoplist] for document in all_documents["homepage_content_documents"]]
	readme_texts = [[word for word in document.lower().split() if word not in stoplist] for document in all_documents["readme_documents"]]
	repo_texts = [[word for word in document.lower().split() if word not in stoplist] for document in all_documents["repo_documents"]]

	# Create the dictionary 
	homepage_content_dictionary = corpora.Dictionary(homepage_content_texts)
	readme_dictionary = corpora.Dictionary(readme_texts)
	repo_dictionary = corpora.Dictionary(repo_texts)

	query_vec_homepage_content = homepage_content_dictionary.doc2bow(query.lower().split())
	query_vec_readme = readme_dictionary.doc2bow(query.lower().split())
	query_vec_repo = repo_dictionary.doc2bow(query.lower().split())

	homepage_content_corpus = [homepage_content_dictionary.doc2bow(text) for text in homepage_content_texts]
	readme_corpus = [readme_dictionary.doc2bow(text) for text in readme_texts]
	repo_corpus = [repo_dictionary.doc2bow(text) for text in repo_texts]
	
	# Define LSI space using the corpus
	homepage_content_lsi = models.LsiModel(homepage_content_corpus, id2word=homepage_content_dictionary, num_topics=2)
	readme_lsi = models.LsiModel(readme_corpus, id2word=readme_dictionary, num_topics=2)
	repo_lsi = models.LsiModel(repo_corpus, id2word=repo_dictionary, num_topics=2)

	# Convert corpus to 2D LSI space
	homepage_content_index = similarities.MatrixSimilarity(homepage_content_lsi[homepage_content_corpus])
	readme_index = similarities.MatrixSimilarity(readme_lsi[readme_corpus])
	repo_index = similarities.MatrixSimilarity(repo_lsi[repo_corpus])

	query_vec_lsi_homepage_content = homepage_content_lsi[query_vec_homepage_content]
	query_vec_lsi_readme = readme_lsi[query_vec_readme]
	query_vec_lsi_repo = repo_lsi[query_vec_repo]

	homepage_content_sims = homepage_content_index[query_vec_lsi_homepage_content]
	readme_sims = readme_index[query_vec_lsi_readme]
	repo_sims = repo_index[query_vec_lsi_repo]

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
	9. Repo Description
	'''
	num_features = 9
	feature_vec = np.zeros((len(package_list), num_features))

	for idx, package in enumerate(package_list):
		# Populate feature vector
		feature_vec[idx,0] = float(package["collaborators_cnt"]) / float(stats_dict["total_collaborator_count"])
		feature_vec[idx,1] = float(package["fork_cnt"]) / float(stats_dict["total_fork_count"])
		feature_vec[idx,2] = package["inv_last_push"] / stats_dict["total_inv_last_push"]
		feature_vec[idx,3] = package["inv_last_update"] / stats_dict["total_inv_last_update"]
		feature_vec[idx,4] = float(package["star_cnt"]) / float(stats_dict["total_star_count"])
		feature_vec[idx,5] = float(package["watcher_cnt"]) / float(stats_dict["total_watcher_count"])
		feature_vec[idx,6] = 5.0*homepage_content_sims[idx]
		feature_vec[idx,7] = 5.0*readme_sims[idx]
		feature_vec[idx,8] = 5.0*repo_sims[idx]

	# Gets the score of packages
	package_score = np.sum(feature_vec, axis=1)
	top_10_idx = np.argsort(-package_score)[:10]
	for idx in top_10_idx:
		print(package_list[idx]["name"], package_score[idx])


if __name__ == "__main__":
	main()