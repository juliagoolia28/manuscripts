%% Script to make parcels from a dataset

% First get a cell array with the full path to each individual subject file

PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';

FILENAMES = {};

for i = 1:22
    FILENAMES{i} = [PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/' num2str(i) '_zstat.nii.gz'];
end

options = struct( ...
	'SET_FREESURFER', 'export FREESURFER_HOME=/Applications/freesurfer/7.1.0 && source /Applications/freesurfer/7.1.0/SetUpFreeSurfer.sh', ... # Point to your freesurfer directory so the code can find mri_convert
	'path_to_freesurfer_bin', ':/Applications/freesurfer/7.1.0/matlab', ... # Point to where MRIread.m and MRIwrite.m live in case they are not already in your path
	'THRESH', 3.090232, ... # Numeric value to threshold volumes at
	'PCT_SUBJ_IN_PARC', 0.80, ... # Percent of subjects needed to consider a parcel "significant" or, representing the majority of subjects.
    'peak_spacing', 4, ... # Minimum distance between peaks of different parcels, in number of voxels. Ex. 3 means all local maxima have to be 3 voxels apart.
	'EXPERIMENT', 'LangLoc_resampled_zthresh3.090232_4voxSpacing', ... # For naming outputs
	'PATH_TO_RESULTS_DIR', [PROJECT_DIR 'data/langloc_resampled_parcels/']); % Where to put the outputs

generate_parcels(FILENAMES, options);