% USVbehcompile_script

AudSync = [2940870;1372790;5437742;1994106;1948252;1628978];
VidSync = [1766;829;3390;623;208;1747];
AudSR = 250e3;
VidSR = 30;

offset = VidSync/VidSR - AudSync/AudSR;

libFolderPath = 'R:\LiuLab\People\Jim\Experiments\TwoChoiceOdorExposureExpt\USVAnalysis';

FileNames = ['B4_031918';
'B6_031918'
'C1_031618'
'C3_031618'
'D1_031718'
'D3_031718'];

[r,~] = size(FileNames);

for i = 1:r
    
libtable = load_lib(libFolderPath,['voleOdorPreference_' FileNames(i,:) '.f32_goodlibfull.txt']);

eval(['USVbehT_' FileNames(i,:) ' = compileUSVBehavior(libtable,BehaviorStruct_' FileNames(i,:) ',offset(i));'])
end