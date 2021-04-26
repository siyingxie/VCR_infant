function [dbPowerCell, convo] = timefrexdecomp(dataCell)
% Time-frequency decomposition


convo = struct();
% data information
convo.condnums       = size(dataCell,1);
convo.num_channels   = size(dataCell{1,1}, 2);
convo.num_tps        = size(dataCell{1,1}, 3);
convo.num_trls       = zeros(convo.condnums,1);
% convolution parameters
convo.times                 = -500:2:1498;
convo.epoch_idx             = dsearchn(convo.times',[-500, 1498]');
convo.srate                 = 500;
convo.frex_min              = 2;
convo.frex_max              = 30;
convo.frex_num              = 30;
convo.frex_baseidx          = dsearchn(convo.times',[-300, -100]');
convo.mor_cyclenum          = 5;
convo.halfwavelet           = 1.3;
convo.mor_time              = -(convo.halfwavelet):1/convo.srate:(convo.halfwavelet);
% logspaced range for peak frequencies
convo.mor_frex              = logspace(log10(convo.frex_min),...
    log10(convo.frex_max),convo.frex_num);
% width of Gaussian
convo.gausian_width         = convo.mor_cyclenum ./(2*pi*convo.mor_frex);
convo.num_wavelet           = length(convo.mor_time);
convo.num_half_of_wavelet   = (convo.num_wavelet-1)/2;

% pre-allocate data cell
dbPowerCell = cell(convo.condnums,convo.frex_num);

for cond_index = 1:convo.condnums %loop through conditions
        
    %double-check whether there are NaN trials
    num_trls                    = size(dataCell{cond_index,1}, 1);
    dataCell{cond_index,1}(isnan(num_trls), :, :) =[]; 
    
    convo.num_trls(cond_index,1)= size(dataCell{cond_index,1},1);
    convo.num_eegchandata       = convo.num_trls(cond_index)*convo.num_tps;
    convo.num_convolution       = convo.num_wavelet+convo.num_eegchandata-1;
    
    %use the nextpow2 function to increase the performance of fft when the 
    %length of a signal is not a power of 2
    convo.num_conv_pow2         = pow2(nextpow2(convo.num_convolution));
    
    for chan_index = 1:convo.num_channels %loop through channels
        
        %EEG channel data- long trial
        trls_tps=squeeze(dataCell{cond_index,1}(:,chan_index,:));
        tps_trls = permute(trls_tps, [2 1]);
        eegchandata = reshape(tps_trls, [1,convo.num_eegchandata]) ;
        
        %fft on EEG channel data- long trial
        fft_eegchan  = fft(eegchandata, convo.num_conv_pow2);
        
        for frex_index= 1:convo.frex_num %loop through frequencies
            
            %sine wave = exp(li*2*pi*f*t)
            sinewave = exp(1i*2*pi*convo.mor_frex(frex_index).*convo.mor_time); 
            %gausian width, or standard deviation of Gausian
            s = convo.gausian_width(frex_index); 
            %gausian window = exp(-(t^2)/(2*s^2));
            gauswin = exp(-(convo.mor_time.^2)./(2*s^2)); 
            %complex morlet wavelets
            cmw = sinewave.*gauswin;
            
            % %check wavelet
            % figure; 
            % plot(convo.mor_time,real(sinewave.*gauswin)); 
            
            % fft on wavelets: Kernel
            fft_wavelet = fft(cmw,convo.num_conv_pow2);
            % normalize
            fft_wavelet = fft_wavelet./max(fft_wavelet);
            % convolution
            ifft_eeg = ifft(fft_wavelet.*fft_eegchan, convo.num_conv_pow2);
            
            %cut the extra length
            ifft_eeg = ifft_eeg(1:convo.num_convolution); 
            %cut the wavelet at the first beginning and at the end
            ifft_eeg = ifft_eeg(convo.num_half_of_wavelet+1:end-convo.num_half_of_wavelet); 
            %extract power
            temppower = abs(reshape(ifft_eeg, convo.num_tps,[])).^2; 
            
            %decibel conversion
            epochIndex = convo.epoch_idx(1):convo.epoch_idx(2);
            bslIndex = convo.frex_baseidx(1):convo.frex_baseidx(2);
            %baseline corrected power (expressed in dB) 
            tempdbpower = 10*log10(temppower(epochIndex,:)./mean(temppower(bslIndex,:),1)); 
            
            dbPowerCell{cond_index,frex_index}(:,chan_index,:) = single(permute(tempdbpower,[2 1])); 
            %3D matrix: trial x channel x time
            
            clear temppower;
        end
    end
end
end