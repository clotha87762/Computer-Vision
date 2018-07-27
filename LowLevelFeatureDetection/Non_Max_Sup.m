function [ out ] = Non_Max_Sup( img,a,b,grad_dir )
%ISLOCALMAX Summary of this function goes here
%   Detailed explanation goes here
    out = 0;
    %display(grad_dir);
    if a<=1||a>=size(img,1)||b<=1||b>=size(img,2),
       out = 0;
    else
    if (grad_dir>=-pi&&grad_dir<-((3/4)*pi))||(grad_dir>=0&&grad_dir<((1/4)*pi)),
       ele1 = img(a,b-1);
       ele2 = img(a-1,b-1);
       d = tan(grad_dir+pi);
       temp1 = d*ele2 +(1-d)*ele1;
       ele1 = img(a,b+1);
       ele2 = img(a+1,b+1);
       d = tan(grad_dir+pi);
       temp2 = d*ele2+(1-d)*ele1;
       out = (img(a,b)>temp1) && (img(a,b)>temp2);
    elseif (grad_dir>=(-(3/4)*pi)&&grad_dir<(-(2/4)*pi))||(grad_dir>=((1/4)*pi)&&grad_dir<((2/4)*pi)),
       ele1 = img(a-1,b-1);
       ele2 = img(a-1,b);
       d = tan(-1*((pi/2)+grad_dir));
       temp1 = ele1*d +ele2*(1-d);
       ele1 = img(a+1,b+1);
       ele2 = img(a+1,b);
       temp2 = ele1*d + ele2*(1-d);
       out = (img(a,b)>temp1) && (img(a,b)>temp2);
    elseif (grad_dir>=(-(2/4)*pi)&&grad_dir<(-(1/4)*pi))||(grad_dir>=((2/4)*pi)&&grad_dir<((3/4)*pi)),
       ele1 = img(a-1,b);
       ele2 = img(a-1,b+1);
       d = tan(grad_dir+(pi/2));
       temp1 = ele1*(1-d) + ele2*d;
       ele1 = img(a+1,b);
       ele2 = img(a+1,b-1);
       temp2 = ele1*(1-d) + ele2*d;
       out = (img(a,b)>temp1) && (img(a,b)>temp2);
    elseif (grad_dir>=(-(1/4)*pi)&&grad_dir<0)||(grad_dir>=((3/4)*pi)&&grad_dir<=pi),
       ele1 = img(a-1,b+1);
       ele2 = img(a,b+1);
       d = tan((-1*grad_dir));
       temp1 = ele1*d + ele2* (1-d);
       ele1 = img(a+1,b-1);
       ele2 = img(a,b-1);
       temp2 = ele1*d + ele2*(1-d);
       out = (img(a,b)>temp1) && (img(a,b)>temp2);
    end
    
     %{ 
    elseif grad_dir>=0&&grad_dir<((1/4)*pi),
       ele1 = img(a,b+1);
       ele2 = img(a+1,b+1);
    elseif grad_dir>=((1/4)*pi)&&grad_dir<((2/4)*pi),
       ele1 = img(a+1,b+1);
       ele2 = img(a+1,b);
    elseif grad_dir>=((2/4)*pi)&&grad_dir<((3/4)*pi),
       ele1 = img(a+1,b);
       ele2 = img(a+1,b-1);
    elseif grad_dir>=((3/4)*pi)&&grad_dir<=pi,
       ele1 = img(a+1,b-1);
       ele2 = img(a,b-1);
    end
    %}
end

