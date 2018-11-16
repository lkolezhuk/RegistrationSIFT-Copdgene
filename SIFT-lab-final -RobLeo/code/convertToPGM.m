function [ output_args ] = convertToPGM( imagePath, imageNewName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    image = imread(imagePath);
    imageNewName = strcat(imageNewName, '.pgm');
    imwrite(image, imageNewName);

end

