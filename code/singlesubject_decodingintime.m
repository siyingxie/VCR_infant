%% Plot single participant's decoding time course
% This script plots the results of time-resolved multivariate analysis
% for all infant participants in the study "Visual category
% representation in the infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;

%% Download dataset (if necessary) and add VCR_infant to the MATLAB path
setup([]);

%% Load result

% User input for result type
datasetstr = 'timecourse';
load(['resultdata_',datasetstr,'.mat']);

% Check data
whos resdata % 40 participants 
whos timepoints % 601 points : from -200ms to 1,000ms in 2ms step
%%

%% Plot result

f=figure(1);

for parn=1:40 % Loop through all participants
    
    subplot(8,5,parn);
    
    resdata_ = squeeze(nanmean(resdata(parn,:),1));
    
    H_plot = plot (timepoints, resdata_, 'LineWidth', 1, 'Color', 'r');
    
    % Cosmetic of plots
    box off;
    H_onset = line([0,0], [-200,100],'Color',[0.5 0.5 0.5], 'Linewidth', 0.5);
    set(get(get(H_onset,'Annotation'),'Legendinformation'),'Icondisplaystyle', 'off');
    
    H_chance = line([-200,1000], [50,50],'Color',[0.5 0.5 0.5], 'Linewidth', 0.5);
    set(get(get(H_chance ,'Annotation'),'Legendinformation'),'Icondisplaystyle', 'off');
    
    set(gca,'XTick',timepoints(1):100:timepoints(end), ...
        'XTickLabel', addcommaarr(timepoints(1):100:timepoints(end)));
    set(gca,'YTick',10:20:90, 'YTickLabel', addcommaarr(10:20:90));
    
    set(gca, 'Fontsize', 8, 'Fontname', 'Arial', ...
        'Xcolor', 'Black', 'Ycolor', 'Black', 'LineWidth', 0.5);
    
    xlim([-100, 1000]); xtickangle(45); % We only see the epoch [-100, 1,000]ms
    ylim([10,90]);
    
    if ismember(parn,36:40)
        xlabel('Time(ms)','Fontsize', 10, 'Fontname', 'Arial')
    else
        set(gca,'XTickLabel',[]);
    end
    
    if mod(parn,5)==1
        ylabel(['Decoding',newline,'accuracy(%)'], ...
            'Fontsize', 10, 'Fontname', 'Arial')
    else
        set(gca,'YTickLabel',[]);
    end
    
    title(sprintf('participant %02d', parn), 'FontSize', 10);
end

% Set figure position and size
width=1000;
height=800;
set(gcf,'Position',[1,1,width,height],...
    'Color', 'White','Renderer','Painters');
movegui(f, 'center');
