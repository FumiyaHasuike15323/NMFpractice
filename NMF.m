close all; clear; clc;

% inputMat = rand(100);
K = 128;
numIterative = 100;

% サブフォルダーにパスを通す
addpath('./bss_eval');

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

outputWave1 = F.pinv((((W1 * actMat1).^2) ./ ((W1 * actMat1).^2 + W2 * actMat2)) .* spec);
outputWave2 = F.pinv((((W2 * actMat2).^2) ./ ((W1 * actMat1).^2 + W2 * actMat2)) .* spec);
audiowrite("test_out1.wav", outputWave1 / max(abs(outputWave1)), Fs);
audiowrite("test_out2.wav", outputWave2 / max(abs(outputWave2)), Fs);

plot(J);

%% SDR
% 入力SDRと入力SIRの計算（入力SARは∞なので不要）
[inSDR, inSIR, ~] = bss_eval_sources([mixedWave, mixedWave].', [inputWave1, inputWave2].');

% 客観評価尺度算出（SDR，SIR，SAR）
[xSize, ySize] = size(mixedWave);
[outSDR, outSIR, SAR] = bss_eval_sources([outputWave1(1 : xSize), outputWave2(1 : xSize)].', [inputWave1, inputWave2].');
outSDR % 信号対歪み比（source-to-distortion ratio），分離音源の音質と分離度合いの両方を含む尺度（分離はできているけど音がボロボロだと低い）
outSIR % 信号対干渉比（source-to-interference ratio），分離音源の分離度合いのみを含む尺度（音はボロボロだけど相手の音源が消えていれば高い）
