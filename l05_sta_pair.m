%%
clc;
clear;
clf;
data_mean= readtable('./Data/sta_pm_oric1z_mean.csv');
data_med= readtable('./Data/sta_pm_oric1z_med.csv');
stations=data_mean.Properties.VariableNames(:,2:1:end);
date=table2array(data_mean(:,1));
%set threshold
gamma=0.1;
%number of station and days
[dayNum,staNum]=size(data_mean);
staNum=staNum-1;
sta_pair_num_mean=zeros(staNum,staNum);
%save all station pairs
staPair1=[];
staPair2=[];
outpath='./goodDays';
if ~exist(outpath)
    mkdir(outpath);
end
pair_num=[];
% mean calculate
for i=2:(staNum+1) %skip the date column
    for j=2:(staNum+1)
        sta1=table2array(data_mean(:,i));
        sta2=table2array(data_mean(:,j));
        % judge whether both st  ation have low coherence on the same day;
        logi=[sta1<gamma,sta2<gamma];
        logi_miss=[ismissing(data_mean(:,i)) ismissing(data_mean(:,j))];
        logi_all=all(logi,2);
        logi_miss=all(logi_miss,2);%whether both day is missed
        %the number of date that have low coherence on both station
        sta_pair_num_mean(i-1,j-1)=sum(logi_all);
        
        if sum(logi_all)>10 && i~=j
            staPair1=[staPair1,i-1];
            staPair2=[staPair2,j-1];
            pair_num=[pair_num sta_pair_num_mean(i-1,j-1)];
            %disp(sprintf('%s-%s',stations{i-1},stations{j-1}));
            %disp(sprintf('%d-%d',i,j));
            %set table for stations and date
            goodDays=table(date,logi_all,logi_miss,day(date,'dayofyear'),year(date),'VariableNames',{'date','is_good','is_miss','dayOfYear','year'});
            datafile=sprintf('goodDays/%s-%s.csv',stations{i-1},stations{j-1});
            writetable(goodDays,datafile,'Delimiter',',','QuoteStrings',true);
        end
       
    end
end

staPair1=stations(staPair1);
staPair2=stations(staPair2);
staPair=table(staPair1',staPair2',pair_num');
writetable(staPair,'goodDays/stationPair.csv','Delimiter',',','QuoteStrings',true);
%%
%mean plot
h = figure(1);
set(h,'Position',[10 10 1500 4000])
imagesc(sta_pair_num_mean);
cbh = colorbar("westoutside");
cbh.Ticks = [0 50 100 300];
set(gca,'Xtick',1:staNum,'Xticklabels',stations(:,1:staNum),'fontsize',14,'XTickLabelRotation',70);
%ax2 = axes();
%set(ax2,'Xtick',1:staNum,'Xticklabels',stations(:,1:staNum),'XAxisLocation','bottom','fontsize',14);
yyaxis left;
set(gca,'Ytick',1:staNum,'Yticklabels',stations(:,1:staNum),'fontsize',14);
yyaxis right;
set(gca,'Ytick',(0:1/staNum:1-(1/staNum))+0.009,'Yticklabels',stations(staNum:-1:1),'fontsize',14);
figtitle=strcat('Number of ideal station pairs $\bar{\gamma}<$',string(gamma));
title(figtitle,'Interpreter','latex');
figfile=strcat('./Figure/sta_pair_mean_',string(gamma),'.png');;
saveas(h,figfile);
%% mean

%% median
% sta_pair_num_med=zeros(staNum,staNum);
% for i=2:(staNum+1) %skip the date column
%     for j=2:(staNum+1)
%         sta1=table2array(data_med(:,i));
%         sta2=table2array(data_med(:,j));
%         % judge whether both st  ation have low coherence on the same day;
%         logi=[sta1<gamma,sta2<gamma];
%         logi=all(logi,2);
%         %the number of date that have low coherence on both station
%         sta_pair_num_med(i-1,j-1)=sum(logi);
%     end
% end
% h = figure(2);
% set(h,'Position',[10 10 1500 2000])
% imagesc(sta_pair_num_med);
% cbh = colorbar("westoutside");
% cbh.Ticks = [0 50 100 300];
% set(gca,'Xtick',1:staNum,'Xticklabels',stations(:,1:staNum),'fontsize',14,'XTickLabelRotation',70);
% 
% 
% %ax2 = axes();
% %set(ax2,'Xtick',1:staNum,'Xticklabels',stations(:,1:staNum),'XAxisLocation','bottom','fontsize',14);
% yyaxis left;
% set(gca,'Ytick',1:staNum,'Yticklabels',stations(:,1:staNum),'fontsize',14);
% yyaxis right;
% set(gca,'Ytick',(0:1/staNum:1-(1/staNum))+0.009,'Yticklabels',stations(staNum:-1:1),'fontsize',14);
% figtitle=strcat('Number of ideal station pairs $\hat{\gamma}<$',string(gamma));
% title(figtitle,'Interpreter','latex');
% figfile=strcat('./Figure/sta_pair_med_',string(gamma),'.png');
% saveas(h,figfile);
%% median

%%  save pairs in txt


%%
