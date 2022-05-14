%Xmatrei: 観測非負値行列　basisMat:基底行列　numIterative:ループ回数
function [outMat, actMat1, actMat2, J] = supervisedEuNMF(Xmatrix, basisMat1, basisMat2, numIterative) 

[~, basisYSize] = size(basisMat1); %観測行列のサイズ
[~, ySize] = size(Xmatrix);

actMat1 = rand(basisYSize, ySize);
actMat2 = rand(basisYSize, ySize); %分解後の行列G1,G2の初期値

ips = 10^(-21); %0割り回避のための数
J = zeros(numIterative, 1); %コスト関数初期化
outMat = (basisMat1 * actMat1) + (basisMat2 * actMat2);


for i = 1 : numIterative
    actMat1 = actMat1 .* ((basisMat1.' * Xmatrix) ./ (basisMat1.' * outMat + ips)); %G1更新
    actMat2 = actMat2 .* ((basisMat2.' * Xmatrix) ./ (basisMat2.' * outMat + ips)); %G2更新
    
    outMat = (basisMat1 * actMat1) + (basisMat2 * actMat2);
    J(i, 1) = (norm(Xmatrix - outMat)) ^ 2;
end
% plot(J);