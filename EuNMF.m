function [Wmatrix, Hmatrix] = EuNMF(Xmatrix, K, numIterative) %Xmatrei: 観測非負値行列　K:WとHの行列のサイズ　numIterative:ループ回数

[xSize, ySize] = size(Xmatrix); %観測行列のサイズ

Wmatrix = rand(xSize, K); %分解後の行列W,Hの初期値
Hmatrix = rand(K, ySize);

ips = 10^(-21); %0割り回避のための数
J = zeros(numIterative, 1); %コスト関数初期化

for i = 1 : numIterative
    Wmatrix = Wmatrix .* ((Xmatrix * (Hmatrix.')) ./ ((Wmatrix * Hmatrix * (Hmatrix.') + ips))); %W更新
    Hmatrix = Hmatrix .* (((Wmatrix.') * Xmatrix) ./ (((Wmatrix.') * Wmatrix * Hmatrix) + ips)); %H更新
    
    J(i, 1) = (norm(Xmatrix - Wmatrix * Hmatrix)) ^ 2;
end

% plot(J);