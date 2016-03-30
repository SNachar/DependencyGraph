function CopyMUseful(Nodes)
% CopyMUseful
% St�phane Nachar (stephane.nachar@ens-cachan.fr)
% Copy requiredFiles from struct Nodes (cf. DependancyGraph) in another
% folder named 'CpMU_filename'
%

%% RegEx Expression
s=filesep;
if s=='\'
    s='\\'; % For RegEx, \ => \\
end
expression=['([^',s,']+)'];

%% Extraction des fichiers
main=Nodes(1).filepath;
[mainpath,mainname] = fileparts(main);
link={Nodes(:).filepath};
folder_created={''};
newfolder = ['CpMU_',mainname];
mkdir(newfolder);
sprintf('D�but de la copie : %d fichiers � traiter',size(link,2))
%% Analyse des chemins
for idlink=1:size(link,2)
    [fpath,fname,fext] = fileparts(link{idlink});
    % Cr�ation des dossiers
    fpath_red=strrep(fpath,mainpath,'');
    folders=regexpi(fpath_red,expression,'match');
    tmp=regexpi(fpath_red,expression);
    folders_link={};

    % 1:end-1 folders
    for id_folder=1:size(folders_link,2)-1
        folders_link=fpath_red(1:(tmp(id_folder+1)-2));
    if ~any(strcmp(folders_link,folder_created))
            mkdir(fullfile(mainpath,newfolder,folders_link));
            folder_created{end+1}=folders_link;
    end
    end
    
    % Last folder
    folders_link=fpath_red;
    if ~any(strcmp(folders_link,folder_created))
            mkdir(fullfile(mainpath,newfolder,folders_link));
            folder_created{end+1}=folders_link;
    end
    
    % Copy file
    newlink=fullfile(mainpath,newfolder,fpath_red,[fname,fext]);
    copyfile(link{idlink},newlink,'f');
end
sprintf('Fin de la copie : %d fichiers cr��(s), %d dossiers cr��(s)',size(link,2),size(folder_created,2))
end