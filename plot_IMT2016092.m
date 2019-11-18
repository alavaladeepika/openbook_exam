clear;
data=xlsread('data.csv');
x=data(:,3);
y=data(:,4);
plot(x,y);
grid on
xlim([0,639])
ylim([0,479])