function [ linex ] = skip_header(observationfileid)
fidxxx=observationfileid;
%% start skip the header
while 1
    linex=fgetl(fidxxx);
    answer=isempty(findstr('END OF HEADER',linex));
        if answer==0
            linex=fgetl(fidxxx); break;
        end
end