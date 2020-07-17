clear
eeglab;
close all;
%% set up file and folders
% establish directories
workdir = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\ft_epochs\july08_interp\';
destinationfolder = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\ft_WLNSF_MP\';

% establish subject list
[d,s,r]=xlsread('subject_list.xlsx');
subject_list = r;
numsubjects = (1:length(s));

[i,j,k]=xlsread('cond_list.xlsx');
cond_list = k;
numconds = (1:length(j));

% load channel information
load goodchanstuff;

%% Perform condition .set to FT transfers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s=1:length(numsubjects)
    subject = subject_list{s};
      fprintf('\n\n\n*** Loading condition 2 EEGLAB data from subject (%s) ***\n\n\n', s , subject);
    EEG = pop_loadset('filename', [subject '_MP2.set'],'filepath',workdir);
eeglab redraw
%convert set to data 
FTcurrentdata = eeglab2fieldtrip (EEG, 'preprocessing','none');
FTcurrentdata_cond2.(['sub_' subject]) = FTcurrentdata;
clearvars FTcurrentdata
end

%% set up freqanalysis cfg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 3:0.5:30;                         % analysis 3 to 30 Hz in steps of 0.5 Hz
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.4;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.032:1;                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.01 sec (50 ms); (32 ms) should be 0.032
%TFRhann = ft_freqanalysis(cfg, dataFIC);

%% run freqanalysis for conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s=1:length(numsubjects)
    subject = subject_list{s};
        fprintf('\n\n\n*** Running condition 3 frequency analysis for (%s) ***\n\n\n', s , subject);
   %Run frequency analysis
        freq_currentsubject = ft_freqanalysis(cfg, FTcurrentdata_cond3.(['sub_' subject]));
        freqcond3.(['sub_' subject]) = freq_currentsubject;
end
clearvars freq_currentsubject

%% Average freq structures
cfg = [];
cfg.keepindividual = 'yes';
cfg.foilim = 'all';
cfg.toilim = 'all';
cfg.channel = 'all';
cfg.paramter = 'powspctrm';

%% %Make a good electrode configuration (subject.elec) to slap onto your grand average
%stuctures by taking one from any random previous subject. The grand
%average step drops the elecrode information for some reason
goodelectrodeconfig = freqcond1.(['sub_' subject_list{1}]).elec

GA_MP1 = ft_freqgrandaverage(cfg,  freqcond1.(['sub_' subject_list{1}]),	freqcond1.(['sub_' subject_list{2}]),	freqcond1.(['sub_' subject_list{3}]),	freqcond1.(['sub_' subject_list{4}]),	freqcond1.(['sub_' subject_list{5}]),	freqcond1.(['sub_' subject_list{6}]),	freqcond1.(['sub_' subject_list{7}]),	freqcond1.(['sub_' subject_list{8}]),	freqcond1.(['sub_' subject_list{9}]),	freqcond1.(['sub_' subject_list{10}]),	freqcond1.(['sub_' subject_list{11}]),	freqcond1.(['sub_' subject_list{12}]),	freqcond1.(['sub_' subject_list{13}]),	freqcond1.(['sub_' subject_list{14}]),	freqcond1.(['sub_' subject_list{15}]),	freqcond1.(['sub_' subject_list{16}]),	freqcond1.(['sub_' subject_list{17}]),	freqcond1.(['sub_' subject_list{18}]),	freqcond1.(['sub_' subject_list{19}]),	freqcond1.(['sub_' subject_list{20}]),	freqcond1.(['sub_' subject_list{21}]),	freqcond1.(['sub_' subject_list{22}]),	freqcond1.(['sub_' subject_list{23}]),	freqcond1.(['sub_' subject_list{24}]),	freqcond1.(['sub_' subject_list{25}]),	freqcond1.(['sub_' subject_list{26}]),	freqcond1.(['sub_' subject_list{27}]),	freqcond1.(['sub_' subject_list{28}]),	freqcond1.(['sub_' subject_list{29}]),	freqcond1.(['sub_' subject_list{30}]),	freqcond1.(['sub_' subject_list{31}]),	freqcond1.(['sub_' subject_list{32}]),	freqcond1.(['sub_' subject_list{33}]),	freqcond1.(['sub_' subject_list{34}]),	freqcond1.(['sub_' subject_list{35}]),	freqcond1.(['sub_' subject_list{36}]),	freqcond1.(['sub_' subject_list{37}]),	freqcond1.(['sub_' subject_list{38}]),	freqcond1.(['sub_' subject_list{39}]),	freqcond1.(['sub_' subject_list{40}]),	freqcond1.(['sub_' subject_list{41}]),	freqcond1.(['sub_' subject_list{42}]),	freqcond1.(['sub_' subject_list{43}]),	freqcond1.(['sub_' subject_list{44}]))
GA_MP1.elec = goodelectrodeconfig;

GA_MP2 = ft_freqgrandaverage(cfg,  freqcond2.(['sub_' subject_list{1}]),    freqcond2.(['sub_' subject_list{2}]),   freqcond2.(['sub_' subject_list{3}]),   freqcond2.(['sub_' subject_list{4}]),   freqcond2.(['sub_' subject_list{5}]),   freqcond2.(['sub_' subject_list{6}]),   freqcond2.(['sub_' subject_list{7}]),   freqcond2.(['sub_' subject_list{8}]),   freqcond2.(['sub_' subject_list{9}]),   freqcond2.(['sub_' subject_list{10}]),  freqcond2.(['sub_' subject_list{11}]),  freqcond2.(['sub_' subject_list{12}]),  freqcond2.(['sub_' subject_list{13}]),  freqcond2.(['sub_' subject_list{14}]),  freqcond2.(['sub_' subject_list{15}]),  freqcond2.(['sub_' subject_list{16}]),  freqcond2.(['sub_' subject_list{17}]),  freqcond2.(['sub_' subject_list{18}]),  freqcond2.(['sub_' subject_list{19}]),  freqcond2.(['sub_' subject_list{20}]),  freqcond2.(['sub_' subject_list{21}]),  freqcond2.(['sub_' subject_list{22}]),  freqcond2.(['sub_' subject_list{23}]),  freqcond2.(['sub_' subject_list{24}]),  freqcond2.(['sub_' subject_list{25}]),  freqcond2.(['sub_' subject_list{26}]),  freqcond2.(['sub_' subject_list{27}]),  freqcond2.(['sub_' subject_list{28}]),  freqcond2.(['sub_' subject_list{29}]),  freqcond2.(['sub_' subject_list{30}]),  freqcond2.(['sub_' subject_list{31}]),  freqcond2.(['sub_' subject_list{32}]),  freqcond2.(['sub_' subject_list{33}]),  freqcond2.(['sub_' subject_list{34}]),  freqcond2.(['sub_' subject_list{35}]),  freqcond2.(['sub_' subject_list{36}]),  freqcond2.(['sub_' subject_list{37}]),  freqcond2.(['sub_' subject_list{38}]),  freqcond2.(['sub_' subject_list{39}]),  freqcond2.(['sub_' subject_list{40}]),  freqcond2.(['sub_' subject_list{41}]),  freqcond2.(['sub_' subject_list{42}]),  freqcond2.(['sub_' subject_list{43}]),  freqcond2.(['sub_' subject_list{44}]))
GA_MP2.elec = goodelectrodeconfig;

GA_MP3 = ft_freqgrandaverage(cfg,  freqcond3.(['sub_' subject_list{1}]),    freqcond3.(['sub_' subject_list{2}]),   freqcond3.(['sub_' subject_list{3}]),   freqcond3.(['sub_' subject_list{4}]),   freqcond3.(['sub_' subject_list{5}]),   freqcond3.(['sub_' subject_list{6}]),   freqcond3.(['sub_' subject_list{7}]),   freqcond3.(['sub_' subject_list{8}]),   freqcond3.(['sub_' subject_list{9}]),   freqcond3.(['sub_' subject_list{10}]),  freqcond3.(['sub_' subject_list{11}]),  freqcond3.(['sub_' subject_list{12}]),  freqcond3.(['sub_' subject_list{13}]),  freqcond3.(['sub_' subject_list{14}]),  freqcond3.(['sub_' subject_list{15}]),  freqcond3.(['sub_' subject_list{16}]),  freqcond3.(['sub_' subject_list{17}]),  freqcond3.(['sub_' subject_list{18}]),  freqcond3.(['sub_' subject_list{19}]),  freqcond3.(['sub_' subject_list{20}]),  freqcond3.(['sub_' subject_list{21}]),  freqcond3.(['sub_' subject_list{22}]),  freqcond3.(['sub_' subject_list{23}]),  freqcond3.(['sub_' subject_list{24}]),  freqcond3.(['sub_' subject_list{25}]),  freqcond3.(['sub_' subject_list{26}]),  freqcond3.(['sub_' subject_list{27}]),  freqcond3.(['sub_' subject_list{28}]),  freqcond3.(['sub_' subject_list{29}]),  freqcond3.(['sub_' subject_list{30}]),  freqcond3.(['sub_' subject_list{31}]),  freqcond3.(['sub_' subject_list{32}]),  freqcond3.(['sub_' subject_list{33}]),  freqcond3.(['sub_' subject_list{34}]),  freqcond3.(['sub_' subject_list{35}]),  freqcond3.(['sub_' subject_list{36}]),  freqcond3.(['sub_' subject_list{37}]),  freqcond3.(['sub_' subject_list{38}]),  freqcond3.(['sub_' subject_list{39}]),  freqcond3.(['sub_' subject_list{40}]),  freqcond3.(['sub_' subject_list{41}]),  freqcond3.(['sub_' subject_list{42}]),  freqcond3.(['sub_' subject_list{43}]),  freqcond3.(['sub_' subject_list{44}]))
GA_MP3.elec = goodelectrodeconfig;

%% Make difference value between MP3 and MP1
GA_31diff = GA_MP1;
GA_31diff.powspctrm = GA_MP3.powspctrm - GA_MP1.powspctrm;
%% Permutation test
cfg = [];
cfg.channel          = {'all'};
cfg.latency          = [0 1];
cfg.frequency        = [13 30];
cfg.avgovertime      = 'no' ;                  
cfg.avgoverfreq      = 'no';
cfg.method           = 'montecarlo';

%cfg.statistic        = 'ft_statfun_depsamplesFmultivariate'; %depsamplesT%'ft_statfun_actvsblT; 'ft_statfun_depsamplesfmultivariate' 'ft_statfun_depsamplesT'
cfg.computestat    = 'yes' 
    cfg.computecritval = 'yes'
    cfg.computeprob    = 'yes'
    cfg.correctm         = 'cluster';

    %t-test
cfg.statistic = 'ft_statfun_depsamplesT';
cfg.clusteralpha     = 0.05;  %either 0.05 or 0.025, 0.025 better for messier data
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 1;
cfg.clustertail      = 1;
cfg.alpha            = 0.05;
cfg.numrandomization = 1000;
% specifies with which sensors other sensors can form clusters
cfg_neighb.method    = 'triangulation';
%GA_1plus here should just be the name of one of your grand average
%structures
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, GA_31diff);

%You can also set up neighbors with a template from the interwebs
% cfg_neighb.method    = 'template';
% cfg.neighbours       = chan62_neighborfile

%% between groups t-test design 
subj = size(numsubjects,2);
design = zeros(2, subj);
for i = 1:subj
design(1,i) = i;
end
subj = subj/2;
design(2,1:subj)        = 1;
design(2,subj+1:end)    = 2;
cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 2; %number of IVs

%% between groups t-test permutation test
stats_31diff_beta = ft_freqstatistics(cfg, GA_31diff)

%% multivariate design
subj = size(numsubjects,2);
group = subj/2;
design = zeros(2,subj*3);
for i = 1:subj
design(1,i) = i;
end
for i = 1:subj
design(1,i+subj:2*subj) = i;
end
for i = 1:subj
design(1,i+2*subj:3*subj) = i;
end
design(2,1:subj)=1;
design(2,subj+1:2*subj)=2;
design(2,1+2*subj:3*subj)=3;
group_design =[ones(1,group), ones(1,group)*2, ones(1,group), ones(1,group)*2, ones(1,group), ones(1,group)*2];
design = [design;group_design];
cfg.design   = design;
cfg.ivar     = 2;
cfg.uvar     = 3;

%% stats test
stats_Ls_multi_test = ft_freqstatistics(cfg, GA_31diff)

%% extract positive clusters
data = stats_31diff_beta;
channels = data.label(sum(sum(data.posclusterslabelmat==1,3),2)>0);
timepoints = data.time(squeeze(sum(sum(data.posclusterslabelmat==1,2),1))>0);
freqpoints = data.freq(squeeze(sum(sum(data.posclusterslabelmat==1,3),1))>0);

%% Extract amplitude data
freq_idx = find(ismember(GA_31diff.freq, freqpoints))
time_idx = find(ismember(GA_31diff.time, timepoints))
channel_idx = find(ismember(GA_31diff.label, channels))
for sub_num = 1:length(numsubjects)
        ssdata_mean(sub_num,1)=squeeze(mean(squeeze(mean(squeeze(mean(squeeze(GA_31diff.powspctrm(sub_num,channel_idx,freq_idx,time_idx))))))));
end
%% topoplot
 %%%%TOPOPLOT of entrie scalp
load quickcap64
cfg = [];
cfg.xlim = [0.5 0.7]; % time range
cfg.ylim = [6 8]; % insert freq range
cfg.zlim = [-0.5 0.5];
cfg.baseline = [-0.5 0];
cfg.baselinetype = 'absolute';
cfg.layout = lay;
%figure; ft_topoplotTFR(cfg, GANLs2); colorbar
%figure; ft_topoplotTFR(cfg, GANLs1); colorbar
figure; ft_topoplotTFR(cfg, GA_31diff); colorbar

%% 
cfg = [];
cfg.baseline = [-0.5 0];
cfg.baselinetype = 'absolute'; %absolute or relative
cfg.parameter = 'powspctrm';
cfg.zlim = [-0.5 0.5];
cfg.xlim = [0 1];
cfg.ylim = [3 10];
cfg.channel = ['Cz','C2']; %pick any channel or avgof channels
cfg.masknans = 'yes';
figure; ft_singleplotTFR(cfg, GA_31diff);colorbar



