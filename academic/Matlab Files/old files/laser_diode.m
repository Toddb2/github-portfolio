clc;
clear all;
clear;

%A1
figure (1)

x = [0,2.5,5,7.5,10,12.5,15,17.5,20,22.5,25];
y = [0,0,0,0,0,0,0.4,0.7,1.1,1.3,1.8];

scatter (x,y)
xlim ([0,30])
ylim ([0,2.5])

%A2
p = polyfit (x,y,1);

p

%A3


%A4


%A5


%B1
figure (2)

x = [0,2.5,5,7.5,10,12.5,15,17.5,20,22.5,25];
y1 = [0,0,0,0,0,0.2,0.5,0.9,1.2,1.6,1.9];
y2 = [0,0,0,0,0,0,0.3,0.6,0.9,1.3,1.6];
y3 = [0,0,0,0,0,0,0,0.2,0.6,0.9,1.2];
y4 = [0,0,0,0,0,0,0,0,0,0.3,0.6];

plot (x,y1,'-',x,y2,'--',x,y3,':',x,y4,'-.')
xlim ([0,30])
ylim ([0,2.5])

