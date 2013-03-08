%%2.1 HOPFIELD NETS

%Creation of several hopfiled nets with different sizes and different
%atractors

%Remember the stable points are given by the columns of the T matrix
%the number of rows coincides with the number of neurons.
%In the following the number of neurons is fixed to 3.
%the number of stable points is fixed to 2

%we run 5 experiments

color = 'rgbmy';
for it = 1:10
    disp('--------------------------------')
    disp('New Experiment/Hopfield Network')
    %def stable points
    switch it
        case 1 
            T = [1,1;
                -1,0;
                0,-1];
        case 2 
            T = [0,1;
                -1,0;
                0,-1];       
            
        case 3 
            T = [2,1;
                -1,0;
                0,-1];       
            
            
        case 4 
            T = [1,0;
                -1,0;
                0,-1];       
            
        case 5 
            T = [2,1;
                -1,0;
                0,-1];       
            
    end
    
    disp('Stable points fixed with matrix T:')
    disp(T)
   
    %create network
    net = newhop(T);
    
    figure;
    for p=1:5
        %sim network with some random vector (must have size 2
        a = {rands(3,1)*2};
        [y,Pf,Af] = sim(net,{1 60},{},a);

        %check if convergence was reached and print the first iteration of
        %convergence

       if isequal(y{end} - T(:,1) < 0.000001, ones(1,length(y{end}))') || isequal(y{end} - T(:,2) < 0.000001, ones(1,length(y{end}))')
           disp('Convergence reached')

        for l = 1:length(y)
           if isequal(y{l} - T(:,1) < 0.000001, ones(1,length(y{1}))') || isequal(y{l} - T(:,2) < 0.000001, ones(1,length(y{l}))')
              str = ['max iteration: ', num2str(l)];
              disp(str)
              break;
           end
        end
       else
           disp('Convergence to stable point not reached')
       end


        %display in 3d

        axis([-2 2 -2 2 -2 2])
        set(gca,'box','on'); axis manual;  hold on;
        plot3(T(1,:),T(2,:),T(3,:),'r*')
        title('Hopfield Network State Space')
        xlabel('a(1)');
        ylabel('a(2)');
        zlabel('a(3)');

        record = [cell2mat(a) cell2mat(y)];
        start = cell2mat(a);
        plot(start(1,1),start(2,1),'bx',record(1,:),record(2,:) ,color(rem(p,5)+1))
    end
    
   input('press enter to move on')
    
end


%capture stable iteration if any


