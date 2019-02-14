% Paul control epochs
% 
% controlEpochs = [1.3512e6 1.6e6 1.754e6 2.259e6 2.7e6 3.0043e6 3.658e6...
%     3.8e6 4.08e6 4.45e6 4.716e6 5.04e6 5.39e6 5.455e6]

controlEpochs = [1.1 1.281 1.37 1.565 2 2.44 2.78 3 3.16 3.5 4.07 4.9 5.16 ...
    5.28] * 1e6;
    

box = [controlEpochs' controlEpochs'+1e3];
damNeil_BLA.trials.behavindices.mountingMale = box;
damNeil_PFC.trials.behavindices.mountingMale = box;
damNeil_NAcc.trials.behavindices.mountingMale = box;