function [time,rinexMatrix]=readRinexNav(rinexFile)
%this function reads rinex nav file and outputs a matrix
%Typical call: outputMatrix=readRinexNav('zina1840.18n')

fipoint = fopen(rinexFile);
endHeader=0;

while 1  % We skip header
   endHeader++;
   line = fgetl(fipoint);
   answer = findstr(line,'END OF HEADER');
   if ~isempty(answer), break;	end;
end;

noeph = -1; %Count the number of lines that contains data.
while 1
   noeph = noeph+1;
   line = fgetl(fipoint);
   if line == -1, break;  end
end;

noeph = noeph/8; %because at every instance there are 8 lines

frewind(fipoint); %Start reading from the begininng of the file.

for i = 1:endHeader, line = fgetl(fipoint); end; %skip header.

eph=zeros(noeph,21);

for i = 1:noeph    %for each eph
	
	var=1;
	for j= 1:8	  %8 lines per eph
		line=fgetl(fipoint);
		if (j==1)
			eph(i,var) = str2num(line(1:2));
			var=var+1;
			eph(i,var) = str2num(line(23:41));
			var=var+1;
			eph(i,var++) = str2num(line(42:60));
			var=var+1;
			eph(i,var++) = str2num(line(61:79));
			var=var+1;	
		else	
			for k=4:19:(numel(line)-18) %line starts at 4 and increament 18 per entry;
				eph(i,var)=str2num(line(k:k+18));
				var=var+1;
				pause;
			end;
		end;
	end;
end;

rinexMatrix=eph;