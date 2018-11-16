%COMPUTE REPROJECTION ERROR

clear all;
close all;
MAIN_HOMOGRAPHY;

origina_image=Im0_gray;
euclidean_result=result_img{1};
affine_result=result_img{2};
projective_result=result_img{3};




for i=1:3

      error(i)=  immse(Im0_gray,result_img{i});
end


mydata=error;
figure,ylim([min(error)-0.05 max(error)+0.05])
hold on
for i = 1:length(mydata)
    h=bar(i,mydata(i));
    if i==1
        set(h,'FaceColor','k');
    elseif i==2
        set(h,'FaceColor','b');
    else
        set(h,'FaceColor','r');
    end
end
 title ('Error comparison between different modality of transformation')
hold off

bar(error), ylim([min(error)-0.05 max(error)+0.05]);


