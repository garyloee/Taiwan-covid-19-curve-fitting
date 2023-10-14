
%Curve fitting by hand
beta=0.00263; %infection rate
gamma=0.2; %recovery rate
N=125; %Total population
I0=2.5; %initial infected cases
T=40;
dt = 0.1; %creating delta T for curve

%Calculation
[S,I,R] = SIRmodel(beta,gamma,N,I0,T,dt);
% Plots that display the epidemic outbreak
timePeriod = 0:dt:T-dt;
% Curve
figure(4);
H2=plot(timePeriod-5,I,'r');


axis([0 30 0 14])

taiwanData=readtable("covid-19_Taiwanese_data_status_revolution.xlsx",ReadVariableNames=true,VariableNamingRule="preserve");
population=23.57; %23.57 million prople
date=table2array(taiwanData(1:1076,1));

threshold=4; %density threshold
gompertz="I0*exp(log(Iin/I0)*(1-exp(-lambda*x)))";


totalInfection=table2array(taiwanData(1:1076,5))/population; %data one
totalDeath=table2array(taiwanData(1:1076,27))/population; %data three
totalActive=totalInfection-(table2array(taiwanData(1:1076,33))/population); %%%%%%%data incomplete%%%%%%%
Active=(table2array(taiwanData(1:1076,5))-table2array(taiwanData(1:1076,33)))/23.57;
for p = 1:size(date,1)  %thresholding
    if totalActive(p)>4
        startDayA=p;
        break
    end
end

endDayA=startDayA+30;

xA=(0:30).';
yA=totalActive(startDayA:endDayA);
size(Active)
hold on
HA1=plot(xA,yA,"bo-");
%hold on
%plot(1:1076,Active);
title(sprintf("Active Infection of first 30 days of contagion since p > %d", threshold))
ylabel("p = active infection/million")
xlabel(sprintf("Days since measured p > %d", threshold))
legend([HA1 H2],"Active Cases","SIR Model",Location="northwest")
hold off

% function reference: https://www.mathworks.com/matlabcentral/fileexchange/75100-sir-epidemic-spread-model
function [S,I,R] = SIRmodel(beta,gamma,N,I0,T,dt)
    S=zeros(1,T/dt);
    S(1)=N;
    I=zeros(1,T/dt);
    I(1)=I0;
    R=zeros(1,T/dt);

    for timeP=1:(T/dt)-1
        dS=(-beta*I(timeP)*S(timeP))*dt;
        dI=(beta*I(timeP)*S(timeP)-gamma*I(timeP))*dt;
        dR=(gamma*I(timeP))*dt;
        S(timeP+1)=S(timeP)+dS;
        I(timeP+1)=I(timeP)+dI;
        R(timeP+1)=R(timeP)+dR;
    end
    
end


