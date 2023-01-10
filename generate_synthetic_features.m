clear
clc
close all

%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

alloy = 'CoNiFeMn'; % CoNiFeMn / CoNiFeCr / CoNiMoW
surface = '111';  % 100 / 111

numconf = 10; % number of HEA configurations

% size of system
nx = 6; 
ny = 6; 
nz = 6; % needs to be a multiple of 3 for the fcc (111) surface

stoichiometry = [0.25 0.25 0.25 0.25]; % the order is in variable "element"


btype = [0 0 1]; % 0-no, 1-yes, [atop bridge hollow]

if btype(1)==1
    name = 'atop';
elseif btype(2)==1
    name = 'bridge';
else
    name = 'hollow';
end

adsorbate = 'OH';

nameout = strcat('syntheticF_',alloy,surface,'_',adsorbate,'_',name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% load relevant files
nameF = strcat('F_',alloy,surface,'_',adsorbate);
load(nameF,'element','rmin','rmax','dr')

% lattice constant
if strcmp(alloy,'CoNiFeMn')
    b = 3.42;
elseif strcmp(alloy,'CoNiFeCr')
    b = 3.43;
elseif strcmp(alloy,'CoNiMoW')
    b = 3.85;
end

nelements = numel(element);

% generate xyz of one HEA system with the surface termination "surface"
[coordsHEA,L] = gencoordsHEA(nx,ny,nz,b,surface);
coordsHEA(:,3) = coordsHEA(:,3) - max(coordsHEA(:,3));
% generate xyz of one HEA system with the surface termination "surface"
[coordsAD,adtype] = gencoordsAD(nx,ny,b,surface,btype);

nHEA = size(coordsHEA,1);
nAD = size(coordsAD,1);
ntotal  = nHEA + nAD;

nbins = (rmax - rmin)/dr;
neach = round(stoichiometry*nHEA);

synF = zeros(numconf*nAD,nbins*numel(element));

count = 1;
for ii=1:numconf

    % generate the array of atom types.
    type = [];
    for kk=1:numel(element)
        type = [type; repmat(element(kk),neach(kk),1)];
    end
    % shuffle the atom types
    type = type(randperm(nHEA,nHEA));
    type = [type; "O"];
    for jj=1:nAD
        coords = [coordsHEA; coordsAD(jj,:)];
        [synF(count,:),~] = featuresHEA(type,coords,rmin,rmax,dr,L);
        count = count + 1;
    end

end

adtype = repmat(adtype,numconf,1);

%save(nameout,'synF','element','adtype','name')

