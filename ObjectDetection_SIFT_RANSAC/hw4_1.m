%%  VLFeat Setup

run('VLFeat/toolbox/vl_setup');
%% book1 local feature matchig
clear all;

magnif =3; %3
threshold =230.0; %230

oribook1 = imread('book1.jpg');
oriscene = imread('scene.jpg');
book1 = single(rgb2gray(oribook1));
scene = single(rgb2gray(oriscene));

bHeight = size(book1,1);
bWidth = size(book1,2);
sHeight = size(scene,1);
sWidth = size(scene,2);
binSize = 300;
[f1 d1] = vl_sift(book1,'magnif',magnif);
[f4 d4] = vl_sift(scene,'magnif',magnif);


min = 1e9;
d4size = size(d4,2);
d1size = size(d1,2);
num = 0;
cor1 = zeros(d1size,2);
cor2 = zeros(d1size,2);
d4 = double(d4);
d1 = double(d1);



for i=1:size(d1,2),
    delta = d4 - repmat(d1(:,i),1,d4size);
    min=1e9;
    for j=1:d4size,
       dis = norm(delta(:,j));
       if dis<min,
          min=dis;
          index = j;
       end
    end
    if min<threshold,
        num = num+1;
        cor1(num,1) = f1(1,i); 
        cor1(num,2) = f1(2,i);
        cor2(num,1) = f4(1,index);
        cor2(num,2) = f4(2,index);
        f4(:,index) = [];
        d4(:,index) = [];
        d4size = d4size -1;
    end
    
end
disImg = uint8(zeros(sHeight,sWidth*2,3));
disImg(1:bHeight,1:bWidth,:) = oribook1(1:bHeight,1:bWidth,:);
disImg(1:sHeight,sWidth+1:2*sWidth,:) = oriscene(1:sHeight,1:sWidth,:);
figure();
imshow(disImg);
for i=1:num,
   line([cor1(i,1) (cor2(i,1)+sWidth)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
end

%% book1  RANSAC Object detection
n = 4;
k = 3000;
t = 10;
d = 13;
Doriscene = im2double(oriscene);
Doribook1 = im2double(oribook1);
IMG = zeros(sHeight,sWidth+bWidth,3);
IMG(1:sHeight,1:sWidth,:) = Doriscene(1:sHeight,1:sWidth,:);
IMG(1:bHeight,(sWidth+1):(sWidth+bWidth),:) = Doribook1(1:bHeight,1:bWidth,:);
deltaH = sHeight - bHeight;
% left = scene point  right = book point
largestInlier = 0;
largestInlierIndex = 0;
bestH = 0;   %% 一定都是x y 順序的問題啦 QQQQQ
for i=1:k,  
    init = randi([1 num],n,1);
    left = zeros(n,3);
    right= zeros(n,3);
    for j=1:n,  %setup initial homography guess
        left(j,1) = cor2(init(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(init(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(init(j),1)+sWidth;
        right(j,2) = cor1(init(j),2);
        right(j,3) = 1;
    end
    [H invH] = homography(left,right,n);% 還是是左右的問題???
    numInlier = 0;
    inlierIndex  = 0;
    for j=1:num,
        if numel(init(find(init==j)))~=0,
            continue;
        end
        rTemp = [cor1(j,1)+sWidth;cor1(j,2);1];
        lTemp = [cor2(j,1);cor2(j,2);1];
        hTemp = H * rTemp;
        hTemp = hTemp./(hTemp(3));
        if norm(lTemp - hTemp)<t,
            numInlier = numInlier +1;
            inlierIndex(numInlier) = j;
            disp('qq');
        end
    end

    if numInlier > d && numInlier > largestInlier,
        disp('bestH');
        largestInlier = numInlier;
        left = zeros(numInlier,3);
        right= zeros(numInlier,3);
       for j=1:numInlier,
        
        left(j,1) = cor2(inlierIndex(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(inlierIndex(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(inlierIndex(j),1)+sWidth;
        right(j,2) = cor1(inlierIndex(j),2);
        right(j,3) = 1;
       end
       largestInlierIndex = inlierIndex;
       [bestH, ~] = homography(left,right,numInlier);
    end
    
end


thisWindow = largeDarkFigure();
imshow(Doribook1);
hold on;

corners = zeros(3,4);
sceneCorners = zeros(3,4);

for i=1:4,
    xlabel('Choosing 4 points representing the 4 corners of the book)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    corners(1,i) = clickX;
    corners(2,i) = clickY;
    corners(3,i) = 1;
end

close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

corners2 = corners;
corners2(1,:) = corners2(1,:)+sWidth;
corners2(2,:) = corners2(2,:);
for i=1:4,
    sceneCorners(:,i) = bestH * corners2(:,i);
    sceneCorners(:,i) = sceneCorners(:,i)./sceneCorners(3,i);
end
figure();
imshow(IMG);
line([sceneCorners(1,1) sceneCorners(1,2)],[sceneCorners(2,1) sceneCorners(2,2)],'LineWidth',0.5,'Color',[1 0 0]);
line([sceneCorners(1,2) sceneCorners(1,3)],[sceneCorners(2,2) sceneCorners(2,3)],'LineWidth',0.5,'Color',[0 1 0]);
line([sceneCorners(1,3) sceneCorners(1,4)],[sceneCorners(2,3) sceneCorners(2,4)],'LineWidth',0.5,'Color',[0 0 1]);
line([sceneCorners(1,4) sceneCorners(1,1)],[sceneCorners(2,4) sceneCorners(2,1)],'LineWidth',0.5,'Color',[1 1 1]);
line([corners2(1,1) corners2(1,2)],[corners2(2,1) corners2(2,2)],'LineWidth',2,'Color',[1 0 0]);
line([corners2(1,2) corners2(1,3)],[corners2(2,2) corners2(2,3)],'LineWidth',2,'Color',[0 1 0]);
line([corners2(1,3) corners2(1,4)],[corners2(2,3) corners2(2,4)],'LineWidth',2,'Color',[0 0 1]);
line([corners2(1,4) corners2(1,1)],[corners2(2,4) corners2(2,1)],'LineWidth',2,'Color',[1 1 1]);


figure();
imshow(IMG);
for i=1:num,
   if numel(find(largestInlierIndex==i))~=0,
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
   else
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 1 0]) ;
   end
end

figure();
imshow(oriscene); % or D???
hold on;
for i=1:largestInlier,
   j = largestInlierIndex(i);
   temp = [cor1(j,1)+sWidth;cor1(j,2);1];
   corTemp = [cor2(j,1);cor2(j,2);1];
   transformed = bestH * temp;
   transformed = transformed./transformed(3);
   devVec = transformed - corTemp;
   disp(devVec);
   quiver(corTemp(1),corTemp(2),devVec(1),devVec(2),0,'LineWidth',0.5);
   viscircles([corTemp(1) corTemp(2)],0.1);
   viscircles([transformed(1) transformed(2)],0.1,'Color',[0 1 0]);
end


%%  book2 local feature matching

clear all;

magnif =3; %3
threshold =150.0; % 150

oribook1 = imread('book2.jpg');
oriscene = imread('scene.jpg');
book1 = single(rgb2gray(oribook1));
scene = single(rgb2gray(oriscene));

bHeight = size(book1,1);
bWidth = size(book1,2);
sHeight = size(scene,1);
sWidth = size(scene,2);
binSize = 300;

[f1 d1] = vl_sift(book1,'magnif',magnif);
[f4 d4] = vl_sift(scene,'magnif',magnif);


min = 1e9;
d4size = size(d4,2);
d1size = size(d1,2);
num = 0;
cor1 = zeros(d1size,2);
cor2 = zeros(d1size,2);
d4 = double(d4);
d1 = double(d1);



for i=1:size(d1,2),
    delta = d4 - repmat(d1(:,i),1,d4size);
    min=1e9;
    for j=1:d4size,
       dis = norm(delta(:,j));
       if dis<min,
          min=dis;
          index = j;
       end
    end
    if min<threshold,
        num = num+1;
        cor1(num,1) = f1(1,i); 
        cor1(num,2) = f1(2,i);
        cor2(num,1) = f4(1,index);
        cor2(num,2) = f4(2,index);
        f4(:,index) = [];
        d4(:,index) = [];
        d4size = d4size -1;
    end
    
end
disImg = uint8(zeros(sHeight,sWidth*2,3));
disImg(1:bHeight,1:bWidth,:) = oribook1(1:bHeight,1:bWidth,:);
disImg(1:sHeight,sWidth+1:2*sWidth,:) = oriscene(1:sHeight,1:sWidth,:);
figure();
imshow(disImg);
for i=1:num,
   line([cor1(i,1) (cor2(i,1)+sWidth)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
end

%% book2  RANSAC Object detection
n = 4;
k = 1000;
t = 5;
d = 10;
Doriscene = im2double(oriscene);
Doribook1 = im2double(oribook1);
IMG = zeros(sHeight,sWidth+bWidth,3);
IMG(1:sHeight,1:sWidth,:) = Doriscene(1:sHeight,1:sWidth,:);
IMG(1:bHeight,(sWidth+1):(sWidth+bWidth),:) = Doribook1(1:bHeight,1:bWidth,:);
deltaH = sHeight - bHeight;
% left = scene point  right = book point
largestInlier = 0;
largestInlierIndex = 0;
bestH = 0;   %% 一定都是x y 順序的問題啦 QQQQQ
for i=1:k,  
    init = randi([1 num],n,1);
    left = zeros(n,3);
    right= zeros(n,3);
    for j=1:n,  %setup initial homography guess
        left(j,1) = cor2(init(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(init(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(init(j),1)+sWidth;
        right(j,2) = cor1(init(j),2);
        right(j,3) = 1;
    end
    [H invH] = homography(left,right,n);% 還是是左右的問題???
    numInlier = 0;
    inlierIndex  = 0;
    for j=1:num,
        if numel(init(find(init==j)))~=0,
            continue;
        end
        rTemp = [cor1(j,1)+sWidth;cor1(j,2);1];
        lTemp = [cor2(j,1);cor2(j,2);1];
        hTemp = H * rTemp;
        hTemp = hTemp./(hTemp(3));
        if norm(lTemp - hTemp)<t,
            numInlier = numInlier +1;
            inlierIndex(numInlier) = j;
            disp('qq');
        end
    end

    if numInlier > d && numInlier > largestInlier,
        disp('bestH');
        largestInlier = numInlier;
        left = zeros(numInlier,3);
        right= zeros(numInlier,3);
       for j=1:numInlier,
        
        left(j,1) = cor2(inlierIndex(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(inlierIndex(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(inlierIndex(j),1)+sWidth;
        right(j,2) = cor1(inlierIndex(j),2);
        right(j,3) = 1;
       end
       largestInlierIndex = inlierIndex;
       [bestH, ~] = homography(left,right,numInlier);
    end
    
end


thisWindow = largeDarkFigure();
imshow(Doribook1);
hold on;

corners = zeros(3,4);
sceneCorners = zeros(3,4);

for i=1:4,
    xlabel('Choosing 4 points representing the 4 corners of the book)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    corners(1,i) = clickX;
    corners(2,i) = clickY;
    corners(3,i) = 1;
end

close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

corners2 = corners;
corners2(1,:) = corners2(1,:)+sWidth;
corners2(2,:) = corners2(2,:);
for i=1:4,
    sceneCorners(:,i) = bestH * corners2(:,i);
    sceneCorners(:,i) = sceneCorners(:,i)./sceneCorners(3,i);
end
figure();
imshow(IMG);
line([sceneCorners(1,1) sceneCorners(1,2)],[sceneCorners(2,1) sceneCorners(2,2)],'LineWidth',3,'Color',[1 0 0]);
line([sceneCorners(1,2) sceneCorners(1,3)],[sceneCorners(2,2) sceneCorners(2,3)],'LineWidth',3,'Color',[0 1 0]);
line([sceneCorners(1,3) sceneCorners(1,4)],[sceneCorners(2,3) sceneCorners(2,4)],'LineWidth',3,'Color',[0 0 1]);
line([sceneCorners(1,4) sceneCorners(1,1)],[sceneCorners(2,4) sceneCorners(2,1)],'LineWidth',3,'Color',[1 1 1]);
line([corners2(1,1) corners2(1,2)],[corners2(2,1) corners2(2,2)],'LineWidth',2,'Color',[1 0 0]);
line([corners2(1,2) corners2(1,3)],[corners2(2,2) corners2(2,3)],'LineWidth',2,'Color',[0 1 0]);
line([corners2(1,3) corners2(1,4)],[corners2(2,3) corners2(2,4)],'LineWidth',2,'Color',[0 0 1]);
line([corners2(1,4) corners2(1,1)],[corners2(2,4) corners2(2,1)],'LineWidth',2,'Color',[1 1 1]);

figure();
imshow(IMG);
for i=1:num,
   if numel(find(largestInlierIndex==i))~=0,
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
   else
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 1 0]) ;
   end
end

figure();
imshow(oriscene); % or D???
hold on;
for i=1:largestInlier,
   j = largestInlierIndex(i);
   temp = [cor1(j,1)+sWidth;cor1(j,2);1];
   corTemp = [cor2(j,1);cor2(j,2);1];
   transformed = bestH * temp;
   transformed = transformed./transformed(3);
   devVec = transformed - corTemp;
   disp(devVec);
   quiver(corTemp(1),corTemp(2),devVec(1),devVec(2),0,'LineWidth',0.5);
   viscircles([corTemp(1) corTemp(2)],0.1);
   viscircles([transformed(1) transformed(2)],0.1,'Color',[0 1 0]);
end


%%  book3 local feature matching

clear all;

magnif =3; %3
threshold =250.0; %250


oribook1 = imread('book3.jpg');
oriscene = imread('scene.jpg');
book1 = single(rgb2gray(oribook1));
scene = single(rgb2gray(oriscene));

bHeight = size(book1,1);
bWidth = size(book1,2);
sHeight = size(scene,1);
sWidth = size(scene,2);
binSize = 300;

[f1 d1] = vl_sift(book1,'magnif',magnif);
[f4 d4] = vl_sift(scene,'magnif',magnif);

min = 1e9;
d4size = size(d4,2);
d1size = size(d1,2);
num = 0;
cor1 = zeros(d1size,2);
cor2 = zeros(d1size,2);
d4 = double(d4);
d1 = double(d1);



for i=1:size(d1,2),
    delta = d4 - repmat(d1(:,i),1,d4size);
    min=1e9;
    for j=1:d4size,
       dis = norm(delta(:,j));
       if dis<min,
          min=dis;
          index = j;
       end
    end
    if min<threshold,
        num = num+1;
        cor1(num,1) = f1(1,i); 
        cor1(num,2) = f1(2,i);
        cor2(num,1) = f4(1,index);
        cor2(num,2) = f4(2,index);
        f4(:,index) = [];
        d4(:,index) = [];
        d4size = d4size -1;
    end
    
end
disImg = uint8(zeros(sHeight,sWidth*2,3));
disImg(1:bHeight,1:bWidth,:) = oribook1(1:bHeight,1:bWidth,:);
disImg(1:sHeight,sWidth+1:2*sWidth,:) = oriscene(1:sHeight,1:sWidth,:);
figure();
imshow(disImg);
for i=1:num,
   line([cor1(i,1) (cor2(i,1)+sWidth)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
end

%% book3  RANSAC Object detection

n = 4;
k = 1000;
t = 10;
d = 20;

Doriscene = im2double(oriscene);
Doribook1 = im2double(oribook1);
IMG = zeros(sHeight,sWidth+bWidth,3);
IMG(1:sHeight,1:sWidth,:) = Doriscene(1:sHeight,1:sWidth,:);
IMG(1:bHeight,(sWidth+1):(sWidth+bWidth),:) = Doribook1(1:bHeight,1:bWidth,:);
deltaH = sHeight - bHeight;
% left = scene point  right = book point
largestInlier = 0;
largestInlierIndex = 0;
bestH = 0;   %% 一定都是x y 順序的問題啦 QQQQQ
for i=1:k,  
    init = randi([1 num],n,1);
    left = zeros(n,3);
    right= zeros(n,3);
    for j=1:n,  %setup initial homography guess
        left(j,1) = cor2(init(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(init(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(init(j),1)+sWidth;
        right(j,2) = cor1(init(j),2);
        right(j,3) = 1;
    end
    [H invH] = homography(left,right,n);% 還是是左右的問題???
    numInlier = 0;
    inlierIndex  = 0;
    for j=1:num,
        if numel(init(find(init==j)))~=0,
            continue;
        end
        rTemp = [cor1(j,1)+sWidth;cor1(j,2);1];
        lTemp = [cor2(j,1);cor2(j,2);1];
        hTemp = H * rTemp;
        hTemp = hTemp./(hTemp(3));
        if norm(lTemp - hTemp)<t,
            numInlier = numInlier +1;
            inlierIndex(numInlier) = j;
            disp('qq');
        end
    end

    if numInlier > d && numInlier > largestInlier,
        disp('bestH');
        largestInlier = numInlier;
        left = zeros(numInlier,3);
        right= zeros(numInlier,3);
       for j=1:numInlier,
        
        left(j,1) = cor2(inlierIndex(j),1);  % 說不訂就是行列的問題喔喔喔喔????
        left(j,2) = cor2(inlierIndex(j),2);
        left(j,3) = 1;
        right(j,1) = cor1(inlierIndex(j),1)+sWidth;
        right(j,2) = cor1(inlierIndex(j),2);
        right(j,3) = 1;
       end
       largestInlierIndex = inlierIndex;
       [bestH, ~] = homography(left,right,numInlier);
    end
    
end


thisWindow = largeDarkFigure();
imshow(Doribook1);
hold on;

corners = zeros(3,4);
sceneCorners = zeros(3,4);

for i=1:4,
    xlabel('Choosing 4 points representing the 4 corners of the book)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    corners(1,i) = clickX;
    corners(2,i) = clickY;
    corners(3,i) = 1;
end

close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

corners2 = corners;
corners2(1,:) = corners2(1,:)+sWidth;
corners2(2,:) = corners2(2,:);
for i=1:4,
    sceneCorners(:,i) = bestH * corners2(:,i);
    sceneCorners(:,i) = sceneCorners(:,i)./sceneCorners(3,i);
end
figure();
imshow(IMG);
line([sceneCorners(1,1) sceneCorners(1,2)],[sceneCorners(2,1) sceneCorners(2,2)],'LineWidth',3,'Color',[1 0 0]);
line([sceneCorners(1,2) sceneCorners(1,3)],[sceneCorners(2,2) sceneCorners(2,3)],'LineWidth',3,'Color',[0 1 0]);
line([sceneCorners(1,3) sceneCorners(1,4)],[sceneCorners(2,3) sceneCorners(2,4)],'LineWidth',3,'Color',[0 0 1]);
line([sceneCorners(1,4) sceneCorners(1,1)],[sceneCorners(2,4) sceneCorners(2,1)],'LineWidth',3,'Color',[1 1 1]);
line([corners2(1,1) corners2(1,2)],[corners2(2,1) corners2(2,2)],'LineWidth',2,'Color',[1 0 0]);
line([corners2(1,2) corners2(1,3)],[corners2(2,2) corners2(2,3)],'LineWidth',2,'Color',[0 1 0]);
line([corners2(1,3) corners2(1,4)],[corners2(2,3) corners2(2,4)],'LineWidth',2,'Color',[0 0 1]);
line([corners2(1,4) corners2(1,1)],[corners2(2,4) corners2(2,1)],'LineWidth',2,'Color',[1 1 1]);

figure();
imshow(IMG);
for i=1:num,
   if numel(find(largestInlierIndex==i))~=0,
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 0 1]) ;
   else
       line([cor1(i,1)+sWidth cor2(i,1)],[cor1(i,2) cor2(i,2)],'LineWidth',0.02,'Color',[0 1 0]) ;
   end
end

figure();
imshow(oriscene); % or D???
hold on;
for i=1:largestInlier,
   j = largestInlierIndex(i);
   temp = [cor1(j,1)+sWidth;cor1(j,2);1];
   corTemp = [cor2(j,1);cor2(j,2);1];
   transformed = bestH * temp;
   transformed = transformed./transformed(3);
   devVec = transformed - corTemp;
   disp(devVec);
   quiver(corTemp(1),corTemp(2),devVec(1),devVec(2),0,'LineWidth',0.5);
   viscircles([corTemp(1) corTemp(2)],0.1);
   viscircles([transformed(1) transformed(2)],0.1,'Color',[0 1 0]);
end
