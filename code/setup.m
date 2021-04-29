% This script downloads the example dataset (if it has not already been downloaded)
% and adds VCR_infant/code to the MATLAB path.
function setup(downloadseed)

path0 = strrep(which('setup.m'),[filesep 'code' filesep 'setup.m'],'');

% Download the dataset if it has not already been downloaded.
% (If you like, you may manually download the dataset from:
%    https://osf.io/ruxfg/?view_only=919a62ecab944e99a80b9a467951d2e1)
load(fullfile(path0,'data', 'dataseed.mat'), 'osfURL');

for iseed = downloadseed
    if ~exist(fullfile(path0,'data',osfURL(iseed).file),'file')
        fprintf('Downloading %s (please be patient).\n',osfURL(iseed).file);
        urlwrite(osfURL(iseed).link, fullfile(path0,'data',osfURL(iseed).file));
        fprintf('Downloading is done!\n');
    end
end

% Add VCR_infant the MATLAB path (in case the user has not already done so).
addpath(genpath(path0));
end