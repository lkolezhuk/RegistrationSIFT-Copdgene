function [H] = computeHomographyNormalized(Features, Matches, Model)

%Features - the locations of the keypoints in the initial image
%Matches - the locations of the keypoints in the transformed image
x_prime = [];
x_init = [];
Mat_Eq = [];
Homography = [];

% for i=1:size(Features,1)
%    x_prime = [x_prime; Features(i,:)'];
%    x_init = [x_init; Matches(i,:)'];
%    Mat_Eq = [Mat_Eq; Features(i,1) -Features(i,2) 1 0];
%    Mat_Eq = [Mat_Eq; Features(i,2)  Features(i,1) 0 1];
% end

% % Normalization
fm_points = [Features; Matches];
mean_fm = mean(fm_points);


difference = fm_points - repmat(mean_fm,size(fm_points,1),1);
% k = 1/sum((sqrt(sum(Features.^2))));
txn = -mean_fm(1);
tyn = -mean_fm(2);
% NTrans = [[k 0 tx];
%            [0 k ty];
%            [0 0 1]];

Features = difference(1:size(Features,1),:);
Matches = difference(size(Features,1)+1:end,:);
Features = Features(:,:)/sum((sqrt(sum(Features.^2))));
Matches = Matches(:,:)/sum((sqrt(sum(Matches.^2))));
% normalized_shapes = [shapes(1:56,:) + difference(1,:)' shapes(57:end,:) + difference(2,:)']; 




% result_first=pinv(Mat_Eq)*x_init;
Mat_eq_projective_matches=[];
switch Model


%%
    case 'projective'
%Homography PROJECTIVE
%in this section the projective matrix will be applied to a transformation
%x_initial corrispond to  x_prime  in the notes (features)
%x_matches corrispond to the matches, the point in the rotation figure
%Mat_eq_projective_matches=[];
x_initial_transp=Features';
x_matches_transp=Matches';

x_initial=x_initial_transp(:);
x_matches=x_matches_transp(:);

for i=1:2:(size(x_initial,1))
    Mat_eq_projective_matches(i,:)=[ x_initial(i) x_initial(i+1) 1 0 0 0 (-(x_initial(i)*x_matches(i))) (-x_matches(i)*x_initial(i+1))];
    Mat_eq_projective_matches(i+1,:)=[ 0 0 0 x_initial(i) x_initial(i+1) 1 (-x_matches(i+1)*x_initial(i)) (-x_matches(i+1)*x_initial(i+1))];
end
%inv(A'*A)*A'*x_matches
result_projective=pinv(Mat_eq_projective_matches)*x_matches;
result_projective_matrix= vec2mat(result_projective,3);
result_projective_matrix(3,3)=1;
H=result_projective_matrix;


%%
%AFFINE TRANSFORMATION
    case 'affine'

x_initial_transp=Features';
x_matches_transp=Matches';

x_initial=x_initial_transp(:);
x_matches=x_matches_transp(:);

for i=1:2:(size(x_initial,1))
    Mat_eq_projective_matches(i,:)=[ x_initial(i) x_initial(i+1) 1 0 0 0];
    Mat_eq_projective_matches(i+1,:)=[0 0 0 x_initial(i) x_initial(i+1) 1 ];
end
result_affine=pinv(Mat_eq_projective_matches)*x_matches;
result_affine_matrix = vec2mat(result_affine,3);
result_affine_matrix(3,3)=1;
H=result_affine_matrix;

%%
    case 'similarity'
%SIMILARITY
 
x_initial_transp=Features';
x_matches_transp=Matches';

x_initial=x_initial_transp(:);
x_matches=x_matches_transp(:);

for i=1:2:(size(x_initial,1))
    Mat_eq_projective_matches(i,:)=[ x_initial(i) -x_initial(i+1) 1 0];
    Mat_eq_projective_matches(i+1,:)=[x_initial(i+1) x_initial(i) 0 1];
end
result_similarity=pinv(Mat_eq_projective_matches)*x_matches;
result_similarity_matrix=[ result_similarity(1) -result_similarity(2) result_similarity(3);
                          result_similarity(2) result_similarity(1) result_similarity(4);
                          0 0 1];
%result_similarity_matrix=vec2mat(result_similarity,3);
result_similarity_matrix(3,3)=1;
H=result_similarity_matrix;
      






%AFFINE EUCLIDEAN
    case'euclidean'
Mat_eq_affine_matches=[];
x_initial_transp=Features';
x_matches_transp=Matches';

x_initial=x_initial_transp(:);
x_matches=x_matches_transp(:);

for i=1:2:(size(x_initial,1))
    Mat_eq_projective_matches(i,:)=[ x_initial(i) -x_initial(i+1) 1 0];
    Mat_eq_projective_matches(i+1,:)=[x_initial(i+1) x_initial(i) 0 1];
end
result_euclidean=pinv(Mat_eq_projective_matches)*x_matches;
result_euclidean_matrix=[ result_euclidean(1) -result_euclidean(2) result_euclidean(3);
                          result_euclidean(2) result_euclidean(1) result_euclidean(4);
                          0 0 1];
%result_euclidean_matrix=vec2mat(result_euclidean,3);
result_euclidean_matrix(3,3)=1;
H=result_euclidean_matrix;
check_det=det(H(1:2,1:2));
%check for rescaling
if (check_det ~= 1)
    result_euclidean_matrix=[ result_euclidean(1)/sqrt(check_det) -result_euclidean(2)/sqrt(check_det) result_euclidean(3);
                          result_euclidean(2)/sqrt(check_det) result_euclidean(1)/sqrt(check_det) result_euclidean(4);
                          0 0 1];
    
end
result_euclidean_matrix(3,3)=1;
H=result_euclidean_matrix;


end
% 
% H(1,3) = H(1,3) - txn;
% H(2,3) = H(2,3) - tyn;
end