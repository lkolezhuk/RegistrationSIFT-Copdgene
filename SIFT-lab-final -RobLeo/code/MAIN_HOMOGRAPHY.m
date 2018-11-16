%Main of Homograpgy
clear all;
close all;
I=load('Features.mat');
Features=I.Features(1).xy;
Matches(:,:,1)=I.Features(2).xy;
Matches(:,:,2)=I.Features(3).xy;
Matches(:,:,3)=I.Features(4).xy;

Im0 = imread('00.pgm');
Im0_gray = rgb2gray(Im0);
Im1=imread('01.pgm');
Im1_gray=rgb2gray(Im1);
Img_projection(:,:,1)=Im1_gray;
Im2=imread('02.pgm');
Im2_gray = rgb2gray(Im2);
Img_projection(:,:,2)=Im2_gray;
Im3=imread('03.pgm');
Im3_gray = rgb2gray(Im3);
Img_projection(:,:,3)=Im3_gray;

%modality={'euclidean';'affine';'projective';'similarity'}

modality={'euclidean';'affine';'similarity'}

result_img={};
H=[];

img_prova=zeros(size(Im0_gray));
%Matches and Im has to be the same
figure;
subplot(2,3,1);
imshow(Im0_gray,[])
title('original')

%
k=3;%this is the index that corrispond to the number of the image
%
H={};
for i=1:size(modality,1)

H{i}=computeHomography(Features,Matches(:,:,k), modality{i});
%H = inv(H);
tform=affine2d(H{i}');
tform=invert(tform);
%we use 'Fillvalue',Im0_gray(1,1) for fill the value of the inverse
%transform that not corripond to any valued
result_img{i}=imwarp(Img_projection(:,:,k),tform,'OutputView', imref2d( size(Im0_gray) ),'Fillvalue',Im0_gray(1,1));
subplot(2,3,i+1);
imshow(result_img{i},[]);
title(modality{i});
end

H{i+1}=computeHomography(Features,Matches(:,:,k), 'projective');
%H = inv(H);
tform = projective2d(H{i+1}');
tform=invert(tform);
result_img{4}=imwarp(Img_projection(:,:,k),tform,'OutputView', imref2d( size(Im0_gray) ),'Fillvalue',Im0_gray(1,1));
%result_img{4}=imwarp(Img_projection(:,:,k),tform);

subplot(2,3,5);
imshow(result_img{4},[]);
title('projective');
subplot(2,3,6);
imshow(Img_projection(:,:,k),[]);
title('distorted')


%%
% In this section we overlap the 2 images
C={};

figure;
%show the error in color scale
for i=1:size(result_img,2)
C{i} = imfuse(Im0_gray,result_img{i},'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
subplot(2,2,i);
imshow(C{i},[]),axis off;
title('ERROR MAP');
end










