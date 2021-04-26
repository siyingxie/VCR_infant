% This script downloads the example dataset (if it has not already been downloaded)
% and adds VCR_infant/code to the MATLAB path.
function setup(downloadseed)

path0 = strrep(which('setup.m'),[filesep 'code' filesep 'setup.m'],'');

% Download the dataset if it has not already been downloaded.
% (If you like, you may manually download the dataset from:
%    https://osf.io/ruxfg/?view_only=919a62ecab944e99a80b9a467951d2e1)

url =  'https://osf.io/';

if downloadseed == 1 || downloadseed == 2
    
    if downloadseed == 1
        files = {'exampledata_infant.mat' 'exampledata_adult.mat'};
        osfids = {'f86ur','4mwdn'};
    end
    
    if downloadseed == 2
        files = {'exampledata_infant_longEpoch.mat' 'exampledata_adult_longEpoch.mat'};
        osfids = {'wda2v','tqak7'};
    end
    
    for p=1:length(files)
        if ~exist(fullfile(path0,'data','preprocessed',files{p}),'file')
            if ~exist(fullfile(path0,'data','preprocessed'),'dir')
                mkdir(fullfile(path0,'data','preprocessed'));
            end
            fprintf('Downloading %s (please be patient).\n',files{p});
            urlwrite(sprintf([url,'%s/download'],osfids{p}), ...
                fullfile(path0,'data','preprocessed',files{p}));
            fprintf('Downloading is done!\n');
        end
    end
    
end


if downloadseed == 3 || downloadseed == 4
    
    if downloadseed == 3
        files = {'exampledata_time.mat' 'exampledata_adult.mat'};
        osfids = {'fg3kn','2s93t'};
    end
    
    if downloadseed == 4
        files = {'exampledata_timefrex.mat'};
        osfids = {'9qajr'};
    end
    
    for p=1:length(files)
        if ~exist(fullfile(path0,'data','rdms',files{p}),'file')
            if ~exist(fullfile(path0,'data','rdms'),'dir')
                mkdir(fullfile(path0,'data','rdms'));
            end
            fprintf('Downloading %s (please be patient).\n',files{p});
            urlwrite(sprintf([url,'%s/download'],osfids{p}), ...
                fullfile(path0,'data','rdms',files{p}));
            fprintf('Downloading is done!\n');
        end
    end
    
end

% Add VCR_infant/code to the MATLAB path (in case the user has not already done so).
addpath(genpath(fullfile(path0,'code')));

end