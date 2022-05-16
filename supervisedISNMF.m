%Xmatrei: 観測非負値行列　basisMat:基底行列　numIterative:ループ回数
function [outMat, actMat1, actMat2, J] = supervisedISNMF(Xmatrix, basisMat1, basisMat2, numIterative) 

[basisXSize, basisYSize] = size(basisMat1); %観測行列のサイズ
[~, ySize] = size(Xmatrix);

actMat1 = rand(basisYSize, ySize);
actMat2 = rand(basisYSize, ySize); %分解後の行列G1,G2の初期値
oneMat = ones(basisXSize, ySize);

ips = 10^(-21); %0割り回避のための数
J = zeros(numIterative, 1); %コスト関数初期化
outMat = (basisMat1 * actMat1) + (basisMat2 * actMat2);


for i = 1 : numIterative
    Top = Xmatrix ./ ((outMat .^ 2) + ips);
    Bottom = oneMat ./ (outMat + ips);
    actMat1 = actMat1 .* ((basisMat1.' * Top) ./ (basisMat1.' * Bottom + ips));
    actMat2 = actMat2 .* ((basisMat2.' * Top) ./ (basisMat2.' * Bottom + ips));
    outMat = (basisMat1 * actMat1) + (basisMat2 * actMat2);
    
    XperWH = Xmatrix ./ (outMat + ips);
    J(i, 1) = sum(XperWH - log(XperWH + ips) - 1, "all");
end

outMat = (basisMat1 * actMat1) + (basisMat2 * actMat2);
% plot(J);