function analyzeObserverData(Time_b_all)

% this function analyzes the compiled observer data. The input should be
% the output of observerReadoutCompile_script 

% row 1: partner sniffing
% row 2: stranger sniffing
% row 3: partner side
% row 4: stranger side

ratio(1,:) = Time_b_all(1,:)./Time_b_all(3,:);
ratio(2,:) = Time_b_all(2,:)./Time_b_all(4,:);

sniffOnlyRatio(1,:) = Time_b_all(1,:)./sum(Time_b_all(1:2,:));
sniffOnlyRatio(2,:) = Time_b_all(2,:)./sum(Time_b_all(1:2,:));

%% compare absolute time sniffing
% box plot
data = Time_b_all(1:2,:)';
p_sniffing = anova1(data);
title('Partner vs Stranger bedding sniffing time')
ylabel('time (s)')
xlabel('Partner (1)     Stragner(2)');
set(gca,'fontsize',15)
savefig('SniffingTimeAbsolute.fig')
print(gcf,'SniffingTimeAbsolute.png','-dpng');
close(gcf);

% stat plot
title('Partner vs Stranger bedding sniffing time stats')
savefig('SniffingTimeAbsolute_stats.fig')
print(gcf,'SniffingTimeAbsolute_stats.png','-dpng');
close(gcf);

% bar plot
dataMean = mean(data);
dataSE = std(data)./sqrt(length(data));
figure;
set(gca,'fontsize',15)
hold on
bar(1:2,dataMean)
% errorbar(1:2,dataMean,dataSE,'.','capsize',12,'linewidth',3)
errorbar(1:2,dataMean,dataSE,'.','linewidth',3)

ylabel('time (s)')
xlabel('Partner (1)     Stragner(2)');
title('Partner vs Stranger bedding sniffing time')
savefig('SniffingTimeAbsolute_bar.fig')
print(gcf,'SniffingTimeAbsolute_bar.png','-dpng');
close(gcf);

%% compare side residing time
data = Time_b_all(3:4,:)';
p_side = anova1(data);
title('Partner vs Stranger side time')
ylabel('time (s)')
xlabel('Partner (1)     Stragner(2)');
set(gca,'fontsize',15)
savefig('SideTimeAbsolute.fig')
print(gcf,'SideTimeAbsolute.png','-dpng');
close(gcf);

% stat plot
title('Partner vs Stranger side time stats')
savefig('SideTimeAbsolute_stats.fig')
print(gcf,'SideTimeAbsolute_stats.png','-dpng');
close(gcf);

% bar plot
dataMean = mean(data);
dataSE = std(data)./sqrt(length(data));
figure;
set(gca,'fontsize',15)
hold on
bar(1:2,dataMean)
% errorbar(1:2,dataMean,dataSE,'.','capsize',12,'linewidth',3)
errorbar(1:2,dataMean,dataSE,'.','linewidth',3)

ylabel('time (s)')
xlabel('Partner (1)     Stragner(2)');
title('Partner vs Stranger side time')
savefig('SideTimeAbsolute_bar.fig')
print(gcf,'SideTimeAbsolute_bar.png','-dpng');
close(gcf);


%% compare the ratio of residing time and sniffing time
data = ratio';
p_portion = anova1(data);
title('Partner vs Stranger portion of sniffing')
ylabel('portion')
xlabel('Partner (1)     Stragner(2)');
set(gca,'fontsize',15)
savefig('PortionSniffing.fig')
print(gcf,'PortionSniffing.png','-dpng');
close(gcf);

% stat plot
title('Partner vs Stranger portion of sniffing stats')
savefig('PortionSniffing_stats.fig')
print(gcf,'PortionSniffing_stats.png','-dpng');
close(gcf);

% bar plot
dataMean = mean(data);
dataSE = std(data)./sqrt(length(data));
figure;
set(gca,'fontsize',15)
hold on
bar(1:2,dataMean)
% errorbar(1:2,dataMean,dataSE,'.','capsize',12,'linewidth',3)
errorbar(1:2,dataMean,dataSE,'.','linewidth',3)


ylabel('portion')
xlabel('Partner (1)     Stragner(2)');
title('Partner vs Stranger portion of sniffing')
savefig('PortionSniffing_bar.fig')
print(gcf,'PortionSniffing_bar.png','-dpng');
close(gcf);


%% compare the ratio of sniffing tme 
data = sniffOnlyRatio';
p_sniffPortion = anova1(data);
title('Partner vs Stranger portion of only sniffing')
ylabel('portion')
xlabel('Partner (1)     Stragner(2)');
set(gca,'fontsize',15)
savefig('PortionOnlySniffing.fig')
print(gcf,'PortionOnlySniffing.png','-dpng');
close(gcf);

% stat plot
title('Partner vs Stranger portion of onlysniffing stats')
savefig('PortionOnlySniffing_stats.fig')
print(gcf,'PortionOnlySniffing_stats.png','-dpng');
close(gcf);


% bar plot
dataMean = mean(data);
dataSE = std(data)./sqrt(length(data));
figure;
set(gca,'fontsize',15)
hold on
bar(1:2,dataMean)
% errorbar(1:2,dataMean,dataSE,'.','capsize',12,'linewidth',3)
errorbar(1:2,dataMean,dataSE,'.','linewidth',3)


ylabel('portion')
xlabel('Partner (1)     Stragner(2)');
title('Partner vs Stranger portion of onlysniffing')
savefig('PortionOnlySniffing_bar.fig')
print(gcf,'PortionOnlySniffing_bar.png','-dpng');
close(gcf);
