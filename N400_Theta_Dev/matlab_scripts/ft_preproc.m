%% Notes:
% Written by Jacob Momsen and Julie Schneider
% Dependencies: EEGlab, Fieldtrip, ERPLab, and the Statistics and Machine Learning Toolbox 
%% Initialize EEGlab %%
addpath '/Users/julie/Documents/MATLAB/eeglab2021.0'
eeglab;

%% startup FT
% restoredefaultpath
% addpath /Users/julie/Documents/MATLAB/eeglab2021.0/plugins/fieldtrip
% ft_defaults

%% set up file and folders
% establish working directory 
erspfolder =  '/Users/julie/Box/N400 and Theta_WLNSF/FT_FS_ERSPS/';
bdffolder = '/Users/julie/Box/N400 and Theta_WLNSF/matlab_scripts/';
parentfolder = '/Users/julie/Box/N400 and Theta_WLNSF/averef files/';
ARfolder = '/Users/julie/Box/N400 and Theta_WLNSF/FT_FS_ERSPS/Trialsums/';
erpfolder = '/Users/julie/Box/N400 and Theta_WLNSF/erp_files/';

% establish parameters
date = 'March11';
highpass=0.1; %set high pass filter
lowpass=50; %set low pass filter
load goodchanstuff.mat;

% establish subject list
[d,s,r]=xlsread('wlnsf_subjects.xlsx');
subject_list = r;
numsubjects = (length(s));

%% FT Preprocessing 
for s=1:numsubjects 
    subject = subject_list{s};

    fprintf('\n\n\n*** Processing subject %d(%s) ***\n\n\n', s, subject);
    EEG = pop_loadset('filename', [subject '_interp.set'],'filepath',[parentfolder subject filesep]);

    eeglab redraw

    EEG = eeg_checkset( EEG );
    EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' });
    EEG = pop_binlister( EEG , 'BDF', [bdffolder 'oc_binlist.txt'],'IndexEL', 1, 'SendEL2', 'EEG', 'Voutput', 'EEG');
    EEG = pop_epochbin( EEG , [-500 1000.0],  'pre');
    EEG = eeg_checkset( EEG );
eeglab redraw

% when we're ready to do AR
EEG  = pop_artstep( EEG , 'Channel',  1:62, 'Flag', [ 1 2], 'Threshold',  100, 'Twindow', [ -500 1000.0], 'Windowsize',  100, 'Windowstep',...
  50 );
EEG  = pop_artmwppth( EEG , 'Channel',  1:62, 'Flag', [ 1 3], 'Threshold',  100, 'Twindow', [ -500 1000.0], 'Windowsize',  100, 'Windowstep',...
  50 );
EEG = pop_rejepoch(EEG, EEG.reject.rejmanual,0);

EEG = pop_saveset( EEG, 'filename',[subject '_OC.set'],'filepath',erspfolder);
eeglab redraw
end

%% ERP Analysis

for s=1:numsubjects 
    subject = subject_list{s};

    EEG = pop_loadset('filename', [subject '_OC.set'],'filepath',erspfolder);
    ERP = pop_averager(EEG, 'Criterion', 'good', 'SEM', 'on');
    pop_savemyerp(ERP, 'erpname', subject, 'filename', [subject '.erp'], 'filepath', erpfolder);
end

