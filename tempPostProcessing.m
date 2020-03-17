error1 = Err.signals.values;
out1 = out.signals.values;
%%
error2 = Err.signals.values;
out2 = out.signals.values;
time = out.time;
%%
error3 = Err.signals.values;
out3 = out.signals.values;
%%
figure;
plot(time,1e6*error1);
hold on;
plot(time,1e6*error2);
%%
figure;
plot(time,1e6*out1);
hold on;
plot(time,1e6*out2);

%%
figure;
plot(time,1e6*error1);
hold on;
plot(time,1e6*error2);
plot(time,1e6*error3);
%%
figure;
plot(time * 1000,1e6*out1);
hold on;
plot(time * 1000,1e6*out2);
plot(time * 1000,1e6*out3);
xlim([0,20]);
%%
alpha1 = 0.1;
alpha2 = 0.56;
alpha3 = 0.81;
alpha4 = 0.95;
alpha5 = 0.95;
alpha6 = 0.95;
figure;
plot(0:5,[alpha1,alpha2,alpha3,alpha4,alpha5,alpha6])
%%
time = noise.time;
noiseValue = noise.signals.values;
figure;
plot(time,noiseValue,'linewidth',2);
ylabel('\mu m');
xlabel('Ê±¼ä (s)');
grid on;
set(gca,'fontsize',14);
%%
fn = 700;
zeta = 0.06
wn = fn * 2 * pi;
m1 = 5; m2 = 20;
k = wn * wn * m1 * m2 /(m1+m2);
c = 2*zeta*wn*m1 * m2 /(m1+m2);
tempG = tf(1,[c,k]);

Op=bodeoptions;
Op.FreqUnits='Hz';
Op.xlim={[1  500]};
Op.PhaseVisible = 'on';
Op.Grid='on';

figure;
bodeplot(tempG,Op);%%
%%
figure;
subplot(3,1,1);
plot(out.time * 1000,out.signals.values * 1e6,'linewidth',2);
hold on;
plot(out.time * 1000,30 * ones(size(out.time)),'linewidth',1);
xlabel('time (ms)');
ylabel('step response (\mum)');

subplot(3,1,2);
plot(Err.time * 1000,Err.signals.values * 1e6,'linewidth',2);
hold on;
plot(out.time * 1000,zeros(size(out.time)),'linewidth',1);

xlabel('time (ms)');
ylabel('error (\mum)');

subplot(3,1,3);
plot(nonlinearU.time * 1000,nonlinearU.signals.values * 1e6,'linewidth',2);
hold on;
plot(out.time * 1000,zeros(size(out.time)),'linewidth',1);

xlabel('time (ms)');
ylabel('u (\mum)');


