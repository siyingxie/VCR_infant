function [data_whitened]= cvmvnn (data, trialIndex)
% Multivariate noise normalization, where the error covariance between
% different sensors is considered, and sensors with high noise
% levels (i.e., unreliable sensors) would be downweighted and sensors with
% low noise levels (i.e., reliable sensors) be emphasized.

% Takes inputs: data - 4D array in [conition x trial x sensor x time points]
% format
% trialIndex - a single column array, indexing the trials used for
% calculating the covariance matrix. We usually use the trials in 
% the training data set.

% Gives output: data_whitened - 4D array in [conition x trial x sensor x time points]
% format

%% calculate sensor Epsilon
sz = size(data);
%epsilon of all sensors
E = NaN(sz(4), sz(1), sz(3), sz(3)); 

for t = 1:sz(4) %loop for time points
    for c = 1:sz(1) %loop for conditions
        
        X = squeeze(data(c, trialIndex, :, t));
        
        [sigma, ~] = covCor(X);
        E(t, c, :, :) = sigma;
    end
    
end

%average by conditions and time points
EE = squeeze(mean(mean(E, 1), 2)); 
clear E
%invert E
IE = EE^(-0.5); 


%% apply channel Epsilon on all data

%pre-allocate matrix
data_whitened = NaN(sz);
for t = 1:sz(4) %loop for time points
    for c = 1:sz(1) %loop for conditions
        for l = 1:sz(2) %loop for trials
            
            X = squeeze(data(c, l, :, t))';
            
            %whiten
            W = X * IE;
            
            data_whitened(c, l, :, t) = W;
            
        end
    end
end
end