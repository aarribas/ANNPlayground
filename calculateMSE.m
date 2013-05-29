function [ MSE ] = calculateMSE( expected, prediction )

%calculates the mean squared error for an expected array and the given
%prediction

 diffsq = (expected-prediction).*(expected-prediction);
 totsum = sum(sum(diffsq));
 MSE = totsum/(size(prediction,2));


end

