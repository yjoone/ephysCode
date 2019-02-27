function fh = plotGradient(data,x,fh)
% This function plots each rows of data by different color. Black to White
% data should be in n by x format, where n is the number of output lines in
% the figure.

if nargin < 3
    fh = gcf;
end

% get the size of data
[n,~] = size(data);

% get the gradient
linecolor = linspace(0,0.9,n);

for i = 1:n
    plot(x,data(i,:),'color',[linecolor(i) linecolor(i) linecolor(i)])
    hold on
end