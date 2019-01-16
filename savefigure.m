function savefigure(fh,outfilepath,outfilename,varargin)
% This function saves the figure on the figure handle (fh) in .fig and .png
% format.

assign(varargin{:})

savefig(fh,fullfile(outfilepath,[outfilename '.fig']))
print(fh,fullfile(outfilepath,[outfilename '.png']),'-dpng')

end