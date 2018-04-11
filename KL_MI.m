function [mi,phasepref,MeanAmp,center] = KL_MI(Amp,Phase)
%%   Compute the one-dimensional Kullback–Leibler modulation index.
%       From Tort et al., J Neurophysiol, 2010
%
%   USAGE:
%       [mi,phasepref] = KL_MI_TEM(Amp,Phase);
%
%   INPUTS:
%       Amp    = time series representing amplitude of high frequency range
%                   already filtered and hilbert transformed
%       Phase  = time series representing phase of low frequency range
%                   already filtered and hilbert transformed
%
%   OUTPUTS:
%       mi          = The modulation index.
%       phasepref   = the "preferred" phase (center of bin with highest
%                       gamma amplitude) expressed in degrees relative to 
%                       delta/theta peak
%       MeanAmp     = average gamma amplitude per phase bin
%       center      = center degree of all phase bins
%
%   original demo script: ModulationIndexCore.m 
%       programmed by Adriano Tort, CBD, BU, 2008
%   adapted to function by Teresa E. Madsen (TEM) on 9/11/12. Obtained by EA from
%   TEM on 5/2014; additional comments added by EA on 5/2014 
  
nbin=18;            % break 0-360o into 18 bins, i.e., each bin has 20o
position=zeros(1,nbin);     % will get beginning of each bin (in rads)
MeanAmp=zeros(1,nbin);      % will get average amplitude within each bin

for j=1:nbin 
    winsize = 2*pi/nbin;
    position(j) = -pi+(j-1)*winsize; 
    I = (Phase <  position(j)+winsize) & (Phase >=  position(j)); % start of bin up to (but not including) start of next bin
    MeanAmp(j)=mean(Amp(I)); % take mean amplitude over phase frequency bin
end

center = mean([position; position+winsize])/pi*180;

% figure; bar([center center+360],[MeanAmp,MeanAmp]); xlim([-180 540]);
% set(gca,'FontName','Arial','Fontsize',14,'XTick',-180:90:540);
% xlabel('Delta/Theta Phase','Fontsize',16); 
% ylabel('Average Gamma Amplitude','Fontsize',16);
% 
% figure; plot(1:length(Amp),Amp,1:length(Phase),Phase);
% dbup; hold all; plot(1:length(indx),theta(indx),1:length(indx),data(indx));

mi=(log(nbin)-(-sum((MeanAmp/sum(MeanAmp)).*log(MeanAmp/sum(MeanAmp)))))...
    /log(nbin);

% get the phase bin containing max gamma amplitude
[~, maxPB] = max(MeanAmp);
% and determine prefered phase
phasepref = center(maxPB);    
end
