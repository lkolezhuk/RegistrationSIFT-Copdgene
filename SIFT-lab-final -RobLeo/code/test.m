close all;
clear all;
clc;


%%
% i = imread('nikon.jpg');
% imwrite(i, 'NikonPGM.pgm', 'pgm')

% J = imread('nikon.jpg');
% imwrite(J, 'CanonPGM.pgm', 'pgm')

%%

[image,d,l] = sift('CanonPGM.pgm');

imageWithMarkers = image;
imageWithMarkers = insertMarker(image, [l(:, 2) l(:, 1)] ,'x','color','blue','size',30);


%figure;
figure('units','normalized','outerposition',[0 0 1 1])
imshow(imageWithMarkers,[]);title('SIFT');

% % Affine tranformation of an image
% tform = maketform('affine',[1 0 0; .5 1 0; 0 0 1]);
% Imm =imread('retina1.pgm');
% J = imtransform(Imm,tform);
% imshow(J,[]);
% imshow(J);
% % imsave
% match(I,J);
