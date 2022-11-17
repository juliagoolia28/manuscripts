function run_ssl_lpsa(SUBJ,RADIUS,MIN_VOXELS)

% Inputs
SUBJ = num2str(SUBJ);
% RADIUS = 3;
% MIN_VOXELS = 20;

%% Make sure freesurfer stuff is on the path

where_you_are = pwd;

if contains(where_you_are,'/Users/julie/Library/CloudStorage/Box-Box/My_Collaborations/fMRI_langlocssl')
    % path_to_freesurfer_bin = '/Applications/freesurfer/7.1.0/matlab'; I
    % did this manually, for some reason this line didn't work
    % path1 = getenv('PATH');
    % path1 = [path1 path_to_freesurfer_bin];
    % setenv('PATH', path1)
    DATA_DIR = '/Users/julie/Library/CloudStorage/Box-Box/My_Collaborations/fMRI_langlocssl/data/';
elseif contains(where_you_are,'/projectnb')    
    % SET_FREESURFER = 'export FREESURFER_HOME=/share/pkg/freesurfer/5.3.0/install';
    path_to_freesurfer_bin = '/Users/julie/freesurfer/matlab';
    path1 = getenv('PATH');
    path1 = [path1 path_to_freesurfer_bin];
    setenv('PATH', path1)
    DATA_DIR = '/Users/julie/Library/CloudStorage/Box-Box/My_Collaborations/fMRI_langlocssl/data/';
end

%% Data directories

TASK1_DIR = [DATA_DIR 'input_data/asl_nosmoothing_copes/relabeled/'];
TASK2_DIR = [DATA_DIR 'input_data/langloc_nosmoothing_copes/'];

RESULTS_DIR = [DATA_DIR 'lpsa_results/lpsa_rad' num2str(RADIUS) '_minvox' num2str(MIN_VOXELS) '/ind_subj_maps/'];
if exist(RESULTS_DIR,'dir') == 0
    mkdir(RESULTS_DIR)
end

%% Load data

MAP1 = MRIread([TASK1_DIR SUBJ '_asl_cope.nii.gz'],0);
MASK1 = MRIread([TASK1_DIR SUBJ '_asl_mask.nii.gz'],0);
MAP2 = MRIread([TASK2_DIR SUBJ '_langloc_cope.nii.gz'],0);
MASK2 = MRIread([TASK2_DIR SUBJ '_langloc_mask.nii.gz'],0);

%% DO LPSA

RVAL = MAP1;
NEG_LOG_P = MAP1;
FISHER_Z = MAP1;
ZSCORED_FZ = MAP1;
NAN = MAP1;
INF = MAP1;

[RVAL.vol,NEG_LOG_P.vol,FISHER_Z.vol,ZSCORED_FZ.vol,NAN.vol,INF.vol] = do_LPSA(MAP1.vol,MASK1.vol,MAP2.vol,MASK2.vol,RADIUS,MIN_VOXELS);

%% Save everything

MRIwrite(RVAL, [RESULTS_DIR SUBJ '_rval.nii.gz'], 'float');
MRIwrite(NEG_LOG_P, [RESULTS_DIR SUBJ '_neg_log_p.nii.gz'], 'float');
MRIwrite(FISHER_Z, [RESULTS_DIR SUBJ '_fisher_z.nii.gz'], 'float');
MRIwrite(ZSCORED_FZ, [RESULTS_DIR SUBJ '_zscored_fz.nii.gz'], 'float');
MRIwrite(NAN, [RESULTS_DIR SUBJ '_nan.nii.gz'], 'float');
MRIwrite(INF, [RESULTS_DIR SUBJ '_inf.nii.gz'], 'float');


