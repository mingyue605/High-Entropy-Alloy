clear
clc
close all
%%
%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

alloy = 'CoNiFeMn'; % CoNiFeMn / CoNiFeCr / CoNiMoW
surface = '111';  % 100 / 111
adsorbate = 'OH'; % O / OH
ngroups = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
nameF = strcat('F_',alloy,surface,'_',adsorbate);
load(nameF)
nameEa = strcat('Ea_',alloy,surface,'_',adsorbate);
load(nameEa)


types = ["bridge","hollow"];
    
for iiii=2%:numel(types)
    name = types(iiii);

    if strcmp(name,'bridge')
        namesynF = strcat('syntheticF_',alloy,surface,'_',adsorbate,'_',name);
        load(namesynF)
    elseif strcmp(name,'hollow')
        namesynF = strcat('syntheticF_',alloy,surface,'_',adsorbate,'_',name);
        load(namesynF)
    end
    
    pred_syn_all = zeros(size(synF,1),ngroups);
    for j = 1:ngroups
        baseFileName = sprintf('%d', j);
        nameML = strcat('fitML_',alloy,surface,'_',adsorbate,'_',name,baseFileName);
        load(nameML)
        pred_syn = fit_mdl.predict(synF);
        pred_syn_all(:,j) = pred_syn;

    end
    pred_syn_all_ave = mean(pred_syn_all,2);
    Eamin = -1;
    Eamax = 1;
    dEa = 0.25;
    nbins = 20;
    
    lwidth = 2;
    fsize = 24;
    
    bins = linspace(Eamin,Eamax,nbins);
    
    [yall_bri,x_bri] = hist(pred_syn_all_ave,bins);
    Atotal = trapz(x_bri,yall_bri);
    figure;
    stairs(x_bri,yall_bri/Atotal,'k','LineWidth',lwidth)
    
    grid on
    axis square
    set(gca,'FontSize',fsize)
    
    box on
    
    xticks((Eamin:dEa:Eamax))
    yticklabels(0)
    
    xlabel(strcat('E_a^{',adsorbate,'}'))
    ylabel('pdf')
    
    xlim([Eamin Eamax])
    
    legend([name],'Location','northwest')

    hold on
    
end

