clear
clc
close all

%%% this script reads the frames in an xyz file and calculates the
%%% features.

%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alloy = 'CoNiFeMn';
surface = '111';
adsorbate = 'OH';
 
rmin =1.1; %1.1;%1.5
rmax = 6.6;%6.6;%7.5
dr = 1.1;%1.1;%1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nameinp = strcat(alloy,surface,'_',adsorbate,'.xyz');

nameout = strcat('F_',alloy,surface,'_',adsorbate);

if strcmp(surface,'100') && strcmp(adsorbate,'O')
    natoms = 73;
elseif strcmp(surface,'100') && strcmp(adsorbate,'OH')
    natoms = 74;
elseif strcmp(surface,'111') && strcmp(adsorbate,'O')
    natoms = 97;
elseif strcmp(surface,'111') && strcmp(adsorbate,'OH')
    natoms = 98;
end

if strcmp(surface,'100')
    Lx = 11.55;
    Ly = Lx;
    Lz = 17.7;
elseif strcmp(surface,'111')
    Lx = 9.6;
    Ly = 8.4;
    Lz = 22;
end

L = [Lx Ly Lz];

fid = fopen(nameinp);

F = [];

countframe = 1;
count = 1;

type = strings(natoms,1);
coords = zeros(natoms,3);
tline = fgetl(fid);

while ischar(tline)

    if count == natoms + 1 % once a whole frame is read
        % calculate features
        [F(countframe,:),element] = featuresHEA(type,coords,rmin,rmax,dr,L);
        % initialize the process
        count = 1;
        type = strings(natoms,1);
        coords = zeros(natoms,3);
        countframe = countframe + 1;
    end

    % split the string into elements in a cell
    prov = split(strtrim(tline));
    if numel(prov)==4 % element x y z - 4 columns
        type(count) = convertCharsToStrings(prov{1});
        coords(count,:) = [str2double(prov{2}) str2double(prov{3}) str2double(prov{4})];
        count = count + 1;
    end

    tline = fgetl(fid);

end

% calculate features
[F(countframe,:),element] = featuresHEA(type,coords,rmin,rmax,dr,L);

fclose(fid);

imagesc(F)

save(nameout,'rmin','rmax','dr','F','element')

