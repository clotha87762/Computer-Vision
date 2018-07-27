function [ minEigD minEigV maxEigD maxEigV P ] = Harris( image,wSize,Sigma)
%HARRIS Summary of this function goes here
%   Detailed explanation goes here
     K = 0.04;
    sobelx = [-1 0 1;-2 0 2;-1 0 1];
    sobely = [-1 -2 -1;0 0 0;1 2 1];
    Ix = imfilter(image,sobelx);
    Iy = imfilter(image,sobely);
    HD = zeros(size(image,1),size(image,2));
    HV = zeros(size(image,1),size(image,2));
    minEigV = zeros(size(image,1),size(image,2),2);
    minEigD = zeros(size(image,1),size(image,2));
    maxEigV = zeros(size(image,1),size(image,2),2);
    maxEigD = zeros(size(image,1),size(image,2));
    P = zeros(size(image,1),size(image,2));
    %i = uint8(1+wSizw/2);
    %j = uint8(1+wSize/2);
    if wSize==3&&Sigma==1,
    mask = fspecial('gaussian',[3 3],1);
    elseif wSize==3&&Sigma==3,
    mask = fspecial('gaussian',[3 3],3);    
    elseif wSize==5&&Sigma==1,
     mask = fspecial('gaussian',[5 5],1);   
    elseif wSize==5&&Sigma==3,
      mask = fspecial('gaussian',[5 5],3);   
    end
    
    for i =uint32(1+wSize/2):uint32(size(image,1)-(wSize/2)),
        for j=uint32(1+wSize/2):uint32(size(image,2)-(wSize/2)),
            Ixy = 0;Ixx=0;Iyy=0;
            for a= floor(-wSize/2):floor(wSize/2),
                for b = floor(-wSize/2):floor(wSize/2),
                    w=double(0);
                if wSize==3,   
                    if (abs(a)+abs(b)==0) ,
                        w=mask(2,2);
                    elseif abs(a)+abs(b)==1,
                        w=mask(2,1);
                    elseif abs(a)+abs(b)==2,
                        w=mask(1,1);
                    end
                elseif wSize==5,
                    if (abs(a)+abs(b)==4) ,
                        w=mask(1,1);
                    elseif (abs(a)+abs(b)==3),
                        w=mask(2,1);
                    elseif abs(a)==2||abs(b)==2,
                        w=mask(3,1);
                    elseif abs(a)==1&&abs(b)==1,
                        w=mask(2,2);
                    elseif abs(a)==1||abs(b)==1,
                        w=mask(2,3);
                    elseif abs(a)==0&&abs(b)==0,
                        w=mask(3,3);
                    end
                    
                end
                   %%w = 1/500;
                Ixy = Ixy + w*Ix(i+a,j+b) * Iy(i+a,j+b);
                Ixx = Ixx + w*Ix(i+a,j+b) * Ix(i+a,j+b);
                Iyy = Iyy + w*Iy(i+a,j+b) * Iy(i+a,j+b);
                end
            end
       
            H = [ Ixx Ixy;Ixy Iyy];
            [HV HD] = eig(H);
            if HD(1,1)>=HD(2,2),
                minEigD(i,j) = HD(2,2);
                minEigV(i,j,:) = HV(:,2);
                maxEigD(i,j) = HD(1,1);
                maxEigV(i,j,:) = HV(:,1);
            else
                minEigD(i,j) = HD(1,1);
                minEigV(i,j,:) = HV(:,1);
                maxEigD(i,j) = HD(2,2);
                maxEigV(i,j,:) = HV(:,2);
            end
             P(i,j) = 20*(det(H) - K*(trace(H)^2));
            
        end
    end
    minEigD = minEigD.*20;

end

