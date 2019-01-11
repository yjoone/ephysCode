function overlayBehavior(damStruct,behavior,varargin)

% line height
ah = gca;
ly = 70;
samplerate = 199.8049;
xunit = 'seconds';

assign(varargin)

% put hold
hold(ah,'on')

behavindices = damStruct.trials.behavindices.(behavior);

if strcmpi(xunit,'seconds')
    behavindices = behavindices/samplerate;
end

for behi = 1:length(behavindices)
    plot([behavindices(behi,1) behavindices(behi,2)],ly*ones(1,2),'ro','markersize',5)
end