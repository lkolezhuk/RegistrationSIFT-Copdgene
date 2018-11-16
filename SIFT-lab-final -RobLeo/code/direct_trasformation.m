
function [total_point_direct]=direct_trasformation(H)


   
   

    
    
    

%Main of Homograpgy

I=load('Features.mat');
Features=I.Features(1).xy;
Matches(:,:,1)=I.Features(2).xy;
Matches(:,:,2)=I.Features(3).xy;
Matches(:,:,3)=I.Features(4).xy;


vector=1:1:size(Features);


Features_vec=Features(vector,:);
%matches_vec=Matches(vector,:,k);


%just for show
modality_order={'euclidean';'affine';'similarity';'projective'}

modality={'euclidean';'affine';'similarity'};




%H={};
for i=1:size(modality,1)


    for n=1:size(vector,2)
    x = [Features_vec(n,:), 1];
  
    x_temp = H{i}*x';
    result_point_direct(n,:)=x_temp(1:2);
    end
    total_point_direct{i}=result_point_direct;
    
    


end
     
   
    for n=1:size(vector,2)
         x = [Features_vec(n,:), 1];
         projective_x_temp = H{4}*x';
         result_point_direct(n,:)=(projective_x_temp(1:2)/projective_x_temp(3));
    end
    
    total_point_direct{i+1}=result_point_direct;
    


end

