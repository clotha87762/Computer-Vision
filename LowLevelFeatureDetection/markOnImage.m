function [ out ] = markOnImage( image,mark )
%MARKONIMAGE Summary of this function goes here
%   Detailed explanation goes here
    out = image.*0.3;

    for i=1:size(image,1),
        for j=1:size(image,2),
           out(i,j)=0.3*image(i,j) + 0.7*mark(i,j);
        end
    end

end

