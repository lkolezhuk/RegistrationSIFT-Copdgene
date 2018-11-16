clear all;
close all;
clc;

Im = imread('CanonPGM.pgm');
%Im = imread('00.pgm');
%Im= imread('NikonPGM.pgm');
image(Im);


I = single((Im)) ;
%[f,d] = vl_sift(I) ;
[f,d]=vl_sift(I, 'PeakThresh', 2.75);
imageWithMarkersVL = I;
imageWithMarkersVL = insertMarker(Im, [f(1, :); f(2, :)]' ,'x-mark','color','blue','size',30);
        
imshow(imageWithMarkersVL,[]);
%%

% hold on;
% perm = randperm(size(f,2)) ;
% sel = perm(1:size(f,2)) ;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

%%

%  tform = maketform('affine',[1 0 0; .5 1 0; 0 0 1]);
%  J = imtransform(I,tform);
%  
%  [fb,db]=vl_sift(J);
%  figure;imshow(J,[]);
%  [matches,scores]=vl_ubcmatch(d,db);
%  hold on;
%  
%  
% perm1 = randperm(size(fb,2)) ;
% sel = perm1(1:50) ;
% h1 = vl_plotframe(fb(:,sel)) ;
% h2 = vl_plotframe(fb(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;



%%
%%VISUALIZATION of both
% figure ; clf ;
% Ia=I;
% Ib=J;
% fa=f;
% imagesc(cat(2, Ia, Ib)) ;
% 
% xa = fa(1,matches(1,:)) ;
% xb = fb(1,matches(2,:)) + size(Ia,2) ;
% ya = fa(2,matches(1,:)) ;
% yb = fb(2,matches(2,:)) ;
% 
% hold on ;
% h = line([xa ; xb], [ya ; yb]) ;
% set(h,'linewidth', 1, 'color', 'b') ;
% 
% vl_plotframe(fa(:,matches(1,:))) ;
% fb(1,:) = fb(1,:) + size(Ia,2) ;
% vl_plotframe(fb(:,matches(2,:))) ;
% axis image off ;
 


