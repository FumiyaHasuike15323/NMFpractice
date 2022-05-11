close all; clear; clc;

inputMat = rand(100);
K = 10;
numIterative = 100;

[W, H] = EuNMF(imputMat, K, numIterative);
% [W, H] = KLNMF(imputMat, K, numIterative);
% [W, H] = ISNMF(imputMat, K, numIterative);