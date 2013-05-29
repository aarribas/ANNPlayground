%clean up
clear all
close all

rand('twister',1234)

%load the data

load data7.mat
Data = Data';

%get the 3000 random samples out of which we will get train/validation/test
%sets

samplesWithoutReplacement = randsample(size(Data,2),3000);

inputSet = [];
labelsSet = [];

for x=1:size(samplesWithoutReplacement', 2)
        inputSet = [inputSet Data(:,samplesWithoutReplacement(x,1))];
        labelsSet = [labelsSet labels(samplesWithoutReplacement(x,1),1)];
end

%attempt at visualizing the different sets of data using scatterplots

%[inputSet,ps1] = mapstd(inputSet);

for x=0:1:2
    
   
    dim1 = inputSet(1,(1 + x*1000):(x*1000)+1000)';
    dim2 = inputSet(2,(1 + x*1000):(x*1000)+1000)';
    dim3 = inputSet(3,(1 + x*1000):(x*1000)+1000)';
    dim4 = inputSet(4,(1 + x*1000):(x*1000)+1000)';
    dim5 = inputSet(5,(1 + x*1000):(x*1000)+1000)';
    dim6 = inputSet(6,(1 + x*1000):(x*1000)+1000)';
    dim7 = inputSet(7,(1 + x*1000):(x*1000)+1000)';
    dim8 = inputSet(8,(1 + x*1000):(x*1000)+1000)';
    dim9 = inputSet(9,(1 + x*1000):(x*1000)+1000)';
    dim10 = inputSet(10,(1 + x*1000):(x*1000)+1000)';
    class = labelsSet(1,(1 + x*1000):(x*1000)+1000)';

    X = [dim1,dim2,dim3, dim4,dim5,dim6, dim7,dim8,dim9, dim10];
  
    figure;

    gplotmatrix(X,[],class,[],[],[],false);
    
    if x == 0
        title('scatter plot matrix - train set')
    elseif x == 1
        title('scatter plot matrix - validation set')
    elseif x == 2        
        title('scatter plot matrix - test set')
    end

end

trainInd = (1:1000);
valInd = (1001:2000);
testInd = (2001:3000);

labelsSet(labelsSet==-1)= 0; %required to plot the confusion matrix

%definition and learning of neural network
net = newff(inputSet,labelsSet,[3],{'tansig' }, 'trainrp', 'learngd', 'mse', {'fixunknowns','removeconstantrows','mapminmax'}, {'removeconstantrows','mapminmax'},'divideind' );

net.trainParam.epochs = 1000;
net.trainParam.lr=0.00001;%(learning rate)
net.trainParam.goal = 0.001;
net.divideParam = struct('trainInd', trainInd, 'valInd', valInd, 'testInd', testInd);

[net,tr] = train(net,inputSet,labelsSet);


