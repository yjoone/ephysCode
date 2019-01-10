function overlayBehavior(damStruct,behavior,ah,varargin)

% line height
ah = gca;
ly = 3;

assign(varargin)

% put hold
hold(ah,'on')

behavindices = damStruct.trials.behavindices.(behavior);

for behi = 1:length(behavindices)
    plot([behavindices(behi,1) behavindices(behi,2)],ly*ones(1,2),'ko','markersize',5)
end