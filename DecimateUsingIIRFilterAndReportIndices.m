function [decimatedSignal,downsampledIndices] = DecimateUsingIIRFilterAndReportIndices(signal,decimateFactor)

decimatedSignal = decimate(signal,decimateFactor); % unless otherwise specified, decimate uses IIR (8th order Chebyshev Type 1)

% determine downsampledIndices (adapted from from MATLAB DECIMATE function,
% under "IIR" filter

lengthInputDataDecimate = length(signal);
nout1 = ceil(lengthInputDataDecimate/decimateFactor);
nbeg1 = decimateFactor - ((decimateFactor*nout1)-lengthInputDataDecimate);
downsampledIndices = nbeg1:decimateFactor:lengthInputDataDecimate;