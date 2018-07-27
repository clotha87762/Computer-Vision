%%Problem 2-1
   clear all;    

    image = imread('GangPoro.png');
   image = rgb2gray(image);
   image = im2double(image);
    wSize = 3;
    Sigma = 1;
    [minEigD ,minEigV, maxEigD, maxEigV , P1] = Harris(image,wSize,Sigma);
    
   
    figure('Name','Coner using smaller Eigenvalue with 3x3 Window & Gaussian weight of sigma = 1');
    imshow(markOnImage(image,minEigD));
    
    % Window  Size = 5
    Sigma = 3;
    
    [minEigD2, minEigV2, maxEigD2 ,maxEigV2 ,P2] =  Harris(image,wSize,Sigma);
    figure('Name','Coner using smaller Eigenvalue with 3x3 Window & Gaussian weight of sigma = 3');
    imshow(markOnImage(image,minEigD2));
 
    wSize = 5;
    Sigma = 1;
   [minEigD3, minEigV3, maxEigD3, maxEigV3, P3] =  Harris(image,wSize,Sigma);
    figure('Name','Coner using smaller Eigenvalue with 5x5 Window & Gaussian weight of sigma = 1');
    imshow(markOnImage(image,minEigD3));
   
    
    Sigma = 3;
    [minEigD4, minEigV4, maxEigD4, maxEigV4, P4] =  Harris(image,wSize,Sigma);
    figure('Name','Coner using smaller Eigenvalue with 5x5 Window & Gaussian weight of sigma = 3');
    imshow(markOnImage(image,minEigD4));

%% Problem 2-2 (Please Run Problem 2-1 before running this)
    figure('Name','Coner using Response Function with 3x3 Window & Gaussian weight of sigma = 1');
    imshow(markOnImage(image,P1));
    figure('Name','Coner using Response Function with 3x3 Window & Gaussian weight of sigma = 3');
    imshow(markOnImage(image,P2));
    figure('Name','Coner using Response Function with 5x5 Window & Gaussian weight of sigma = 1');
    imshow(markOnImage(image,P3));
    figure('Name','Coner using Response Function with 5x5 Window & Gaussian weight of sigma =3');
    imshow(markOnImage(image,P4));

%% Problem 2-3

    minEigDNMS = minEigD;
    check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if minEigD(i+a,j+b)>minEigD(i,j),
                       check(i,j) = 0;
                       
                    end   
                end
            end
        end
    end
 
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(minEigD(i,j)<0.1);
               minEigDNMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using smaller Eigvalue with 3x3 window and sigma = 1');
    minEigDNMS(minEigDNMS<0.1) = 0;
    imshow(markOnImage(image,minEigDNMS));
 
     minEigD2NMS = minEigD2;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if minEigD2(i+a,j+b)>minEigD2(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(minEigD2(i,j)<0.1);
               minEigD2NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using smaller Eigvalue with 3x3 window and sigma = 3');
    minEigD2NMS(minEigD2NMS<0.1) = 0;
    imshow(markOnImage(image,minEigD2NMS));
    
    
     minEigD3NMS = minEigD3;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if minEigD3(i+a,j+b)>minEigD3(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(minEigD3(i,j)<0.1);
               minEigD3NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using smaller Eigvalue with 5x5 window and sigma = 1');
    minEigD3NMS(minEigD3NMS<0.1) = 0;
    imshow(markOnImage(image,minEigD3NMS));
    
    
     minEigD4NMS = minEigD4;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if minEigD4(i+a,j+b)>minEigD4(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(minEigD4(i,j)<0.1);
               minEigD4NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using smaller Eigvalue with 5x5 window and sigma = 3');
    minEigD4NMS(minEigD4NMS<0.1) = 0;
    imshow(markOnImage(image,minEigD4NMS));
    
    
    
    P1NMS = P1;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if P1(i+a,j+b)>P1(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(P1(i,j)<0.1);
               P1NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using response  function with 3x3 window and sigma = 1');
    P1NMS(P1NMS<0.1)=0;
    imshow(markOnImage(image,P1NMS));
    
      P2NMS = P2;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if P2(i+a,j+b)>P2(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(P2(i,j)<0.1);
               P2NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using response  function with 3x3 window and sigma = 3');
     P2NMS(P2NMS<0.1)=0;
    imshow(markOnImage(image,P2NMS));
    
      P3NMS = P3;
     check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if P3(i+a,j+b)>P3(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(P3(i,j)<0.1);
               P3NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using response  function with 5x5 window and sigma = 1');
     P3NMS(P3NMS<0.1)=0;
    imshow(markOnImage(image,P3NMS));
    
    
    P4NMS = P4;
    check = ones(size(image,1),size(image,2));
    for i=2:size(image,1)-1,
        for j=2:size(image,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if P4(i+a,j+b)>P4(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(image,1),
        for j=1:size(image,2),
            if check(i,j) == 0||(P4(i,j)<0.1);
               P4NMS(i,j) = 0; 
            end
        end
    end
    figure('Name','Local Max Coner Using response  function with 5x5 window and sigma = 3');
    P4NMS(P4NMS<0.1)=0;
    imshow(markOnImage(image,P4NMS));
    
    %% Problem 2-4
    rImage = imrotate(image,30);
    sImage = imresize(image,0.5);
    wSize = 3;
    Sigma = 1;
    [~, ~, ~, ~, rP1] =  Harris(rImage,wSize,Sigma);
    rP1 = imrotate(rP1,330);
    figure('Name','Rotated Corner using response function with 3x3 window and sigma = 1');
    imshow(rP1);
    [~,~,~,~,sP1] = Harris(sImage,wSize,Sigma);
    sP1 = imresize(sP1,2);
    figure('Name','Scaled Corner using response function with 3x3 window and sigma = 1');
    imshow(markOnImage(image,sP1));
    Sigma = 3;
    [~, ~, ~, ~, rP2] = Harris(rImage,wSize,Sigma);
    rP2 = imrotate(rP2,-30);
    figure('Name','Rotated Corner using response function with 3x3 window and sigma = 3');
    imshow(rP2);
    [~,~,~,~,sP2] = Harris(sImage,wSize,Sigma);
    sP2 = imresize(sP2,2);
    figure('Name','Scaled Corner using response function with 3x3 window and sigma = 3');
    imshow(markOnImage(image,sP2));
    wSize = 5;
    Sigma = 1;
    [~, ~, ~, ~, rP3] = Harris(rImage,wSize,Sigma);
    rP3 = imrotate(rP3,-30);
    figure('Name','Rotated Corner using response function with 5x5 window and sigma = 1');
    imshow(rP3);
   [~,~,~,~,sP3] = Harris(sImage,wSize,Sigma);
    sP3 = imresize(sP3,2);
    figure('Name','Scaled Corner using response function with 5x5 window and sigma = 1');
    imshow(markOnImage(image,sP3));
    Sigma = 3;
    [~, ~, ~, ~, rP4] = Harris(rImage,wSize,Sigma);
    rP4 = imrotate(rP4,-30);
    figure('Name','Rotated Corner using response function with 5x5 window and sigma = 3');
    imshow(rP4);
    [~,~,~,~,sP4] = Harris(sImage,wSize,Sigma);
    sP4 = imresize(sP4,2);
    figure('Name','Scaled Corner using response function with 5x5 window and sigma = 3');
    imshow(markOnImage(image,sP4));
    
    %% Probelm 2-5   Dicussed in my Report
    check = ones(size(rP1,1),size(rP1,2));
    rP1NMS = rP1;
    for i=2:size(rP1,1)-1,
        for j=2:size(rP1,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if rP1(i+a,j+b)>rP1(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(rP1,1),
        for j=1:size(rP1,2),
            if check(i,j) == 0||(rP1(i,j)<0.1);
               rP1NMS(i,j) = 0; 
            end
        end
    end
    
     check = ones(size(sP1,1),size(sP1,2));
    sP1NMS = sP1;
    for i=2:size(sP1,1)-1,
        for j=2:size(sP1,2)-1,
            for a=-1:1,
                for b=-1:1,
                    if sP1(i+a,j+b)>sP1(i,j),
                       check(i,j) = 0;
                    end   
                end
            end
        end
    end
    for i=1:size(sP1,1),
        for j=1:size(sP1,2),
            if check(i,j) == 0||(sP1(i,j)<0.1);
               sP1NMS(i,j) = 0; 
            end
        end
    end
    
    figure('Name','Rotated');
    imshow(rP1NMS.*5);
    figure('Name','Scaled');
    imshow(sP1NMS.*5);
    figure('Name','original');
    imshow(P1NMS.*5);
    %{
    mixed = zeros(size(image,1),size(image,2),3);
    temp = imread('GangPoro.png');
    mixed(:,:,1) = P1;
    mixed(:,:,2) = rP1;
    mixed(:,:,3) = sP1;
    temp = temp.*0.2 + mixed.*0.8;
    figure('Name','Difference between the detected points of original(Red),rotated(Green),and scaled(Blue) ');
    subplot_tight(1,3,1,0);
    imshow(P1);
    subplot_tight(1,3,2,0);
    imshow(rP1);
    subplot_tight(1,3,3,0);
    imshow(sP1);
    %}