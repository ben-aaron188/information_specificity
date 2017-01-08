import csv, random
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB, BernoulliNB, MultinomialNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import RidgeClassifier, PassiveAggressiveClassifier, LogisticRegression

from sklearn import cross_validation
from sklearn.cross_validation import train_test_split
from sklearn import metrics
from sklearn.metrics import precision_score
from sklearn.metrics import precision_recall_fscore_support

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
				elif feature_set == "unerliwc":
					for i in range(41, 59):
						vector.append(float(row[i]))
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


testsize = 0.8
k = 20
X, C = get_data("inf_spec_ner_liwc_speciteller.csv", "ner", 1)
features_train, features_test, target_train, target_test = train_test_split(X, C, test_size=testsize, random_state=42)
lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
classifier_fit = lsvc.fit(features_train, target_train)
classifier_out = classifier_fit.predict(features_test)
metrics1 = metrics.classification_report(target_test, classifier_out)
metrics2 = metrics.confusion_matrix(target_test, classifier_out)
print(metrics1)
print(metrics2)
cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='f1_weighted')
avg_accuracy_score = cross_val_score.mean()
print(avg_accuracy_score)
cross_val_predict = cross_validation.cross_val_predict(classifier_fit, X, C, cv=k)
metrics_cross_val_predict = metrics.accuracy_score(C, cross_val_predict)
print(metrics_cross_val_predict)



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


# def main():
# 	atts = [
# 		["NER", "ner"],
# 		["Unique NER", "uner"],
# 		["LIWC", "liwc"],
# 		["NER + LIWC", "nerliwc"],
# 		["Unique NER + LIWC", "unerliwc"],
# 		["NER + Unique NER + LIWC", "comb"]
# 	]
#
# 	inner_atts = [
# 		["Negative", 0],
# 		["Positive", 1]
# 	]
#
# 	k = 5
#
# 	for att in atts:
# 		print(att[0])
#
# 		for polarity in inner_atts:
# 			print(polarity[0])
#
# 			X, C = get_data("inf_spec_ner_liwc_speciteller.csv", att[1], polarity[1])
#
# 			gnb = GaussianNB()
# 			print("GNB: " + str(k_fold(X, C, k, gnb)))
#
# 			bnb = BernoulliNB()
# 			print("BNB: " + str(k_fold(X, C, k, bnb)))
#
# 			bnb = MultinomialNB()
# 			print("MNB: " + str(k_fold(X, C, k, bnb)))
#
# 			rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
# 			print("RF: " + str(k_fold(X, C, k, rf)))
#
# 			lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
# 			print("Linear SVM: " + str(k_fold(X, C, k, lsvc)))
#
# 			svc = SVC(kernel='linear')
# 			print("SVM (linear kernel): " + str(k_fold(X, C, k, svc)))
#
# 			knn = KNeighborsClassifier(n_neighbors=10)
# 			print("kNN: " + str(k_fold(X, C, k, knn)))
#
# 			pc = Perceptron(n_iter=50)
# 			print("Perceptron: " + str(k_fold(X, C, k, pc)))
#
# 			ridge = RidgeClassifier(tol=1e-2, solver="lsqr")
# 			print("Ridge Regression: " + str(k_fold(X, C, k, ridge)))
#
# 			pa = PassiveAggressiveClassifier()
# 			print("Passive Aggressive: " + str(k_fold(X, C, k, pa)))
#
# 			print("")


def main2(testsize, k):
	atts = [
		["NER", "ner"],
		["Unique NER", "uner"],
		["LIWC", "liwc"],
		["NER + LIWC", "nerliwc"],
		["Unique NER + LIWC", "unerliwc"],
		["NER + Unique NER + LIWC", "comb"]
	]
	inner_atts = [
		["Negative", 0],
		["Positive", 1]
	]
	# k = 5
	for att in atts:
		print(att[0])
		for polarity in inner_atts:
			print(polarity[0])
			X, C = get_data("inf_spec_ner_liwc_speciteller.csv", att[1], polarity[1])
			features_train, features_test, target_train, target_test = train_test_split(X, C, test_size=testsize, random_state=42)
			# gnb = GaussianNB()
			# classifier_fit = gnb.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("GNB: " + metrics1)
			#print("GNB: " + str(k_fold(X, C, k, gnb)))
			#
			# bnb = BernoulliNB()
			# classifier_fit = bnb.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("BNB: " + metrics1)
			# print("BNB: " + str(k_fold(X, C, k, bnb)))
			#
			# mnb = MultinomialNB()
			# classifier_fit = mnb.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("MNB: " + metrics1)
			# print("MNB: " + str(k_fold(X, C, k, mnb)))
			#
			rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
			classifier_fit = rf.fit(features_train, target_train)
			classifier_out = classifier_fit.predict(features_test)
			metrics1 = metrics.classification_report(target_test, classifier_out)
			metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			print("RF:")
			print(metrics1)
			# print("RF: " + str(k_fold(X, C, k, rf)))
			lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
			classifier_fit = lsvc.fit(features_train, target_train)
			classifier_out = classifier_fit.predict(features_test)
			metrics1 = metrics.classification_report(target_test, classifier_out)
			metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			print("Linear SVM:")
			print(metrics1)
			# print("Linear SVM: " + str(k_fold(X, C, k, lsvc)))
			svc = SVC(kernel='linear')
			classifier_fit = svc.fit(features_train, target_train)
			classifier_out = classifier_fit.predict(features_test)
			metrics1 = metrics.classification_report(target_test, classifier_out)
			metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			print("SVM (linear kernel):")
			print(metrics1)
			# print("SVM (linear kernel): " + str(k_fold(X, C, k, svc)))
			# knn = KNeighborsClassifier(n_neighbors=10)
			# classifier_fit = knn.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("kNN: " + metrics1)
			# print("kNN: " + str(k_fold(X, C, k, knn)))
			#
			# pc = Perceptron(n_iter=50)
			# classifier_fit = pc.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("Perceptron: " + metrics1)
			# print("Perceptron: " + str(k_fold(X, C, k, pc)))
			#
			# ridge = RidgeClassifier(tol=1e-2, solver="lsqr")
			# classifier_fit = ridge.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("Ridge Regression: " + metrics1)
			# print("Ridge Regression: " + str(k_fold(X, C, k, ridge)))
			#
			# pa = PassiveAggressiveClassifier()
			# classifier_fit = pa.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("Passive Aggressive: " + metrics1)
			# print("Passive Aggressive: " + str(k_fold(X, C, k, pa)))
			#
			lr = LogisticRegression()
			classifier_fit = lr.fit(features_train, target_train)
			classifier_out = classifier_fit.predict(features_test)
			metrics1 = metrics.classification_report(target_test, classifier_out)
			metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			print("Logistic regression:")
			print(metrics1)
			#
			print("")

main2(0.80, 20)
