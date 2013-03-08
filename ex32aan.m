%load file with matrix 500x256 where each line represents an image of a
%handwritten 3

close all 

%requires threes.mat in the working directory.
load threes -ascii

%extract the average observation
mean3 = mean(threes,1);

%have a look at the mean 3 
imagesc(reshape(mean3,16,16),[0,1]);

%obtain covariance matrix
CovMat = cov(threes);

%obtain eigenvectors and eigenvalues
[EigVectorsTot, EigValuesMatTot] = eig(CovMat);

figure;
hold on;
plot(EigVectorsTot(end,:),'r');
plot(EigVectorsTot(end-1,:),'b');
plot(EigVectorsTot(end-2,:),'g');
plot(EigVectorsTot(end-3,:),'y');
plot(EigVectorsTot(end-4,:),'p');
plot(EigVectorsTot(end-5,:),'m');


hold off;

figure;
imagesc(reshape(EigVectorsTot(end,:),16,16),[0,1]);

figure;
imagesc(reshape(EigVectorsTot(end-1,:),16,16),[0,1]);

figure;
imagesc(reshape(EigVectorsTot(end-2,:),16,16),[0,1]);

figure;
imagesc(reshape(EigVectorsTot(end-3,:),16,16),[0,1]);

figure;
imagesc(reshape(EigVectorsTot(end-4,:),16,16),[0,1]);


figure;
imagesc(reshape(EigVectorsTot(end-5,:),16,16),[0,1]);

figure;

%in the plot we observe that 3 to 4 eigenvalues are way superior than the
%rest. Those are the core vectors that we can use in pca
plot(diag(EigValuesMatTot),'*')


count =1 ;
for dim=1:size(threes,2)
    
    [Error, CompressedData] = pca_k_dims(threes, dim);
    
    RMSDiff(count) = Error;
    
    count = count +1;
end

figure;
%plot RMSDiff
plot(1:size(threes,2), RMSDiff,'*-');
xlabel('Dims');
ylabel('Error');
title('Root mean square error after PCA with varying dimensionality');