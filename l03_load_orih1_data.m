clear all;
clc;

%% calculate all H1 coherence AFTER ROTATION into a csv table with day and station name as index
% stationlst = textread('./stalist_YS_test2.txt','%s');
stationlst = textread('./stalist_YS.txt','%s');
outpath='./Data';
if ~exist(outpath)
    mkdir(outpath);
end
% for is = 1:length(stationlst)
for is = 1:length(stationlst)
    disp(stationlst{is})
    datadir = './NOISETC_Orient/SPECTRA';
    datafiles = dir(fullfile(datadir,strcat(sprintf('YS%s',stationlst{is}),'/*.mat')));
    
    clear c1z; clear c2z; clear dayId;
    clear T;
    clear ori_c1z;
    
    for i = 1:length(datafiles)
        
        load(strcat(datafiles(i).folder,'/',datafiles(i).name));
        
        npts_smooth = floor(specprop.params.NFFT/1000)+1;

        
%         c1z(i,:) = abs(smooth(abs(specprop.cross.c1z_stack).^2./...
%             (specprop.power.c11_stack.*specprop.power.czz_stack),npts_smooth)).^2;
%         c2z(i,:) = abs(smooth(abs(specprop.cross.c2z_stack).^2./...
%             (specprop.power.c22_stack.*specprop.power.czz_stack),npts_smooth)).^2;
        ori_c1z(i,:) = abs(smooth(abs(specprop.rotation.ori_ch1z).^2./...
             (specprop.rotation.ori_ch1h1.*specprop.rotation.czz),npts_smooth)).^2;
%         ori_c2z(i,:) = abs(smooth(abs(specprop.rotation.ori_ch2z).^2./...
%             (specprop.rotation.ori_ch2h2.*specprop.rotation.czz),npts_smooth)).^2;
        dayId(i,:) = datetime(specprop.params.dayid(1:8),'InputFormat','yyyyMMdd');
        
        if i == 1
            period = 1./specprop.params.f;
            f = specprop.params.f;
        end
    end
    % average coherence in period [8,50] -- primary
    PM_ind = find(f>1/50 & f<1/10);
    ori_c1z_pm=ori_c1z(:,PM_ind);
    %sum of all coherence in the whole day in PM (PERIOD in [8,50]
    
    ori_c1z_mean=mean(ori_c1z_pm,2);
    ori_c1z_med=median(ori_c1z_pm,2);
    
    %create table with
    T_mean=table(dayId,ori_c1z_mean,'VariableNames',{'dayId',stationlst{is}});
    T_med=table(dayId,ori_c1z_med,'VariableNames',{'dayId',stationlst{is}});
    if (exist('T_all_mean'))
        T_all_mean = outerjoin(T_all_mean,T_mean,"Keys",'dayId','MergeKeys',true);
        T_all_med = outerjoin(T_all_med,T_med,"Keys",'dayId','MergeKeys',true);
    else
        T_all_mean = T_mean;
        T_all_med = T_med;
    end
%     h = figure(1);
%     set(h,'Position',[510 210 1000 1200])
%     clf;
%    
%     figfile=strcat(outpath,'/',stationlst{is},'.png');
%     saveas(h,figfile);

end
writetable(T_all_mean,'Data/sta_pm_oric1z_mean.csv','Delimiter',',','QuoteStrings',true);
writetable(T_all_med,'Data/sta_pm_oric1z_med.csv','Delimiter',',','QuoteStrings',true)

