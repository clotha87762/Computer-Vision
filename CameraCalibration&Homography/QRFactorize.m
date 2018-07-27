function [ Q , R ] = QRFactorize( M )
%QRFACTORIZE Summary of this function goes here
%   Detailed explanation goes here 

% Input : a 3 by 3 matrix

u1 = M(:,1);
e1 = u1/norm(u1);
u2 = M(:,2) - (M(:,2)' * e1)* e1;
e2 = u2/norm(u2);
u3 = M(:,3) - (M(:,3)' * e1) * e1 -(M(:,3)' * e2) * e2;
e3 = u3/norm(u3);
Q = [e1 , e2, e3];

R = Q' * M;

end

