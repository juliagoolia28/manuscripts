function [RVAL_VOL,NEG_LOG_P_VOL,FISHER_Z_VOL,ZSCORED_FZ_VOL,NAN_VOL,INF_VOL] = do_LPSA(MAP1_VOL,MASK1_VOL,MAP2_VOL,MASK2_VOL,RADIUS,MIN_VOXELS)

    COMBINED_MASK_VOL = (MASK1_VOL > 0) & (MASK2_VOL > 0);
    MASK_IDXS = find(COMBINED_MASK_VOL);
    
    zeros_vol = zeros(size(MAP1_VOL));

    [RAW_CORR_VOL, RAW_NEG_LOG_P_VOL] = corr_in_sphere(MAP1_VOL, MAP2_VOL, RADIUS, MASK_IDXS, MIN_VOXELS);
    
    NAN_VOL = zeros_vol;
    INF_VOL = zeros_vol;
    RVAL_VOL = RAW_CORR_VOL;
    NEG_LOG_P_VOL = RAW_NEG_LOG_P_VOL;
    % FISHER_Z_VOL = zeros_vol;
    ZSCORED_FZ_VOL = zeros_vol;
    
    NAN_VOL(isnan(RAW_CORR_VOL)) = 1;
    INF_VOL(isinf(RAW_CORR_VOL)) = 1;
    
    RVAL_VOL(isnan(RAW_CORR_VOL)) = 0;
    RVAL_VOL(isinf(RAW_CORR_VOL)) = 0;
    
    NEG_LOG_P_VOL(isnan(RAW_CORR_VOL)) = 0;
    NEG_LOG_P_VOL(isinf(RAW_CORR_VOL)) = 0;
    
    FISHER_Z_VOL = fisherTransform(RVAL_VOL);
    
    temp_mean_fz = mean(FISHER_Z_VOL(MASK_IDXS));
    temp_std_fz = std(FISHER_Z_VOL(MASK_IDXS));
    
    ZSCORED_FZ_VOL(MASK_IDXS) = (FISHER_Z_VOL(MASK_IDXS) - temp_mean_fz)/temp_std_fz;

end

function [corr_img, neg_log_p_img] = corr_in_sphere(vol1,vol2,radius,mask_idxs,min_voxels)

corr_img = zeros(size(vol1));
neg_log_p_img = zeros(size(vol1));
zeros_vol = zeros(size(vol1));
[offsets,~] = construct_sphere(radius);

for j = 1:length(mask_idxs)
    
    temp_center = mask_idxs(j);
    
    [x,y,z] = ind2sub(size(vol1),temp_center);
    
    %% Step 3: Draw a sphere around it
    
    sphere_idxs = [];
    n = 1;
    
    for i = 1:size(offsets,1)
        
        if ((x+offsets(i,1)) <= size(vol1,1)) && ((y+offsets(i,2)) <= size(vol1,2)) && ((z+offsets(i,3)) <= size(vol1,3)) ...
                && ((x+offsets(i,1)) > 0) && ((y+offsets(i,2)) > 0) && ((z+offsets(i,3)) > 0)
            sphere_idxs(n) = sub2ind(size(vol1),x+offsets(i,1),y+offsets(i,2),z+offsets(i,3));
            n = n+1;
        end
        
    end
    
    temp_mask_idxs = intersect(mask_idxs,sphere_idxs);
    
    mask_vol = zeros_vol;
    mask_vol(temp_mask_idxs) = 1;
    
    
    %% Step 4: Correlate voxels from both maps within that sphere
    if length(temp_mask_idxs) >= min_voxels
        [corr_img(temp_center),neg_log_p_img(temp_center),~,~] = correlate_voxels(mask_vol,vol1,vol2);
    end
    clear sphere_idxs
    
end
end

function [r_val,neg_log_p_val,task1_voxels,task2_voxels] = correlate_voxels(mask_vol,task1_vol,task2_vol)

% Find voxels in mask

mask_idxs = find(mask_vol);

if isempty(mask_idxs)
    
    r_val = NaN;
    neg_log_p_val = NaN;
    task1_voxels = [];
    task2_voxels = [];
    
else
    
    task1_voxels = task1_vol(mask_idxs);
    
    task2_voxels = task2_vol(mask_idxs);
    
    if size(task1_voxels,2) > 1
        task1_voxels = task1_voxels';
        task2_voxels = task2_voxels';
    end
    
    [r_val,p_val] = corr(task1_voxels,task2_voxels);
    neg_log_p_val = -log10(p_val);
    
end
end

function [offsets,distances] = construct_sphere(radius_fix)

% function courtesy of Dr. Sung-Joo Lim

% construct a sphere in a voxel space (isotrophic size).
% input: radius of the sphere - # of voxels
% 
% output: sphere coordinates in voxelspace with origin of 0,0,0 

    radius = radius_fix;


    side=ceil(radius)*2+1;

    % make an array that is sufficienly large (actually too big)
    offsets=zeros(side^3,3);

    % keep track of where we store indices in offsets:
    % for every location within the sphere (in the code below),
    % add one to row_pos and then store the locations
    row_pos=0;

    % the grid positions (relative to the origin) to consider
    single_dimension_candidates=floor(-radius):ceil(radius);

    % Consider the candidates in all three spatial dimensions using
    % nested for loops and an if statement.
    % For each position:
    % - see if it is at most at distance 'radius' from the origin
    % - if that is the case, increase row_pos and store the position in
    %   'offsets'
    %
    % >@@>
    for x=single_dimension_candidates
        for y=single_dimension_candidates
            for z=single_dimension_candidates
                if x^2+y^2+z^2<=radius^2
                    row_pos=row_pos+1;
                    offsets(row_pos,:)=[x y z];
                end
            end
        end
    end
    % <@@<

    % cut off empty values at the end
    offsets=offsets(1:row_pos,:);

    % compute distances
    unsorted_distances=sqrt(sum(offsets.^2,2));

    % sort distances and apply to offsets
    [distances,idxs]=sort(unsorted_distances);
    offsets=offsets(idxs,:);
end

function z = fisherTransform(r)

    z = 0.5*log((1 + r)./(1 - r));
    
end