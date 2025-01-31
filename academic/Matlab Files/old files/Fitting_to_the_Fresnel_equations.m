%Import the data from Excel

data=xlsread('FresnelEquations.xlsx');

AngleOfIncidence=data(:,1);
SPolarisation=data(:,2);
PPolarisation=data(:,3);


%Clear the current figure

clf;
figure(1)

%Plot the measured points using errorbar()

hold on

errorbar(AngleOfIncidence,PPolarisation,0.05*ones(size(PPolarisation)),'b+');
errorbar(AngleOfIncidence,SPolarisation,0.05*ones(size(PPolarisation)),'ro');
xlabel('Angle of incidence (degrees)');
ylabel('Reflection coefficient');

legend('P polarisation data','S polarisation data');
axis normal
grid on
box on

hold off

%Generate the theory data

AngleOfIncidenceDegrees = 0:1:90;

Rs = ReflectionS(1.4,AngleOfIncidenceDegrees);
Rp = ReflectionP(1.4,AngleOfIncidenceDegrees);


%Add the theory data to the graph

hold on

plot(AngleOfIncidenceDegrees,Rp,'blue');
plot(AngleOfIncidenceDegrees,Rs,'red');

hold off

%Find the best fit

SPolFit = fitnlm(AngleOfIncidence,SPolarisation,@ReflectionS, [1.5]);
PPolFit = fitnlm(AngleOfIncidence,PPolarisation,@ReflectionP, [1.5]);

%Generate the fit data

SPol_n = round(SPolFit.Coefficients{1,1},2);
PPol_n = round(PPolFit.Coefficients{1,1},2);
SPol_error = round(SPolFit.Coefficients{1,2},1, 'significant');
PPol_error = round(PPolFit.Coefficients{1,2},1,'significant');


RsFit = ReflectionS(SPol_n,AngleOfIncidenceDegrees);
RpFit = ReflectionP(PPol_n,AngleOfIncidenceDegrees);

%Add the best fit data to the graph

hold on
 
plot(AngleOfIncidenceDegrees,RpFit,'blue--');
plot(AngleOfIncidenceDegrees,RsFit,'red--');
xlabel('Angle of incidence (degrees)');
ylabel('Reflection coefficient');
axis([0,90,-0.1,1]);
h=legend('P polarisation data','S polarisation data','P polarisation theory, n = 1.3','S polarisation theory, n = 1.3',join(['P polarisation best fit, n = ',num2str(num2str(PPol_n)),'+/-',num2str(num2str(PPol_error))]),join(['S polarisation best fit, n = ',num2str(num2str(SPol_n)),'+/-',num2str(num2str(SPol_error))]));
set(h,'FontSize',10,'location','northwest');
title ('Fresnel Coefficients for S and P Polarised light','FontSize',10, 'FontWeight', 'normal');

hold off




%Define the functions for the Fresnel coefficients

function [ ReflectionDataS ] = ReflectionS(n2,theta)

ReflectionDataS = abs((cos(theta*pi/180)-n2*sqrt(1-((1/n2)*sin(theta*pi/180)).^2))./(cos(theta*pi/180)+n2*sqrt(1-((1/n2)*sin(theta*pi/180)).^2))).^2;

end

function [ ReflectionDataP ] = ReflectionP(n2,theta)

ReflectionDataP = abs((-n2*cos(theta*pi/180)+sqrt(1-((1/n2)*sin(theta*pi/180)).^2))./(n2*cos(theta*pi/180)+sqrt(1-((1/n2)*sin(theta*pi/180)).^2))).^2;

end






