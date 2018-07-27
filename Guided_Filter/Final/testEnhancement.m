clear all;

[file , ~] = uigetfile('.','Select an image to smooth');
I = imread(file);
I = im2double(I);
p = I;
 
r = 16;  
epsilon = 0.1^2;  %0.1 with flower3  0.4 with teacher
q = zeros(size(I));
 
q(:,:,1) = GuidedFilterColor(I(:,:,:),p(:,:,1),r,epsilon);
q(:,:,2) = GuidedFilterColor(I(:,:,:),p(:,:,2),r,epsilon);
q(:,:,3) = GuidedFilterColor(I(:,:,:),p(:,:,3),r,epsilon);

q2(:,:,1) = bfilter2(p(:,:,1),r,[r 0.1]);
q2(:,:,2) = bfilter2(p(:,:,2),r,[r 0.1]);
q2(:,:,3) = bfilter2(p(:,:,3),r,[r 0.1]);

enhanced = (I-q).*5 + q;
enhanced2 = (I-q2).*5 + q2; 

figure();
imshow([I ,q , enhanced , enhanced2],[0 1]);
 
 