function plotPowerChangeData(OTAgroup,aCSFgroup,analysisname,filepath)

% This function takes in numeric data for first 4 inputs (treatment/control
% P/S). These input should be in 1 by n format, where each column
% represents each animal.

colorvar = 'rgbymcwk'
% minuteConversion = 1/60; % this is conversion rate from the input data to minutes. 
% currently set for seconds to minutes.

treatmentPmean = mean(OTAgroup);
treatmentSmean = mean(aCSFgroup);

% create a figure
figure;
bar([treatmentPmean; treatmentSmean]) 
set(gca,'xticklabel',([{'OTA', 'aCSF'}]))
ylabel('Power density change (a.u.)')
xlabel('groups')

% add in individual dots
hold on
title(analysisname)
plot(ones(size(OTAgroup)),OTAgroup,'o','markeredgecolor','k')
plot(ones(size(aCSFgroup))*2,aCSFgroup,'o','markeredgecolor','k')

savefig(fullfile(filepath,analysisname))
print(fullfile(filepath,analysisname),'-dpng')
close gcf