function USVsPerBeh = analyzeUSVBehavior(USVbehT)

% this function takes in USVbehT (output from compileUSVBehavior.m, a table
% containing call properties of the calls emitted during a specific behavior.

beh_u = unique(USVbehT.behavior);

for beh_i = 1:length(beh_u)
    call_i = find(USVbehT.behavior == beh_i);
    behUSVStruct_temp = USVbehT(call_i,:);
    USVsPerBeh{beh_i} = behUSVStruct_temp;
end
end