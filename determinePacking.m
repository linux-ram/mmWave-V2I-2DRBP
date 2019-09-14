function [data, NRsbLeftUnpacked, IndRsbLeftUnpacked, TrimLoss] = determinePacking(RB, allItems)

% Ignore Value of the items
RSBIgnorVal = allItems(:,[1 2]);
RSB = reshape(RSBIgnorVal',1,numel(RSBIgnorVal));

%% Get input ready
% allTiles = [70 80 30 20 50 20 10 60 40 20 30 50 20 30];
allTiles = horzcat(RB, RSB);
args = strjoin(string(strsplit(num2str(allTiles,' %d'))));

%% Run the Guillotine Packing Algorithm
% !2DRBP 70 80 30 20 50 20 10 60 40 20 30 50 20 30
[status,cmdout] = system(char(['2DRBP' '' args]));
data=str2num(cmdout);

%% Determine efficacy of packing
BinArea = prod(RB);
idx = all(data == -1, 2);
data(idx, :) = [];
rectUnpacked=nonzeros([1:numel(idx)]'.*idx);
NRsbLeftUnpacked = num2str(numel(rectUnpacked));
IndRsbLeftUnpacked = num2str(rectUnpacked');
RSBIgnorVal(rectUnpacked,:)=[];
dim = 2; AreaPacked = sum(prod(RSBIgnorVal,dim));
TrimLoss = (BinArea - AreaPacked)/BinArea;
% fprintf('Trim Loss: %s\n', num2str(TrimLoss));
% fprintf('#RSBs left unpacked: %s\n', NRsbLeftUnpacked);
% fprintf('Index of RSBs left unpacked: %s\n', IndRsbLeftUnpacked);


end