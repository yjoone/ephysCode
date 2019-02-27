% this script generates a sample video to illustrate in vivo
% electrophysiology. It will generate a video and corresponding neural
% traces in gif form

%% Get the neural indices for first mating epoch

cd C:\Users\ykwon36\Documents\workspace_Jim\ExampleVideos
% load in completedRun.mat
% load('C:\Users\ykwon36\Documents\workspace_Jim\O\completedRun.mat')

behavind = damNeil_NAcc.trials.behavindices.mountingMale(1,:);
BLAdata = damNeil_BLA.trials.signal(behavind(1):behavind(2));
NAcdata = damNeil_NAcc.trials.signal(behavind(1):behavind(2));
PFCdata = damNeil_PFC.trials.signal(behavind(1):behavind(2));

% create gif
fh = figure('visible','off');
outfilename = 'sample3neuralactivity.gif';
vo = VideoWriter(outfilename);
open(vo)

for i = 1:numel(BLAdata)
    subplot(3,1,1)
    plot(BLAdata(1:i),'linewidth',1)
    set(gca,'xlim',[0 numel(BLAdata)]);
    set(gca,'ylim',[-50 50]);
    title BLA
    subplot(3,1,2)
    plot(NAcdata(1:i),'linewidth',1)
    set(gca,'xlim',[0 numel(BLAdata)]);
    set(gca,'ylim',[-50 50]);
    title NAcc
    subplot(3,1,3)
    plot(PFCdata(1:i),'linewidth',1)
    set(gca,'xlim',[0 numel(BLAdata)]);
    set(gca,'ylim',[-125 125]);
    title PFC
    drawnow
    frame = getframe(fh);
    im = frame2im(frame);
    
    writeVideo(vo,im);
          % Capture the plot as an image 
      frame = getframe(fh); 
      im = frame2im(frame); 
      % Write to the GIF File 
      if i == 1 
          imwrite(rgb2gray(im),outfilename,'gif', 'delaytime',0.001, 'Loopcount',inf); 
      else 
          imwrite(rgb2gray(im),outfilename,'gif','delaytime',0.001, 'WriteMode','append'); 
      end 
      
      
end
close(vo)