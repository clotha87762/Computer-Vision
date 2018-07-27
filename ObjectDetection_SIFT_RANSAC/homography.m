function [ H , invH ] = homography( left,right ,num)
%HOMOGRAPHY Summary of this function goes here
%   Detailed explanation goes here
A = zeros(2*num,9);
for i=1:2:(2*num-1),
     j = uint8(i/2);
     A(i,:) = [right(j,1),right(j,2),1,0,0,0,-left(j,1)*right(j,1),-left(j,1)*right(j,2),-left(j,1)];
     A(i+1,:) = [0,0,0,right(j,1),right(j,2),1,-left(j,2)*right(j,1),-left(j,2)*right(j,2),-left(j,2)];
end

temp = A'*A;
[V,D] = eig(temp);
min = inf;

for i=1:9,
    if D(i,i)<min,
       min = D(i,i); 
       index = i;
    end
end
minVec = V(:,index);
minVec = minVec./norm(minVec);
H = reshape(minVec,3,3)';
invH = inv(H);
%display(H);


end

