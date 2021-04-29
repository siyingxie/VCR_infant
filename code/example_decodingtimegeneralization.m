%% Example: Time generalization analysis
% This script demonstrates the time-generalization analysis
% of the example EEG dataset for the study "Visual category
% representation in the infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;
% Start timing
tic;

%% Download dataset (if necessary) and add VCR_infant/code to the MATLAB path
setup(1);

%% Load example dataset

% User input for running decoding on example infant or adult dataset. 
% populationString = 'infant' or populationString = 'adult';
populationString = 'infant';
load(['../data/exampledata_',populationString,'.mat']);

% Check timelock
timelock
%%

%% Define irrelevant channels (only works for infant example dataset) 
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

%% Time-generalization analysis

% The procedure is equivalent to the time-resolved classification analysis
% (see example_decodingintime.m) with the only difference that
% classifiers trained on data from a particular time point were not only
% tested on left out data from the same time point, but iteratively on
% data from the same and all other time points.

% Decoding is done pair-wise for all pairs of conditions.
% For M conditions, you will have to do ((M*(M-1))/2 (i.e., possible
% pair-wise condition combinations) condition-pair specific classifications.
% The result you could get for a pairwise classification would be 0, 50 or
% 100% correct, with 50% being chance level.

% NOTE: Randomization is used within averagetrials.m so results might
% differ between computations.

% We repeat the training & testing procedure "permutationX" times average
% the accuracies of all repetitions to get the mean decoding accuracy.
permutationX = 10;
% Theoretically, the more repetitions, the finer the sampling of a real
% state of things. 100 permutations is usually enough, one can however
% determine empirically the number for a given dataset.
% Here, we use 10 to speed up the example.

% Object categories as conditions
conditionM = 4;

% For time and memory efficiency, we downsampled the EEG data to a sampling
% rate of 50 Hz by averaging the raw EEG data in 20ms bins.
origTempRes = 500; % 500 Hz
resTempRes = 50; % 50 Hz
timePoints2Average = origTempRes/resTempRes;
[dataCell, timepointT] = averagetimepoints(dataCell, timePoints2Average);
% timepointT: Time points of EEG epoch (from -200ms to +1,000ms) in 20ms-steps

% Pre-allocate result matrix
DA = nan(permutationX, conditionM, conditionM, timepointT, timepointT);
% This analysis yielded thus a size M*M decoding accuracy matrix indexed
% in rows and columns by the conditions compared for all time point
% combinations from -200ms to +1,000ms.

for permX = 1:permutationX % Loop through repetitions
    
    % To increase the signal-to-noise ratio (SNR),
    % we randomly assigned raw trials into N bins of approximately
    % equal size each and averaged them into pseudo-trials. In this example, N =
    % 4.
    pseudoTrialN = 4;
    pseudoData = averagetrials(dataCell, pseudoTrialN);
    
    % Additional whitening data procedure:
    % One can do decoding on the EEG data directly as the data come out
    % of a standard preprocessing pipeline.
    % However, some additional preprocessing is beneficial for
    % multivariate analyses. It relates to the multivariate noise normalization.
    % For more details, please see Guggenmos, M., Sterzer, P., & Cichy, R. M.
    % Neuroimage, 173, 434-447. (2018).
    pseudoData = cvmvnn(pseudoData,1:3);
    
    for condA = 1:conditionM % Loop for condition A
        for condB = condA+1:conditionM % Loop for condition B
            
            for timeA = 1:timepointT % Loop for time point A
                
                % Implement leave-one-pseudo-trial-out cross validated
                % classification approach.
                
                % We trained the SVM classifier to pair-wise decode any
                % two conditions using three of the four pseudo-trials
                % for training at time point A
                training_data = ...
                    double([squeeze(pseudoData(condA, 1:end - 1, :, timeA)); ...
                    squeeze(pseudoData(condB, 1:end - 1, :, timeA))]);
                labels_train = [ones(pseudoTrialN-1,1);...
                    2*ones(pseudoTrialN - 1,1)];
                
                % Train model
                model = svmtrain(labels_train, training_data, '-s 0 -t 0 -q');
                
                for timeB = 1:timepointT % Loop for time point B
                    
                    % We used the fourth left-out pseudo-trial 
                    % at time point B for testing, yielding classification 
                    % accuracy (chance level 50%) as a result.
                    testing_data = double([squeeze(pseudoData(condA, end, :, timeB))'; ...
                        squeeze(pseudoData(condB, end, :, timeB))']);
                    labels_test = [1;2];
                    
                    % Test model
                    [~, accuracy, ~] = svmpredict(labels_test, testing_data, model, '-q');
                    
                    % Assign the decoding result into DA matrix
                    DA(permX, condB, condA, timeA, timeB) = accuracy(1);
                end
            end
        end
    end
end

% Average the DA matrix across repetetions
DA_mean = squeeze(nanmean(DA,1));

% Display run time
disp("Decoding done.")
runTime_minutes = toc/60
%%

%% Plot decoding matrix at (100ms, 200ms)

% For each time point combination (e.g., tx = 100ms; ty = 200ms), 
% we get a decoding accuracy matrix of size 4 × 4, with rows and columns 
% indexed by the conditions classified.
% The matrix is symmetric across the diagonal, with the diagonal undefined.
% This procedure yielded one decoding matrix for every time point.
timeComb = dsearchn([-200:20:1000]', [100,200]');
DA_mean_matrix = squeeze(DA_mean(:,:,timeComb(1),timeComb(2)));
DecodingMatrix = triu(DA_mean_matrix.',1) + tril(DA_mean_matrix);

figure(1);
imagesc(1:4,1:4,DecodingMatrix);
set(gca, 'xtick',1:4, 'xticklabel',{'toy','body','house','face'});
set(gca, 'ytick',1:4, 'yticklabel',{'toy','body','house','face'});
axis equal; axis tight;
xlabel('Condition'); ylabel ('Condition');
CH = colorbar('southoutside');
CH.Label.String = 'Decoding accuracy (%)';
title('Decoding matrix at tx=100ms, ty=200ms');
% Adjust the position and size of figure
rectFig = get(gcf,'position');
width=600;
height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%

%% Plot time-time matrix of category decoding
figure(2);
imagesc(-200:20:1000, -200:20:1000, squeeze(nanmean(nanmean(DA_mean,1),2)));
axis xy; axis equal; axis tight;
xlabel('Time (ms)'); ylabel('Time (ms)');
CH = colorbar('southoutside');
CH.Label.String = 'Decoding accuracy (%)';
title('Time-time matrix of category decoding on example data');
% Adjust the position and size of figure
rectFig = get(gcf,'position');
width=600;
height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%