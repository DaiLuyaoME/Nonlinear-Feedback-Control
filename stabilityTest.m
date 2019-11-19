% %%
% sys1 = feedback(GcDis*GpDis,1);
% sys2 = feedback(GcDis*GpDis*2,1);
% [num1,den1] = tfdata(sys1,'v');
% [num2,den2] = tfdata(sys2,'v');
% [A1,B1,C1,D1] = tf2ss(num1,den1);
% [A2,B2,C2,D2] = tf2ss(num2,den2);
% %%
% n = size(A1,1);
% cvx_begin sdp
% variable P(n,n) symmetric
% A1'*P*A1 - P <= zeros(n)
% A2'*P*A2 - P <= zeros(n)
% P >= zeros(n)
% cvx_end

%% continuous time domain

sys1 = ss(minreal(feedback(C*Gp,1)));
sys2 = ss(minreal(feedback(C*Gp*1.1,1)));
[A1,B1,C1,D1] = ssdata(sys1);
[A2,B2,C2,D2] = ssdata(sys2);

n = size(A1,1);
cvx_clear
cvx_begin sdp
cvx_precision high
variable P(n,n) symmetric
A1'*P + P*A1 < eye(n)
A2'*P + P*A2 < eye(n)
P > eye(n)
cvx_end
%%
%% continuous time domain

sys1 = minreal(feedback(C*Gp,1));
sys2 = minreal(feedback(C*Gp*1.5,1));
[num1,den1] = tfdata(sys1,'v');
[num2,den2] = tfdata(sys2,'v');
[A1,B1,C1,D1] = tf2ss(num1,den1);
[A2,B2,C2,D2] = tf2ss(num2,den2);

n = size(A1,1);
setlmis([]) 
p = lmivar(1,[n 1]);
lmiterm([1 1 1 p],1,A1,'s');
lmiterm([-2 1 1 p],1,1);
lmiterm([3 1 1 p],1,A2,'s');
lmis = getlmis;
[tmin,xfeas] = feasp(lmis);
P = dec2mat(lmis,xfeas,p);

%%
%% continuous time domain

sys1 = minreal(feedback(C*Gp,1));
sys2 = minreal(feedback(C*Gp*1.1,1));
[num1,den1] = tfdata(sys1,'v');
[num2,den2] = tfdata(sys2,'v');
[A1,B1,C1,D1] = tf2ss(num1,den1);
[A2,B2,C2,D2] = tf2ss(num2,den2);

n = size(A1,1);
setlmis([]) 
p = lmivar(1,[n 1]);
lmiterm([1 1 1 p],1,A1,'s');
lmiterm([1 1 2 0],1);
lmiterm([1 2 2 p],-1,1);
lmis = getlmis;
[tmin,xfeas] = feasp(lmis);
P = dec2mat(lmis,xfeas,p);




