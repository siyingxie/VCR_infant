function [dataCell, timepointT_ds] = averagetimepoints(dataCell, timePoints2Average)
% Downsample the EEG data to a certain sampling rate by averaging the raw 
% EEG data in N-ms steps (here, N defined by timePoints2Average)

% Get relevant information 
conditionN = size(dataCell,1);
channelO = size(dataCell{1,1}, 2);
timepointT = size(dataCell{1,1}, 3);

timepointT_ds = ceil(timepointT/timePoints2Average);

for condIndex = 1:conditionN
    conditionMatrix = dataCell{condIndex, 1};
    
    % Number of trials in the condition
    trialNumber = size(conditionMatrix, 1);
    
    conditionMatrix_ds = single(nan(trialNumber, channelO, timepointT_ds));
    
    for stepIndex = 1:timepointT_ds-1
        time_combination = (1 + (stepIndex - 1) * timePoints2Average):...
            (timePoints2Average + (stepIndex - 1) * timePoints2Average);
        conditionMatrix_ds(:, :, stepIndex) = ...
            nanmean(conditionMatrix(:, :, time_combination), 3);
    end
    
    conditionMatrix_ds(:, :, timepointT_ds) = ...
        nanmean(conditionMatrix(:, :, end), 3);
    
    dataCell{condIndex, 1} = conditionMatrix_ds;
    clear conditionMatrix conditionMatrix_ds trialNumber
end
end