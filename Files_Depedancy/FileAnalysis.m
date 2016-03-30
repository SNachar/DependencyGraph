function [Nodes,Connexions]=FileAnalysis(filepath)
% File Analysis - Generate Connexions between Matlab files
% Stéphane Nachar (stephane.nachar@ens-cachan.fr)
% 
% Input :
% > filepath : FULL path of your file (Exemple : 'C:\test.m')
%
% Output :
% > Nodes : Struct with name & filepath of each file called by the main
% > Connexion : Double with links between idParent & idChild

%% Initialisation
Nodes = struct;
Connexions = [];
%Subgraph = struct; % For a future version
idNode = 1;
idConnexion = 1;
%idGraph = 1;

FilesUntreated={filepath}; % Liste de fichiers à traiter
niveau = 0;                % Niveau d'étude

%% Enregistrement du main :
NameParent = strrep(filepath, '.m', ''); % On retire le .m
NameParent = regexprep(NameParent, '\w*\', '');        % On retire le path (C:\*\)
NameParent = regexprep(NameParent, '.:', '');          % On retire le path (C:)

Nodes(idNode).name = NameParent;
Nodes(idNode).filepath = filepath;
[Nodes(idNode).input,Nodes(idNode).output]=RecupIO(filepath);
idNode = idNode + 1;


%% Boucle sur les niveaux
while ~isempty(FilesUntreated) % On traite niveau par niveau
    niveau = niveau+1;
    % Affichage
    display(sprintf('Niveau %d en cours de traitement',niveau));
    display(sprintf('Nombre de fichiers à traiter : %d',size(FilesUntreated,1)));
    % Traitement des fichiers du niveau non traités
    FilesUntreatedLvlUp = {};
    for idfile = 1:size(FilesUntreated,1)
        filenameParent=FilesUntreated{idfile};
        idParent = find(strcmp(filenameParent,{Nodes(:).filepath})); % Id Parent dans la structure Nodes
        [fList,~] = matlab.codetools.requiredFilesAndProducts(FilesUntreated{idfile},'toponly');
        idParentCut=strcmp(filenameParent,fList);
        fList(:,idParentCut)=[];
        display(sprintf(['        ',Nodes(idParent).name, ' a %d enfant(s)'],size(fList,2)));
        for idfList=1:size(fList,2)
            filenameChild=fList{idfList};
            idChild=find(strcmp(filenameChild,{Nodes(:).filepath}));
            if isempty(idChild) % Child non listé (donc non traité)
                idChild=idNode;
                FilesUntreatedLvlUp=[FilesUntreatedLvlUp;filenameChild]; %#ok<*AGROW>
                NameChild = strrep(filenameChild, '.m', ''); % On retire le .m
                NameChild = regexprep(NameChild, '\w*\', '');        % On retire le path (C:\*\)
                NameChild = regexprep(NameChild, '.:', '');          % On retire le path (C:)
                Nodes(idChild).name=NameChild;
                Nodes(idChild).filepath=filenameChild;
                [Nodes(idChild).input,Nodes(idChild).output]=RecupIO(filenameChild);
                idNode=idNode+1;
            end
            Connexions(idConnexion,:) = [idParent,idChild];
            idConnexion=idConnexion+1;
        end
    end
    FilesUntreated=FilesUntreatedLvlUp;
    display(sprintf('Nombre de fichiers de niveau %d : %d\n',niveau,size(FilesUntreated,1)));      
end

end