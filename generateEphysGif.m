% script to generate gif version of ephys data

load('/Volumes/ecas-research/LiuLab/People/Jim/Experiments/OTmanipEphysExpt/Experiments_NL/Neil/Habituation1_Neil_112818.mat')
box = chan4(4e5:4.01e5);
fh = figure;

outfilename = 'test.gif';
% vo = VideoWriter(outfilename);
% open(vo)


for i = 1:10:length(box)
    plot(box(1:i));
    set(gca,'xlim',[0 numel(box)]);
    set(gca,'ylim',[50 200]);
    drawnow
    
      % Capture the plot as an image 
      frame = getframe(fh); 
      im = frame2im(frame); 
      % Write to the GIF File 
      if i == 1 
          imwrite(im(:,:,3),outfilename,'gif', 'delaytime',0.1, 'Loopcount',inf); 
      else 
          imwrite(im(:,:,3),outfilename,'gif','delaytime',0.1, 'WriteMode','append'); 
      end 
    
end
