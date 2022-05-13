close all; clear; clc;

% inputMat = rand(100);
K = 128;
numIterative = 500;

F = DGTtool;
[inputWave, Fs] = audioread("music_piano.wav");
inputMat = abs(F(inputWave));

% [W, H] = EuNMF(inputMat, K, numIterative);
[W, H] = KLNMF(inputMat, K, numIterative);
% [W, H] = ISNMF(inputMat, K, numIterative);

outputWave = F.pinv(W * H);
audiowrite("test_out.wav", outputWave / max(abs(outputWave)), Fs);
