%% set up file and folders
% establish working directory 
workdir = 'K:\Dept\CallierResearch\Maguire\For RA use\Studies\Theme Category\Studies\JMS_N400_Theta\data\';
txtdir = 'K:\Dept\CallierResearch\Maguire\For RA use\Studies\Theme Category\Studies\JMS_N400_Theta\';
erpdir = 'K:\Dept\CallierResearch\Maguire\For RA use\Studies\Theme Category\Studies\JMS_N400_Theta\erp\';
chanloc_file = pop_loadset('K:\Dept\CallierResearch\Maguire\For RA use\Studies\Theme Category\Studies\JMS_N400_Theta\data\120608_1f_4y\MTCnoBS.set');
[d,s,r]=xlsread('tc_subjects.xlsx');

epoch_baseline= -100  
epoch_end= 1000

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% establish subject list
for k=1:length(s); %edit for subject of interest (can run multiple at once)

    %load continuous data
    EEG = pop_loadset('filename','MTCnoBS.set','filepath',[workdir s{k}]);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = epoch2continuous(EEG);
    EEG = pop_interp(EEG, chanloc_file.chanlocs, 'spherical');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    %Create eventlist, apply binlist, extract epochs, and artifact rejection
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [workdir s{k} filesep 'eventlist.txt'] ); 
    EEG  = pop_binlister( EEG , 'BDF', [txtdir 'binlist.txt'], 'ExportEL', [workdir s{k} filesep 'binlist.txt'],'ImportEL', [workdir s{k} filesep 'eventlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    EEG = pop_epochbin( EEG , [epoch_baseline  epoch_end],  'pre'); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET ,'savenew',[workdir s{k} filesep s{k} '_epoch_ar.set'],'gui','off'); 
    ERP = pop_averager(ALLEEG , 'Criterion', 'good', 'DSindex',CURRENTSET, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', s{k}, 'filename', [s{k} '.erp'], 'filepath', erpdir, 'Warning', 'on');  
end


%% Average individual ERPs together into group
    ERP = pop_gaverager( [txtdir 'create_grand_avg_erp.txt'] , 'ExcludeNullBin', 'on', 'SEM', 'on' );
    %Filter ERP at low-pass of 30 Hz
    ERP = pop_filterp( ERP,  1:62 , 'Cutoff',  30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    %Run channel operation to compute average over left ROI
    ERP = pop_erpchanoperator( ERP, {  'ch63 = (ch25+ch26+ch27+ch34)/4 label Left Central'} , 'ErrorMsg', 'popup', 'KeepLocations',  0, 'Warning', 'on' );
    %Plot ERP Waveform
    ERP = pop_ploterps( ERP, [ 2 4],  63 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6471 106.857 31.9412], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -99.0 998.0   -50 0:200:800 ], 'YDir', 'normal' );