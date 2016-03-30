function [filepath_output]=GraphwizConversion(Nodes,Connexions)
%% Rédaction du fichier Graphwiz
delete('graphwiz.dot')
fileID = fopen('graphwiz.dot','w');
finit = ['digraph g { \n',...
        'graph [\n',...
        '    rankdir = LR\n',...
        '    bgcolor= white\n',...
        ']\n',...
        '\n'];
fend  = '\n}';

% Rédaction de l'entête
fprintf(fileID,finit);

% Rédaction des Nodes
for idNodes=1:size(Nodes,2)
    txtinput=[];
    for idInput=1:size(Nodes(idNodes).input,2)
        txtinput=[txtinput,'|',Nodes(idNodes).input{idInput}]; %#ok<*AGROW>
    end
    txtoutput=[];
    for idOutput=1:size(Nodes(idNodes).output,2)
        txtoutput=[txtoutput,'|',Nodes(idNodes).output{idOutput}];
    end
    tmp=['Node',num2str(idNodes),' [\n',...
        '	label = "',Nodes(idNodes).name];
    if size(Nodes(idNodes).input,2)~=0
        tmp=[tmp,'|Input:',txtinput];
    end
    if size(Nodes(idNodes).output,2)~=0
        tmp=[tmp,'||Output:',txtoutput];
    end
    tmp=[tmp,'"\n',...
        '   shape = "record"',...
        '   fontsize = 9',...
        ']\n',...
        '\n'];
    fprintf(fileID,tmp);
end

for idConnexions=1:size(Connexions,1)
    tmp=['Node%d -> Node%d [\n'...
        '	penwidth = 1\n'... 
        '	fontsize = 8\n'... 
        ']\n'...
        '\n'];
    fprintf(fileID,tmp,Connexions(idConnexions,1),Connexions(idConnexions,2));
end

% Rédaction de la fin
fprintf(fileID,fend);
fclose(fileID);
filepath_output=[pwd,'\graphwiz.dot'];
end