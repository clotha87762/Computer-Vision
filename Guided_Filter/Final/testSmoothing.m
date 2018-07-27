clear all;

[file , ~] = uigetfile('.','Select an image to smooth');

I = imread(file);

if size(I,3)==3,
   I= rgb2gray(I); 
end
I = im2double(I);

p = I;
r = 16;
epsilon = 0.2^2;  % 0.2^2 
[q] = GuidedFilter(I,p,r,epsilon);

str =sprintf('r = %d  epsilon = %f',r,epsilon);
figure('Name',str);
imshow([I,q]);
