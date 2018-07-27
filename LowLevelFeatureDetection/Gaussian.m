function [ smoothed_img ] = Gaussian( img,size,sigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    display(size(1));
    display(size(2));
    g_mask = fspecial('gaussian',[size(1) size(2)],sigma);
    smoothed_img = imfilter(img,g_mask);
end

