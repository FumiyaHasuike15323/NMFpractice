function [Wmatrix, Hmatrix] = ISNMF(Xmatrix, K, numIterative) %Xmatrei: 観測非負値行列　K:WとHの行列のサイズ　numIterative:ループ回数

[xSize, ySize] = size(Xmatrix); %観測行列のサイズ

Wmatrix = rand(xSize, K); %分解後の行列W,Hの初期値
Hmatrix = rand(K, ySize);
oneMat  = ones(xSize, ySize);

ips = 10^(-21); %0割り回避のための数
J = zeros(numIterative, 1); %コスト関数初期化

for i = 1 : numIterative
    WHMat = Wmatrix * Hmatrix;
    WMatTop = (Xmatrix ./ ((WHMat .^ 2) + ips)) * (Hmatrix.');
    WMatBottom = (oneMat ./ (WHMat + ips)) * (Hmatrix.');
    Wmatrix = Wmatrix .* (WMatTop ./ (WMatBottom + ips)) .^ (1/2);
   
    HMatTop = (Wmatrix.') * (Xmatrix ./ ((WHMat .^ 2) + ips));
    HMatBottom = (Wmatrix.') * (oneMat ./ (WHMat + ips));
    Hmatrix = Hmatrix .* (HMatTop ./ (HMatBottom + ips)) .^ (1/2);
    
    XperWH = Xmatrix ./ (Wmatrix * Hmatrix + ips);
    J(i, 1) = sum(XperWH - log(XperWH + ips) - 1, "all");
end

% plot(J);