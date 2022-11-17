%% 

PROJECT_DIR = '/Users/julie/Library/CloudStorage/Box-Box/My_Collaborations/fMRI_langlocssl/';

SET_FREESURFER = 'export FREESURFER_HOME=/Users/julie/freesurfer && source /Users/julie/freesurfer/SetUpFreeSurfer.sh'; % Point to your freesurfer directory so the code can find mri_convert
path_to_freesurfer_bin = '/Users/julie/freesurfer/matlab'; % Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
	
path1 = getenv('PATH');
path1 = [path1 path_to_freesurfer_bin];
setenv('PATH', path1)
unix(SET_FREESURFER);

%% Conjunction analyses

threshs = [1.645, 2.326]; 
% RESULTS_DIR = [DATA_DIR 'conjunction_results/ind_subj_conj_thresh' num2str(THRESHOLD) '/'];

for i = 1:22    
    for j = 1:length(threshs)
        
        run_ssl_conjunction_analysis(i, threshs(j))
        
    end    
end

%% Make parcels for conjunctions
for j = 1:length(threshs)
    
    FILENAMES = {};
    for i = 1:22
        FILENAMES{i} = [PROJECT_DIR 'data/conjunction_results/ind_subj_conj_thresh' num2str(threshs(j)) '/' num2str(i) '_conj.nii.gz'];
    end
    
    options = struct( ...
        'SET_FREESURFER', 'export FREESURFER_HOME=/Applications/freesurfer/7.1.0 && source /Applications/freesurfer/7.1.0/SetUpFreeSurfer.sh', ... # Point to your freesurfer directory so the code can find mri_convert
        'path_to_freesurfer_bin', ':/Applications/freesurfer/7.1.0/matlab', ... # Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
        'THRESH', threshs(j), ... # Numeric value to threshold volumes at
        'PCT_SUBJ_IN_PARC', 0.80, ... # Percent of subjects needed to consider a parcel "significant" or, representing the majority of subjects.
        'peak_spacing', 4, ... # Minimum distance between peaks of different parcels, in number of voxels. Ex. 3 means all local maxima have to be 3 voxels apart.
        'EXPERIMENT', ['Conjunction_at_thresh' num2str(threshs(j))], ... # For naming outputs
        'PATH_TO_RESULTS_DIR', [PROJECT_DIR 'data/conjunction_results/conj_parcels_thresh' num2str(threshs(j))]); % Where to put the outputs
    started_here = pwd();
    cd ./make_parcels-master/
    generate_parcels(FILENAMES, options);
    cd(started_here)
end

%% Run the LPSA analysis

RADIUS = 3;
MIN_VOXELS = 20;

for i = 1:22
    
    run_ssl_lpsa(i,RADIUS,MIN_VOXELS)
    
end

% Run group analysis

%% LPSA Parcels

threshs = [1.645,2.326];

for j = 1:length(threshs)
    
    FILENAMES = {};
    for i = 1:22
        FILENAMES{i} = [PROJECT_DIR 'data/lpsa_results/lpsa_rad3_minvox20/ind_subj_maps/' num2str(i) '_zscored_fz.nii.gz'];
    end
    
    options = struct( ...
        'SET_FREESURFER', 'export FREESURFER_HOME=/Users/julie/freesurfer && source /Users/julie/freesurfer/SetUpFreeSurfer.sh', ... % Point to your freesurfer directory so the code can find mri_convert
        'path_to_freesurfer_bin', '/Users/julie/freesurfer/matlab', ... # Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
        'THRESH', threshs(j), ... # Numeric value to threshold volumes at
        'PCT_SUBJ_IN_PARC', 0.50, ... # Percent of subjects needed to consider a parcel "significant" or, representing the majority of subjects.
        'peak_spacing', 4, ... # Minimum distance between peaks of different parcels, in number of voxels. Ex. 3 means all local maxima have to be 3 voxels apart.
        'EXPERIMENT', ['lpsa_thresh' num2str(threshs(j))], ... # For naming outputs
        'PATH_TO_RESULTS_DIR', [PROJECT_DIR 'data/lpsa_results/lpsa_rad3_minvox20/lpsa_parcels_rad3_minvox20_thresh' num2str(threshs(j))]); % Where to put the outputs
    started_here = pwd();
   % cd /Users/julie/Library/CloudStorage/Box-Box/My_Collaborations/fMRI_langlocssl/code/make_parcels-master/
    generate_parcels(FILENAMES, options);
    cd(started_here)
end

%% Make language parcels

threshs = 3.090;

for j = 1:length(threshs)
    
    FILENAMES = {};
    for i = 1:22
        FILENAMES{i} = [PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/' num2str(i) '_zstat.nii.gz'];
    end
    
    options = struct( ...
        'SET_FREESURFER', 'export FREESURFER_HOME=/Applications/freesurfer/7.1.0 && source /Applications/freesurfer/7.1.0/SetUpFreeSurfer.sh', ... # Point to your freesurfer directory so the code can find mri_convert
        'path_to_freesurfer_bin', ':/Applications/freesurfer/7.1.0/matlab', ... # Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
        'THRESH', 3.090, ... # Numeric value to threshold volumes at
        'PCT_SUBJ_IN_PARC', 0.80, ... # Percent of subjects needed to consider a parcel "significant" or, representing the majority of subjects.
        'peak_spacing', 4, ... # Minimum distance between peaks of different parcels, in number of voxels. Ex. 3 means all local maxima have to be 3 voxels apart.
        'EXPERIMENT', ['langloc_thresh' num2str(threshs(j))], ... # For naming outputs
        'PATH_TO_RESULTS_DIR', [PROJECT_DIR 'data/langlocs_parcels_thresh' num2str(threshs(j))]); % Where to put the outputs
    started_here = pwd();
    cd ./make_parcels-master/
    generate_parcels(FILENAMES, options);
    cd(started_here)
end

%% Make parcels based on asl data

threshs = [1.645,2.326,3.090]; 

for j = 1:length(threshs)
    
    FILENAMES = {};
    for i = 1:22
        FILENAMES{i} = [PROJECT_DIR 'data/smoothed_data/asl_zstat/relabeled/' num2str(i) '_zstat.nii.gz'];
    end
    
    options = struct( ...
        'SET_FREESURFER', 'export FREESURFER_HOME=/Applications/freesurfer/7.1.0 && source /Applications/freesurfer/7.1.0/SetUpFreeSurfer.sh', ... # Point to your freesurfer directory so the code can find mri_convert
        'path_to_freesurfer_bin', ':/Applications/freesurfer/7.1.0/matlab', ... # Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
        'THRESH', threshs(j), ... # Numeric value to threshold volumes at
        'PCT_SUBJ_IN_PARC', 0.80, ... # Percent of subjects needed to consider a parcel "significant" or, representing the majority of subjects.
        'peak_spacing', 4, ... # Minimum distance between peaks of different parcels, in number of voxels. Ex. 3 means all local maxima have to be 3 voxels apart.
        'EXPERIMENT', ['asl_thresh' num2str(threshs(j))], ... # For naming outputs
        'PATH_TO_RESULTS_DIR', [PROJECT_DIR 'data/asl_parcels_thresh' num2str(threshs(j))]); % Where to put the outputs
    started_here = pwd();
    cd([PROJECT_DIR 'code/make_parcels-master/'])
    generate_parcels(FILENAMES, options);
    cd(started_here)
end

%% Measure response magnitudes in frois

opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
opts.PARCEL_DIR = [opts.PROJECT_DIR 'data/langlocs_parcels_thresh3.09_09-Oct-2020/'];
opts.PARCEL_FILE = [opts.PARCEL_DIR 'langloc_thresh3.09_probability_map_thresh2subjs_smoothed_parcels_sig.nii.gz'];

opts.SUBJ_DEFINE_DATA_DIR = [opts.PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/'];
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/make_parcels-master/data/smoothed_data/asl_cope/';

opts.RESULTS_DIR = [opts.PROJECT_DIR 'data/froi_analysis_results/'];
if ~exist(opts.RESULTS_DIR,'dir')
    mkdir(opts.RESULTS_DIR)
end

% Conditions to measure
opts.COND = 'stat_learning_contrast';
opts.SUBJ_IDS = 1:22;

run_froi_resp_mag(opts);

clear opts

%% Measure correlation in language parcels

opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
opts.PARCEL_DIR = [opts.PROJECT_DIR 'data/langlocs_parcels_thresh3.09_09-Oct-2020/'];
opts.PARCEL_FILE = [opts.PARCEL_DIR 'langloc_thresh3.09_probability_map_thresh2subjs_smoothed_parcels_sig.nii.gz'];
 
opts.TASK1_DIR = [opts.PROJECT_DIR 'data/langloc_nosmoothing_copes/resampled/'];
opts.TASK2_DIR = [opts.PROJECT_DIR 'data/asl_nosmoothing_copes/relabeled/'];
opts.MASK1_DIR = [opts.PROJECT_DIR 'data/langloc_nosmoothing_copes/resampled/'];
opts.MASK2_DIR = [opts.PROJECT_DIR 'data/asl_nosmoothing_copes/relabeled/'];

opts.RESULTS_DIR = [opts.PROJECT_DIR 'data/corr_analysis_results/'];
if ~exist(opts.RESULTS_DIR,'dir')
    mkdir(opts.RESULTS_DIR)
end

opts.SUBJ_IDS = 1:22;

correlate_in_parcel(opts)

clear opts

%% Measure correlation in conjunction parcels

opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
opts.PARCEL_DIR = [opts.PROJECT_DIR 'data/conjunction_results/conj_parcels_thresh1.645_02-Oct-2020/'];
opts.PARCEL_FILE = [opts.PARCEL_DIR 'Conjunction_at_thresh1.645_probability_map_thresh2subjs_smoothed_parcels_50pct.nii.gz'];
 
opts.TASK1_DIR = [opts.PROJECT_DIR 'data/langloc_nosmoothing_copes/resampled/'];
opts.TASK2_DIR = [opts.PROJECT_DIR 'data/asl_nosmoothing_copes/relabeled/'];
opts.MASK1_DIR = [opts.PROJECT_DIR 'data/langloc_nosmoothing_copes/resampled/'];
opts.MASK2_DIR = [opts.PROJECT_DIR 'data/asl_nosmoothing_copes/relabeled/'];

opts.RESULTS_DIR = [opts.PROJECT_DIR 'data/corr_analysis_in_conjunct_parcels/'];
if ~exist(opts.RESULTS_DIR,'dir')
    mkdir(opts.RESULTS_DIR)
end

opts.SUBJ_IDS = 1:22;

correlate_in_parcel(opts)

clear opts

%% Measure correlation in LPSA parcel a.k.a. In the place where 50% of subjects have high correlations, are those correlations related to behavior?

opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
opts.PARCEL_DIR = [opts.PROJECT_DIR 'data/lpsa_results/lpsa_rad3_minvox20/lpsa_parcels_rad3_minvox20_thresh2.326_15-Oct-2020/'];
opts.PARCEL_FILE = [opts.PARCEL_DIR 'lpsa_thresh2.326_probability_map_thresh2subjs_smoothed_parcels.nii.gz'];

% opts.SUBJ_DEFINE_DATA_DIR = [opts.PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/'];
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/lpsa_results/lpsa_rad3_minvox20/ind_subj_maps/';

opts.RESULTS_DIR = [opts.PROJECT_DIR 'data/lpsa_parcel_analysis_results/'];
if ~exist(opts.RESULTS_DIR,'dir')
    mkdir(opts.RESULTS_DIR)
end

% Conditions to measure
opts.COND = 'lpsa_correlations_fisher_z';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'fisher_z';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.COND = 'lpsa_correlations_rval';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'rval';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.COND = 'lpsa_correlations_zscored_fz';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zscored_fz';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/smoothed_data/langloc_zstat/resampled/';

opts.COND = 'langloc_intact-deg';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zstat';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/smoothed_data/asl_zstat/relabeled/';

opts.COND = 'asl_contrast_zstat';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zstat';
run_parcel_resp_mag(opts);

clear opts

%% UPDATE 7/20/21 Measure in the p < 0.05 LPSA parcels
% Measure correlation in LPSA parcel a.k.a. In the place where 50% of subjects have high correlations, are those correlations related to behavior?

opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
opts.PARCEL_DIR = [opts.PROJECT_DIR 'data/lpsa_results/lpsa_rad3_minvox20/lpsa_parcels_rad3_minvox20_thresh1.645_15-Oct-2020/'];
opts.PARCEL_FILE = [opts.PARCEL_DIR 'lpsa_thresh1.645_probability_map_thresh2subjs_smoothed_parcels_sig.nii.gz'];

% opts.SUBJ_DEFINE_DATA_DIR = [opts.PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/'];
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/lpsa_results/lpsa_rad3_minvox20/ind_subj_maps/';

opts.RESULTS_DIR = [opts.PROJECT_DIR 'data/lpsa_parcel_analysis_results_p_lsthan_0p05/'];
if ~exist(opts.RESULTS_DIR,'dir')
    mkdir(opts.RESULTS_DIR)
end

% Conditions to measure
opts.COND = 'lpsa_correlations_fisher_z';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'fisher_z';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.COND = 'lpsa_correlations_rval';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'rval';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.COND = 'lpsa_correlations_zscored_fz';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zscored_fz';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/smoothed_data/langloc_zstat/resampled/';

opts.COND = 'langloc_intact-deg';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zstat';
run_parcel_resp_mag(opts);

% Conditions to measure
opts.SUBJ_MEASURE_DATA_DIR = '/Users/tlscott/projects/StatLearning_Collab/data/smoothed_data/asl_zstat/relabeled/';

opts.COND = 'asl_contrast_zstat';
opts.SUBJ_IDS = 1:22;
opts.MAPTYPE = 'zstat';
run_parcel_resp_mag(opts);

clear opts