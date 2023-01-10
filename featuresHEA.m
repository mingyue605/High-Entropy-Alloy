function [F,element,t] = featuresHEA(type,coords,rmin,rmax,dr,L)

    [idxO,~] = find(type=="O");
    [idxH,~] = find(type=="H");
    
    coordsO = coords(idxO,:);
    
    coordsHEA = coords;
    coordsHEA([idxO; idxH],:) = [];
    
    typeHEA = type;
    typeHEA([idxO; idxH],:) = [];
    
    numdens = numel(typeHEA)/(L(1)*L(2)*L(3));
    
    element = unique(typeHEA);
    
    delta = coordsO - coordsHEA;

    for ii=1:3
        delta(delta(:,ii)>L(ii)/2,ii) = delta(delta(:,ii)>L(ii)/2,ii) - L(ii);
        delta(delta(:,ii)<-L(ii)/2,ii) = delta(delta(:,ii)<-L(ii)/2,ii) + L(ii);
    end
    distance = sqrt(sum(delta.^2,2));
    
    nbins = (rmax - rmin)/dr;
    
    F = zeros(1,nbins*numel(element));
    
    for ii = 1:nbins
        r = rmin+(ii-1)*dr;
        for jj=1:numel(element)
            [idx_match,~] = find( distance>=r & distance<(r+dr) & typeHEA==element(jj));
            F(4*(ii-1)+jj) = numel(idx_match)/(4*pi*r.^2)/numdens;
        end
    end

end