function [pseudo_data_matrix] = averagetrials(dataCell,pseudoTrialN)
% Randomly assign raw trials into N bins of approximately
% equal size each and averaged them into pseudo-trials.
% Takes input: dataCell - a cell array, where each cell in the first column
% contains raw trial data of each condition in a format of [trials x
% channels x time points];
% pseudoTrialN - an array, it defines number of pseudo-trials to be produced.

% Get relevant information 
conditionN = size(dataCell,1);
channelO = size(dataCell{1,1}, 2);
timepointT = size(dataCell{1,1}, 3);

% Pre-allocate matrix
pseudo_data_matrix = single(NaN(conditionN, pseudoTrialN, channelO, timepointT));

% Loop through conditions
for condIndex = 1:conditionN 
    
    conditionMatrix = dataCell{condIndex, 1};
    
    % Number of trials in the condition
    rawTrialNumber = size(conditionMatrix, 1);
    % Number of trials in one pseudo-trial
    numberTrial2Group = floor(rawTrialNumber / pseudoTrialN); 
    
    % randomly permuted trials in the condition matrix
    conditionMatrix_permuted = conditionMatrix(randperm(rawTrialNumber), :, :);
    
    % Loop through N-1 trial group 
    for stepIndex = 1:pseudoTrialN - 1 
        trial_selector = ...
            (1 + (stepIndex - 1) * numberTrial2Group):...
            (numberTrial2Group + (stepIndex - 1) * numberTrial2Group);
        pseudo_data_matrix(condIndex, stepIndex, :, :) = ...
            nanmean(conditionMatrix_permuted(trial_selector, :, :), 1);
    end
    % For the last trial group
    pseudo_data_matrix(condIndex, pseudoTrialN, :, :) = ...
        nanmean(conditionMatrix_permuted(((1 + (pseudoTrialN - 1) * numberTrial2Group):end), :, :), 1);
    
    clear conditionMatrix conditionMatrix_permuted rawTrialNumber numberTrial2Group
end