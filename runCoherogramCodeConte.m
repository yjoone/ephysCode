% create dam 
dam = struct;
dam.signal.data1 = data1';
dam.signal.data3 = data3';
dam.signal.data5 = data5';
dam.samplerate = 24414.0625; % Hz
startLastRangeSamples = [1 numel(data1)];
chanNameCell1 = {'data1','data1','data3'};
chanNameCell2 = {'data3','data5','data5'};
dataAcq = 'TDT';

[coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpectOut] = MakeCoherenceRaster(dam,startLastRangeSamples,chanNameCell1,chanNameCell2,dataAcq,'specifyBehavs',false,'keepFrequenciesRange',[3 100]);