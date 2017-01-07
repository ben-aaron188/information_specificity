import csv, random
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB, BernoulliNB, MultinomialNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import RidgeClassifier


def sum_up(list):
	sum = 0

	for elem in list:
		sum = sum + elem

	return sum


def get_data(path, feature_set, pol):
	features = []

	with open(path) as csv_file:
		reader = csv.reader(csv_file)

		for row in reader:
			vector = []
			polarity = int(row[len(row) - 4])
			veracity = int(row[len(row) - 5])

			# 0 -> deceptive, 1 -> truthful
			if polarity == pol:

				if feature_set == "ner":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))
				elif feature_set == "uner":
					for i in range(41, 59):
						vector.append(float(row[i]))
				elif feature_set == "liwc":
					for i in range(67, 160):
						vector.append(float(row[i]))
				elif feature_set == "nerliwc":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))

					for i in range(67, 160):
						vector.append(float(row[i]))
				elif feature_set == "comb":
					for i in range(23, 41):
						vector.append(float(row[i]))

					vector.append(round((sum_up(vector)) / float(row[17]), 4))

					for i in range(41, 59):
						vector.append(float(row[i]))

					for i in range(67, 160):
						vector.append(float(row[i]))

				# add class
				features.append([vector, veracity])

	random.shuffle(features)
	
	X = []
	C = []

	for elem in features:
		X.append(elem[0])
		C.append(elem[1])

	return X, C


def compute_acc(targets, data):
	count = 0

	for i in range(0, len(targets)):
		if targets[i] == data[i]:
			count = count + 1

	return count / (len(targets))


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


def main():
	atts = [
		["NER", "ner"],
		["Unique NER", "uner"],
		["LIWC", "liwc"],
		["NER + LIWC", "nerliwc"],
		["NER + Unique NER + LIWC", "comb"]
	]

	inner_atts = [
		["Negative", 0],
		["Positive", 1]
	]

	k = 5

	for att in atts:
		print(att[0])

		for polarity in inner_atts:
			print(polarity[0])

			X, C = get_data("inf_spec_ner_liwc_speciteller.csv", att[1], polarity[1])

			gnb = GaussianNB()
			print("GNB: " + str(k_fold(X, C, k, gnb)))

			bnb = BernoulliNB()
			print("BNB: " + str(k_fold(X, C, k, bnb)))

			bnb = MultinomialNB()
			print("MNB: " + str(k_fold(X, C, k, bnb)))

			rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
			print("RF: " + str(k_fold(X, C, k, rf)))

			lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
			print("Linear SVM: " + str(k_fold(X, C, k, lsvc)))

			svc = SVC(kernel='linear')
			print("SVM (linear kernel): " + str(k_fold(X, C, k, svc)))

			knn = KNeighborsClassifier(n_neighbors=10)
			print("kNN: " + str(k_fold(X, C, k, knn)))

			pc = Perceptron(n_iter=50)
			print("Perceptron: " + str(k_fold(X, C, k, pc)))

			ridge = RidgeClassifier(tol=1e-2, solver="lsqr")
			print("Ridge Regression: " + str(k_fold(X, C, k, ridge)))

			print("")


main()
