function [ R Q ] = RQFactorize( M )
%RQFACTORIZE Summary of this function goes here
%   Detailed explanation goes here
    [Q,R] = QRFactorize(flipud(M)')
    R = flipud(R');
    R = fliplr(R);
    Q = Q';   
    Q = flipud(Q);
    R = -R;
    Q = -Q;
end

