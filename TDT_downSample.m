function ephysData_ds = TDT_downSample(ephysData,r_factor,n_order)

% This function takes in high frequency TDT ephys data and downsamples it
% by the r_factor using decimate function. It also uses IIR filter to apply
% bidirectional filter (compared to FIR which is only one direction).

if nargin < 2
    r_factor = 48;
    n_order = 10;
elseif nargin < 3
    n_order = 10;
end

wb = whos('ephysData');
if ~strcmp(wb.class,'double')
    ephysData = double(ephysData);
end

ephysData_ds = decimate(ephysData,r_factor,n_order,'IIR');
