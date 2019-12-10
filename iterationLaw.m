errorData = Err.signals.values;
dErrorData = dErr.signals.values;
zeroIndex = errorData .* dErrorData <= 0;
figure;plot(errorData);
%%
beginIndex = 1;
endIndex = 30;
errorData = errorData(beginIndex:endIndex);
dErrorData = dErrorData(beginIndex:endIndex);
zeroIndex = zeroIndex(beginIndex:endIndex);

%%
T = feedback(GcDis * GpDis,1);
tempFilter = -1 * minreal((1+alpha*T)^-1 * T);
[b,a] = tfdata(tempFilter,'v');
e_alpha = filter(b,a,errorData);
e_alpha(zeroIndex) = 0;
J_alpha = errorData' * e_alpha;
J_alpha_square = e_alpha' * e_alpha;

gamma = 1;
alphaNew = alpha - gamma * J_alpha_square^-1 * J_alpha;