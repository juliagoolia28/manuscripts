function correlate_in_parcel(opts)

if isfloat(opts.SUBJ_IDS)
    for i = 1:length(opts.SUBJ_IDS)
        SUBJ_ID_STR{i} =['subj_' num2str(opts.SUBJ_IDS(i))];
    end
end

%% Load Parcels

PARCEL_VOL = MRIread(opts.PARCEL_FILE,0);
vol_vals = unique(PARCEL_VOL.vol);
parcel_nums = vol_vals(vol_vals > 0);

for i = 1:length(parcel_nums)
    PARCEL_NUM_STR{i} =['parcel_' num2str(parcel_nums(i))];
end

%% For each subject load two maps

n_subjs = length(opts.SUBJ_IDS);
n_parcels = length(parcel_nums);

% For each subject
for i = 1:n_subjs
   
    TASK1_VOL = MRIread([opts.TASK1_DIR num2str(opts.SUBJ_IDS(i)) '_langloc_cope.nii.gz'],0);
    TASK2_VOL = MRIread([opts.TASK2_DIR num2str(opts.SUBJ_IDS(i)) '_asl_cope.nii.gz'],0);
    MASK1_VOL = MRIread([opts.MASK1_DIR num2str(opts.SUBJ_IDS(i)) '_langloc_mask.nii.gz'],0);
    MASK2_VOL = MRIread([opts.MASK2_DIR num2str(opts.SUBJ_IDS(i)) '_asl_mask.nii.gz'],0);
    
    % For each parcel
    for j = 1:n_parcels
        
        temp_mask = (PARCEL_VOL.vol == parcel_nums(j)) & (MASK1_VOL.vol == 1) & (MASK2_VOL.vol == 1);
        [corr_in_parcel(i,j),p(i,j)] = calc_corr_in_parcel(temp_mask,TASK1_VOL.vol,TASK2_VOL.vol);
        fisher_z(i,j) = fisherTransform(corr_in_parcel(i,j));
        
    end

end

results1 = array2table(corr_in_parcel,'VariableNames',PARCEL_NUM_STR,'RowNames',SUBJ_ID_STR);
writetable(results1,[opts.RESULTS_DIR '/rval_in_parcel.csv'])

results2 = array2table(p,'VariableNames',PARCEL_NUM_STR,'RowNames',SUBJ_ID_STR);
writetable(results2,[opts.RESULTS_DIR '/pval_of_corr_in_parcel.csv'])

results3 = array2table(fisher_z,'VariableNames',PARCEL_NUM_STR,'RowNames',SUBJ_ID_STR);
writetable(results3,[opts.RESULTS_DIR '/fisherZ_in_parcel.csv'])

end

function [r,p] = calc_corr_in_parcel(temp_mask,task1,task2)

    mask_idxs = find(temp_mask);
    [r,p] = corr(task1(mask_idxs),task2(mask_idxs));

end

function z = fisherTransform(r)

    z = 0.5*log((1 + r)./(1 - r));
    
end