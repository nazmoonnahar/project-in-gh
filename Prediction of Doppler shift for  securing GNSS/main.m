%%
close all; clear all; clc; 
format long;

%% input files

navfile='zina1840.18n'; % the navigation file
obsfile='zina1940.18o'; % the observation file


%% read the navigation file %%

outputfile='eph.dat'; % the output generated from the navigation file
rinexe(navfile,outputfile);
Eph = get_eph(outputfile);

%% read the observation file %%
fido = fopen(obsfile,'rt'); %rt is reading permission and t for text mode

%% analyze observation file header %%
[Obs_types1, ant_delta1, ifound_types1, eof11] = anheader(obsfile);
NoObs_types1 = size(Obs_types1,2)/2;
liney=skip_header(fido);

no_of_epochs=1; % this adversary model works with 1 epoch only
Pos = [];

%% calculate position and plot
for q=1:no_of_epochs
%     [ obsnew1,time1,sats1,linex1 ] = readdata(fido,liney);
    [ obsnew1,time1,sats1,linex1 ] = readdata_g(fido,liney);
    liney=linex1;
    i = fobs_typ(Obs_types1,'C1');
    pos = recpo_ls(obsnew1(:,i),sats1,time1,Eph);
    Pos = [Pos pos]; % this is the calculated position
    
    figure(10);
    % Real and attacker induced position is figure 10
    scatter3(Pos(1,q),Pos(2,q),Pos(3,q),'fill','MarkerFaceColor','r','MarkerEdgeColor','r');
%     plot3(Pos(1,q),Pos(2,q),Pos(3,q));
    hold on;
%     grid off;
end

real_position = mean(Pos,2); % for no_of_epoch > 1
status = fclose(fido);
fprintf('\nTrue Position\nX: %12.3f  Y: %12.3f  Z: %12.3f', real_position(1,1), real_position(2,1), real_position(3,1))
%% adversary model
% underattack1 = [7 8 6]; % prns of spoofed sats
underattack1 = [3 6]; % prns of spoofed sats
replaydelay = 1e-6; % signal replay delay by attacker % min 0.42e-6
[obsnew2, obsfresh, obsfake]= replayattack(obsnew1,replaydelay,underattack1);

% the above line imposes the replay delay to sats under attack
% and generates a new observation matrix obsnew2
% besides, obsfresh matrix contains values with non-polluted pseudoranges
% and obsfake matrix contains values with only polluted pseudoranges

Position_under_influence= recpo_ls(obsnew2(:,i),sats1,time1,Eph);
fprintf('\nAttacker-influenced Position\nX: %12.3f  Y: %12.3f  Z: %12.3f', Position_under_influence(1,1), Position_under_influence(2,1), Position_under_influence(3,1))
scatter3(Position_under_influence(1,q),Position_under_influence(2,q),Position_under_influence(3,q),'fill','MarkerFaceColor','b','MarkerEdgeColor','b');
legend('True Position','Attacker-influenced Position')
dista=dist3d(Position_under_influence,real_position);
fprintf('\n Distance between "Attacker-influenced" and "True" position is \n%12.3f meters\n',dista)
%str = sprintf('Distance between "attacker induced" position \nand "original" position is %5.3f meters', dista);
str=sprintf('"True position" and "Attacker-influenced  position" of the receiver');
title(str);
hold off;

%% calculate every different combinations
for number_of_sats_in_calc = 6
    satsindex = [1: length(sats1)];
    comb = combnk(satsindex,number_of_sats_in_calc);
    % generates all the combinations of sats taking
    % "number_of_sats_in_calc" at a time. 
    
    Position = []; 
%     FreshPosition=[];
    
    for combindex = 1:size(comb,1)
        [obscombnew,satscombnew] = gencombgs (obsnew2,sats1,comb,combindex);
        positionx=recpo_ls(obscombnew(:,i),satscombnew,time1,Eph);
        Position=[Position positionx];
        hold on;
    end
    clfilename=['cl' num2str(number_of_sats_in_calc) '.mat'];
    delete(clfilename);
    save(clfilename,'Position','number_of_sats_in_calc','sats1','comb','satsindex','Pos')
    
    clfilenamecommon='export.mat';
    delete(clfilenamecommon);
    save(clfilenamecommon,'Position','number_of_sats_in_calc','sats1','comb','satsindex','Pos')
end

MeanFakePosition=mean(Position,2);
fprintf('\nMean Combinatorial Position\nX: %12.3f  Y: %12.3f  Z: %12.3f', MeanFakePosition(1,1), MeanFakePosition(2,1), MeanFakePosition(3,1))

distc=dist3d(Position_under_influence,MeanFakePosition);
fprintf('\n Distance between "Attacker-influenced" and "Mean Combinatorial" position is \n%12.3f meters\n',distc)
%%
figure(20)
% Real and "mean of combinations" is figure 20
scatter3(Pos(1,q),Pos(2,q),Pos(3,q),'fill','MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
scatter3(MeanFakePosition(1,:),MeanFakePosition(2,:),MeanFakePosition(3,:),'fill','MarkerFaceColor','k','MarkerEdgeColor','k');
legend('True position','Mean Combinatorial Position');
distb=dist3d(MeanFakePosition,real_position);
fprintf('\n Distance between "Mean Combinatorial Position" and "True position" is \n%12.3f meters\n',distb)
str = sprintf('Distance between "Mean combinatorial position" \nand "True position" is %5.3f meters', distb);
title(str);
hold off;

%% 
figure(30)
% Real and all the combinations is figure 30
colormap parula
scatter3(Position(1,:),Position(2,:),Position(3,:),'*','MarkerEdgeColor','k');
hold on;
scatter3(Position_under_influence(1,q),Position_under_influence(2,q),Position_under_influence(3,q),'fill','MarkerFaceColor','b','MarkerEdgeColor','b');
scatter3(Pos(1,q),Pos(2,q),Pos(3,q),'fill','MarkerFaceColor','r','MarkerEdgeColor','r');
scatter3(MeanFakePosition(1,:),MeanFakePosition(2,:),MeanFakePosition(3,:),'fill','MarkerFaceColor','k','MarkerEdgeColor','k');
legend('Combinations','Attacker-influenced Position','True Position','Mean combinatorial Position','location','best');
str=sprintf('Comparison of positions of the receiver');
title(str)
% legend(,'Real Position');
hold off;


%%
figure(40)
% Real and all the combinations is figure 40
% but closer to 40 meters to the real position are red.
for check=1:size(Position,2)        
    if ((real_position(1,1)-Position(1,check))^2+(real_position(2,1)-Position(2,check))^2+(real_position(3,1)-Position(3,check))^2) <= (40)^2
%         disp('true')
        figure(40)
        scatter3(Position(1,check),Position(2,check),Position(3,check),'d','MarkerEdgeColor','r')
        hold on;
%         grid off;
    else
        figure(40)
        scatter3(Position(1,check),Position(2,check),Position(3,check),'d','MarkerEdgeColor','b')
%         disp('false')
%         grid off;
        hold on;
    end
end
scatter3(Pos(1,q),Pos(2,q),Pos(3,q),'fill','MarkerFaceColor','r','MarkerEdgeColor','r');
stra='All the combinations, but closer to the real position are red.';
title(stra);
hold off;

%% Exporting the variables for other m files
cl=Position; cl(4,:)=[]; 
% cl=cl';
pall=cl;
positionfilename='cl.mat'; delete('cl.mat');
save(positionfilename,'cl','sats1','underattack1','number_of_sats_in_calc','Pos')
fakeobsfilename='obsnew2.mat'; delete('obsnew2.mat');
save(fakeobsfilename,'obsnew2')

figure(10)
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')

figure(30)
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
