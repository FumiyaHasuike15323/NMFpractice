close all; clear; clc;

% inputMat = rand(100);
K = 128;
numIterative = 500;

F = DGTtool;
[inputWave, Fs] = audioread("music_guitar.wav");
spec = F(inputWave);
angleSpec = angle(spec);
inputMat = abs(spec);


% [W, H] = EuNMF(inputMat, K, numIterative);
% [W, H] = KLNMF(inputMat, K, numIterative);
[W, H] = ISNMF(inputMat, K, numIterative);

outputWave = F.pinv((W * H) .* exp(1i * angleSpec));
audiowrite("test_out.wav", outputWave / max(abs(outputWave)), Fs);
