clear all;
close all;
clc;

[image,d,l] = sift('retina1.pgm');

imageWithMarkers = image;
imageWithMarkers = insertMarker(imageWithMarkers, [l(:, 2) l(:, 1)] ,'x','color','blue','size',5);



%Finding optimal parameters for vlfeat in order to qualitatively match the
%results of the original Lowe SIFT implementation
c_i = 0;
c_j = 0;

for i=5:0.5:15%peak threshold
    c_i = c_i + 1;
    c_j = 0;
    for j=7.5:5:20.5%edge thresold
        c_j = c_j + 1;
        
        I = single(image);
        [f,d] = vl_sift(I, 'PeakThresh', i, 'edgethresh', j);
        
        number_of_keypts(c_i, c_j) = length(f);
        peak_thresh(c_i,c_j) = i;
        edge_thresh(c_i,c_j) = j;
        
        imageWithMarkersVL = image;
        imageWithMarkersVL = insertMarker(imageWithMarkersVL, [f(1, :); f(2, :)]' ,'x','color','blue','size',5);
        
        resultImage = [imageWithMarkers imageWithMarkersVL];
        figure;
        imshow(resultImage,[]); title(['PeakThresh: ' num2str(i) '   EdgeThresh: ' num2str(j)]);
        pause(1);
    end
end



% Build a graph descirbing the dependence of the number of generated
% keypoints on the parameters of the Vlfeat method implementation
figure;
plot(peak_thresh, number_of_keypts,'.-');
% reference line shows the number of keypoints generated b original Lowe
% SIFT implementanion. The points of intersection of this line with the
% others determines a possible combination of vlfeat parameters, that will
% cause a generation of the exact number of keypoints as in the Lowe case
hline = refline([0 length(l)]);
hline.Color = 'r';
title(strcat('Keypoints generated depending on the parameters of VLfeat (For Lowe SIFT = ', num2str(length(l)), ')')); 
legend(strcat('Lowest edge threshold : ', num2str(min(min(edge_thresh)))));
xlabel('Peak threshold');
ylabel('Number of generated keypoints');


