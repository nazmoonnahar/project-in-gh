%%
close all; clear all; clc; 
format long;

%% input files

%navfile='zina1940.18n'; % the navigation file
%obsfile='zina1940.18o'; % the observation file


prompt = 'Navigational File name: ';
navfile = input(prompt,'s');
prompt = 'Observational File name: ';
obsfile = input(prompt,'s');

%navfile='zina2100.18n';
%obsfile='zina2100.18o';

%navfile='baku2080.18n';
%obsfile='baku2080.18o';
%% read the navigation file %%
[time,Trtime,Eph]=rinexe(navfile);

no_of_epochs=numel(Eph(1,:));
navPos = satpos(time,Eph);%position is calculated for all Eph of navfile.

navTime = time; 

%% read the observation file %%
fido = fopen(obsfile,'rt'); %rt is reading permission and t for text mode

%% analyze observation file header %%
[Obs_types1, ant_delta1, ifound_types1, eof11] = anheader(obsfile);
Obs_types1=[Obs_types1(1:strfind(Obs_types1,'#')-1)]
NoObs_types1 = size(Obs_types1,2)/2;
liney=skip_header(fido);

obsTime=[]; 
obsPos = [];
%% calculate position and plot
figure(10);

xlabel('X position'), ylabel('Y position'), zlabel('Z position');
for q=1:no_of_epochs

    [ obsnew1,time1,sats1,linex1 ] = readdata_g(fido,liney,Obs_types1);
    liney=linex1;
	obsTime=[obsTime time1];
    i = fobs_typ(Obs_types1,'C1');
    pos = recpo_ls(obsnew1(:,i),sats1,time1,Eph);
    obsPos = [obsPos pos]; % this is the calculated position using observational file
    
    figure(10);
    % Real and attacker induced position is figure 10
    scatter3(obsPos(1,q),obsPos(2,q),obsPos(3,q),'fill','MarkerFaceColor','r','MarkerEdgeColor','r');
    scatter3(navPos(1,q),navPos(2,q),navPos(3,q),'fill','MarkerFaceColor','b','MarkerEdgeColor','b');
    
	xlabel('X position'), ylabel('Y position'), zlabel('Z position');
	title('Satellite and Reciever position.');
	
%     plot3(Pos(1,q),Pos(2,q),Pos(3,q));
    hold on;
%     grid off;
end

hold off;
pause;
sampleNavPos=navPos(1:3,1:32);
sampleObsPos=obsPos(1:3,1:32);
sampleObsTime=obsTime(1:32);
sampleNavTime=navTime(1:32);
sampleOmegaDot=Eph(17,1:32);
sampleSatNumber=Eph(1,1:32);
sampleTheta=Eph(7,1:32);

%variables
ro= sqrt(sum((sampleNavPos-sampleObsPos).^2));
C=ro./(sampleObsTime-sampleNavTime);
%C=2.99*10^8;
r=6371000;
R=r+ro;
velocityObs=464.58;
velocitySat=sampleOmegaDot;
L1=1575.42*10^6;

dopplerShift= ((C+velocityObs)./(C-velocitySat))*L1;
dopplerFrequencyDifference=(L1-dopplerShift);

v=sampleOmegaDot.*cos(sampleTheta);

outputPackege=[sampleSatNumber;dopplerShift;dopplerFrequencyDifference;v]
output=[];
temp=[];

while 1
	prompt='Satellite Number ';
	satNum=input(prompt);
	if(satNum==0)
		break;
	end;
	for i=1 : 32
		if(outputPackege(1,i))==satNum
			 output=[output outputPackege(:,i)];
		end;
	end;
	output
	output=[];
end;
			


%plots
histogram(sampleSatNumber);
xlabel('Sat Number'), ylabel('frequency');
title('Satellite number and frequency.');
pause;

x=outputPackege(1,:);
y=outputPackege(3,:);
plot(x, y), xlabel('SatelliteNumber'), ylabel('dopplerfrequencyDifference'), title('SatelliteVSDopplerShift')
pause;

scatter(outputPackege(1,:),outputPackege(4,:));
xlabel('Sat Number'), ylabel('Velocity');
title('Satellite number Vs Velocity.');