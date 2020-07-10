%Establish path to copy from
pathinput = 'K:\Dept\CallierResearch\Maguire\Backups\WLNSF_Epoched_Moved2020\FinalWord\';
%Establish path to create and copy to
pathoutput = 'K:\Dept\CallierResearch\Maguire\Julie\WL Learner\wkdir\';
%Load excel list of subjects
[d,s,r]=xlsread('subject_list.xlsx');

for k=1:length(s); 

copyfile ([pathinput (s{k})], [pathoutput (s{k})])

end
