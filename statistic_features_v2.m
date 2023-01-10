clear
clc
close all
%%
T = readtable('CoNiFeMn111_OH_dr_1.1_B.csv');
data = table2array(T);
F = data(:,1:4);
mask = F~=0;
num = 1:1:size(F,2);
n = nchoosek(num,3);
%%

for ii = 4%:size(F,2)
    for jj = 4%:size(F,2)
        prov = mask(:,ii)+mask(:,jj);
        rows = find(prov ==2); 
    end
end
%%
for ii = 4%:size(F,2)
    for jj = 4%:size(F,2)
        for kk = 4
            prov = mask(:,ii)+mask(:,jj)+mask(:,kk);
            rows = find(prov ==3);
        end
    end
end
%%
%cd Desktop
x = [1:1:100];
T = readtable('fit_aic_ini_allNL.csv');
data = table2array(T);
cc = parula(10);

for i=1:10
    plot(x,data(:,i),'Color',cc(i,:),'LineWidth',1.5)
    hold on
end
ylabel('aic','FontSize',15)
xlabel('No. of cycles','FontSize',15)
title('Fittness - Atom I (\sigma = 0.5)','FontSize',15)
set(gca,'FontSize',15)