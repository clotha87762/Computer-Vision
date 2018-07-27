clear all;

I = imread('flash2.bmp');
p = imread('noflash2.bmp');
I = im2double(I);
p = im2double(p);

r=8;
epsilon = 0.02^2;

q = zeros(size(I));

q(:, :, 1) = GuidedFilter(I(:, :, 1), p(:, :, 1), r, epsilon);
q(:, :, 2) = GuidedFilter(I(:, :, 2), p(:, :, 2), r, epsilon);
q(:, :, 3) = GuidedFilter(I(:, :, 3), p(:, :, 3), r, epsilon);

figure();
imshow([I,p,q],[0,1]);