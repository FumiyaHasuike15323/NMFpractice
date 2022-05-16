function [outMat, actMat1, actMat2, J] = supervisedNMF(mixedMat, basisMat1, basisMat2)
numIterative = 512;

% [outMat, actMat1, actMat2, J] = supervisedEuNMF(mixedMat, basisMat1, basisMat2, numIterative);
% [outMat, actMat1, actMat2, J] = supervisedKLNMF(mixedMat, basisMat1, basisMat2, numIterative);
[outMat, actMat1, actMat2, J] = supervisedISNMF(mixedMat, basisMat1, basisMat2, numIterative);