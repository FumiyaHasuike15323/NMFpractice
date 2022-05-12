close all; clear; clc;

inputMat = rand(100);
K = 10;
numIterative = 100;

[W, H] = EuNMF(inputMat, K, numIterative);
% [W, H] = KLNMF(inputMat, K, numIterative);
% [W, H] = ISNMF(inputMat, K, numIterative);
