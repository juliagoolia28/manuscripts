%This script will pull in .set files from EEGLAB, convert them into
%Fieldtrip-friendly data structures, run a TF analysis on them, and then
%run a permutation based statistical analysis. Set files need to
%only contain a single condition from your experiment. This analysis can
%only compare 2 conditions together.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
eeglab

%setup paths to data
rawdir = './raw_data/';
wkdir = './wkdir/';
set_files = './set_files/';

%update parentfolder path and replace with participant info; make 1 script
%for each group  
[d,s,r]=xlsread('subject_list_numeric.xlsx');
subject_list = r;
numsubjects = (1:length(s));

%update destinationfolder path and condition names - need to match the file
%name: '_M+1goods'...

%Establish generic 
cond1 = 'Sem_Cor_Epoch.set';
cond2 = 'Sem_Error_Epoch.set';

%Perform condition 1 .set to FT transfers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s=1:length(numsubjects)
    subject = subject_list{s};
    subjectfolder = [set_files subject filesep];
    fprintf('\n\n\n*** Loading condition 1 EEGLAB data from subject (%s) ***\n\n\n', s , subject);
    EEG = pop_loadset('filename',cond2,'filepath',subjectfolder);
eeglab redraw
%convert set to data 
FTcurrentdata = eeglab2fieldtrip (EEG, 'preprocessing','none');
FTcurrentdata_cond2.(subject) = FTcurrentdata;
end

%second run, may change cfg.foi and cfg.toi

%set up freqanalysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg = [];
cfg.output     = 'pow';
cfg.channel    = 'all';
cfg.method     = 'wavelet';
cfg.trials = 'all';
cfg.keeptrials = 'no';
%cfg.taper      = 'hanning';
cfg.foi        = [3:0.2:30];
cfg.toi        = [-0.5:0.05:1];
%cfg.t_ftimwin  = 7./cfg.foi; %7 cycles

%run freqanalysis for condition 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s=1:length(numsubjects)
    subject = subject_list{s};
    subjectfolder = [workdir subject];
    fprintf('\n\n\n*** Running condition 1  frequency analysis for (%s) ***\n\n\n', s , subject);
   
%Run frequency analysis
freq_currentsubject = ft_freqanalysis(cfg, FTcurrentdata_cond1.(subject));
freq_cond1.(subject) = freq_currentsubject;
end
clearvars freq_currentsubject

%3rd run; modify at condition info (names and number of sub)

%Let's average some freq structures
cfg = [];
cfg.keepindividual = 'yes';
cfg.foilim = 'all';
cfg.toilim = 'all';
cfg.channel = 'all';
cfg.paramter = 'powspctrm';
%cfg.inputfile = freq_condition1;
%For now you have to add all the files manually

%grandaverage the data
for s=1:length(numsubjects)
    subject = subject_list{s};
    subjectfolder = [workdir subject];
    
%Run frequency analysis
GA_JMStest = ft_freqgrandaverage(cfg, freq_cond1.(subject));
GA_JMStest.elec = freq_cond1.(subject).elec;
end


%Run 4 - update latency and frequency if interested
%This is the permutation test

cfg = [];
cfg.channel          = {'all'};
cfg.latency          = [0 .6];
cfg.frequency        = [3 30]; %searches across all frequencies
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 1;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = .05;
cfg.numrandomization = 500;
% specifies with which sensors other sensors can form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, GA_JMStest);
% cfg.avgoverfreq='yes';

subj = s;% number of subjects
design = zeros(2,2*subj);% design differs based on between versus within (similar to ANOVA)

for i = 1:subj
design(1,i) = i;
end
for i = 1:subj
design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 1; %number of IVs

pause 

%whichever 2 way comparison I want to run
[stat_DLD] = ft_freqstatistics(cfg, GA_MP1, GA_MP3)


pause

%clusterplot man 

cfg = [];
cfg.alpha  = 0.8;
cfg.parameter = 'stat';
cfg.zlim   = [-4 4];
cfg.layout = 'quickcap64.mat';
ft_clusterplot(cfg, stat_DLD);
