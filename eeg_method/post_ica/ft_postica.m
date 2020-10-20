clear
eeglab;
%% set up file and folders
% establish working directory 
inputdir = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\';
wkdir = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\ft_epochs\';
input_ending = 'M+Correct.set'
date = 'july08';
mkdir([wkdir date])

% establish parameters
epoch_baseline = -500.0 %epoch baseline
epoch_end = 1500.0 %epoch offset

% establish subject list
[d,s,r]=xlsread('subject_list.xlsx');
subject_list = r;
numsubjects = (1:length(s));

% condition specific information
binlist_file = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\Matlab_Scripts\MP3_binlist.txt'
output_ending = '_MP3.set'

% load channel information
load goodchanstuff;
%% Run Loop
for s=1:length(numsubjects)
    
    subject = subject_list{s};
    input_filename = [input_ending]
    output_filename = [subject output_ending]
%%%% Cond 1
fprintf('\n\n\n*** Processing subject %d(%s) ***\n\n\n', s, subject);
EEG = pop_loadset('filename',input_filename,'filepath',[inputdir subject '/']);
EEG = epoch2continuous(EEG);
%EEG = eeg_checkset( EEG );
eeglab redraw

EEG = eeg_checkset( EEG );
EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' });
EEG = pop_binlister( EEG , 'BDF',binlist_file,'IndexEL', 1, 'SendEL2', 'EEG', 'Voutput', 'EEG');
EEG = pop_epochbin( EEG , [epoch_baseline epoch_end],  'pre');
EEG = eeg_checkset( EEG );
eeglab redraw
tmp = reshape(EEG.data, [size(EEG.data, 1) size(EEG.data, 2) * size(EEG.data, 3) ]);
[Z,mu,sigma] = zscore(tmp, 0, 2);
tmp = reshape(Z, size(EEG.data));
EEG.data = tmp;
clearvars tmp
% when we're ready to do AR
EEG  = pop_artstep( EEG , 'Channel',  [1:EEG.nbchan], 'Flag', [ 1 2], 'Threshold',  12, 'Twindow', [epoch_baseline epoch_end], 'Windowsize',  100, 'Windowstep',...
  50 );
EEG  = pop_artmwppth( EEG , 'Channel',  [1:EEG.nbchan], 'Flag', [ 1 3], 'Threshold',  12, 'Twindow', [epoch_baseline epoch_end], 'Windowsize',  100, 'Windowstep',...
  50 );

% EEG.chanlocs = goodchanlocs;
% EEG.icachansind = goodicachansind;
T = EEG.reject.rejmanual;
Rej = sum(T(:) == 1);
Tot = length(T);
ARsum = (Rej/Tot);
ARsum_total.(['sub_' subject])(1) = ARsum;
ARsum_total.(['sub_' subject])(2) = Rej;
ARsum_total.(['sub_' subject])(3) = Tot;
Sent1flags.(['sub_' subject]) = T;

clearvars T Rej Tot ARsum;
tmp = reshape(EEG.data, [size(EEG.data, 1) size(EEG.data, 2) * size(EEG.data, 3) ]);
multy = (tmp.*sigma)+mu;
tmp = reshape(multy, size(EEG.data));
EEG.data = tmp;

EEG = pop_saveset( EEG, 'filename',output_filename,'filepath',[wkdir date]);
eeglab redraw

clearvars Z mu sigma tmp multy

end