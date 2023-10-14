clear variables;

%% Obtaining data
taiwanData=readtable("covid-19_Taiwanese_data_status_revolution.xlsx",ReadVariableNames=true,VariableNamingRule="preserve");
population=23.57; %23.57 million prople
date=table2array(taiwanData(1:1076,1));

threshold=4; %density threshold

logistic="Iin*I0/(I0+(Iin-I0)*exp(-lambda*x))";
gompertz="I0*exp(log(Iin/I0)*(1-exp(-lambda*x)))";

%% Labeling data
totalInfection=table2array(taiwanData(1:1076,5))/population; %data one
totalDeath=table2array(taiwanData(1:1076,27))/population; %data three
totalActive=totalInfection-(table2array(taiwanData(1:1076,33))/population); %%%%%%%data incomplete%%%%%%%

%% Calculation

%First Curve

for i = 1:size(date,1)  %thresholding
    if totalInfection(i)>threshold
        startDay=i;
        break
    end
end
endDay=startDay+30;
date(i)
x1=(0:30).';
y1=totalInfection(startDay:endDay);
[gompertzCurve,gofGomp]=fit(x1,y1,gompertz,"StartPoint",[0.5,0.5,0.5]);  %gomp curve fitting
[logisticCurve,gofLog]=fit(x1,y1,logistic,"StartPoint",[0.5,0.5,0.5]);  %log curve fitting
gompertzCurve

%Second Curve
for k = 1:size(date,1)  %thresholding
    if totalDeath(k)>threshold
        startDayD=k;
        break
    end
end
date(k)
endDayD=startDayD+30;

x2=(0:30).';
y2=totalDeath(startDayD:endDayD);

[gompertzCurve2,gofGomp2]=fit(x2,y2,gompertz,"StartPoint",[0.5,0.5,0.5]);  %gomp curve fitting
[logisticCurve2,gofLog2]=fit(x2,y2,logistic,"StartPoint",[0.5,0.5,0.5]);  %log curve fitting
gompertzCurve2

%Active Curve
for p = 1:size(date,1)  %thresholding
    if totalActive(p)>4
        startDayA=p;
        break
    end
end

endDayA=startDayA+30;

xA=(0:30).';
yA=totalActive(startDayA:endDayA);

[gompertzCurveA,gofGompA]=fit(xA,yA,gompertz,"StartPoint",[0.5,0.5,0.5]);  %gomp curve fitting
[logisticCurveA,gofLogA]=fit(xA,yA,logistic,"StartPoint",[0.5,0.5,0.5]);  %log curve fitting

%% Active SIR fitting
%S=Susceptible
%I=Infected
%R=Recovered
%a=infection rate
%r=recovery rate


%% Plotting
figure(2)
fig=gcf;
fig.Position=[10 10 1000 400];

subplot(1,2,1);  %first

H1=plot(x1,y1, "o-");

hold on
H2=plot(gompertzCurve,"g-");
%H3=plot(logisticCurve,"r--");

title(sprintf("Infection data of first 30 days of contagion since n > %d", threshold))
ylabel("n = reported infections/million")
xlabel(sprintf("Days since measured n > %d", threshold))
%legend([H1,H2,H3],"Infected Cases","Gompertz curve","Logistic Curve",Location="northwest")
%legend(H1,"Infected Cases",Location="northwest")
legend([H1,H2],"Infected Cases","Gompertz curve",Location="northwest")
hold off

subplot(1,2,2);   %Second

H4=plot(x2,y2,"o-");

hold on
H5=plot(gompertzCurve2,"g-");
%H6=plot(logisticCurve2,"r--");

title(sprintf("Fatality data of first 30 days of contagion since m > %d", threshold))
ylabel("m = reported deaths/million")
xlabel(sprintf("Days since measured m > %d", threshold))
%legend([H4,H5,H6],"Fatal Cases","Gompertz curve","Logistic curve",Location="northwest")
%legend(H4,"Fatal Cases",Location="northwest")
legend([H4,H5],"Fatal Cases","Gompertz curve",Location="northwest")
hold off

figure(3)   %Active
fig=gcf;
fig.Position=[10 10 500 400];

HA1=plot(xA,yA,"bo-");

hold on
HA2=plot(gompertzCurveA,"g--");
HA3=plot(logisticCurveA,"r--");

title(sprintf("Active Infection of first 30 days of contagion since p > %d", threshold))
ylabel("p = active infection/million")
xlabel(sprintf("Days since measured p > %d", threshold))
legend([HA1,HA2,HA3],"Active Cases","Gompertz curve","Logistic curve",Location="northwest")
hold off

%% measure goodness of fit to evaluate


gofInfection=table(["Gompertz"; "Logistic"],[gofGomp.rmse ;gofLog.rmse],'VariableNames',["Curve Type","Root Mean Squared Error"]);
fprintf('Goodness of infection data curve fit\n')
disp(gofInfection)

gofFatality=table(["Gompertz"; "Logistic"],[gofGomp2.rmse ;gofLog2.rmse],'VariableNames',["Curve Type","Root Mean Squared Error"]);
fprintf('Goodness of fatality data curve fit\n')
disp(gofFatality)




