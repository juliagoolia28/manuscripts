function run_ssl_conjunction_analysis(SUBJ, THRESHOLD)

% Inputs
SUBJ = num2str(SUBJ);

% z thresholds for reference:
%   p = 0.05 : z = 1.645
%   p = 0.01 : z = 2.326
%   p = 0.001 : z = 3.090
%   p = 0.0001 : z = 3.719
%   p = 0.00001 : z = 4.265
% THRESHOLD = 2.326;

%% Make sure freesurfer stuff is on the path

where_you_are = pwd;

if contains(where_you_are,'/Users/tlscott/projects')
    % path_to_freesurfer_bin = '/Applications/freesurfer/7.1.0/matlab'; I
    % did this manually, for some reason this line didn't work
    % path1 = getenv('PATH');
    % path1 = [path1 path_to_freesurfer_bin];
    % setenv('PATH', path1)
    DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/';
elseif contains(where_you_are,'/projectnb')    
    % SET_FREESURFER = 'export FREESURFER_HOME=/share/pkg/freesurfer/5.3.0/install';
    path_to_freesurfer_bin = '/share/pkg/freesurfer/5.3.0/install/matlab';
    path1 = getenv('PATH');
    path1 = [path1 path_to_freesurfer_bin];
    setenv('PATH', path1)
    DATA_DIR = '/projectnb/perlab/users/tlscott/SSL/data/';
end

%% Data directories

TASK1_DIR = [DATA_DIR 'smoothed_data/asl_zstat/relabeled/'];
TASK2_DIR = [DATA_DIR 'smoothed_data/langloc_zstat/resampled/'];

RESULTS_DIR = [DATA_DIR 'conjunction_results/ind_subj_conj_thresh' num2str(THRESHOLD) '/'];
if exist(RESULTS_DIR,'dir') == 0
    mkdir(RESULTS_DIR)
end

%% Load one stat map from each task for each subject

MAP1 = MRIread([TASK1_DIR SUBJ '_zstat.nii.gz'],0);
MAP2 = MRIread([TASK2_DIR SUBJ '_zstat.nii.gz'],0);

blank_vol = zeros(size(MAP1.vol));
CONJ_MAP = MAP1;
CONJ_MAP.vol = blank_vol;

% Find overlap at some threshold

CONJ_MAP.vol = MAP1.vol >= THRESHOLD & MAP2.vol >= THRESHOLD;

% Save the binary map that results

MRIwrite(CONJ_MAP, [RESULTS_DIR SUBJ '_conj.nii.gz'], 'float');

