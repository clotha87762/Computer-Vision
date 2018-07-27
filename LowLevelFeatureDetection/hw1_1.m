%% Problem1-1

   clear all;
   image = imread('GangPoro.png');
   image = rgb2gray(image);
   image = im2double(image);
   height = size(image,1);
   width = size(image,2);
   imshow(image);
   h = 5; % Change Kernel Size Here
   w = 5; % Change Kernel Size Here
   sigma = 2; %Change sigma here
   smoothed_img = Gaussian(image,[h w],sigma);
   figure('Name','Gaussain h=5,w=5,sigma=2');
   imshow(smoothed_img);
   sigma = 5;
   smoothed_img2 = Gaussian(image,[h w],sigma);
   figure('Name','Gaussian  h=5,w=5,sigma=5');
   imshow(smoothed_img2);
   sigma =2;
   h=15;
   w=15;
   smoothed_img3 = Gaussian(image,[h w],sigma);
   figure('Name','Gaussian h=15,w=15,sigma=2');
   imshow(smoothed_img3);
   sigma = 5;
   smoothed_img4 = Gaussian(image,[h w],sigma);
   figure('Name','Gaussianh=15,w=15,sigma=5');
   imshow(smoothed_img4);
   
   
   
   
%%  Problem1-2   Sobel Operator 
     hsvMap = linspace( 0, 1, 99 )' ;
    hsvMap(:, 2) = 0.5;
    hsvMap(:, 3) = 1;
    rgbMap = hsv2rgb(hsvMap);
    rgbMap = [ 0.2 0.2 0.2 ; rgbMap ];
    
    gradient_x = Sobel(smoothed_img,0);
    gradient_y = Sobel(smoothed_img,1);
    gradient_dir  = atan2(gradient_x,gradient_y);
    gradient_mag = (sqrt(gradient_x.^2 +gradient_y.^2));
    gradient_dir_visual = (gradient_dir+pi) * 0.99 / (2*pi) + 0.01;
    gradient_dir_visual( gradient_mag<0.1 ) = 0;
    figure('Name','Gaussian Kernel Size 5*5,Sigma = 2  Magnitude');
    imshow(gradient_mag);
    figure('Name','Gaussian Kernel Size 5*5,Sigma=2 Direction');
    imshow(gradient_dir_visual,'ColorMap',rgbMap);
    
    gradient_x = Sobel(smoothed_img3,0);
    gradient_y = Sobel(smoothed_img3,1);
    gradient_dir  = atan2(gradient_x,gradient_y);
    gradient_mag = (sqrt(gradient_x.^2 +gradient_y.^2));
    gradient_dir_visual = (gradient_dir+pi) * 0.99 / (2*pi) + 0.01;
    gradient_dir_visual( gradient_mag<0.1 ) = 0;
    figure('Name','Gaussian Kernel Size 15*15,Sigma=2 Magnitude');
    imshow(gradient_mag);
    figure('Name','Gaussian Kernel Size 15*15,Sigma=2 Direction');
    imshow(gradient_dir_visual,'ColorMap',rgbMap);
    
    
    
%% Problem 1-3
    checked = double(ones(height,width));
    %%checked(gradient_mag<0.2) = 0; % THRESHOLD TOO HIGH?
    grad_mag = gradient_mag;
    grad_mag(grad_mag<0.1)=0;
    for i=1:height,
        for j=1:width,
            out = Non_Max_Sup(grad_mag,i,j,gradient_dir(i,j));
            if out==1,
               checked(i,j)=1; 
            else
               checked(i,j)=0; 
            end
        end
    end
    figure('Name','Edge Thinning with Threshold 0.1');
    imshow(checked);
    
    grad_mag = gradient_mag;
    grad_mag(grad_mag<0.2)=0;
    for i=1:height,
        for j=1:width,
            out = Non_Max_Sup(grad_mag,i,j,gradient_dir(i,j));
            if out==1,
               checked(i,j)=1; 
            else
               checked(i,j)=0; 
            end
        end
    end
    figure('Name','Edge Thinning with Threshold 0.2');
    imshow(checked);