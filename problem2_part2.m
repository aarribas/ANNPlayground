
close all
clear all


load data7.mat
Data = Data';

%get the 3000 random samples out of which we will get train/validation/test
%sets

samplesWithoutReplacement = randsample(size(Data,2),3000);

origInputSet = [];
labelsSet = [];

for x=1:size(samplesWithoutReplacement', 2)
        origInputSet = [origInputSet Data(:,samplesWithoutReplacement(x,1))];
        labelsSet = [labelsSet labels(samplesWithoutReplacement(x,1),1)];
end

%pca requires mean 0 and max deviation 1 
[inputSet,ps1] = mapstd(origInputSet);

CovMat = cov(inputSet');

%obtain eigenvectors and eigenvalues
[EigVectorsTot, EigValuesMatTot] = eig(CovMat);
EigVals = diag(EigValuesMatTot)

mean = sum(EigVals')/10

totEigVals = EigVals'./sum(EigVals')

cumsum(totEigVals)

figure;
title('EigenValues')
plot(1:size(diag(EigValuesMatTot),1), diag(EigValuesMatTot), 'r+');

%[Error, CompressedData] = pca_k_dims(inputSet', totEigVals(1,end-8));

[compressedData, ps2] = processpca(inputSet,totEigVals(1,end-8)-0.00001);

size(compressedData)

%TODO

trainInd = [(1:500)];
valInd = (1001:2000);
testInd = (2001:3000);

labelsSet(labelsSet==-1)= 0; %required to plot the confusion matrix

%definition and learning of neural network
net = newpr(compressedData,labelsSet,[200],{'logsig' }, 'trainrp', 'learngdm', 'mse', {'fixunknowns','removeconstantrows','mapminmax'}, {'removeconstantrows','mapminmax'},'divideind' );

net.trainParam.epochs = 1000;
net.trainParam.lr_inc = 1.0001
net.trainParam.max_fail = 20
net.trainParam.lr= 0.0001;
net.trainParam.goal = 0.0005;
net.trainParam.max_perf_inc = 1.0001
net.divideParam = struct('trainInd', trainInd, 'valInd', valInd, 'testInd', testInd);

[net,tr] = train(net,compressedData,labelsSet);