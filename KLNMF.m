function [Wmatrix, Hmatrix] = KLNMF(Xmatrix, K, numIterative) %Xmatrei: 観測非負値行列　K:WとHの行列のサイズ　numIterative:ループ回数

[xSize, ySize] = size(Xmatrix); %観測行列のサイズ

Wmatrix = rand(xSize, K); %分解後の行列W,Hの初期値
Hmatrix = rand(K, ySize);
oneMat = ones(xSize, ySize);

ips = 10^(-21); %0割り回避のための数
J = zeros(numIterative, 1); %コスト関数初期化

for i = 1 : numIterative
    Wmatrix = Wmatrix .* (((Xmatrix ./ (Wmatrix * Hmatrix + ips)) * Hmatrix.') ./ ((oneMat * (Hmatrix.') + ips)));
    Hmatrix = Hmatrix .* ((Wmatrix.' * (Xmatrix ./ (Wmatrix * Hmatrix + ips))) ./ (((Wmatrix.') * oneMat  + ips)));
    
    J(i, 1) = sum((Xmatrix .* log((Xmatrix ./ (Wmatrix * Hmatrix + ips)) + ips) - (Xmatrix - (Wmatrix * Hmatrix))), "all");
end

plot(J);
