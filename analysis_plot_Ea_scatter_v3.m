clear
clc
close all
%%
load('Mnbridge108000.mat')
max_val = max(M(:,1));
adsorbate = 'OH'; 

Eamin = -1.25;
Eamax = 0;
dEa = 0.25;
nbins = 20;
lwidth = 2;
fsize = 24;
bins = linspace(Eamin,Eamax,nbins);

%%
combo = {};
for ii = 1:4
    for jj = ii:4
        if ii == jj
            [idx,~] = find(M(:,ii) == max_val); 
            
        else
            [idx,~] = find(M(:,ii)~=0 & M(:,jj)~=0);
            
            
        end
        %[idx,~] = find(M(:,ii)~=0 & M(:,jj)~=0);
        combo{ii,jj} = M(idx,5);
    end
end
%%
[yall_bri,xall_bri] = hist(M(:,5) ,bins);
%sh = stairs(xall_bri,yall_bri,'Color',[0.8 0.8 0.8],'LineWidth',lwidth);
All_total = trapz(xall_bri,yall_bri);
sh = stairs(xall_bri,yall_bri/All_total,'Color',[0.8 0.8 0.8],'LineWidth',lwidth);
% fill background color
bottom = 0; %identify bottom; or use min(sh.YData)
x = [sh.XData(1),repelem(sh.XData(2:end),2)];
y = [repelem(sh.YData(1:end-1),2),sh.YData(end)];
fill([x,fliplr(x)],[y,bottom*ones(size(y))], [0.8 0.8 0.8]); hold on;


newcell = reshape(combo, ii*jj, 1); % reshape cells
newcell2 = newcell(~cellfun('isempty',newcell)); % remove empty cells
nseries = size(newcell2,1);
cc = jet(nseries);

for kk = 1:size(newcell2,1)
    [y_bri,x_bri] = hist(newcell2{kk,1} ,bins);
    % Atotal = trapz(x_bri,yall_bri);
    sh = stairs(x_bri,y_bri/All_total,'Color',cc(kk,:),'LineWidth',lwidth);
    % sh2 = stairs(x_bri,y_bri,'Color',cc(kk,:),'LineWidth',lwidth);
    hold on
end


grid on
axis square
set(gca,'FontSize',fsize)

box on

xticks((Eamin:dEa:Eamax))
xlabel(strcat('E_apred^{',adsorbate,'}'))
ylabel('pdf')
xlim([Eamin Eamax])

legend([ "All" "Co-Co" "Co-Fe" "Fe-Fe" "Co-Mn"...
    "Fe-Mn" "Mn-Mn" "Co-Ni" ...
    "Fe-Ni" "Mn-Ni" "Ni-Ni"],'Location','northeast')

%% hollow
clear
clc

load('Mhollow.mat')
adsorbate = 'OH'; 

Eamin = -1.0;
Eamax = 0;
dEa = 0.05;
nbins = 30;
lwidth = 2;
fsize = 24;
bins = linspace(Eamin,Eamax,nbins);

features = M(:,1:4);
C = unique(features);
C(C==0) = []; % C(1)-min; C(2)-med; C(3)-max
%%
numel_ele = 4;
combo = cell(numel_ele,1);

for ii = 1:numel_ele
    subc = {};
    for jj = ii:numel_ele
         
        for kk = jj:numel_ele
           

            if (ii == jj) && (jj == kk) % 3 elements are the same
                [idx,~] = find(M(:,ii) == C(3));
            elseif (ii == jj) && (jj ~= kk) % 2 elements are same e.g. 1-1-2;1-1-3
                [idx,~] = find(M(:,ii) == C(2) & M(:,kk) == C(1));
            elseif (ii ~= jj) && (jj == kk) % 2 elements are same e.g. 1-2-2;1-3-3
                [idx,~] = find(M(:,ii) == C(1) & M(:,kk) == C(2));
            else % no elements are same e.g. 1-2-3;1-2-4;1-3-4
                [idx,~] = find(M(:,ii) == C(1) & M(:,jj) == C(1) & M(:,kk) == C(1));
            end
            
            subc{jj, kk} = M(idx,5);
            
        end
        
    end
    combo{ii} = subc;
end

%%
[yall_bri,xall_bri] = hist(M(:,5) ,bins);
%sh = stairs(xall_bri,yall_bri,'Color',[0.8 0.8 0.8],'LineWidth',lwidth);
All_total = trapz(xall_bri,yall_bri);
sh = stairs(xall_bri,yall_bri/All_total,'Color',[0.8 0.8 0.8],'LineWidth',lwidth);
% fill background color
bottom = 0; %identify bottom; or use min(sh.YData)
x = [sh.XData(1),repelem(sh.XData(2:end),2)];
y = [repelem(sh.YData(1:end-1),2),sh.YData(end)];
fill([x,fliplr(x)],[y,bottom*ones(size(y))], [0.8 0.8 0.8]); hold on;
%% find total number of conditions - tot
new_cellall = {};
val_all = [];
cell3 = [];
for i = 1:numel_ele
    newcell = reshape(combo{i}, numel_ele*numel_ele, 1); % reshape cells
    newcell2 = newcell(~cellfun('isempty',newcell)); % remove empty cells
    new_cellall{i} = newcell2;
    cell3 = [cell3;newcell2];
end
%%
cc = jet(size(cell3,1));
Eamin = -1.0;
Eamax = 0;
dEa = 0.05;
nbins = 30;
lwidth = 2;
fsize = 24;
bins = linspace(Eamin,Eamax,nbins);
%%
for kk = 1:size(cell3,1)
    [y_bri,x_bri] = hist(cell3{kk,1} ,bins);
    sh = stairs(x_bri,y_bri/All_total,'Color',cc(kk,:),'LineWidth',lwidth);
    hold on
end

grid on
axis square
set(gca,'FontSize',fsize)

box on

xticks((Eamin:dEa:Eamax))
xlabel(strcat('E_apred^{',adsorbate,'}'))
ylabel('pdf')
xlim([Eamin Eamax])

legend([ "All" "Co-Co-Co" "Co-Co-Fe" "Co-Fe-Fe" "Co-Co-Mn" "Co-Fe-Mn" "Co-Mn-Mn"...
    "Co-Co-Ni" "Co-Fe-Ni" "Co-Mn-Ni" "Co-Ni-Ni" ...
    "Fe-Fe-Fe" "Fe-Fe-Mn" "Fe-Mn-Mn" "Fe-Fe-Ni" "Fe-Mn-Ni" "Fe-Ni-Ni" ...
    "Mn-Mn-Mn" "Mn-Mn-Ni" "Mn-Ni-Ni" "Ni-Ni-Ni"...
    ],'Location','northeast')



%%


% for i = 1:4
% 
%     for j = i:4
%         for k = j:4
%             m = combo{i}(j,k);
%             [y_bri,x_bri] = hist(m{1,1} ,bins);
%             Atotal = trapz(x_bri,y_bri);
%             sh = stairs(x_bri,y_bri/Atotal,'LineWidth',lwidth);
%             hold on
%         end
%     end
% 
% 
% end


