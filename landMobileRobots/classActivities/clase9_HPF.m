clear all
close all
clc

dt = 0.01
time = [0:dt:20];
s = 2*sin(time);
r = 20 *sin(time*0.01);

RC = 0.2

for i=1:numel(s)
    sr(i) = s(i) + r(i);
    
    if i > 1
        sf(i) = (RC/(RC+dt)) * sr(i) + (RC/(RC+dt)) *sf(i)*sf(i-1);
    else
        sf(i) = sr(i);
    end
end


figure
plot(time, sr, 'color', 'red')
hold on 
plot(time, s, 'color', 'blue')
plot(time, sf, 'color', 'black')

