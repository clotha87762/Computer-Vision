%% 3-A
clear all;


h = 0.35;

image = imread('AhriPoro.jpg');
image = im2double(image);
height = size(image,1);
width = size(image,2);
length = height * width;
rgbData = zeros(length,3);
for i=1:height,
    for j=1:width,
       rgbData((i-1)*width+j,:) = image(i,j,:);
    end
end
dis = zeros(length,1);
whichMode = zeros(length,1);
iterate = 0;
finalLoc = zeros(length,3);
 labels = zeros(length,1);
 c = 4;
 t = 0;
 
for i=1:length,
     
    iterate = iterate +1; 
    
     if labels(i)~=0,
        continue;
    end
    
    
    flag = 0;
    temp = rgbData(i,:);
    meanShift = zeros(1,3);
  
    momotaro = zeros(length,1);
    while flag==0,
        index = find(h>sqrt(sum((rgbData-repmat(temp,[length 1])).^2,2)));
        inWindow = rgbData(index,:);
        sigma = sum(inWindow,1);
        num = size(inWindow,1);
        meanShift = sigma ./ num;
        if sum((meanShift-temp).^2)<0.1,
           flag = 1; 
        end
        % momotaro(find((h/c)>sqrt(sum((inWindow-repmat(temp,[num 1])).^2,2)))) =1;
        temp = meanShift;
    end
  
    momotaro(index) = 1;
    momotaro(find(labels~=0))=0;
    old = 0;
    if t>0,
        for k=1:t,
           if sqrt((meanShift-labelColor(k,:)).^2)<h/2,
             % disp('qq');
              old = k;
              break;
           end
        end
    end
    
    if old~=0,
        labels(find(momotaro==1)) = old; 
    else
        t= t+1;
        labels(find(momotaro==1)) = t;
        %num2 = numel(find(labels==t));
        %finalLoc(labels==t,:) = repmat(meanShift,[num2 1]); 
        labelColor(t,:) = meanShift; 
    end
end
 
 %{
 clusters = zeros(length,1);
while size(finalLoc,1)~=0,
    t = t+1;
    a = finalLoc(1,:);
    delta = (finalLoc(:,1) - a(1)).^2 +  (finalLoc(:,2) - a(2)).^2 + (finalLoc(:,3) - a(3)).^2 ;
    clusters(find(delta<h/2)) = t;
    finalLoc(find(delta<h/2),:) = [];
end
 %}
segImg = image;
for i=1:height,
    for j=1:width,
        segImg(i,j,:) =labelColor(labels((i-1)*width+j),:);
    end
end


    figure();
    imshow(segImg);





%% 3-B



clear all;


hs = 0.3;
hr = 8;
image = imread('AhriPoro.jpg');
image = im2double(image);
height = size(image,1);
width = size(image,2);
length = height * width;
Data = zeros(length,5);
for i=1:height,
    for j=1:width,
       Data((i-1)*width+j,1:3) = image(i,j,:);
       Data((i-1)*width+j,4) = i/height;
        Data((i-1)*width+j,5) = j/width; 
    end
end
dis = zeros(length,1);
whichMode = zeros(length,1);
iterate = 0;
finalLoc = zeros(length,3);
 labels = zeros(length,1);
 c = 4;
 t = 0;
 count = 0;
for i=1:length,
     
    iterate = iterate +1; 
    
     if labels(i)~=0,
        continue;
    end
    
    
    flag = 0;
    temp = Data(i,:);
    meanShift = zeros(1,5);
   % tempIndex = zeros(length,1);
    momotaro = zeros(length,1);
    while flag==0,
       % spaceIndex = find(hr>sqrt(sum((Data(:,4:5)-repmat(temp(4:5),[length 1])).^2,2)));
       % colorIndex = find(hs>sqrt(sum((Data(:,1:3)-repmat(temp(1:3),[length 1])).^2,2)));
        index = find(hs>sqrt(sum((Data-repmat(temp,[length 1])).^2,2)));
       % index = intersect(colorIndex,spaceIndex);
        inWindow = Data(index,:);
        sigma = sum(inWindow,1);
        num = size(inWindow,1);
        meanShift = sigma ./ num;
        if (sum((meanShift(1:3)-temp(1:3)).^2))<0.1,
           flag = 1; 
        end
        %tempIndex = find(hs/c>sqrt(sum((Data-repmat(temp,[length 1])).^2,2)));
        % Do we need spatial momotaro??
        %tempIndex = intersect(colorIndex,spaceIndex);
       % momotaro(tempIndex) =1;
        temp = meanShift;
        
    end
  
    momotaro(index) = 1;
    %momotaro(find(labels~=0))=0;
    old = 0;
    if t>0,
        for k=1:t,
           if sqrt((meanShift(1:3)-labelColor(k,1:3)).^2)<hs/2,
              %disp('qq');
              old = k;
              break;
           end
        end
    end
    count = count +numel(find(momotaro==1));
   % disp(count);
    if old~=0,
        labels(find(momotaro==1)) = old; 
    else
        t= t+1;
        labels(find(momotaro==1)) = t;
        %num2 = numel(find(labels==t));
        %finalLoc(labels==t,:) = repmat(meanShift,[num2 1]); 
        labelColor(t,:) = meanShift(:); 
    end
end
 
 %{
 clusters = zeros(length,1);
while size(finalLoc,1)~=0,
    t = t+1;
    a = finalLoc(1,:);
    delta = (finalLoc(:,1) - a(1)).^2 +  (finalLoc(:,2) - a(2)).^2 + (finalLoc(:,3) - a(3)).^2 ;
    clusters(find(delta<h/2)) = t;
    finalLoc(find(delta<h/2),:) = [];
end
 %}
segImg = image;
for i=1:height,
    for j=1:width,
        segImg(i,j,:) =labelColor(labels((i-1)*width+j),1:3);
    end
end

figure();
    imshow(segImg);

%% 3-C-A

clear all;


h = 0.11;

image = imread('AhriPoro.jpg');
image = im2double(image);
height = size(image,1);
width = size(image,2);
length = height * width;
rgbData = zeros(length,3);
imageLUV = colorspace('Luv<-RGB',image);

for i=1:height,
    for j=1:width,
       rgbData((i-1)*width+j,:) = imageLUV(i,j,:);
    end
end
rgbData(find(isnan(rgbData)))=0;
MAX =max(rgbData(:));
MIN =min(rgbData(:));
rgbData = (rgbData - MIN)/(MAX - MIN);

dis = zeros(length,1);
whichMode = zeros(length,1);
iterate = 0;
finalLoc = zeros(length,3);
 labels = zeros(length,1);
 c = 4;
 t = 0;
 count = 0;
for i=1:length,
     
    iterate = iterate +1; 
    
     if labels(i)~=0,
        continue;
     end
    
    flag = 0;
    temp = rgbData(i,:);
    meanShift = zeros(1,3);
  
    momotaro = zeros(length,1);
   
    while flag==0,
        index = find(h>sqrt(sum((rgbData-repmat(temp,[length 1])).^2,2)));
        inWindow = rgbData(index,:);
        sigma = sum(inWindow,1);
        num = size(inWindow,1);
        %disp(num);
        meanShift = sigma ./ num;
        if sum((meanShift-temp).^2)<0.1,
           flag = 1; 
        end
        % momotaro(find((h/c)>sqrt(sum((inWindow-repmat(temp,[num 1])).^2,2)))) =1;
        temp = meanShift;
    end
  
    momotaro(index) = 1;
    momotaro(find(labels~=0))=0;
    count = count +numel(find(momotaro==1));
    disp(count);
    old = 0;
    if t>0,
        for k=1:t,
           if sqrt((meanShift-labelColor(k,:)).^2)<h,
              old = k;
              break;
           end
        end
    end
    
    if old~=0,
        labels(find(momotaro==1)) = old; 
    else
        t= t+1;
        labels(find(momotaro==1)) = t;
        labelColor(t,:) = meanShift; 
    end
end

segImg = image;
labelColor = labelColor*(MAX-MIN) +MIN;

for i=1:height,
    for j=1:width,
        segImg(i,j,:) =labelColor(labels((i-1)*width+j),:);
    end
end
segImg = colorspace('RGB<-Luv',segImg);

figure();
    imshow(segImg);

%%  3-C-B


clear all;


h = 0.1;

image = imread('AhriPoro.jpg');
image = im2double(image);
height = size(image,1);
width = size(image,2);
length = height * width;
rgbData = zeros(length,3);
Data = zeros(length,5);
imageLUV = colorspace('Luv<-RGB',image);

for i=1:height,
    for j=1:width,
       rgbData((i-1)*width+j,:) = imageLUV(i,j,:);
    end
end
rgbData(find(isnan(rgbData)))=0;
MAX =max(rgbData(:));
MIN = min(rgbData(:));
rgbData = (rgbData - MIN)/(MAX - MIN);

for i=1:height,
    for j=1:width,
       Data((i-1)*width+j,1:3) = rgbData((i-1)*width+j,:);
       Data((i-1)*width+j,4) = i/height; 
       Data((i-1)*width+j,5) = j/width;
    end
end


iterate = 0;

 labels = zeros(length,1);
 c = 4;
 t = 0;
 count = 0;
for i=1:length,
     
    iterate = iterate +1; 
    
     if labels(i)~=0,
        continue;
     end
   
    flag = 0;
    temp = Data(i,:);
    meanShift = zeros(1,5);
  
    momotaro = zeros(length,1);
   
    while flag==0,
        index = find(h>sqrt(sum((Data-repmat(temp,[length 1])).^2,2)));
        inWindow = Data(index,:);
        sigma = sum(inWindow,1);
        num = size(inWindow,1);
        %disp(num);
        meanShift = sigma ./ num;
        if sum((meanShift-temp).^2)<0.1,
           flag = 1; 
        end
        % momotaro(find((h/c)>sqrt(sum((inWindow-repmat(temp,[num 1])).^2,2)))) =1;
        temp = meanShift;
    end
  
    momotaro(index) = 1;
    momotaro(find(labels~=0))=0;
    count = count +numel(find(momotaro==1));
    disp(count);
    old = 0;
    if t>0,
        for k=1:t,
           if sqrt((meanShift(1:3)-labelColor(k,1:3)).^2)<h,
              old = k;
              break;
           end
        end
    end
    
    if old~=0,
        labels(find(momotaro==1)) = old; 
    else
        t= t+1;
        labels(find(momotaro==1)) = t;
        labelColor(t,:) = meanShift; 
    end
end

segImg = image;
labelColor = labelColor(:,1:3);
labelColor = labelColor*(MAX-MIN) +MIN;

for i=1:height,
    for j=1:width,
        segImg(i,j,:) =labelColor(labels((i-1)*width+j),:);
    end
end
segImg = colorspace('RGB<-Luv',segImg);

figure();
    imshow(segImg);
