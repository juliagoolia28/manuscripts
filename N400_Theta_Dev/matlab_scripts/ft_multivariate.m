clear
eeglab;
close all;

%% startup FT
restoredefaultpath
addpath /Users/julie/Documents/MATLAB/eeglab2021.0/plugins/fieldtrip
ft_defaults

%% set up file and folders
% establish working directory 
erspfolder =  '/Users/julie/Box/N400 and Theta_WLNSF/FT_FS_ERSPS/';
%bdffolder = '/Users/julie/Box/ConCom_Julie/matlab_scripts/binlists/';
%parentfolder = '/Users/julie/Box/ConCom_Julie/';
%ARfolder = '/Users/julie/Box/ConCom_Julie/FT_FS_ERSPS/Trialsums/';

% establish subject list
[d,s,r]=xlsread('wlnsf_subjects.xlsx');
subject_list = r;
numsubjects = (1:length(s));

% [i,j,k]=xlsread('cond_list.xlsx');
% cond_list = k;
% numconds = (1:length(j));

% load channel information
% load goodchanstuff_HL.mat;

%% Perform condition .set to FT transfers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s=1:length(numsubjects)
    subject = subject_list{s};
      fprintf('\n\n\n*** Loading OC condition EEGLAB data from subject (%s) ***\n\n\n', s , subject);
    EEG = pop_loadset('filename', [subject '_OC.set'],'filepath',erspfolder);
eeglab redraw
%convert set to data 
FTcurrentdata = eeglab2fieldtrip (EEG, 'preprocessing','none');
FTcurrentdata_OC.(['sub_' subject]) = FTcurrentdata;
clearvars FTcurrentdata
end

%% set up freqanalysis cfg %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 3:0.5:50;                         % analysis 3 to 30 Hz in steps of 0.5 Hz
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.4;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.025:1;                  % time window "slides" from -0.5 to 1 sec in steps of 25 msec/.025
%TFRhann = ft_freqanalysis(cfg, dataFIC);

%% run freqanalysis for conditions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure you have fieldtrip installed and added to the path.
for s=1:length(numsubjects)
    subject = subject_list{s};
        fprintf('\n\n\n*** Running condition 1 frequency analysis for (%s) ***\n\n\n', s , subject);
   %Run frequency analysis
        freq_currentsubject = ft_freqanalysis(cfg, FTcurrentdata_OC.(['sub_' subject]));
        freq_OC.(['sub_' subject]) = freq_currentsubject;
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
goodelectrodeconfig = freq_OC.(['sub_' subject_list{1}]).elec

GA_OC = ft_freqgrandaverage(cfg,  freq_OC.(['sub_' subject_list{1}]),	freq_OC.(['sub_' subject_list{2}]),	freq_OC.(['sub_' subject_list{3}]),	freq_OC.(['sub_' subject_list{4}]),	freq_OC.(['sub_' subject_list{5}]),	freq_OC.(['sub_' subject_list{6}]),	freq_OC.(['sub_' subject_list{7}]),	freq_OC.(['sub_' subject_list{8}]),	freq_OC.(['sub_' subject_list{9}]),	freq_OC.(['sub_' subject_list{10}]),	freq_OC.(['sub_' subject_list{11}]),	freq_OC.(['sub_' subject_list{12}]),	freq_OC.(['sub_' subject_list{13}]),	freq_OC.(['sub_' subject_list{14}]),	freq_OC.(['sub_' subject_list{15}]),	freq_OC.(['sub_' subject_list{16}]),	freq_OC.(['sub_' subject_list{17}]),	freq_OC.(['sub_' subject_list{18}]),	freq_OC.(['sub_' subject_list{19}]),	freq_OC.(['sub_' subject_list{20}]),	freq_OC.(['sub_' subject_list{21}]),	freq_OC.(['sub_' subject_list{22}]),	freq_OC.(['sub_' subject_list{23}]),	freq_OC.(['sub_' subject_list{24}]),	freq_OC.(['sub_' subject_list{25}]),	freq_OC.(['sub_' subject_list{26}]),	freq_OC.(['sub_' subject_list{27}]),	freq_OC.(['sub_' subject_list{28}]),	freq_OC.(['sub_' subject_list{29}]),	freq_OC.(['sub_' subject_list{30}]),	freq_OC.(['sub_' subject_list{31}]),	freq_OC.(['sub_' subject_list{32}]),	freq_OC.(['sub_' subject_list{33}]),	freq_OC.(['sub_' subject_list{34}]),	freq_OC.(['sub_' subject_list{35}]),	freq_OC.(['sub_' subject_list{36}]),	freq_OC.(['sub_' subject_list{37}]),	freq_OC.(['sub_' subject_list{38}]),	freq_OC.(['sub_' subject_list{39}]),	freq_OC.(['sub_' subject_list{40}]),	freq_OC.(['sub_' subject_list{41}]),	freq_OC.(['sub_' subject_list{42}]),	freq_OC.(['sub_' subject_list{43}]),	freq_OC.(['sub_' subject_list{44}]),	freq_OC.(['sub_' subject_list{45}]),	freq_OC.(['sub_' subject_list{46}]),	freq_OC.(['sub_' subject_list{47}]),	freq_OC.(['sub_' subject_list{48}]),	freq_OC.(['sub_' subject_list{49}]),	freq_OC.(['sub_' subject_list{50}]),	freq_OC.(['sub_' subject_list{51}]),	freq_OC.(['sub_' subject_list{52}]),	freq_OC.(['sub_' subject_list{53}]),	freq_OC.(['sub_' subject_list{54}]),	freq_OC.(['sub_' subject_list{55}]),	freq_OC.(['sub_' subject_list{56}]),	freq_OC.(['sub_' subject_list{57}]),	freq_OC.(['sub_' subject_list{58}]),	freq_OC.(['sub_' subject_list{59}]),	freq_OC.(['sub_' subject_list{60}]),	freq_OC.(['sub_' subject_list{61}]),	freq_OC.(['sub_' subject_list{62}]),	freq_OC.(['sub_' subject_list{63}]),	freq_OC.(['sub_' subject_list{64}]),	freq_OC.(['sub_' subject_list{65}]),	freq_OC.(['sub_' subject_list{66}]),	freq_OC.(['sub_' subject_list{67}]),	freq_OC.(['sub_' subject_list{68}]),	freq_OC.(['sub_' subject_list{69}]),	freq_OC.(['sub_' subject_list{70}]),	freq_OC.(['sub_' subject_list{71}]),	freq_OC.(['sub_' subject_list{72}]),	freq_OC.(['sub_' subject_list{73}]),	freq_OC.(['sub_' subject_list{74}]),	freq_OC.(['sub_' subject_list{75}]),	freq_OC.(['sub_' subject_list{76}]),	freq_OC.(['sub_' subject_list{77}]),	freq_OC.(['sub_' subject_list{78}]),	freq_OC.(['sub_' subject_list{79}]),	freq_OC.(['sub_' subject_list{80}]),	freq_OC.(['sub_' subject_list{81}]),	freq_OC.(['sub_' subject_list{82}]),	freq_OC.(['sub_' subject_list{83}]),	freq_OC.(['sub_' subject_list{84}]),	freq_OC.(['sub_' subject_list{85}]),	freq_OC.(['sub_' subject_list{86}]),	freq_OC.(['sub_' subject_list{87}]),	freq_OC.(['sub_' subject_list{88}]),	freq_OC.(['sub_' subject_list{89}]),	freq_OC.(['sub_' subject_list{90}]),	freq_OC.(['sub_' subject_list{91}]),	freq_OC.(['sub_' subject_list{92}]),	freq_OC.(['sub_' subject_list{93}]),	freq_OC.(['sub_' subject_list{94}]),	freq_OC.(['sub_' subject_list{95}]),	freq_OC.(['sub_' subject_list{96}]),	freq_OC.(['sub_' subject_list{97}]),	freq_OC.(['sub_' subject_list{98}]),	freq_OC.(['sub_' subject_list{99}]),	freq_OC.(['sub_' subject_list{100}]),	freq_OC.(['sub_' subject_list{101}]),	freq_OC.(['sub_' subject_list{102}]),	freq_OC.(['sub_' subject_list{103}]),	freq_OC.(['sub_' subject_list{104}]),	freq_OC.(['sub_' subject_list{105}]),	freq_OC.(['sub_' subject_list{106}]),	freq_OC.(['sub_' subject_list{107}]),	freq_OC.(['sub_' subject_list{108}]),	freq_OC.(['sub_' subject_list{109}]),	freq_OC.(['sub_' subject_list{110}]),	freq_OC.(['sub_' subject_list{111}]),	freq_OC.(['sub_' subject_list{112}]),	freq_OC.(['sub_' subject_list{113}]),	freq_OC.(['sub_' subject_list{114}]),	freq_OC.(['sub_' subject_list{115}]),	freq_OC.(['sub_' subject_list{116}]),	freq_OC.(['sub_' subject_list{117}]),	freq_OC.(['sub_' subject_list{118}]),	freq_OC.(['sub_' subject_list{119}]),	freq_OC.(['sub_' subject_list{120}]),	freq_OC.(['sub_' subject_list{121}]),	freq_OC.(['sub_' subject_list{122}]),	freq_OC.(['sub_' subject_list{123}]),	freq_OC.(['sub_' subject_list{124}]),	freq_OC.(['sub_' subject_list{125}]),	freq_OC.(['sub_' subject_list{126}]),	freq_OC.(['sub_' subject_list{127}]),	freq_OC.(['sub_' subject_list{128}]),	freq_OC.(['sub_' subject_list{129}]),	freq_OC.(['sub_' subject_list{130}]),	freq_OC.(['sub_' subject_list{131}]),	freq_OC.(['sub_' subject_list{132}]),	freq_OC.(['sub_' subject_list{133}]),	freq_OC.(['sub_' subject_list{134}]),	freq_OC.(['sub_' subject_list{135}]),	freq_OC.(['sub_' subject_list{136}]),	freq_OC.(['sub_' subject_list{137}]),	freq_OC.(['sub_' subject_list{138}]),	freq_OC.(['sub_' subject_list{139}]),	freq_OC.(['sub_' subject_list{140}]),	freq_OC.(['sub_' subject_list{141}]),	freq_OC.(['sub_' subject_list{142}]),	freq_OC.(['sub_' subject_list{143}]),	freq_OC.(['sub_' subject_list{144}]),	freq_OC.(['sub_' subject_list{145}]),	freq_OC.(['sub_' subject_list{146}]),	freq_OC.(['sub_' subject_list{147}]),	freq_OC.(['sub_' subject_list{148}]),	freq_OC.(['sub_' subject_list{149}]),	freq_OC.(['sub_' subject_list{150}]),	freq_OC.(['sub_' subject_list{151}]),	freq_OC.(['sub_' subject_list{152}]),	freq_OC.(['sub_' subject_list{153}]),	freq_OC.(['sub_' subject_list{154}]),	freq_OC.(['sub_' subject_list{155}]),	freq_OC.(['sub_' subject_list{156}]),	freq_OC.(['sub_' subject_list{157}]),	freq_OC.(['sub_' subject_list{158}]),	freq_OC.(['sub_' subject_list{159}]),	freq_OC.(['sub_' subject_list{160}]),	freq_OC.(['sub_' subject_list{161}]),	freq_OC.(['sub_' subject_list{162}]),	freq_OC.(['sub_' subject_list{163}]),	freq_OC.(['sub_' subject_list{164}]),	freq_OC.(['sub_' subject_list{165}]),	freq_OC.(['sub_' subject_list{166}]),	freq_OC.(['sub_' subject_list{167}]),	freq_OC.(['sub_' subject_list{168}]),	freq_OC.(['sub_' subject_list{169}]),	freq_OC.(['sub_' subject_list{170}]),	freq_OC.(['sub_' subject_list{171}]),	freq_OC.(['sub_' subject_list{172}]),	freq_OC.(['sub_' subject_list{173}]),	freq_OC.(['sub_' subject_list{174}]),	freq_OC.(['sub_' subject_list{175}]),	freq_OC.(['sub_' subject_list{176}]),	freq_OC.(['sub_' subject_list{177}]),	freq_OC.(['sub_' subject_list{178}]),	freq_OC.(['sub_' subject_list{179}]),	freq_OC.(['sub_' subject_list{180}]),	freq_OC.(['sub_' subject_list{181}]),	freq_OC.(['sub_' subject_list{182}]),	freq_OC.(['sub_' subject_list{183}]),	freq_OC.(['sub_' subject_list{184}]),	freq_OC.(['sub_' subject_list{185}]),	freq_OC.(['sub_' subject_list{186}]),	freq_OC.(['sub_' subject_list{187}]),	freq_OC.(['sub_' subject_list{188}]),	freq_OC.(['sub_' subject_list{189}]),	freq_OC.(['sub_' subject_list{190}]),	freq_OC.(['sub_' subject_list{191}]),	freq_OC.(['sub_' subject_list{192}]),	freq_OC.(['sub_' subject_list{193}]),	freq_OC.(['sub_' subject_list{194}]),	freq_OC.(['sub_' subject_list{195}]),	freq_OC.(['sub_' subject_list{196}]),	freq_OC.(['sub_' subject_list{197}]),	freq_OC.(['sub_' subject_list{198}]),	freq_OC.(['sub_' subject_list{199}]),	freq_OC.(['sub_' subject_list{200}]),	freq_OC.(['sub_' subject_list{201}]),	freq_OC.(['sub_' subject_list{202}]),	freq_OC.(['sub_' subject_list{203}]),	freq_OC.(['sub_' subject_list{204}]),	freq_OC.(['sub_' subject_list{205}]),	freq_OC.(['sub_' subject_list{206}]),	freq_OC.(['sub_' subject_list{207}]),	freq_OC.(['sub_' subject_list{208}]),	freq_OC.(['sub_' subject_list{209}]),	freq_OC.(['sub_' subject_list{210}]),	freq_OC.(['sub_' subject_list{211}]),	freq_OC.(['sub_' subject_list{212}]),	freq_OC.(['sub_' subject_list{213}]),	freq_OC.(['sub_' subject_list{214}]),	freq_OC.(['sub_' subject_list{215}]),	freq_OC.(['sub_' subject_list{216}]),	freq_OC.(['sub_' subject_list{217}]),	freq_OC.(['sub_' subject_list{218}]),	freq_OC.(['sub_' subject_list{219}]),	freq_OC.(['sub_' subject_list{220}]),	freq_OC.(['sub_' subject_list{221}]),	freq_OC.(['sub_' subject_list{222}]),	freq_OC.(['sub_' subject_list{223}]),	freq_OC.(['sub_' subject_list{224}]),	freq_OC.(['sub_' subject_list{225}]),	freq_OC.(['sub_' subject_list{226}]))
GA_OC.elec = goodelectrodeconfig;
