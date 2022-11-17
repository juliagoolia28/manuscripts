function run_parcel_resp_mag(opts)

%% Measure response magnitudes in frois

% Changed from measuring in fROIs to measuring across the whole parcel.
% No need for a defining volume, just take every voxel in the parcel.

% opts.PROJECT_DIR = '/Users/tlscott/projects/StatLearning_Collab/';
% opts.PARCEL_DIR = [PROJECT_DIR 'data/langlocs_parcels_thresh3.09_09-Oct-2020/'];
% opts.PARCEL_FILE = [PARCEL_DIR 'langloc_thresh3.09_probability_map_thresh2subjs_smoothed_parcels_sig.nii.gz'];
% 
% opts.SUBJ_DEFINE_DATA_DIR = [PROJECT_DIR 'data/smoothed_data/langloc_zstat/resampled/'];
% opts.SUBJ_MEASURE_DATA_DIR = [PROJECT_DIR 'data/smoothed_data/asl_cope/'];
% 
% opts.RESULTS_DIR = [PROJECT_DIR 'data/froi_analysis_results/'];
% if ~exist(opts.RESULTS_DIR,'dir')
%     mkdir(opts.RESULTS_DIR)
% end
% 
% % Conditions to measure
% opts.COND = {'stat_learning_contrast'};
% opts.SUBJ_IDS = 1:22;

if isfloat(opts.SUBJ_IDS)
    for i = 1:length(opts.SUBJ_IDS)
        SUBJ_ID_STR{i} =['subj_' num2str(opts.SUBJ_IDS(i))];
    end
end

%% Load parcels

PARCEL_VOL = MRIread(opts.PARCEL_FILE,0);
vol_vals = unique(PARCEL_VOL.vol);
parcel_nums = vol_vals(vol_vals ~= 0);

for i = 1:length(parcel_nums)
    PARCEL_NUM_STR{i} =['parcel_' num2str(parcel_nums(i))];
end

%% For each parcel...

n_subjs = length(opts.SUBJ_IDS);
n_parcels = length(parcel_nums);

% For each subject
for i = 1:n_subjs

    % Load stat map for defining frois
    % DEFINE_VOL = MRIread([opts.SUBJ_DEFINE_DATA_DIR num2str(opts.SUBJ_IDS(i)) '_zstat.nii.gz'],0);
    % Load cope(s) for measuring response
    MEASURE_VOL = MRIread([opts.SUBJ_MEASURE_DATA_DIR num2str(opts.SUBJ_IDS(i)) '_' opts.MAPTYPE '.nii.gz'],0);
    
    % For each parcel
    for j = 1:n_parcels
        
        temp_mask = PARCEL_VOL.vol == parcel_nums(j);
        mean_in_roi(i,j) = MeanCopeParcel(temp_mask,MEASURE_VOL.vol);
        
    end

end

%% Setup results structure

results = array2table(mean_in_roi,'VariableNames',PARCEL_NUM_STR,'RowNames',SUBJ_ID_STR);
writetable(results,[opts.RESULTS_DIR '/' opts.COND '_parcel_resp_mag.csv'])

end

function mean_in_roi = MeanCopeParcel(parcel_mask_vol,testing_vol)

% Mask defining volume with parcel
% Parcel mask should just be ones and zeros
voxel_idxs_in_parcel = find(parcel_mask_vol);

testing_data_voxel_values = testing_vol(voxel_idxs_in_parcel);

mean_in_roi = mean(testing_data_voxel_values);

end