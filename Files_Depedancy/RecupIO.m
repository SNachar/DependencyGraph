function [input,output,status]=RecupIO(filepath)
%% RecupIO
% Permet de r�cup�rer les inputs et outputs de fichiers
% 
stopRead = 10;          % Ligne apr�s laquelle on arr�te de lire le fichier 
fileID=fopen(filepath); % Ouverture du fichier en mode text
status=false;           % Valide la lecture de la ligne w/ "function"

for nLine=1:stopRead    % Pour chaque ligne
tline = fgetl(fileID);  % On lit la ligne nLine
if ~isempty(strfind(tline,'function'))       % Recherche du mot-cl� function
    % Analyse de l'input
    input = regexpi(tline,'\(.*\)','match');
    if ~isempty(input)
        input = regexpi(input{1},'\w*','match');
    end
    % Analyse de l'output
    output = regexpi(tline,'\[.*\]','match');
    if ~isempty(output)
        output = regexpi(output{1},'\w*','match');
    end
    status=true;
    break
end
end
if ~status
% Si on arrive � cette �tape, on arr�te de lire et on met un warning
warning(['Fin de lecture du fichier ',filepath,'\n'...
                  'Le fichier peut ne pas �tre une fonction']);
input={};
output={};
end
fclose(fileID);
end