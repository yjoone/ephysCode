function coherogramStruct = coherogramStructPostProcessing(coherogramStruct)

% adapted from samplepipepine.m step 14. This function will replace the
% script in that section. JK 011318
% coherogramStructNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD;

% plotCoherogram(coherogramStruct)
behavNamesCoherogramStruct = fieldnames(coherogramStruct);


for i=1:numel(behavNamesCoherogramStruct)
    behavNameCoherogramStruct =  behavNamesCoherogramStruct{i};

    CValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).C;
     
    
    phiValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).phi;
    
    S12ValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).S12;
     
    
    S1ValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).S1;
      
    
    S2ValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).S2;
       
    
    phistdValsCoherogram = coherogramStruct.(behavNameCoherogramStruct).phistd;
    
    coherogramStruct.(behavNameCoherogramStruct).CMean = mean(CValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).CSTD = std(CValsCoherogram,0,1); %rows refer to time

    coherogramStruct.(behavNameCoherogramStruct).phiMean = mean(phiValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).phiSTD = std(phiValsCoherogram,0,1); %rows refer to time

    coherogramStruct.(behavNameCoherogramStruct).S12Mean = mean(S12ValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).S12STD = std(S12ValsCoherogram,0,1); %rows refer to time

    coherogramStruct.(behavNameCoherogramStruct).S1Mean = mean(S1ValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).S1STD = std(S1ValsCoherogram,0,1); %rows refer to time

    coherogramStruct.(behavNameCoherogramStruct).S2Mean = mean(S2ValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).S2STD = std(S2ValsCoherogram,0,1); %rows refer to time

    coherogramStruct.(behavNameCoherogramStruct).phistdMean = mean(phistdValsCoherogram,1); %rows refer to time
    coherogramStruct.(behavNameCoherogramStruct).phistdSTD = std(phistdValsCoherogram,0,1); %rows refer to time


end

