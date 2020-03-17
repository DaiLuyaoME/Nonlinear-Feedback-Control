alpha = 0.1;

deltaRatio = 0.01;
beginIndex = 1;
endIndex = 30;
iterationNum = 6;
alphaBuffer = zeros(iterationNum,1);
outBuffer = [];
alphaBuffer(1) = alpha;

for i = 2:iterationNum

tempAlpha = alpha;
%% original run
timeSpan = [0, 0.01];
alpha =  tempAlpha;
accCoef = 0;
jerkCoef = 0;
snapCoef = 0;
trajParameters.dis = 0.04;
trajParameters.vel = 0.25;
trajParameters.acc = 10; 
trajParameters.jerk = 800;
trajParameters.snap = 64000;
sim('main',timeSpan);
errorData = Err.signals.values;
dErrorData = dErr.signals.values;
outBuffer = [outBuffer,out.signals.values];
zeroIndex = errorData .* dErrorData <= 0;
%figure;plot(errorData);

errorData = errorData(beginIndex:endIndex);
dErrorData = dErrorData(beginIndex:endIndex);
zeroIndex = zeroIndex(beginIndex:endIndex);



%% first run
timeSpan = [0, 0.01];
accCoef = 0;
jerkCoef = 0;
snapCoef = 0;
alpha =  tempAlpha * (1-deltaRatio);
sim('main',timeSpan);
errorData1 = Err.signals.values;
dErrorData1 = dErr.signals.values;
zeroIndex1 = errorData1 .* dErrorData1 <= 0;
%figure;plot(errorData1);
errorData1 = errorData1(beginIndex:endIndex);
dErrorData1 = dErrorData1(beginIndex:endIndex);
zeroIndex1 = zeroIndex1(beginIndex:endIndex);
%% second run
timeSpan = [0, 0.01];
accCoef = 0;
jerkCoef = 0;
snapCoef = 0;
alpha =  tempAlpha * (1+deltaRatio);
sim('main',timeSpan);
errorData2 = Err.signals.values;
dErrorData2 = dErr.signals.values;
zeroIndex2 = errorData2 .* dErrorData2 <= 0;
%figure;plot(errorData2);
errorData2 = errorData2(beginIndex:endIndex);
dErrorData2 = dErrorData2(beginIndex:endIndex);
zeroIndex2 = zeroIndex2(beginIndex:endIndex);
%% gradient estimation by finite difference
deltaAlpha = tempAlpha * 2 * deltaRatio;
e_alpha = (errorData2 - errorData1) / deltaAlpha;
J_alpha = errorData' * e_alpha;
J_alpha_square = e_alpha' * e_alpha;
gamma = 1;
alpha = tempAlpha - gamma * J_alpha_square^-1 * J_alpha;
alphaBuffer(i) = alpha;
end
%%
figure;
tempx = (1:numel(alphaBuffer)) - 1;
plot(tempx, alphaBuffer);
%%
num = size(outBuffer,1);
tempTime = ((1:num) - 1) * 1/5000;
figure;
plot(tempTime * 1000,outBuffer(:,[1,end]) * 1e6);