%% Pre-Computation
clear all;
left = zeros(4,3);
right = zeros(4,3);
image = imread('ximending.jpg');

height = size(image,1);
width = size(image,2);

thisWindow = largeDarkFigure();
imshow(image);
hold on;


for i=1:4,
    xlabel('Choosing 4 points of left poster (From Left up,clockwisely choose)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    left(i,1) = clickY;
    left(i,2) = clickX;
    left(i,3) = 1;
end


for i=1:4,
    xlabel('Choosing 4 points of right poster  (From Left up,clockwisely choose)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
   right(i,1) = clickY;
   right(i,2) = clickX;
   right(i,3) = 1;
end

close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

%%  2-A

A = zeros(8,9);
for i=1:2:7,
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
display(H);
%% 2-B
vertices = [left(1,1),left(1,2);left(2,1),left(2,2);left(3,1),left(3,2);left(4,1),left(4,2)];
leftmask = poly2mask( vertices(:,2), vertices(:,1), height, width );
figure();
imshow(leftmask);

inleft = zeros( height, width );
[ y, x ] = find(leftmask);
pixNum = length(y);
for pixI = 1 : pixNum
	inleft( y(pixI), x(pixI) ) = 1;
end

figure();
imshow(inleft);
% right
vertices = [right(1,1),right(1,2);right(2,1),right(2,2);right(3,1),right(3,2);right(4,1),right(4,2)];
rightmask = poly2mask( vertices(:,2), vertices(:,1), height, width );
figure();
imshow(rightmask);

inright = zeros( height, width );
[ y, x ] = find(rightmask);
pixNum = length(y);
for pixI = 1 : pixNum
	inright( y(pixI), x(pixI) ) = 1;
end

figure();
imshow(inright);

tempLeft = zeros(height,width,3);
tempRight = zeros(height,width,3);
for i=1:height,
    for j=1:width,
        
        if inright(i,j)==1,
          pos = H * [i,j,1]';
          pos = pos./pos(3);
          tempRight(i,j,:) = bilinear(pos(1),pos(2),image);
        end
        
    end
end
for i=1:height,
    for j=1:width,
        
        if inleft(i,j)==1,
          pos = invH * [i,j,1]';
          pos = pos./pos(3);
          tempLeft(i,j,:) = bilinear(pos(1),pos(2),image);
        end
        
    end
end
image2 = image;
t = 0;
for i=1:height,
    for j=1:width,
        
        if inright(i,j)==1,
            image2(i,j,:) = tempRight(i,j,:);
           % t=t+1;
        elseif inleft(i,j)==1,
            image2(i,j,:) = tempLeft(i,j,:);
           % t=t+1;
        end
        
    end
end
figure();
imshow(image2);














