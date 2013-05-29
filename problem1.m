close all

load Data_Problem1.mat

%user name digits in descending order
d1 = 9;
d2 = 8;
d3 = 7;
d4 = 6;
d5 = 3;

%create new dataset
Tnew = (d1*T1+d2*T2+d3*T3+d4*T4+d5*T5)/(d1+d2+d3+d4+d5);

%the dataset is supposed to be noiseless and contain no outliers, hence no
%extra manipulations are required

%get Target validation and test set
samplesWithoutReplacement = randsample(size(Tnew,1),3000);

outputTargetSet = [];
x1TargetSet = [];
x2TargetSet = [];

for x=1:size(samplesWithoutReplacement', 2)
        outputTargetSet = [outputTargetSet Tnew(samplesWithoutReplacement(x,1))];
        x1TargetSet = [x1TargetSet X1(samplesWithoutReplacement(x,1))];
        x2TargetSet = [x2TargetSet X2(samplesWithoutReplacement(x,1))];
end

%visualize the dataset (not very useful though) 
%plot3(x1TargetSet,x2TargetSet,outputTargetSet,'+');

trainInd = (1:1000);
valInd = (1001:2000);
testInd = (2001:3000);

%define network
net = newff([0,1;0,1], outputTargetSet,[6 6 ], {'tansig' 'tansig' }, 'trainlm', 'learngdm', 'mse', {'fixunknowns','removeconstantrows','mapminmax'}, {'removeconstantrows','mapminmax'},'divideind' );
%net = newff([0,1;0,1], outputTargetSet,[13], {'tansig' }, 'trainlm', 'learngdm', 'mse', {'fixunknowns','removeconstantrows','mapminmax'}, {'removeconstantrows','mapminmax'},'divideind' );

net.trainParam.epochs = 1000;
net.performFcn ='mse';
net.trainParam.goal = 0.0001; 
net.divideFcn = 'divideind';  
net.divideParam.trainInd = trainInd;
net.divideParam.valInd = valInd;
net.divideParam.testInd = testInd;

%train the network
[net,tr] = train(net,[x1TargetSet;x2TargetSet],outputTargetSet);

%plot the performance
plotperform(tr)

%use the one below in order to do a loop trying different architectures
min(tr.vperf)

%double check the results on the test set

[predictedTestSetOutput,Xf,Af,E,perf] = sim(net,[x1TargetSet(2001:3000); x2TargetSet(2001:3000)]);

%create surfaces

xlin = linspace(min(x1TargetSet(2001:3000)),max(x1TargetSet(2001:3000)),100);
ylin = linspace(min(x2TargetSet(2001:3000)),max(x2TargetSet(2001:3000)),100);

[X,Y] = meshgrid(xlin,ylin);

error  = abs(outputTargetSet(2001:3000)-predictedTestSetOutput);

outputSurface = griddata(x1TargetSet(2001:3000), x2TargetSet(2001:3000), predictedTestSetOutput, X, Y, 'cubic');
testSurface =  griddata(x1TargetSet(2001:3000), x2TargetSet(2001:3000), outputTargetSet(2001:3000), X, Y, 'cubic');
errorSurface = griddata(x1TargetSet(2001:3000), x2TargetSet(2001:3000), error, X, Y, 'cubic');

figure
mesh(X,Y,outputSurface) %interpolated
axis tight; hold on
title('test set expected')
plot3(x1TargetSet(2001:3000), x2TargetSet(2001:3000),outputTargetSet(2001:3000),'.','MarkerSize',15) %nonuniform


figure
mesh(X,Y,testSurface) %interpolated
axis tight; hold on
title('test set predicted')
plot3(x1TargetSet(2001:3000),  x2TargetSet(2001:3000), predictedTestSetOutput,'.','MarkerSize',15) %nonuniform

figure
mesh(X,Y,errorSurface) %interpolated
axis tight; hold on
title('test set error')
plot3(x1TargetSet(2001:3000),  x2TargetSet(2001:3000), error,'.','MarkerSize',15) %nonuniform


%MSE calculation
 diffsq = (error).*(error);
 totsum = sum(sum(diffsq));
 MSE = totsum/(size(error,2))