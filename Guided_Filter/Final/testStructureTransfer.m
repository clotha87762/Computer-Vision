clear all;

I = imread('toy.bmp');
p = rgb2gray(imread('toy-mask.bmp'));
I = im2double(I);
p = im2double(p);

r = 60;
epsilon = 10^-6;

q = GuidedFilterColor(I,p,r,epsilon);

I1 = I(:,:,1);
I2 = I(:,:,2);
I3 = I(:,:,3);
I1(find(q<0.3)) = 0;
I2(find(q<0.3)) = 0;
I3(find(q<0.3)) = 0;
II = zeros(size(I));
II(:,:,1) = I1;
II(:,:,2) = I2;
II(:,:,3) = I3;
figure();
imshow([I,repmat(p,[1 1 3]),repmat(q,[1 1 3]),II],[0 1]);