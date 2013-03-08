function [error, compressedMat] = pca_k_dims(InputMatrix,Kdims)

%InputMatrix should be made of observations (rows) and variables (columns)

p = InputMatrix';

[y,ps1] = mapstd(p);

[z, ps2] = processpca(y,1-Kdims/size(p,1));

compressedMat = z;

z2 = processpca('reverse', z, ps2);
xnew = mapstd('reverse', z2, ps1);

diffsq = (p-xnew).*(p-xnew);
totsum = sum(sum(diffsq));
totsumavg = totsum/(size(p,2)*size(p,1));

error = sqrt(totsumavg);
    

end