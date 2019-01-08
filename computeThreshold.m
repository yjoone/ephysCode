function [LEDthresholds] = computeThreshold(LED)

threshold = 17;
windowsize = 1e4;

M = movmean(LED,windowsize);

LEDthresholds = M+threshold;
