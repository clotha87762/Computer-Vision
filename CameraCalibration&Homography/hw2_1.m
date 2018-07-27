%% Pre-Computation of points correspondence
[point3D , point2D] = clicker('chessboard.jpg');

%save('point3D.mat',point3D);
%save('point3D.mat',point2D);

%%  1-A
clear all;
load('points2D3D.mat');
image = imread('chessboard.jpg');
height = size(image,1);
width = size(image,2);
point3D(:,4) = 1;
point2D(:,3) = 1;
A = zeros(126,12);
for i=1:2:125,
    j = uint8(i/2);
    A( i,:) = [point3D(j,1),point3D(j,2),point3D(j,3),1,0,0,0,0,-point3D(j,1)*point2D(j,1),-point3D(j,2)*point2D(j,1),-point3D(j,3)*point2D(j,1),-point2D(j,1)];
    A( i+1,:) = [0,0,0,0,point3D(j,1),point3D(j,2),point3D(j,3),1,-point3D(j,1)*point2D(j,2),-point3D(j,2)*point2D(j,2),-point3D(j,3)*point2D(j,2),-point2D(j,2)];
end

temp = A'*A;
[V,D] = eig(temp);
min = inf;

for i=1:12,
    if D(i,i)<min,
       min = D(i,i); 
       index = i;
    end
end

minVec = V(:,index);

%minVec = point2D\point3D;
minVec = minVec./norm(minVec);

%% 1-B

P = reshape(minVec,4,3)';
M = P(:,1:3);
%tt = P(:,4);
%c = -1 *inv(M)*tt; 
[K,R] = RQFactorize(M);
t = K\[P(1,4) ,P(2,4) ,P(3,4)]';
%R = -R;
%t = -t
%t = -1 * R * P(:,4);
Ex = [R,t];
P = K*Ex;
%% 1-C

ReP = zeros(63,3);
temp3D(:,1) = point3D(:,1)*width;
temp3D(:,2) = point3D(:,2)*height;
temp3D(:,3) =  point3D(:,3);
temp3D(:,4) = 1;

for i =1:63,
    temp = P * point3D(i,:)';
    ReP(i,1) = temp(1);
    ReP(i,2) = temp(2);
    ReP(i,3) = temp(3);
    ReP(i,:) = ReP(i,:)./ReP(i,3);
end



for i=1:63,
    image(uint32(ReP(i,2)),uint32(ReP(i,1)),1) = 255;
    image(uint32(ReP(i,2)),uint32(ReP(i,1)),2) = 0;
    image(uint32(ReP(i,2)),uint32(ReP(i,1)),3) = 0;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1)),1) = 255;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1)),2) = 0;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1)),3) = 0;
    image(uint32(ReP(i,2)),uint32(ReP(i,1))+1,1) = 255;
    image(uint32(ReP(i,2)),uint32(ReP(i,1))+1,2) = 0;
    image(uint32(ReP(i,2)),uint32(ReP(i,1))+1,3) = 0;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1))+1,1) = 255;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1))+1,2) = 0;
    image(uint32(ReP(i,2))+1,uint32(ReP(i,1))+1,3) = 0;
end

figure();
imshow(image);
rms =0;
for i =1:63,
    rms = rms + sum((ReP(i,:) - point2D(i,:)).^2);
end
rms = rms/63;
rms = rms^(0.5);
display(rms);
%% 1-D 

%RR(1,:) = RR(1,:).* (-1);
visualizeCamera(point3D,R,t);

