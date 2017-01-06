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


def get_data(path, feature_set):
	features = []

	with open(path) as csv_file:
		reader = csv.reader(csv_file)

		for row in reader:
			vector = []
			polarity = int(row[len(row) - 4])
			veracity = int(row[len(row) - 5])

			# 0 -> deceptive, 1 -> truthful
			if polarity == 0 or polarity == 1:

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

	split = 1280

	# automatically adjust split size
	if (len(features) == 800):
		split = 640

	train = features[:split]
	test = features[split:]

	X_train = []
	X_test = []
	C_train = []
	C_test = []

	for elem in train:
		X_train.append(elem[0])
		C_train.append(elem[1])

	for elem in test:
		X_test.append(elem[0])
		C_test.append(elem[1])

	return X_train, C_train, X_test, C_test


def compute_acc(targets, data):
	count = 0

	for i in range(0, len(targets)):
		if targets[i] == data[i]:
			count = count + 1

	return count / (len(targets))


def main():
	atts = [
		["NER", "ner"],
		["Unique NER", "uner"],
		["LIWC", "liwc"],
		["NER + LIWC", "nerliwc"],
		["NER + Unique NER + LIWC", "comb"]
	]

	for att in atts:
		print(att[0])
		X_train, C_train, X_test, C_test = get_data("inf_spec_ner_liwc_speciteller.csv", att[1])

		gnb = GaussianNB()
		gnbp = gnb.fit(X_train, C_train)
		print("GNB: " + str(compute_acc(C_test, gnbp.predict(X_test))))

		bnb = BernoulliNB()
		bnbp = bnb.fit(X_train, C_train)
		print("BNB: " + str(compute_acc(C_test, bnbp.predict(X_test))))

		mnb = MultinomialNB()
		mnbp = mnb.fit(X_train, C_train)
		print("MNB: " + str(compute_acc(C_test, mnbp.predict(X_test))))

		rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
		rfp = rf.fit(X_train, C_train)
		print("RF: " + str(compute_acc(C_test, rfp.predict(X_test))))

		lsvc = LinearSVC(loss='squared_hinge', penalty="l1", dual=False, tol=1e-3)
		lsvcp = lsvc.fit(X_train, C_train)
		print("Linear SVM: " + str(compute_acc(C_test, lsvcp.predict(X_test))))

		svc = SVC()
		svcp = svc.fit(X_train, C_train)
		print("SVM: " + str(compute_acc(C_test, svcp.predict(X_test))))

		knn = KNeighborsClassifier(n_neighbors=10)
		knnp = knn.fit(X_train, C_train)
		print("KNN: " + str(compute_acc(C_test, knnp.predict(X_test))))

		pc = Perceptron(n_iter=50)
		pcp = pc.fit(X_train, C_train)
		print("Perceptron: " + str(compute_acc(C_test, pcp.predict(X_test))))

		ridge = RidgeClassifier(tol=1e-2, solver="lsqr")
		ridgep = ridge.fit(X_train, C_train)
		print("Ridge Classifier: " + str(compute_acc(C_test, ridgep.predict(X_test))))

		print("")


main()
