close all; clear; clc;

% inputMat = rand(100);
K = 128;
numIterative = 100;

%% Learning Stage
F = DGTtool;
[inputWave1, Fs1] = audioread("songKitamura\GPO\melody1\gpo_tp.wav");
[inputWave2, Fs2] = audioread("songKitamura\GPO\midrange\gpo_pf.wav");
spec1 = F(inputWave1);
spec2 = F(inputWave2);
angleSpec1 = angle(spec1);
angleSpec2 = angle(spec2);
inputMat1 = abs(spec1);
inputMat2 = abs(spec2);


% [W1, H1] = EuNMF(inputMat1, K, numIterative);
[W1, H1] = KLNMF(inputMat1, K, numIterative);
% [W1, H1] = ISNMF(inputMat1, K, numIterative);

% [W2, H2] = EuNMF(inputMat2, K, numIterative);
[W2, H2] = KLNMF(inputMat2, K, numIterative);
% [W2, H2] = ISNMF(inputMat2, K, numIterative);

% outputWave = F.pinv((W1 * H1) .* exp(1i * angleSpec));
% audiowrite("test_out.wav", outputWave / max(abs(outputWave)), Fs);

%% 分離
[mixedWave, Fs] = audioread("songKitamura\GPO\gpo_tp_pf_mixed.wav");
spec = F(mixedWave);
angleSpec = angle(spec);
inputMat = abs(spec);
[outMat, actMat1, actMat2, J] = supervisedNMF(inputMat, W1, W2);

outputWave = F.pinv((outMat) .* exp(1i * angleSpec));
audiowrite("test_out.wav", outputWave / max(abs(outputWave)), Fs);

plot(J);