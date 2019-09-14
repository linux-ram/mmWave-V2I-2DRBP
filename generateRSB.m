function [T, B] = generateRSB(nVehicle,expt,Ttot,Btot,minSampAllRoutes)
% Code for Coherence Bandwidth
% P_Bc(20MHz <= Bc <= 132 MHz) = 1
% P_Bc(Bc >= 66 MHz) = 0.95

T=zeros(minSampAllRoutes,1); B=zeros(minSampAllRoutes,1);
MaxRABeams = 5;
for i=1:minSampAllRoutes
    rng=rand(1);
    Bc = (66e6 + (132e6-66e6)*rand(1))*(rng<0.95)+(20e6 + (66e6-20e6)*rand(1))*(rng>0.95);
    BeamWidthMS=deg2rad(8);
    R=0.9; v = 10; Oper_Freq = 73e9; c= 3e8; lambda = c/Oper_Freq; f_D=v/lambda;
    alphaLOS = deg2rad(5 + (90-5)*rand); D = 5 + (100-5)*rand; D_lambda = D/lambda;
    Tc = (D_lambda*acos(2*BeamWidthMS^2*log(R)+1))/(f_D*sin(alphaLOS));
    Tc=min(Tc,0.6);
    T(i)=Tc;
    B(i)=Bc;

T(i) = 0.1 + 0.8*rand;
B(i) = 1e8 + (1e9-2e8)*rand;

% T(i)=(MaxRABeams>=nVehicle(expt))*Ttot+(MaxRABeams<nVehicle(expt))*(MaxRABeams/nVehicle(expt))*Ttot;
% B(i)=(MaxRABeams>=nVehicle(expt))*Btot+(MaxRABeams<nVehicle(expt))*(1/MaxRABeams)*Btot;

end
%hist(collect)