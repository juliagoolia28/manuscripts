%Load subject excel file
[d,s,r]=xlsread('tc_subjects.xlsx');
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for k=1:length(s);

EEG = pop_loadset('filename','MTCnoBS.set','filepath',strcat('K:\Dept\CallierResearch\Maguire\For RA use\Studies\Theme Category\Studies\JMS_N400_Theta\data\', s{k}, '\\'));
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
     
end

disp('LoadDataSets is done running');
