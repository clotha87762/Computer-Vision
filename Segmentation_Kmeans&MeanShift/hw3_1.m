%% USING MATLAB KMEANS TO JUSTIFY MY ANSWER
clear all;
image = imread('AhriPoro.jpg');
 image = im2double(image);
 height = size(image,1);
 width = size(image,2);
 data=zeros(height*width,3);
 kk = 11;
 for i=1:height,
     for j =1:width,
        data((i-1)*width+j,:) = image(i,j,:);
     end
 end
 [idx ,~, ~, d] = kmeans(data,kk);
 
 clusterCenter = uint32(zeros(kk,1));
  for i=1:kk,
        
            disToCenter = d(:,i);
            disToCenter(idx ~=i)= 1e9;
            [ ~ , minIndex] = min(disToCenter);
            clusterCenter(i) = minIndex;
 end
 
 
 
 segImg = zeros(height,width,3);
   for i=1:height,
     for j=1:width,
         clusterIndex =  clusterCenter(idx((i-1)*width+j));
         segImg(i,j,:) = image((clusterIndex/width)+1,mod(clusterIndex,width),:);
     end
   end
%%  1-A
 clear all;
 
 
 HowManyClusters = 11;
 
 
 
 
 image = imread('LuluPoro.jpg');
 image = im2double(image);
 height = size(image,1);
 width = size(image,2);
 length = height * width;
 probVec = ones(length,1);
 probVec = probVec./(length);
 kk = HowManyClusters;
 objFunc = 0;
 
 totalPick = 50;
 
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
 
 segImg = zeros(height,width,3);
 
   for i=1:height,
     for j=1:width,
         clusterIndex =  minClusterCenter(minCluster((i-1)*width+j));
         segImg(i,j,:) = image((clusterIndex/width)+1,mod(clusterIndex,width),:);
     end
   end
    
  for i=1:kk,
    clusterIndex =  minClusterCenter(i);
     image((clusterIndex/width),mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+2,:) = 1;
  end
  figure();
 imshow(segImg);

%%  1-B
 clear all;
 
 HowManyClusters = 11;
 
 image = imread('LuluPoro.jpg');
 image = im2double(image);
 height = size(image,1);
 width = size(image,2);
 length = height * width;
 probVec = ones(length,1);
 probVec = probVec./(length);
 kk = HowManyClusters;
 objFunc = 0;
 
 
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

thisWindow = largeDarkFigure();
imshow(image);
hold on;
 for i=1:kk,
    xlabel('Choosing Initial Cluster Points Manually)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    clusterCenter(i) = clickY*width + clickX ;
end
close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

     iterate = 0;
     whichCluster = zeros(length,1);
     dist = zeros(length,1);
     minDis = zeros(length,1);
     
     flag = 0;
     while flag==0,
         iterate = iterate +1;  % QAQ 
         minDis(:) =  1e9;
         flag=1;
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
 
  
 
 segImg = zeros(height,width,3);
 
   for i=1:height,
     for j=1:width,
         clusterIndex =  clusterCenter(whichCluster((i-1)*width+j));
         segImg(i,j,:) = image((clusterIndex/width),mod(clusterIndex,width),:);
     end
     
   end
   
   for i=1:kk,
    clusterIndex =  clusterCenter(i);
     image((clusterIndex/width),mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+2,:) = 1;
  end
    figure();
 imshow(segImg);
   
%% 1-C-A

clear all;
 
 
 HowManyClusters = 11;
 
 
 
 
 image = imread('LuluPoro.jpg');
 image = im2double(image);
 
 
 
 height = size(image,1);
 width = size(image,2);
 length = height * width;
 rData = zeros(length,1);
 gData = zeros(length,1);
 bData = zeros(length,1);

 LUVdata = image;
 imageLUV = colorspace('Luv<-RGB',image);
for i=1:height,
     for j=1:width
       
        rData((i-1)*width+j) =  imageLUV(i,j,1);
        gData((i-1)*width+j) = imageLUV(i,j,2);
        bData((i-1)*width+j) =  imageLUV(i,j,3);
    
     end
end
 rData(find(isnan(rData))) = 0;
 gData(find(isnan(gData))) = 0;
 bData(find(isnan(bData))) = 0;
 
 probVec = ones(length,1);
 probVec = probVec./(length);
 kk = HowManyClusters;
 objFunc = 0;
 
 totalPick = 50;
 
 minObjFunc = 1e12;
 minCluster = zeros(length,1);
 minClusterCenter = uint32(zeros(kk,1));
 
 clusterCenter = uint32(zeros(kk,1));

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
     whichCluster = ones(length,1);
     dist = zeros(length,1);
     minDis = zeros(length,1);
    
     flag = 0;
     while flag==0,
         iterate = iterate +1;  % QAQ 
         flag=1;
          minDis(:) =  1e9;
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
 
 segImg = zeros(height,width,3);
 
   for i=1:height,
     for j=1:width,
         clusterIndex =  minClusterCenter(minCluster((i-1)*width+j));
         segImg(i,j,:) = image((clusterIndex/width),mod(clusterIndex,width),:);
     end
   end
   
   
    for i=1:kk,
    clusterIndex =  minClusterCenter(i);
     image((clusterIndex/width),mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width),:) = 1;
     image((clusterIndex/width),mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+2,:) = 1;
     image((clusterIndex/width)+2,mod(clusterIndex,width)+1,:) = 1;
     image((clusterIndex/width)+1,mod(clusterIndex,width)+2,:) = 1;
  end
    figure();
    imshow(segImg);
   
   
   
%%  1-C-B

 clear all;
 
 HowManyClusters = 7;
 
 image = imread('LuluPoro.jpg');
 image = im2double(image);
 height = size(image,1);
 width = size(image,2);
 length = height * width;
 probVec = ones(length,1);
 probVec = probVec./(length);
 kk = HowManyClusters;
 objFunc = 0;
 
 
 clusterCenter = uint32(zeros(kk,1));
 rData = zeros(length,1);
 gData = zeros(length,1);
 bData = zeros(length,1);

 imageLUV = colorspace('Luv<-RGB',image);
for i=1:height,
     for j=1:width
       
        rData((i-1)*width+j) =  imageLUV(i,j,3);
        gData((i-1)*width+j) = imageLUV(i,j,1);
        bData((i-1)*width+j) =  imageLUV(i,j,2);
    
     end
end
 rData(find(isnan(rData))) = 0;
 gData(find(isnan(gData))) = 0;
 bData(find(isnan(bData))) = 0;
 
 
thisWindow = largeDarkFigure();
imshow(image);
hold on;
 for i=1:kk,
    xlabel('Choosing Initial Cluster Points Manually)');
    [ clickX, clickY ] = ginput(1);
    scatter( clickX, clickY, 100, 'lineWidth', 4 );
    drawnow;
    clusterCenter(i) = clickY*width + clickX ;
end
close(thisWindow);
clear clickX; 
clear clickY;
clear thisWindow;

     iterate = 0;
     whichCluster = zeros(length,1);
     dist = zeros(length,1);
     minDis = zeros(length,1);
     minDis = minDis + 100;
     flag = 0;
     while flag==0,
         iterate = iterate +1;  % QAQ 
         flag=1;
         minDis(:) =  1e9;
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
 
  
 
 segImg = zeros(height,width,3);
 
   for i=1:height,
     for j=1:width,
         clusterIndex =  clusterCenter(whichCluster((i-1)*width+j));
         segImg(i,j,:) = image((clusterIndex/width),mod(clusterIndex,width),:);
     end
     
   end
   
   figure();
    imshow(segImg);

