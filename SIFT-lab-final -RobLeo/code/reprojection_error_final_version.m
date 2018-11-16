%COMPUTE REPROJECTION ERROR
clear all;
close all;
result_point=[];
total_point={};
trasform_direct_point={};
for k=1:3

%Main of Homograpgy

I=load('Features.mat');
Features=I.Features(1).xy;
Matches(:,:,1)=I.Features(2).xy;
Matches(:,:,2)=I.Features(3).xy;
Matches(:,:,3)=I.Features(4).xy;


vector=1:1:64;
Features_vec=Features(vector,:);
matches_vec=Matches(vector,:,:);

vector_for_homography=[1 20 40 64];
Features_for_homography=Features(vector,:);
matches_vec_for_homography=Matches(vector,:,:);

%just for show
modality_order={'euclidean';'affine';'similarity';'projective'}

modality={'euclidean';'affine';'similarity'};




H={};
for i=1:size(modality,1)

H{i}=computeHomography(Features_for_homography,matches_vec_for_homography(:,:,k), modality{i});

    for n=1:size(vector,2)
    x = [Features(n,:), 1];
    y = [matches_vec(n,:,k),1];
    x_temp = inv(H{i})*y';
    result_point(n,:)=x_temp(1:2);
    end
    total_point{i,k}=result_point;
    
    


end
     
    H{i+1}=computeHomography(Features_for_homography,matches_vec_for_homography(:,:,k), 'projective');
    for n=1:size(vector,2)
         x = [Features(n,:), 1];
         y = [matches_vec(n,:,k),1];
         projective_x_temp = inv(H{4})*y';
         result_point(n,:)=(projective_x_temp(1:2)/projective_x_temp(3));
    end
    
    total_point{i+1,k}=result_point;
    trasform_direct_point=[trasform_direct_point ,direct_trasformation(H)'];

   



end


error1=error_compute(total_point,Features_vec);
%trasform_direct_point=direct_trasformation(H)';

for i=1:size(trasform_direct_point,2)
    % image i   
   
    for j=1:size(trasform_direct_point,1)
       
      error_direct(j,i)=immse(trasform_direct_point{j,i}(:,:),matches_vec(:,:,i));
  
    end 
    
end

%total_point{a,b}(c:d)
%a type of trasformation(aff,euc,sim,proj)
%b number of the image
%c and d are x and y of each point

%example total_point{1,3}will access the cordinate of traformation 1
%that is affine for image 3


for i=1:size(total_point,2)
    % image i
    figure
   
    for j=1:size(total_point,1)
        %trasformation j
    
    subplot(2,2,j),plot(Features_vec(:,1),Features_vec(:,2),'*'),hold on;
    subplot(2,2,j),plot(total_point{j,i}(:,1),total_point{j,i}(:,2),'o')
    legend('reference point','moving point')
    title(modality_order{j});
  
    end 
     suptitle(['Similarity between the transformed  and  reference images for dataset ' num2str(i) ]);
end


reprojection_error_final=error1.^2+error_direct.^2;

for i=1:size(total_point,2)
    % image i
    figure
   
    for j=1:size(total_point,1)
        %trasformation j
       
    subplot(2,2,j),plot(matches_vec(:,1,i),matches_vec(:,2,i),'*'),hold on;
    subplot(2,2,j),plot(trasform_direct_point{j,i}(:,1),trasform_direct_point{j,i}(:,2),'o')
    legend('reference point','moving point')
    title(modality_order{j});
  
    end 
     suptitle(['Similarity between the transformed  and  reference images for dataset ' num2str(i) ' after direct trasformations']);
end






