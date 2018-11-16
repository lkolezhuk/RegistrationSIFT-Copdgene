function [ H ] = computeHomographyRANSAC( features, matches )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Parameters
num_iter = 50;
num_iter2 = 50;
subset_size = 5;
outlier_estimated_percentage = 25;
subset_gather_thresh = 1000;



% [nm,features,matches] = match('skin1.pgm','skin2.pgm');
% features = [features(:,2) features(:,1)];
% matches = [matches(:,2) matches(:,1)];
% im1 = imread('skin1.pgm');
% im2 = imread('skin2.pgm');
inlier_estimated_count = ceil((1 - outlier_estimated_percentage/100) * size(features,1));

for i=1:num_iter
    rand_indexes(i,:) = randperm(size(features,1), subset_size);
    rand_features = features(rand_indexes(i,:),:);
    rand_matches = matches(rand_indexes(i,:),:);
    
    H = computeHomographyNormalized(rand_features, rand_matches, 'affine');
   
    
    tform = affine2d(H');
    tform = invert(tform);
%     result_img{i} = imwarp(im2,tform,'OutputView', imref2d( size(im1) ));
%     temp_err_sum = mse(im1, result_img{i});
    diff_keyf(i) = error_compute(features, matches, H);
    
end


[~,min_index] = min(diff_keyf);
best_indexes = rand_indexes(min_index,:);
best_features = features(best_indexes,:);
best_matches = matches(best_indexes,:);

[diff_keyf_sorted,diff_keyf_sorted_ind] = sort(diff_keyf);
% better_feature_indexes = rand_indexes(diff_keyf < diff_keyf(min_index) + subset_gather_thresh,:);
better_feature_indexes = rand_indexes(diff_keyf_sorted_ind(1:inlier_estimated_count),:);
better_feature_indexes = unique(better_feature_indexes);
better_features = features(better_feature_indexes,:);

 H = computeHomographyNormalized(better_features, matches(better_feature_indexes, :), 'affine');
%  H = computeHomography(better_features, matches(better_feature_indexes, :), 'affine'); 
%  tform = affine2d(HN');
%  tform = invert(tform);
%  result_img_better = imwarp(im2,tform,'OutputView', imref2d( size(im1) ));
% 
% figure;imshowpair(result_img{min_index},im1,'falsecolor');
% figure;imshowpair(result_img_better, im1,'falsecolor');
% 

end

