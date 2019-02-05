% Neil control epochs

controlEpochs = [1.709e6 2.0935e6 2.462e6 2.556e6 3.43e6 3.841e6 3.896e6 4.261e6 4.633e6 4.725e6 5.13e6]


box = [controlEpochs' controlEpochs'+1e3];
damNeil_BLA.trials.behavindices.mountingMale = box;
damNeil_PFC.trials.behavindices.mountingMale = box;
damNeil_NAcc.trials.behavindices.mountingMale = box;