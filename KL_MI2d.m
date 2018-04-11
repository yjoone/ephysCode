function [mod2d,phasepref2d] = KL_MI2d(dataLowF,dataHighF,flow,fhigh,flowBandPlusMinus,fhighBandPlusMinus,samplerate,plt)
%%   Compute the two-dimensional Kullback–Leibler MI and plot the result.
%       From Tort et al., J Neurophysiol, 2010
%
%   USAGE:
%       [mod2d, flow, fhigh] = KL_MI2d_NL(data); % 2d reflects that varying
%       both phase and amplitude frequencies
%
%   INPUTS:
%       dataLowF   = The unfiltered data (row vector) that will filter in
%       low frequencies
%       dataHighF = The unfiltered data (row vector) that will filter in
%       high frequencies (can be same or different signal (e.g. second
%       brain region) as dataLowF)
%       samplerate = sampling rate
%       plt    = 'y' or 'n' to plot data
%
%   OUTPUTS:
%       A plot of the two-dimensional modulation index.
%       mod2d  = The two-dim modulation index.
%       flow   = The frequency axis for the lower phase frequencies.
%       fhigh  = The frequency axis for the higher amplitude frequencies.
%
%   DEPENDENCIES:
%    KL_MI_TEM.m
%    eegfilt.m (From EEGLAB Toolbox, http://www.sccn.ucsd.edu/eeglab/)
%
%   original function programmed by MAK.  Nov 12, 2007.
%   modified by TEM 9/12/12. Obtained from TEM 5/14. Modified by EA 5/14.

%if nargin < 3 || isempty(plt);  plt = 'n';  end

%colorbarRange = [0 30e-3];

flow1 = flow-flowBandPlusMinus;
flow2 = flow+flowBandPlusMinus;
fhigh1 = fhigh-fhighBandPlusMinus;
fhigh2 = fhigh+fhighBandPlusMinus;

mod2d = zeros(length(flow1), length(fhigh1)); % initialize array
phasepref2d = zeros(length(flow1), length(fhigh1)); % initialize array
h = waitbar(0,'Filtering data...');

for i=1:length(flow1)
    % Filter the low freq signal & extract its phase.
    theta=eegfilt(dataLowF,samplerate,flow1(i),flow2(i)); % EA 5/24/14: sampling rate initially set to 1000 by TEM; updated to general samplerate var and added var as function input 
    phase = angle(hilbert(theta));
    clc
    waitbar(i/length(flow1))
    for j=1:length(fhigh1)
        % Filter the high freq signal & extract its amplitude envelope.
        gamma=eegfilt(dataHighF,samplerate,fhigh1(j),fhigh2(j)); % EA 5/24/14: sampling rate initially set to 1000 by TEM; updated to general samplerate var and added var as function input     
        amp = abs(hilbert(gamma));
        [mi,phasepref,MeanAmp,center] = KL_MI(amp, phase);   % Compute the modulation index.
        mod2d(i,j) = mi; % row is low freq, column is high freq
        phasepref2d(i,j) = phasepref;
    end
end
close(h)

if plt == 'y'
    %Plot the two-dimensional modulation index.
    figure(); imagesc(flow, fhigh, mod2d'); colorbar; axis xy;%caxis([0 0.04]);
    set(gca, 'FontName', 'Arial', 'FontSize', 14); title('KL-MI 2d');
    xlabel('Phase Frequency (Hz)');  ylabel('Envelope Frequency (Hz)');
end
end
