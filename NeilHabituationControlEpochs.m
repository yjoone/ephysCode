% Paul control epochs
% 
% controlEpochs = [1.3512e6 1.6e6 1.754e6 2.259e6 2.7e6 3.0043e6 3.658e6...
%     3.8e6 4.08e6 4.45e6 4.716e6 5.04e6 5.39e6 5.455e6]

controlEpochs = [2.352 2.84 3.07 3.65 4 5 6 7 8 8.8] *1e5
    

box = [controlEpochs' controlEpochs'+1e3];
damNeil_BLA.trials.behavindices.mountingMale = box;
damNeil_PFC.trials.behavindices.mountingMale = box;
damNeil_NAcc.trials.behavindices.mountingMale = box;