import csv
import random
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
# path {String} -> path leading to csv data file
# feature_set {String} -> the feature set description that should be included (see descriptions below)
# pol {Integer} -> the polarity the data is filtered on (truthful = 1,
# deceptive = 0)
def get_data(path, feature_set, pol):
    features = []
    with open(path) as csv_file:
        reader = csv.reader(csv_file)
        for row in reader:
            vector = []
            polarity = int(row[len(row) - 4])
            veracity = int(row[len(row) - 5])
            if polarity == pol:
                # NER
                if feature_set == "ner":
                    for i in range(41, 59):
                        vector.append(float(row[i]))
                    vector.append(float(row[171]))
                # NER Best Freq.
                elif feature_set == "nerbf":
                    vector.append(float(row[41]))
                    vector.append(float(row[43]))
                    vector.append(float(row[52]))
                    vector.append(float(row[53]))
                    vector.append(float(row[55]))
                    vector.append(float(row[57]))
                    vector.append(float(row[58]))
                # LIWC
                elif feature_set == "liwc":
                    # for i in range(67, 160):
                    for i in range(68, 160):
                        vector.append(float(row[i]))
                # LIWC + NER
                elif feature_set == "nerliwc":
                    for i in range(41, 59):
                        vector.append(float(row[i]))
                    # for i in range(67, 160):
                    for i in range(68, 160):
                        vector.append(float(row[i]))
                    vector.append(float(row[171]))
                    vector.append(float(row[167]))
                # LIWC + NER Best Freq.
                elif feature_set == "liwcnerbf":
                    vector.append(float(row[41]))
                    vector.append(float(row[43]))
                    vector.append(float(row[52]))
                    vector.append(float(row[53]))
                    vector.append(float(row[55]))
                    vector.append(float(row[57]))
                    vector.append(float(row[58]))
                    # for i in range(67, 160):
                    for i in range(68, 160):
                        vector.append(float(row[i]))
                # LIWC + NER + NER Best Freq.
                elif feature_set == "liwcnernerbf":
                    vector.append(float(row[41]))
                    vector.append(float(row[43]))
                    vector.append(float(row[52]))
                    vector.append(float(row[53]))
                    vector.append(float(row[55]))
                    vector.append(float(row[57]))
                    vector.append(float(row[58]))
                    # for i in range(67, 160):
                    for i in range(68, 160):
                        vector.append(float(row[i]))
                    for i in range(41, 59):
                        vector.append(float(row[i]))
                    vector.append(float(row[171]))
                # add the class for each vector
                features.append([vector, veracity])
    random.seed(42)
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


# K-fold cross-validation implementation for mixed polarities
#
# Parameters:
# k {Integer} -> k
# pol {Integer} -> Train data polarity
# feature_set {String} -> Selected feature set
# path {String} -> path leading to csv data file;
def pn_fold(k, classifier, pol, feature_set, path):
    accuracy = 0
    folds = []
    precision_array_0 = []
    recall_array_0 = []
    f1_array_0 = []
    precision_array_1 = []
    recall_array_1 = []
    f1_array_1 = []
    X_test, C_test = get_data(path, feature_set, 1 - pol)
    size = int(len(X_test) / k)
    for i in range(0, k):
        folds.append([X_test[(i * size):(i + 1) * size],
                      C_test[(i * size):(i + 1) * size]])
    for x in range(0, len(folds)):
        X_train, C_train = get_data(path, feature_set, pol)
        trained = classifier.fit(
            X_train[0:size * (k - 1)], C_train[0:size * (k - 1)])
        predicted = trained.predict(folds[x][0])
        accuracy = accuracy + compute_acc(folds[x][1], predicted)
        eval_metrics = precision_recall_fscore_support(folds[x][1], predicted)
        precision_array_0.append(eval_metrics[0][0])
        precision_array_1.append(eval_metrics[0][1])
        recall_array_0.append(eval_metrics[1][0])
        recall_array_1.append(eval_metrics[1][1])
        f1_array_0.append(eval_metrics[2][0])
        f1_array_1.append(eval_metrics[2][1])
    calculate_results(precision_array_0, precision_array_1, recall_array_0, recall_array_1, f1_array_0, f1_array_1,
                      accuracy / k)


# K-fold cross-validation implementation for one polarity
#
# Parameters:
# k {Integer} -> k
# classifier name {String} -> classifier description
# X_proxy {List} -> feature array
# C_proxy {List} -> corresponding classes
def manual_cross_val(k, classifier_name, X_proxy, C_proxy):
    accuracy = 0
    X_ = np.array(X_proxy)
    C_ = np.array(C_proxy)
    kf = cross_validation.KFold(
        len(X_), n_folds=k, shuffle=True, random_state=42)
    precision_array_0 = []
    recall_array_0 = []
    f1_array_0 = []
    precision_array_1 = []
    recall_array_1 = []
    f1_array_1 = []
    for train_index, test_index in kf:
        X_train, X_test = X_[train_index], X_[test_index]
        y_train, y_test = C_[train_index], C_[test_index]
        classifier_fit = classifier_name.fit(X_train, y_train)
        predicted = classifier_fit.predict(X_test)
        eval_metrics = precision_recall_fscore_support(y_test, predicted)
        precision_array_0.append(eval_metrics[0][0])
        precision_array_1.append(eval_metrics[0][1])
        recall_array_0.append(eval_metrics[1][0])
        recall_array_1.append(eval_metrics[1][1])
        f1_array_0.append(eval_metrics[2][0])
        f1_array_1.append(eval_metrics[2][1])
        accuracy = accuracy + compute_acc(y_test, predicted)
    calculate_results(precision_array_0, precision_array_1, recall_array_0, recall_array_1, f1_array_0, f1_array_1,
                      accuracy / k)


# Prints CV results
#
# Parameters:
# pa0 {List} -> Deceptive precision
# pa1 {List} -> Truthful precision
# ra0 {List} -> Deceptive recall
# ra1 {List} -> Truthful recall
# f10 {List} -> Deceptive f1
# f11 {List} -> Truthful f1
# acc {float} -> Accuracy
def calculate_results(pa0, pa1, ra0, ra1, f10, f11, acc):
    p_c0_np = np.array(pa0)
    p_c1_np = np.array(pa1)
    r_c0_np = np.array(ra0)
    r_c1_np = np.array(ra1)
    f1_c0_np = np.array(f10)
    f1_c1_np = np.array(f11)
    print("Precision class0: " + str(round(p_c0_np.mean() * 100, 2)))
    print("Precision class1: " + str(round(p_c1_np.mean() * 100, 2)))
    print("Recall class0: " + str(round(r_c0_np.mean() * 100, 2)))
    print("Recall class1: " + str(round(r_c1_np.mean() * 100, 2)))
    print("F1 class0: " + str(round(f1_c0_np.mean() * 100, 2)))
    print("F1 class1: " + str(round(f1_c1_np.mean() * 100, 2)))
    print("Accuracy: " + str(round(acc * 100, 2)))


# Main-method
#
# Parameters:
# k {Integer} -> k
def main(k):
    feature_sets = [
        ["NER", "ner"],
        ["NER Best Freq.", "nerbf"],
        ["LIWC", "liwc"],
        ["NER + LIWC", "nerliwc"],
        ["NER Best Freq. + LIWC", "liwcnerbf"],
        ["NER + NER Best Freq. + LIWC", "liwcnernerbf"]
    ]
    polarities = [
        ["Negative", 0],
        ["Positive", 1]
    ]
    crossed = [
        ["Negative -> Positive", 0],
        ["Positive -> Negative", 1],
    ]
    path = "inf_spec_ner_liwc_speciteller.csv"
    rf = RandomForestClassifier(n_estimators=200, criterion='entropy')
    svc = LinearSVC(penalty="l1", dual=False, tol=1e-3)
    lr = LogisticRegression()
    for feature_set in feature_sets:
        print(feature_set[0])
        for polarity in polarities:
            print(polarity[0])
            X, C = get_data(path, feature_set[1], polarity[1])
            # run k-fold cv
            print("--------- RF --------")
            manual_cross_val(k, rf, X, C)
            print("")
            print("-------------------------------------------------------")
            print("--------- SVM --------")
            manual_cross_val(k, svc, X, C)
            print("")
            print("-------------------------------------------------------")
            print("--------- Log Reg --------")
            manual_cross_val(k, lr, X, C)
            print("")
            print("-------------------------------------------------------")
    print("============================================================")
    for feature_set in feature_sets:
        print(feature_set[0])
        for cross in crossed:
            print(cross[0])
            # run k-fold cv
            print("--------- RF --------")
            pn_fold(k, rf, cross[1], feature_set[1], path)
            print("")
            print("-------------------------------------------------------")
            print("--------- SVM --------")
            pn_fold(k, svc, cross[1], feature_set[1], path)
            print("")
            print("-------------------------------------------------------")
            print("--------- Log Reg --------")
            pn_fold(k, lr, cross[1], feature_set[1], path)
            print("")
            print("-------------------------------------------------------")
