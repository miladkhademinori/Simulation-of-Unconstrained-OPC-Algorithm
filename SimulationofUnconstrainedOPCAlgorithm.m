% Milad Khademi Nori 95123012
% Exercise 2
% Simulation of Unconstrained OPC Algorithm

% In this homework, the OPC algorithm is applied to a simple single-cell and a two-cell wireless network.
% The following parameters are fixed for both cases :
% Cell coverage area = 100m*100m
% Background noise power DeltaPower2= e-10W
% OPC constant ni = 0.05
% Path gain hi = 0.1d ^(-3)
% Simulate the system under the above conditions, for 5 number of users. The users should be uniformly
% distributed in the cell.

%% 1. Plot SINR and power of each user versus the number of iterations (a measure of time).
% Change the initial transmit power of users. Does it make change the
% equilibrium transmit power vector?
% Which users transmit at high power levels? Why? Does it depend on initial transmit power vector?
Nu = 5;
Length = 100;
Width = 100;
DeltaPower2 = 1e-10 * ones( Nu , 1);
Ni = 0.05;
NiVec = Ni * ones( Nu , 1);
PositionOfBS = [ 0 , 0 ];
X = 1:Length/Nu:Length;
Y = 1:Length/Nu:Length;
XYVector = [X;Y]';
DistanceFromBS = pdist2(XYVector,PositionOfBS,'euclidean');
PathGainh = 0.1*DistanceFromBS.^(-3);
MaxOfIteration = 50;
PowerVector = zeros( Nu , 1); % rand( Nu , 1) for next question
GamaVector = zeros( Nu , 1);
PowerVectorHistory = [];
GamaVectorHistory = [];
PrePowerVector = zeros( Nu , 1);
PostPowerVector = zeros( Nu , 1);

for k = 1:MaxOfIteration
    PowerVectorHistory = [PowerVectorHistory;PowerVector'];
    GamaVectorHistory = [GamaVectorHistory;GamaVector'];
    PrePowerVector = PostPowerVector;
    for i = 1:Nu
        PowerVector( i , 1 ) =  NiVec( i , 1) / (( PowerVector' * PathGainh ...
        - PowerVector( i , 1 ) * PathGainh( i , 1 ) + DeltaPower2( i , 1 ) )/(PathGainh( i , 1 )));

        GamaVector( i , 1 ) = ( PowerVector( i , 1 ) * PathGainh( i , 1 ))/( PowerVector' * PathGainh ...
        - PowerVector( i , 1 ) * PathGainh( i , 1 ) + DeltaPower2( i , 1 ) );
    end
    PostPowerVector = PowerVector;
    if abs(PostPowerVector - PrePowerVector) <= 0.0001  
            PowerVectorHistory = [PowerVectorHistory;PowerVector'];
            GamaVectorHistory = [GamaVectorHistory;GamaVector'];
        break;
    end

end

figure
subplot(2,1,1);
plot(GamaVectorHistory);
title('GamaVectorHistory');
subplot(2,1,2);
plot(PowerVectorHistory);
title('PowerVectorHistory');
%% Increase the OPC constant (Ni) from 0.05 to 1 by step size 0.01. Plot achieved sum rate versus
%  different values of Ni. Analyze OPC constant’s impact on performance of the OPC algorithm.
%  Decrease the OPC constant (Ni) from 0.05 to 0.01 by step size 0.01. Plot achieved sum rate versus
%  different values of Ni. Analyze OPC constant’s impact on performance of the OPC algorithm.
GamaVectorForDifferentNi = [];
Nu = 5;
for j = 0.05:-0.01:0.01
Length = 100;
Width = 100;
DeltaPower2 = 1e-10 * ones( Nu , 1);
NiVec = j * ones( Nu , 1);
PositionOfBS = [ 0 , 0 ];
X = 1:Length/Nu:Length;
Y = 1:Width/Nu:Width;
XYVector = [X;Y]';
DistanceFromBS = pdist2(XYVector,PositionOfBS,'euclidean');
PathGainh = 0.1*DistanceFromBS.^(-3);
MaxOfIteration = 500;
PowerVector = zeros( Nu , 1);
GamaVector = zeros( Nu , 1);
PrePowerVector = zeros( Nu , 1);
PostPowerVector = zeros( Nu , 1);
for k = 1:MaxOfIteration
    PrePowerVector = PostPowerVector;
    for i = 1:Nu
        PowerVector( i , 1 ) =  NiVec( i , 1) / (( PowerVector' * PathGainh ...
        - PowerVector( i , 1 ) * PathGainh( i , 1 ) + DeltaPower2( i , 1 ) )/(PathGainh( i , 1 )));

        GamaVector( i , 1 ) = ( PowerVector( i , 1 ) * PathGainh( i , 1 ))/( PowerVector' * PathGainh ...
        - PowerVector( i , 1 ) * PathGainh( i , 1 ) + DeltaPower2( i , 1 ) );
    end
    PostPowerVector = PowerVector;
    if abs(PostPowerVector - PrePowerVector) <= 0.0001
        break;
    end

end
GamaVectorForDifferentNi = [GamaVectorForDifferentNi;GamaVector'];
end

plot (0.05:-0.01:0.01,sum(GamaVectorForDifferentNi'))

%% To study how OPC works when users move, assume a two-cell wireless network with 9 users as shown
% in Fig. a. Suppose that users 1 to 4 and 6 to 9 are fixed, and user 5 at t = 0 starts moving from its starting
% point in cell No. 1 towards cell No. 2 in Fig. a at a uniform speed of 5 m=s (18 km=h). The movement
% of user 5 from the starting point to the end point lasts 30 seconds. Each user updates its transmit power
% every 1 ms employing OPC. When user 5 enters cell No. 2, i.e. at t = 13 s, base-station 2 is assigned to
% it. Excluding the moving user 5, note that user 3 in cell No. 1, and user 9 in cell No. 2 are the closest
% users to the base station in their corresponding cells.

% Plot the transmit power levels and the received SINRs versus time for users 3, 5, and 9.
% Does movement of user 5 change the best user on each cell? How? Explain.
% Discuss and interpret the results.

Nu = 9;
DeltaPower2 = 1e-10 * ones( Nu , 1);
Ni = 0.05;
NiVec = Ni * ones( Nu , 1);
PositionOfBS1 = [ 50  , 50 ];
PositionOfBS2 = [ 150 , 50 ];
X = [ 20 , 30 , 60 , 40 , 70 , 110 , 160 , 170 , 200 ];
Y = [ 40 , 10 , 35 , 50 , 90 , 80  , 70  , 20  , 30  ];
XYVector = [X;Y]';
DistanceFromBS1 = pdist2(XYVector,PositionOfBS1,'euclidean');
DistanceFromBS2 = pdist2(XYVector,PositionOfBS2,'euclidean');
PathGainh1 = 0.1*DistanceFromBS1.^(-3);
PathGainh2 = 0.1*DistanceFromBS2.^(-3);
step = 3000;
Pmax = 10;
Pmin = 0.001;
MaxOfIteration = step;
PowerVector1 = zeros( Nu , 1);
GamaVector1 = zeros( Nu , 1);
PowerVector2 = zeros( Nu , 1);
GamaVector2 = zeros( Nu , 1);
PowerVectorHistory1 = zeros(step,9);
GamaVectorHistory1 = zeros(step,9);
PowerVectorHistory2 = zeros(step,9);
GamaVectorHistory2 = zeros(step,9);
% PrePowerVector = zeros( Nu , 1);
% PostPowerVector = zeros( Nu , 1);

for k = 1:MaxOfIteration
    PowerVectorHistory1(k,:) = PowerVector1';
    GamaVectorHistory1(k,:) = GamaVector1';
    PowerVectorHistory2(k,:) = PowerVector2';
    GamaVectorHistory2(k,:) = GamaVector2';

    for i = 1:Nu
        PowerVector1( i , 1 ) =  NiVec( i , 1) / (( PowerVector1' * PathGainh1 ...
        - PowerVector1( i , 1 ) * PathGainh1( i , 1 ) + DeltaPower2( i , 1 ) )/(PathGainh1( i , 1 )));
    
        PowerVector2( i , 1 ) =  NiVec( i , 1) / (( PowerVector2' * PathGainh2 ...
        - PowerVector2( i , 1 ) * PathGainh2( i , 1 ) + DeltaPower2( i , 1 ) )/(PathGainh2( i , 1 )));
    if PowerVector1( i , 1 ) >= Pmax
        PowerVector1( i , 1 ) = Pmax;
    end
    
    if PowerVector2( i , 1 ) >= Pmax
        PowerVector2( i , 1 ) = Pmax;
    end
    if isnan(PowerVector1 ( i , 1 ))
        PowerVector1 ( i , 1 ) = Pmin;
    end
    if isnan(PowerVector2 (i , 1 ))
        PowerVector2( i , 1 ) = Pmin;
    end

        GamaVector1( i , 1 ) = ( PowerVector1( i , 1 ) * PathGainh1( i , 1 ))/( PowerVector1' * PathGainh1 ...
        - PowerVector1( i , 1 ) * PathGainh1( i , 1 ) + DeltaPower2( i , 1 ) );
    
        GamaVector2( i , 1 ) = ( PowerVector2( i , 1 ) * PathGainh2( i , 1 ))/( PowerVector2' * PathGainh2 ...
        - PowerVector2( i , 1 ) * PathGainh2( i , 1 ) + DeltaPower2( i , 1 ) );
    end
    

X = [ 20 , 30 , 60 , 40+k*(150/step) , 70 , 110 , 160 , 170 , 200 ];
Y = [ 40 , 10 , 35 , 50 , 90 , 80  , 70  , 20  , 30  ];
XYVector = [X;Y]';
DistanceFromBS1 = pdist2(XYVector,PositionOfBS1,'euclidean');
DistanceFromBS2 = pdist2(XYVector,PositionOfBS2,'euclidean');
PathGainh1 = 0.1*DistanceFromBS1.^(-3);
PathGainh2 = 0.1*DistanceFromBS2.^(-3);
% if PathGainh1>= 1000
%     PathGainh1 = 1000;
% end
% 
% if PathGainh2>= 1000
%     PathGainh2 = 1000;
% end


end

figure
subplot(4,1,1);
plot(GamaVectorHistory1);
title('GamaVectorHistory1');
subplot(4,1,2);
plot(PowerVectorHistory1);
title('PowerVectorHistory1');
subplot(4,1,3);
plot(GamaVectorHistory2);
title('GamaVectorHistory2');
subplot(4,1,4);
plot(PowerVectorHistory2);
title('PowerVectorHistory2');

