clear all;
%% run b01 first
%% plot all coherence including H1,H2 before and after rotation
stationlst = textread('./stalist_YS_test2.txt','%s');
outpath='./Figure/allCoh';
if ~exist(outpath)
    mkdir(outpath);
end
% for is = 1:length(stationlst)
for is = 1:length(stationlst)
    datadir = './NOISETC_Orient/SPECTRA';
    datafiles = dir(fullfile(datadir,strcat(sprintf('YS%s',stationlst{is}),'/*.mat')));
    
    clear c1z; clear c2z; clear dayId;
    clear ori_c1z;clear ori_c2z;
    
    for i = 1:length(datafiles)
        
        load(strcat(datafiles(i).folder,'/',datafiles(i).name));
        
        npts_smooth = floor(specprop.params.NFFT/1000)+1;

        
        c1z(i,:) = abs(smooth(abs(specprop.cross.c1z_stack).^2./...
            (specprop.power.c11_stack.*specprop.power.czz_stack),npts_smooth)).^2;
        c2z(i,:) = abs(smooth(abs(specprop.cross.c2z_stack).^2./...
            (specprop.power.c22_stack.*specprop.power.czz_stack),npts_smooth)).^2;
        ori_c1z(i,:) = abs(smooth(abs(specprop.rotation.ori_ch1z).^2./...
            (specprop.rotation.ori_ch1h1.*specprop.rotation.czz),npts_smooth)).^2;
        ori_c2z(i,:) = abs(smooth(abs(specprop.rotation.ori_ch2z).^2./...
            (specprop.rotation.ori_ch2h2.*specprop.rotation.czz),npts_smooth)).^2;
        dayId(i,:) = datetime(specprop.params.dayid(1:8),'InputFormat','yyyyMMdd');
        
        if i == 1
            period = 1./specprop.params.f;
            f = specprop.params.f;
        end
    end
    h = figure(1);
    set(h,'Position',[510 210 1000 1200])
    clf;
    % average coherence in period [8,50] -- primary
    
    df = f(2) - f(1);
    p_range = [8, 50];
    f_range = length(f) - round((1./p_range)/df);
    f_start=f_range(1);
    f_end=f_range(2);
    ori_c1z_pm=ori_c1z(:,f_start:1:f_end);
    ori_c1z_pm_mean=mean(ori_c1z_pm,2);
    %H1 plot
    subplot(2,2,1);

    p_ticks = [2 3 4 5 6 7 8 10 20 100];
    f_index = length(f) - round((1./p_ticks)/df);
    imagesc(c1z(:,end:-1:2),[0 0.6]);
    % set(gca, 'XScale', 'log')
    set(gca,'Xtick',f_index,'Xticklabels',string(p_ticks),'fontsize',14);
    set(gca,'Ytick',[]);
    xlabel('Frequency (Hz)','fontsize',16);
    ylabel('day','fontsize',16);
    xlim([f_index(1) f_index(end)]);
    cbh = colorbar("westoutside");
    cbh.Ticks = [0 0.2 0.4 0.6];
    title('Brfore Rotation H1','fontsize',16);
   

    %H2 plot
    subplot(2,2,2);

    p_ticks = [2 3 4 5 6 7 8 10 20 100];
    f_index = length(f) - round((1./p_ticks)/df);
    imagesc(c2z(:,end:-1:2),[0 0.6]);
    % set(gca, 'XScale', 'log')
    set(gca,'Xtick',f_index,'Xticklabels',string(p_ticks),'fontsize',14);
    set(gca,'Ytick',[]);
    xlabel('Frequency (Hz)','fontsize',16);
    ylabel('day','fontsize',16);
    xlim([f_index(1) f_index(end)]);
    cbh = colorbar("westoutside");
    cbh.Ticks = [0 0.2 0.4 0.6];
    title('Brfore Rotation H2','fontsize',16);

    % hotmap of h1z coherence after rotation
    subplot(2,2,3);

    p_ticks = [2 3 4 5 6 7 8 10 20 100];
    f_index = length(f) - round((1./p_ticks)/df);
    imagesc(ori_c1z(:,end:-1:2),[0 0.6]);
    % set(gca, 'XScale', 'log')
    set(gca,'Xtick',f_index,'Xticklabels',string(p_ticks),'fontsize',14);
    set(gca,'Ytick',[]);
    xlabel('Frequency (Hz)','fontsize',16);
    ylabel('day','fontsize',16);
    xlim([f_index(1) f_index(end)]);
    cbh = colorbar("westoutside");
    cbh.Ticks = [0 0.2 0.4 0.6];
    title('After Rotation H1','fontsize',16);
   

    %%H2 after rotation
    subplot(2,2,4);

    p_ticks = [2 3 4 5 6 7 8 10 20 100];
    f_index = length(f) - round((1./p_ticks)/df);
    imagesc(ori_c2z(:,end:-1:2),[0 0.6]);
    % set(gca, 'XScale', 'log')
    set(gca,'Xtick',f_index,'Xticklabels',string(p_ticks),'fontsize',14);
    set(gca,'Ytick',[]);
    xlabel('Frequency (Hz)','fontsize',16);
    ylabel('day','fontsize',16);
    xlim([f_index(1) f_index(end)]);
    cbh = colorbar("westoutside");
    cbh.Ticks = [0 0.2 0.4 0.6];
    title('After Rotation H2','fontsize',16);
    sgtitle(strcat(stationlst{is}),'fontsize',20);
    figfile=strcat(outpath,'/',stationlst{is},'.png');
    saveas(h,figfile);
end