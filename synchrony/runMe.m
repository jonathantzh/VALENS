clc
clear
close all
%% Load EEG signals here
nTrial = 12;
exp = 'Baseline';
IBD = nan(nTrial, 1);

for i = 1:nTrial
load(['experimentData' filesep exp filesep 'Player1'...
filesep 'trial' num2str(i) '.mat']);
aEEG = recordData(:,4:17);

load(['experimentData' filesep exp filesep 'Player2'...
    filesep 'trial' num2str(i) '.mat']);

bEEG = recordData(:,4:17);
%% Data analysis
    for k = 1:240
[adj] = brainSynchrony(aEEG(128*(k-1)+1:128*k,:), bEEG(128*(k-1)+1:128*k,:));
threshold = 0.5; %0.1 yields same values for all 1s segments, and greater than 1
IBDs(k,1) = brainDensity(adj, threshold);
    end
IBD(i,1) = sum(IBDs)/240;
end
save(['Results' filesep exp '.mat'], 'IBD');