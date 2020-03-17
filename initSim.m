%% model parameters
modelTypeName = {'rigidBody','doubleMassNonColocated','doubleMassColocated'};
modelInfo.mass = [5,20];
modelInfo.fr = 700;
modelInfo.dampRatio = 0.03;
modelInfo.type = modelTypeName{2};
fs = 5000;
Ts = 1/fs;
Gp = createPlantModel(modelInfo);

%% delay factor
delayCount = 1.3;
s = tf('s');
delayModel = exp(-delayCount*Ts*s);
delayModel = pade(delayModel,2);

%% generate plant model with delay
GpWithDelay = Gp * delayModel;
GpDis = c2d(GpWithDelay,Ts,'zoh');


%% ideal feedforward coefficients 
m = modelInfo.mass;
% idealAccCoef = sum(m);
% idealJerkCoef = sum(m) * tau;
% idealSnapCoef = sum(m) * ( 1/wn.^2 + 0.5 * tau.^2);
%%
sigma = 2;%噪声的标准差，单位m
varNoise=sigma*sigma;%注意，白噪声的模块中的Noise Power 需要填成varNoise*Ts
noisePower=varNoise*Ts;
%%
fn = 500;
wn = fn * 2 * pi;
lpFilter = tf(wn*wn,[1,2*0.7*wn,wn*wn]);
% figure;bodeplot(lpFilter);
lpFilter = c2d(lpFilter,1/5000,'tustin');
%%
% z1 = 0.001;
% z2 = 0.3278;
% % f = {670,1670,1820,1850,1230};
% f = {4};
% num = numel(f);
% notchFlag = 2;
% tempFilter = 1;
% tempAntiFilter = 1;
% for i = 1:num
%     temp = notchFilter(f{i},z1,z2);
%     tempAnti = notchFilter(f{i},z2,z1);
%     temp = discretizeControllerWithFrequencyPrewarping(temp,f{i},5000);
%     tempAnti = discretizeControllerWithFrequencyPrewarping(tempAnti,f{i},5000);
%     tempFilter = temp * tempFilter;
%     tempAntiFilter = tempAnti * tempAntiFilter;
% end
% figure;
% 
% switch notchFlag
%     case 1
%         C = tempFilter;
%     case 2
%         C = tempAntiFilter;
% end
% bodeplot(C);
% lpFilter = C;