function [ out ] = bilinear( x , y, image )
%BILINEAR Summary of this function goes here
%   Detailed explanation goes here
    xx = uint32(x);
    yy = uint32(y);
    a =  x - floor(x);
    b =  y - floor(y);
    out = (1-a)*(1-b)*image(xx,yy,:) + a*(1-b)*image(xx+1,yy,:) + (1-a)*b*image(xx,yy+1,:) + a*b*image(xx+1,yy+1,:);
end

