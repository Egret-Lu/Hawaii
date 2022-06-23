clear;
clf;
data_mean= readtable('./Data/sta_pm_oric1z_mean.csv');
data_med= readtable('./Data/sta_pm_oric1z_med.csv');
date_fufillNum=58-sum(ismissing(data_mean),2); % number of station that have data on this date
%mean plot
%plot average pm coherence for each station on eacg day,show in hot map
h = figure(1);
set(h,'Position',[510 210 2000 2000])
clf;
% for i=2:59
%     sta_data=table2array(rmmissing(data(:,i)));
%     subplot(59,1,i);
%     plot(sta_data);
% end
%subplot(9,9,72:81)
%stackedplot(data(:,2:end));
%subplot(1,9,9:9);
h=figure(1);
set(h,'Position',[10 10 2200 2200])
%%plot1
%%The number of station avaliable on each day
subplot(20,1,1:2);
plot(date_fufillNum','LineWidth',1.5,'Color','b');
set(gca,'Xtick',[],'Xticklabels',[]);
%%plot2
%%hotmap for PM coherence on each day for each station
subplot(20,1,3:20);
data_fill=fillmissing(data_mean(:,2:end),'constant',0);% fill NAN with 0
imagesc(table2array(data_fill)')
grid on;
ax = gca; % Get handle to current axes
ax. GridColor = [1, 1, 1];  % set the grid color
ax.GridAlpha = 0.6;  % set the grid lines transparency
ax.LineWidth = 2;
cob = colorbar('eastoutside');
%set xticks
dates=table2array(data_mean(:,1));
[dayNum,staNum]=size(data_mean);
staNum=staNum-1%the first is date
set(gca,'Xtick',1:100:dayNum,'Xticklabels',string(dates(1:100:dayNum)),'fontsize',14);
%set yticks
stations=data_mean.Properties.VariableNames(:,2:1:end);
yyaxis left;
set(gca,'Ytick',1:staNum,'Yticklabels',stations(1:staNum),'fontsize',14);
%%set yticks on right for convience
yyaxis right;
set(gca,'Ytick',(0:1/staNum:1-(1/staNum))+0.009,'Yticklabels',stations(staNum:-1:1),'fontsize',14);
sgtitle('Average PM coherence on each day','fontsize',20);
figfile=strcat('./Figure/sta_pm_mean.png');
saveas(h,figfile);

%%median

h2=figure(2);
set(h2,'Position',[10 10 2200 2200])
%%plot1
%%The number of station avaliable on each day
subplot(20,1,1:2);
plot(date_fufillNum','LineWidth',1.5,'Color','b');
set(gca,'Xtick',[],'Xticklabels',[]);
%%plot2
%%hotmap for PM coherence on each day for each station
subplot(20,1,3:20);
data_fill=fillmissing(data_med(:,2:end),'constant',0);% fill NAN with 0
imagesc(table2array(data_fill)')
grid on;
ax = gca; % Get handle to current axes
ax. GridColor = [1, 1, 1];  % set the grid color
ax.GridAlpha = 0.6;  % set the grid lines transparency
ax.LineWidth = 2;
cob = colorbar('eastoutside');
%set xticks
dates=table2array(data_med(:,1));
[dayNum,staNum]=size(data_med);
staNum=staNum-1%the first is date
set(gca,'Xtick',1:100:dayNum,'Xticklabels',string(dates(1:100:dayNum)),'fontsize',14);
%set yticks
stations=data_med.Properties.VariableNames(:,2:1:end);
set(gca,'Ytick',1:staNum,'Yticklabels',stations(1:staNum),'fontsize',14);
%%set yticks on right for convience
yyaxis right;
set(gca,'Ytick',(0:1/staNum:1-(1/staNum))+0.009,'Yticklabels',stations(staNum:-1:1),'fontsize',14);
sgtitle('Median PM coherence on each day','fontsize',20);
figfile=strcat('./Figure/sta_pm_med.png');
saveas(h2,figfile);
%%median