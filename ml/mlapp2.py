import csv, random
import numpy as np
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
					vector.append(float(row[171]))
				elif feature_set == "liwc":
					for i in range(67, 160):
						vector.append(float(row[i]))
				elif feature_set == "nerliwc":
					for i in range(23, 41):
						vector.append(float(row[i]))
					vector.append(round((sum_up(vector)) / float(row[17]), 4))
					for i in range(67, 160):
						vector.append(float(row[i]))
					vector.append(float(row[167]))
				elif feature_set == "unerliwc":
					for i in range(41, 59):
						vector.append(float(row[i]))
					for i in range(67, 160):
						vector.append(float(row[i]))
					vector.append(float(row[171]))
					vector.append(float(row[167]))
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

def manual_cross_val(k, classifier_name, X_proxy, C_proxy):
	# define classifiers
	rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
	lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
	lr = LogisticRegression()
	#
	X_ = np.array(X_proxy)
	C_ = np.array(C_proxy)
	kf = cross_validation.KFold(len(X_), n_folds=k, shuffle=True, random_state = 42)
	precision_array_0 = []
	recall_array_0 = []
	f1_array_0 = []
	accuracy_array_0 = []
	precision_array_1 = []
	recall_array_1 = []
	f1_array_1 = []
	accuracy_array_1 = []
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
	accuracy_avg_score = round(accuracy_cross_val_score.mean()*100, 2)
	print("Precision class0: " + str(round(p_c0_np.mean()*100, 2)))
	print("Precision class1: " + str(round(p_c1_np.mean()*100, 2)))
	print("Recall class0: " + str(round(r_c0_np.mean()*100, 2)))
	print("Recall class1: " + str(round(r_c1_np.mean()*100, 2)))
	print("F1 class0: " + str(round(f1_c0_np.mean()*100, 2)))
	print("F1 class1: " + str(round(f1_c1_np.mean()*100, 2)))
	print("Accuracy: " + str(accuracy_avg_score))

def main3(k):
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
	for att in atts:
		print(att[0])
		for polarity in inner_atts:
			print(polarity[0])
			X, C = get_data("inf_spec_ner_liwc_speciteller.csv", att[1], polarity[1])
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

main3(5)

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
			f1_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='f1_weighted')
			precision_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='precision')
			recall_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='recall')
			accuracy_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='accuracy')
			f1_avg_score = round(f1_cross_val_score.mean()*100, 2)
			precision_avg_score = round(precision_cross_val_score.mean()*100, 2)
			recall_avg_score = round(recall_cross_val_score.mean()*100, 2)
			accuracy_avg_score = round(accuracy_cross_val_score.mean()*100, 2)
			print("precision = " + str(precision_avg_score))
			print("recall = " + str(recall_avg_score))
			print("F1 = " + str(f1_avg_score))
			print("accuracy = " + str(accuracy_avg_score))
			print("-------------------------------------------------------")
			# print("RF: " + str(k_fold(X, C, k, rf)))
			lsvc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
			classifier_fit = lsvc.fit(features_train, target_train)
			classifier_out = classifier_fit.predict(features_test)
			metrics1 = metrics.classification_report(target_test, classifier_out)
			metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			print("Linear SVM:")
			print(metrics1)
			f1_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='f1_weighted')
			precision_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='precision')
			recall_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='recall')
			accuracy_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='accuracy')
			f1_avg_score = round(f1_cross_val_score.mean()*100, 2)
			precision_avg_score = round(precision_cross_val_score.mean()*100, 2)
			recall_avg_score = round(recall_cross_val_score.mean()*100, 2)
			accuracy_avg_score = round(accuracy_cross_val_score.mean()*100, 2)
			print("precision = " + str(precision_avg_score))
			print("recall = " + str(recall_avg_score))
			print("F1 = " + str(f1_avg_score))
			print("accuracy = " + str(accuracy_avg_score))
			print("-------------------------------------------------------")
			# print("Linear SVM: " + str(k_fold(X, C, k, lsvc)))
			# svc = SVC(kernel='linear')
			# classifier_fit = svc.fit(features_train, target_train)
			# classifier_out = classifier_fit.predict(features_test)
			# metrics1 = metrics.classification_report(target_test, classifier_out)
			# metrics2 = metrics.confusion_matrix(target_test, classifier_out)
			# print("SVM (linear kernel):")
			# print(metrics1)
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
			f1_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='f1_weighted')
			precision_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='precision')
			recall_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='recall')
			accuracy_cross_val_score = cross_validation.cross_val_score(classifier_fit, X, C, cv=k, scoring='accuracy')
			f1_avg_score = round(f1_cross_val_score.mean()*100, 2)
			precision_avg_score = round(precision_cross_val_score.mean()*100, 2)
			recall_avg_score = round(recall_cross_val_score.mean()*100, 2)
			accuracy_avg_score = round(accuracy_cross_val_score.mean()*100, 2)
			print("precision = " + str(precision_avg_score))
			print("recall = " + str(recall_avg_score))
			print("F1 = " + str(f1_avg_score))
			print("accuracy = " + str(accuracy_avg_score))
			print("-------------------------------------------------------")
			#
			print("")

# main2(0.80, 5)
