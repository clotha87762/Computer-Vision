inputName = 'jaguar.avi';

%   output name
outputName = 'jaguar_3.avi';

%   Create object to read video files 
video1 = VideoReader(inputName);

%   info of input video
nFrames = video1.NumberOfFrames;
vidHeight = video1.Height;
vidWidth = video1.Width;

%   Create object to write video files 
video2 = VideoWriter(outputName);

open(video2);

newImage = imread('haway.jpg');
newImage = im2double(newImage);
HowManyClusters = 2;

image = read(video1, 1);
image = im2double(image);
thisWindow = largeDarkFigure();
imshow(image);
hold on;
backVec = zeros(3,3);
frontVec = zeros(3,3);
for i=1:3,
xlabel('Choosing 3 representative Points that can stand for the back ground  Manually');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
clickX = uint32(clickX);    
clickY = uint32(clickY);    
backVec(i,:) = image(clickY,clickX,:);   
end
for i=1:3,
xlabel('Choosing 3 representative Points that can stand for the front ground  Manually');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
clickX = uint32(clickX);    
clickY = uint32(clickY);    
frontVec(i,:) = image(clickY,clickX,:);   
end
close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;


for k = 1 : nFrames
    % read the k-th frame of input video
  image = read(video1, k);

  image = im2double(image);
  height = size(image,1);
  width = size(image,2);
  length = height * width;
  probVec = ones(length,1);
  probVec = probVec./(length);
  kk = HowManyClusters;
  objFunc = 0;
 
 totalPick = 10;
 
 minObjFunc = 1e9;
 minCluster = zeros(length,1);
 minClusterCenter = uint32(zeros(kk,1));
 
 clusterCenter = uint32(zeros(kk,1));
 rData = zeros(length,1);
 gData = zeros(length,1);
 bData = zeros(length,1);

    
    
    for i=1:height,
     for j=1:width
        rData((i-1)*width+j) = image(i,j,1);
        gData((i-1)*width+j) = image(i,j,2);
        bData((i-1)*width+j) = image(i,j,3);
     end
 end

 
 
 for pick=1:totalPick,
 
     probVec = ones(length,1);
     probVec = probVec./(length);
     disVec = zeros(length,1);
     for i=1:kk,
        selected = randsample(length,1,true,probVec);
        clusterCenter(i) = selected;
        disVec = disVec + (rData-rData(selected)).^2 +  (gData-gData(selected)).^2 +  (bData-bData(selected)).^2;
        probVec = disVec./sum(disVec); 
     end


     iterate = 0;
     whichCluster = zeros(length,1);
     dist = zeros(length,1);
     minDis = zeros(length,1);
     flag = 0;
     while flag==0,
         iterate = iterate +1;  % QAQ 
         flag=1;
          minDis(:) = 1e9;
         for i=1:kk,
            dist = (rData - rData(clusterCenter(i))).^2 +(gData - gData(clusterCenter(i))).^2 + (bData - bData(clusterCenter(i))).^2 ;
            whichCluster(dist<minDis) = i;
            minDis(dist<minDis) = dist(dist<minDis);
         end


         for i=1:kk,
             num = numel(rData(whichCluster == i));
             newCenter = [sum(rData(whichCluster == i))/num;
                          sum(gData(whichCluster == i))/num;
                          sum(bData(whichCluster == i))/num;
                         ];
            disToCenter = (rData - newCenter(1)).^2 + (gData - newCenter(2)).^2 +(bData- newCenter(3)).^2;
            disToCenter(whichCluster ~=i)= 1e9;
            [ ~ , minIndex] = min(disToCenter);
            if minIndex ~= clusterCenter(i),
               flag = 0;
            end
            clusterCenter(i) = minIndex;
         end
     end
     objFunc = 0;
     for i=1:kk,
        objFunc =objFunc + sum((rData(whichCluster==i)-rData(clusterCenter(i))).^2) ;
        objFunc =objFunc + sum((gData(whichCluster==i)-gData(clusterCenter(i))).^2) ;
        objFunc =objFunc + sum((bData(whichCluster==i)-bData(clusterCenter(i))).^2) ;
     end

     if objFunc<minObjFunc,
        minObjFunc = objFunc;
        minCluster = whichCluster;
        minClusterCenter = clusterCenter;
     end
     
 end
 clusterIsBack = zeros(kk,1);
 
 for i=1:kk,
   frontTotal = (rData(minClusterCenter(i))-frontVec(1,1)).^2 +  (gData(minClusterCenter(i))-frontVec(1,2)).^2+(bData(minClusterCenter(i))-frontVec(1,3)).^2 +  (rData(minClusterCenter(i))-frontVec(2,1)).^2+ (gData(minClusterCenter(i))-frontVec(2,2)).^2 +  (bData(minClusterCenter(i))-frontVec(2,3)).^2+ (rData(minClusterCenter(i))-frontVec(3,1)).^2+ (gData(minClusterCenter(i))-frontVec(3,2)).^2 +  (bData(minClusterCenter(i))-frontVec(3,3)).^2
   backTotal = (rData(minClusterCenter(i))-backVec(1,1)).^2 +  (gData(minClusterCenter(i))-backVec(1,2)).^2+(bData(minClusterCenter(i))-backVec(1,3)).^2 +  (rData(minClusterCenter(i))-backVec(2,1)).^2+ (gData(minClusterCenter(i))-backVec(2,2)).^2 +  (bData(minClusterCenter(i))-backVec(2,3)).^2+ (rData(minClusterCenter(i))-backVec(3,1)).^2+ (gData(minClusterCenter(i))-backVec(3,2)).^2 +  (bData(minClusterCenter(i))-backVec(3,3)).^2
   if backTotal < frontTotal,
      clusterIsBack(i) = 1; 
   end
 end
 
 segImg = zeros(height,width,3);
 backCluster = minCluster(width*10 + 100);
   for i=1:height,
     for j=1:width,
        % clusterIndex =  minClusterCenter(minCluster((i-1)*width+j));
         %segImg(i,j,:) = image((clusterIndex/width)+1,mod(clusterIndex,width),:);
         if clusterIsBack(minCluster((i-1)*width+j)) == 1,
            segImg(i,j,1) = newImage(i,j,1);
            segImg(i,j,2) = newImage(i,j,2);
            segImg(i,j,3) = newImage(i,j,3);
         else,
            segImg(i,j,:) = image(i,j,:);
         end
     end
   end
    
    %figure();
    imshow(segImg);
    % write data from an array to the video
    writeVideo(video2, segImg);
end
close(video2)