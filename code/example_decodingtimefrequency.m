%% Example : Decode object categories in time and frequency
% This script demonstrates time- and frequency-resolved multivariate analysis
% conducted to the example EEG dataset of study "Visual category
% representation of infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;
% Start timing
tic;

%% Download dataset (if necessary) and add VCR_infant/code to the MATLAB path
setup(2);

%% Load example dataset

% User input for running decoding on example infant or adult dataset. 
% populationString = 'infant' or populationString = 'adult';
populationString = 'infant';
load(['../data/preprocessed/exampledata_',populationString,'_longEpoch.mat']);

% Check timelock
timelock
%%

%% Define the irrelavant channels (only work for infant example dataset) 
if strcmp(populationString, 'infant')
    flagChannels=~ismember(timelock.label,...
        {'Cz','HEOG','VEOG','TRIGGER', 'V-', 'V+Fp2'});
else
    flagChannels=true(length(timelock.label),1);
end
%%

%% Sort trials into four category conditions
[dataCell{1:4,2}]=deal('toy','body','house','face');
for i_conds = 1:4
    flagTrials = ismember(timelock.trialinfo(:,2),i_conds);
    dataCell{i_conds,1} = single(timelock.trial(flagTrials,flagChannels,:));
end

% Check dataCell
dataCell
%%

%% Time-frequency decomposition
[dBPowerCell,convo] = timefrexdecomp(dataCell);
clear dataCell;

% Check dBPowerCell and convo
dBPowerCell
convo
%%

%% Define time points and frequcies of interest

% Frequency of interest
TOI = dsearchn(convo.times',[-200, 1000]');
dBPowerCell = cellfun(@(x) x(:,:,TOI(1):TOI(2)), dBPowerCell,'UniformOutput', 0);

% Frequency of interest
FOI = convo.mor_frex;
frequencyF = length(FOI);
%%

%% Decode object categories in time and frequency

% Time- and frequency- resolved classification analysis
% The procedure was equivalent to the time-resolved classification analysis
% (see example_decodingintime.m) with the only difference that
% classification was conducted on power value patterns instead of 
% raw activation value patterns. 
% The analysis was conducted separately for each frequency bin separately. 

% Pre-allocate cell array
DA_frexCell = cell(frequencyF,1);

for frexF = 1:frequencyF %Loop through frequencies
    
    % Define dataCell for decoding, i.e., power data in one frequency step
    dataCell = {dBPowerCell{1:4,frexF}};
    dataCell = reshape(dataCell,[4,1]);
    
    % For time and memory efficiency, we downsampled dB power data to a 
    % sampling rate of 50 Hz by averaging the raw EEG data in 20ms bins.
    origTempRes = 500; % 500 Hz
    resTempRes = 50; % 50 Hz
    timePoints2Average = origTempRes/resTempRes;
    [dataCell, timepointT] = averagetimepoints(dataCell, timePoints2Average);
    % timepointT: Time points of EEG epoch (from -200ms to +1000ms) in 20ms-steps
    
    % Decoding is done pairwisely for all pairs of conditions.
    % For M conditions, you will have to do ((M*(M-1))/2 (i.e., possible
    % pair-wise condition combinations) condition-pair specific classifications.
    % The result you could get for a pairwise classification would be 0, 50 or
    % 100% correct, 50% is the chance level.
    
    % NOTE: randomization is used within averagetrials.m so results may
    % be different each time it is run.

    % We repeat the trainning & testing procedure "permutationX" times average
    % the accuracies of all repetetions to get the mean decoding accuracy.
    permutationX = 10;
    % Theoretically, the more repetetions the finer the sampling of a real
    % state of things. 100 permutations is usually enough, one can however
    % determine empirically for the data how much is enough.
    % Here, we use 10 as a fast running example.
    
    % Object categories as conditions
    conditionM = 4;
    
    % Pre-allocate result matrix
    DA = nan(permutationX, conditionM, conditionM, timepointT);
    % This analysis yielded thus a size M*M decoding accuracy matrix indexed
    % in rows and columns by the conditions compared for all time point
    % combinations from -200 to +1,000ms.
    
    for permX = 1:permutationX % Loop through repetitions
        
        % To increase the signal-to-noise ratio (SNR),
        % we randomly assigned raw trials into N bins of approximately
        % equal size each and averaged them into pseudo-trials, here N is equal
        % to 4.
        pseudoTrialN = 4;
        pseudoData = averagetrials(dataCell, pseudoTrialN);
        
        for condA = 1:conditionM % Loop for condition A
            for condB = condA+1:conditionM % Loop for condition B
                for timeT = 1:timepointT % Loop for time point A
                    
                    % Implement leave-one-pseudo-trial-out cross validated
                    % classification approach.
                    
                    % We trained the SVM classifier to pairwise decode any
                    % two conditions using three of the four pseudo-trials
                    % for training at time point A
                    training_data = ...
                        double([squeeze(pseudoData(condA, 1:end - 1, :, timeT)); ...
                        squeeze(pseudoData(condB, 1:end - 1, :, timeT))]);
                    labels_train = [ones(pseudoTrialN-1,1);...
                        2*ones(pseudoTrialN - 1,1)];
                    
                    % Train model
                    model = svmtrain(labels_train, training_data, '-s 0 -t 0 -q');
                    
                    % We used the fourth left-out pseudo-trial
                    % at time point B for testing, yielding classification
                    % accuracy (chance level 50%) as a result.
                    testing_data = double([squeeze(pseudoData(condA, end, :, timeT))'; ...
                        squeeze(pseudoData(condB, end, :, timeT))']);
                    labels_test = [1;2];
                    
                    % Test model
                    [~, accuracy, ~] = svmpredict(labels_test, testing_data, model, '-q');
                    
                    % Assign the decoding result into DA matrix
                    DA(permX, condB, condA, timeT) = accuracy(1);
                    
                end
            end
        end
    end
    
    % Average the DA matrix across repetetions
    DA_frexCell{frexF,1} = nanmean(DA,1);
end

DA_timefrex = cat(1,DA_frexCell{:}); 
% 4D matrix: frequency x condition x condition x time point

% Display run time
disp("Decoding done.")
runTime_minutes = toc/60
%%

%% Plot EEG dB power after decomposition
figure(1);
% We average dB power values across channels, trials
meandBPowerCell = cellfun(@(x) mean(mean(x,1),2),dBPowerCell,'UniformOutput',0);
meandBPowerMat = cell2mat(meandBPowerCell);

imagesc(-200:2:1000,1:30,squeeze(nanmean(meandBPowerMat,1)));
set(gca,'YTick',[1,6,11,16,21,26,30], ...
    'YTickLabel', round(FOI([1,6,11,16,21,26,30]),2));
axis xy; axis tight;
xlim([-200,1000]);
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
CH = colorbar('eastoutside'); CH.Label.String = 'Power (dB)';
title('Decomposition: average EEG signal power');
% Adjust the position and size of figure
rectFig = get(gcf,'position');
width=600;
height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%


%% Plot decoding matrix at (100ms, 2Hz)

% For each time-frequency combination (e.g., tx = 100ms; fy = 2Hz),
% we get a decoding accuracy matrix of size 4 × 4, with rows and columns
% indexed by the conditions classified.
% The matrix is symmetric across the diagonal, with the diagonal undefined.
% This procedure yielded one decoding matrix for every time point.
figure(2);
tx = dsearchn([-200:20:1000]', 100);
fy = dsearchn(FOI', 2);
DA_mean_matrix = squeeze(DA_timefrex(fy,:,:,tx));
DecodingMatrix = triu(DA_mean_matrix.',1) + tril(DA_mean_matrix);

imagesc(1:4,1:4,DecodingMatrix);
set(gca, 'xtick',1:4, 'xticklabel',{'toy','body','house','face'},...
    'ytick',1:4, 'yticklabel',{'toy','body','house','face'});
axis equal; axis tight;
xlabel('Condition'); ylabel ('Condition');
CH = colorbar('southoutside');
CH.Label.String = 'Decoding accuracy (%)';
title('Decoding matrix at (100ms,2Hz)');
% Adjust the position and size of figure
rectFig = get(gcf,'position');
width=600;
height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%

%% Plot time-frequency decoding matrix
figure(3); 
imagesc(-200:20:1000, 1:30, squeeze(nanmean(nanmean(DA_timefrex,2),3)));
set(gca,'YTick',[1,6,11,16,21,26,30], ...
    'YTickLabel', round(FOI([1,6,11,16,21,26,30]),2));
axis xy; axis tight;
xlim([-200,1000]);
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
CH = colorbar('eastoutside');
CH.Label.String = 'Decoding accuracy (%)';
title('Time-frequency decoding matrix');
% Adjust the position and size of figure
rectFig = get(gcf,'position');
width=600;
height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%