%3.1
%PCA

%Let's build a random 500x500 matrix and apply PCA to it.
%We will then recover the datapoints back and compute the root mean square
%difference.

%Build 500x50 random matrix (each column is a dimension each row is an
%observation

P = rand(500,50);
numcols = size(P,2);

%obtain covariance matrix
CovMat = cov(P);

%obtain mean
Mean = mean(P,2);   

%ETREMELY IMPORTANT TO COMPUTE THE AVERAGE OBSERVATION
%THIS AVERAGE OBSERVATION HAS TO BE RE_USED LATER ON TO RECOVER THE
%ORIGINAL VALUES!

RMSDiff=zeros(1,10);

for it=1:10
    
    %let's do pca augmenting the dimension 10% per iteration.
    %This will allow us to compare the recovery of the original data
    %depending on the dimension (Note dimension = number of highest eigen
    %vectors chosen.
    
    %obtain highest eigenvectors and eigenvalues of covariance matrix
    
    
    [EigVectorsTot, EigValuesMatTot] = eig(CovMat);
    
    [EigVectors, EigValuesMat] = eigs(CovMat, numcols*(it*0.1));
     
    E = EigVectors;
    
    %Extract the EigenValues
    EigValues = diag(EigValuesMat);
    
    Quality = sum(EigValues)/sum(diag(EigValuesMatTot));
    
    str = ['For dimension: ', num2str(numcols/10*it), ' the quality is expected to be: ', num2str(Quality)];
    disp(str)
    
%     %denormalize the eigenVectors
%     for col = 1:size(E,2)
%         E(:,col) = E(:,col) * EigValues(col);
%     end
%     
    %data after pca => z
    Z = transpose(E)*P';
    
    %recovery of original data
    xnew = E*Z;

%     for row = 1:size(xnew,1)
%         xnew(row,:) = xnew(row,:) + Mean';
%     end
    
    xnew = xnew';
    
    %compute the root mean square error:
    %compute diff squared
    %sum rows
    %sum cols
    %divide by n = 500
    %obtain root
  
    RMSDiff(it) = sqrt(sum(sum((P-xnew).*(P-xnew)))/(size(P,1)*size(P,2)));
    
end
figure;
size(RMSDiff,2)
plot((numcols/10)*(1:10), RMSDiff,'*-');
xlabel('Dimension');
ylabel('Error');
title('Root mean square error after PCA with varying dimensionality');

%TODO VERIFY WHY THE ABOVE DOES NOT WORK
  

%3.1.2


input('Press enter to load choles_all and apply manual pca.');

%repeat the above with the matrix from choles_all
clear

load choles_all

P = p';

%obtain covariance matrix
CovMat = cov(P);

%obtain mean

Mean = mean(P,2);

dims = size(P,2);

RMSDiff=zeros(1,dims);


for it=1:dims
    
    %let's do pca augmenting the dimensions per iteration.
    %This will allow us to compare the recovery of the original data
    %depending on the dimension (Note dimension = number of highest eigen
    %vectors chosen.
    
    %obtain highest eigenvectors and eigenvalues of covariance matrix
    
    
    [EigVectorsTot, EigValuesMatTot] = eig(CovMat);
    
    if it == dims
        E = EigVectorsTot;
        EigValues = EigValuesMatTot;
        
    else
        [EigVectors, EigValuesMat] = eigs(CovMat, it);
        E = EigVectors;
        EigValues = diag(EigValuesMat);
    end
    
    %Extract the EigenValues
    
    
    Quality = sum(EigValues)/sum(diag(EigValuesMatTot));
    
    str = ['For dimension: ', num2str(it), ' the quality is expected to be: ', num2str(Quality)];
    disp(str)
    
%     %denormalize the eigenVectors //not needed?
%     for col = 1:size(E,2)
%         E(:,col) = E(:,col) * EigValues(col);
%     end
    
    %data after pca => z
    Z = transpose(E)*P';
    
    %recovery of original data
    xnew = E*Z;
%     
%     for row = 1:size(xnew,1)
%         xnew(row,:) = xnew(row,:) + Mean';
%     end
    
    xnew = xnew';
    
    %xnew = xnew' + Mean;
    
    %compute the root mean square error:
    %compute diff squared
    %sum rows
    %sum cols
    %divide by n = 500
    %obtain roo
    
    RMSDiff(it) = sqrt(sum(sum((P-xnew).*(P-xnew)))/(size(P,1)*size(P,2)));
    
end
figure;
%plot RMSDiff
plot(1:dims, RMSDiff,'*-');
xlabel('Dimension');
ylabel('Error');
title('Root mean square error after PCA with varying dimensionality');

%next phase, same withc processpca and mapstd
input('lets do the previous but using processpca and mapstd')
count =1 ;

size(p)
for frac=0:0.01:1-0.01
    [y,ps1] = mapstd(p);
    [z, ps2] = processpca(y,frac);

    z2 = processpca('reverse', z, ps2);
    xnew = mapstd('reverse', z2, ps1);
    
    diffsq = (p-xnew).*(p-xnew);
    totsum = sum(sum(diffsq));
    totsumavg = totsum/(size(p,1)*size(p,2));
    
    RMSDiff(count) = sqrt(totsumavg);
    
    count = count +1;
end

figure;
%plot RMSDiff
plot(0:0.01:1-0.01, RMSDiff,'*-');
xlabel('Frac');
ylabel('Error');
title('Root mean square error after PCA with varying dimensionality');