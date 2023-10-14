clear variables
taiwanData=readtable('covid-19_Taiwanese_data_status_revolution.xlsx',ReadVariableNames=true,VariableNamingRule='preserve');

date=table2array(taiwanData(1:1076,1));
caseCount=table2array(taiwanData(1:1076,5))/23.57;
disisolation=table2array(taiwanData(1:1076,33))/23.57; %%%%%%%data incomplete%%%%%%%
deathCount=table2array(taiwanData(1:1076,27))/23.57;
figure(1)
fig=gcf;
fig.Position=[10 10 1000 400];
subplot(1,2,1);
x=date;
y1=caseCount;
plot(x,y1,'-')
title('Cumulative Infections Per Million')
legend('Infected Cases',Location="northwest")
ylabel('Number of Infected Cases Reported/million')
xlabel('Date')
%{
subplot(1,3,2)
y2=disisolation;
plot(x,y2,'-')
title('Cumulative Disisolation')
legend('Disisolated Cases',Location="northwest")
ylabel('Number of Disisolated Cases Reported')
xlabel('Date')
%}
subplot(1,2,2);
y3=deathCount;
plot(x,y3,'-')
title('Cumulative Deaths Per Million')
legend('Fatal Cases',Location="northwest")
ylabel('Number of Fatal Cases Reported/million')

xlabel('Date')