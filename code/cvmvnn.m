function [data_whitened]= cvmvnn (data, trialIndex)
% Multivariate noise normalization

%calculate channel Epsilon only on training data
sz = size(data);
E = NaN(sz(4), sz(1), sz(3), sz(3)); %epsilon of all channels

for t = 1:sz(4)
    for c = 1:sz(1)
        
        X = squeeze(data(c, trialIndex, :, t));
        
        [sigma, ~] = covCor(X);
        E(t, c, :, :) = sigma;
    end
    
end
EE = squeeze(mean(mean(E, 1), 2)); %average by conditions and time points
clear E
IE = EE^(-0.5); %invert E


% apply channel Epsilon on all data
data_whitened = NaN(sz); %pre-allocate matrix
for t = 1:sz(4)
    for c = 1:sz(1)
        for l = 1:sz(2)
            
            X = squeeze(data(c, l, :, t))';
            W = X * IE; %whiten
            data_whitened(c, l, :, t) = W;
            
        end
    end
end
end