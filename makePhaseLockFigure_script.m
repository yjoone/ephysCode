% make phase lock figure 

fh = figure('units','inches','position',[14 10 2 1.5]);

ah1 = subplot(2,1,1);
hold on;
ah2 = subplot(2,1,2);
set(ah1,'position',[.25 .3 .58 .7]);

xbins = [-2.5*pi:pi/6:6.5*pi]+pi/12;
phaseDataAll = [phase50All; phase50All+2*pi; phase50All+4*pi];

hist(ah1, phaseDataAll,xbins);
set(ah1,'xlim',[0.01 4*pi+0.01]);
set(ah1,'ylim',[261 600]);
set(ah1,'box','on')
xlabel(ah1,'Phase (deg)','fontsize',9)
ylabel(ah1,'Firing Probability','fontsize',9)
set(ah1,'ytick',[262 392 523],'yticklabel',{'.05','.075','.100'},'fontsize',8)
set(ah1,'xtick',[0 pi*2 pi*4]+0.01,'xticklabel',{'0','360','720'},'fontsize',8)
hold on; 
y = sin(x+param(1,4)+pi/12)*param(1,2)+param(1,1);
plot(ah1,x,y,'r')

hh = findobj(ah1,'type','patch');
% hh.FaceColor = [.7 .7 .7];
hh.FaceColor = [0  1 1];

set(ah2,'position',[.63 .77 .2 .23]);
set(ah2,'box','on')
shadedErrorBar(1:40,s1_m(16:55),s1_sd(16:55))
hold on;
set(ah2,'xlim',[0 40])
set(ah2,'ylim',[-2000 1000])
set(ah2,'xticklabel',[])
set(ah2,'yticklabel',[])
set(ah2,'xtick',[],'ytick',[])
plot(ah2,20:(20+23),ones(1,24)*(-1000),'k','linewidth',3)

mTextBox = uicontrol('style','text');
set(mTextBox,'String','Rayleigh''s r = 7.6e-5','fontSize',9)
set(mTextBox,'unit','normalized')
set(mTextBox,'position',[.27 .78 .35 .2])
set(mTextBox,'backgroundcolor',[1 1 1])
