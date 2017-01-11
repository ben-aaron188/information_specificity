import csv, random
import numpy as np
from sklearn import cross_validation
from sklearn.svm import LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import precision_recall_fscore_support


# Sums up the values of an array.
#
# Parameters:
# list {List} -> array whose values should be summed up
def sum_up(list):
	sum = 0
	for elem in list:
		sum = sum + elem
	return sum


# Data retrieval and pre-processing.
#
# Parameters:
# path {String} -> path leading to csv data file;
# feature_set {String} -> the feature set description that should be included (see descriptions below)
# pol {Integer} -> the polarity the data is filtered on (truhtful = 1, deceptive = 0)
def get_data(path, feature_set, pol):
	features = []

	with open(path) as csv_file:
		reader = csv.reader(csv_file)
		for row in reader:
			vector = []
			polarity = int(row[len(row) - 4])
			veracity = int(row[len(row) - 5])

			if polarity == pol:

				# NER feature set
				if feature_set == "ner":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))

				# Unique NER feature set
				elif feature_set == "uner":
					for i in range(41, 59):
						vector.append(float(row[i]))

					vector.append(float(row[171]))

				# LIWC feature set
				elif feature_set == "liwc":
					for i in range(67, 160):
						vector.append(float(row[i]))

				# LIWC + NER feature set combination
				elif feature_set == "nerliwc":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))

					for i in range(67, 160):
						vector.append(float(row[i]))

					vector.append(float(row[167]))

				# LIWC + unique NER feature set combination
				elif feature_set == "unerliwc":
					for i in range(41, 59):
						vector.append(float(row[i]))

					for i in range(67, 160):
						vector.append(float(row[i]))

					vector.append(float(row[171]))
					vector.append(float(row[167]))

				# NER + unique NER + LIWC feature set combination
				elif feature_set == "comb":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))

					for i in range(41, 59):
						vector.append(float(row[i]))

					for i in range(67, 160):
						vector.append(float(row[i]))

					vector.append(float(row[171]))
					vector.append(float(row[167]))

				# add the class for each vector
				features.append([vector, veracity])

	random.shuffle(features)

	# feature array
	X = []

	# corresponding classes
	C = []

	for elem in features:
		X.append(elem[0])
		C.append(elem[1])

	return X, C


# Computes the accuracy for given targets and predictions.
#
# Parameters:
# targets {List} -> target values
# data {List} -> predicted values
def compute_acc(targets, data):
	count = 0
	for i in range(0, len(targets)):
		if targets[i] == data[i]:
			count = count + 1

	return count / (len(targets))


# Parameters:
# folds {List} -> array of k folds
# x {Integer} -> Index of test fold
def get_train_data(folds, x):
	X_train = []
	C_train = []

	for i in range(0, len(folds)):
		if i != x:
			current = folds[i]

			for k in range(0, len(current[0])):
				X_train.append(current[0][k])
				C_train.append(current[1][k])

	return X_train, C_train


# K-fold cross-validation implementation
#
# Parameters:
# X {List} -> feature array
# C {List} -> corresponding class array
# k {Integer} -> k
# classifier {Sklearn Object} -> selected classifier
def k_fold(X, C, k, classifier):
	size = int(len(X) / k)
	folds = []
	accuracy = 0

	for i in range(0, k):
		folds.append([X[i * size:(i + 1) * size], C[i * size:(i + 1) * size]])

	for x in range(0, len(folds)):
		X_train, C_train = get_train_data(folds, x)
		X_test = folds[x][0]
		C_test = folds[x][1]
		trained = classifier.fit(X_train, C_train)
		accuracy = accuracy + compute_acc(C_test, trained.predict(X_test))

	return accuracy / k


# K-fold cross-validation implementation
#
# Parameters:
# k {Integer} -> k
# classifier name {String} -> classifier description
# X_proxy {List} -> feature array
# C_proxy {List} -> corresponding classes
def manual_cross_val(k, classifier_name, X_proxy, C_proxy):
	# define classifiers
	rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
	lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
	lr = LogisticRegression()

	X_ = np.array(X_proxy)
	C_ = np.array(C_proxy)
	kf = cross_validation.KFold(len(X_), n_folds=k, shuffle=True, random_state=42)
	precision_array_0 = []
	recall_array_0 = []
	f1_array_0 = []
	precision_array_1 = []
	recall_array_1 = []
	f1_array_1 = []

	for train_index, test_index in kf:
		X_train, X_test = X_[train_index], X_[test_index]
		y_train, y_test = C_[train_index], C_[test_index]

		if classifier_name == "rf":
			classifier_fit = rf.fit(X_train, y_train)
		elif classifier_name == "lsvc":
			classifier_fit = lsvc.fit(X_train, y_train)
		elif classifier_name == "lr":
			classifier_fit = lr.fit(X_train, y_train)

		eval_metrics = precision_recall_fscore_support(y_test, classifier_fit.predict(X_test))
		precision_array_0.append(eval_metrics[0][0])
		precision_array_1.append(eval_metrics[0][1])
		recall_array_0.append(eval_metrics[1][0])
		recall_array_1.append(eval_metrics[1][1])
		f1_array_0.append(eval_metrics[2][0])
		f1_array_1.append(eval_metrics[2][1])

	p_c0_np = np.array(precision_array_0)
	p_c1_np = np.array(precision_array_1)
	r_c0_np = np.array(recall_array_0)
	r_c1_np = np.array(recall_array_1)
	f1_c0_np = np.array(f1_array_0)
	f1_c1_np = np.array(f1_array_1)
	accuracy_cross_val_score = cross_validation.cross_val_score(classifier_fit, X_, C_, cv=k, scoring='accuracy')
	accuracy_avg_score = round(accuracy_cross_val_score.mean() * 100, 2)
	print("Precision class0: " + str(round(p_c0_np.mean() * 100, 2)))
	print("Precision class1: " + str(round(p_c1_np.mean() * 100, 2)))
	print("Recall class0: " + str(round(r_c0_np.mean() * 100, 2)))
	print("Recall class1: " + str(round(r_c1_np.mean() * 100, 2)))
	print("F1 class0: " + str(round(f1_c0_np.mean() * 100, 2)))
	print("F1 class1: " + str(round(f1_c1_np.mean() * 100, 2)))
	print("Accuracy: " + str(accuracy_avg_score))


# Main-method
#
# Parameters:
# k {Integer} -> k
def main(k):
	feature_sets = [
		["NER", "ner"],
		["Unique NER", "uner"],
		["LIWC", "liwc"],
		["NER + LIWC", "nerliwc"],
		["Unique NER + LIWC", "unerliwc"],
		["NER + Unique NER + LIWC", "comb"]
	]

	polarities = [
		["Negative", 0],
		["Positive", 1]
	]

	for feature_set in feature_sets:
		print(feature_set[0])
		for polarity in polarities:
			print(polarity[0])
			X, C = get_data("inf_spec_ner_liwc_speciteller.csv", feature_set[1], polarity[1])

			# run k-fold cv
			print("--------- RF --------")
			manual_cross_val(k, "rf", X, C)
			print("")
			print("-------------------------------------------------------")
			print("--------- SVM --------")
			manual_cross_val(k, "lsvc", X, C)
			print("")
			print("-------------------------------------------------------")
			print("--------- Log Reg --------")
			manual_cross_val(k, "lr", X, C)
			print("")
			print("-------------------------------------------------------")
