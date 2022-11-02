%% Plot single participant's RSA time generalization analysis result
% This script plots the results of relating category
% representations of infants and adults in time using RSA
% in the study "Visual category representation in the infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;

%% Download dataset (if necessary) and add VCR_infant to the MATLAB path
setup(11);

%% Load result

% User input for result type
datasetstr = 'rsatimetime';
load(['resultdata_',datasetstr,'.mat']);

%% Plot result

f=figure(1);

for parn=1:20

    subplot(4,5,parn)
    
    resdata_ = squeeze(nanmean(resdata(parn,:,:),1));
    
    [H_image]=imagesc(timepoints, timepoints, resdata_);
    
    % Cosmetic of plots 
    axis xy;
    axis equal;
    axis tight;
    set(gca,'Fontname', 'Arial',...
        'Fontweight','Normal',...
        'Fontsize', 6,...
        'Linewidth',1,...
        'Tickdir','in', 'Xcolor', 'Black', 'Ycolor', 'Black');
    set(gca,'XTick',timepoints(1):200:timepoints(end), ...
        'XTickLabel', addcommaarr(timepoints(1):200:timepoints(end)));
    xtickangle(45);
    xlim([-100,1000]); % We only see the epoch [-100, 1,000]ms
    set(gca,'YTick',timepoints(1):200:timepoints(end), ...
        'YTickLabel', addcommaarr(timepoints(1):200:timepoints(end)));
    ylim([-100,1000]); % We only see the epoch [-100, 1,000]ms
    
   % color map
    colormap(plotcolors);
    caxis([0,1]);
    
    line([0,1000], [0,0],'Color',[0.6,0.6,0.6], 'Linewidth', 1, 'linestyle', '-');
    line([0,0], [0,1000],'Color',[0.6,0.6,0.6], 'Linewidth', 1, 'linestyle', '-');
    

    if ismember(parn,16:20)
        xlabel('Time(ms)','Fontsize', 8, 'Fontname', 'Arial')
    else
        set(gca,'XTickLabel',[]);
    end
    
    if mod(parn,5)==1
        ylabel('Time(ms)','Fontsize', 8, 'Fontname', 'Arial');
    else
        set(gca,'YTickLabel',[]);
    end
    
    title(sprintf('Participant %02d', parn),'Fontsize', 8);
end

% Set color bar 
cbpos = [0.92 0.4 0.015 0.2];
CBar_Handle = colorbar('position',cbpos);
set(CBar_Handle,'FontSize', 8,'Linewidth', 0.5, 'FontName', 'Arial','Color', 'black');
set(get(CBar_Handle, 'YLabel'),  'String', "Spearman's R", ...
    'FontSize', 8, 'FontName', 'Arial','Color', 'Black');

% Set figure position and size
width=650;
height=680;
set(gcf,'Position',[1,1,width,height],...
    'Color', 'White','Renderer','Painters');
movegui(f, 'center');