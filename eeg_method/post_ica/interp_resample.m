wkdir = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\ft_epochs\july08\';
outputdir = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\ft_epochs\july08_interp\';
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Load excel list of subjects
[d,s,r]=xlsread('subject_list.xlsx');
EEG = pop_loadset('filename', '022517_1f_9y_MP1.set','filepath',workdir);

%cut 49, 99, 115, 127, 128, 145, 146, 151, 153
for k= [1,2,4:length(s)]; 
        EEG = pop_loadset('filename', [(s{k}) '_MP3.set'],'filepath',workdir);
        EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');
        EEG = pop_resample( EEG, 500);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',[outputdir (s{k}) '_MP3.set'],'gui','off'); 
        ALLEEG = pop_delset( ALLEEG, [ 2 ] );
end





