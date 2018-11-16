function [error]=error_compute(total_point,Features_vec)
%work with a cell total_point that it is a matrix whit all the trasformed
%point for all the image
for i=1:size(total_point,2)
    % image i
   
   
    for j=1:size(total_point,1)
       
      error(j,i)=immse(total_point{j,i}(:,:),Features_vec(:,:));
  
    end 
    
end