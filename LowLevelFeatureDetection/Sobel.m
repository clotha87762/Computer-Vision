function [ out ] = Sobel( img,direction )
%SOBEL Summary of this function goes here
%   Detailed explanation goes here
    if direction ==0,
        mask = [ -1 0 1;-2 0 2;-1 0 1];
    elseif direction==1,
        mask = [-1 -2 -1;0 0 0;1 2 1];
    end
    out = imfilter(img,mask);
end

