function [coords,L] = gencoordsHEA(nx,ny,nz,b,surface)

if strcmp(surface,'111')

    d = b/sqrt(2); % equilateral triangle side
    v = b*sqrt(3)/2/sqrt(2); % height of equilateral triangle
    h = b/sqrt(3); % interlayer distance

    % generate a triangular planar lattice
    plane = [];
    count = 1;
    for jj=1:ny
        y = (jj-1)*v;
        if mod(jj,2)==0
            incrx = d/2;
        else
            incrx = 0;
        end
        for ii=1:nx
            x = incrx + (ii-1)*d;
            plane(count,:) = [x y 0];
            count = count + 1;
        end
    end
    % generate a block of ABC stacking
    coords_ABC = [plane(:,1)     plane(:,2)       plane(:,3);
        plane(:,1)+d/2 plane(:,2)+v/3   plane(:,3)+h;
        plane(:,1)+d   plane(:,2)+2*v/3 plane(:,3)+2*h];

    nblocks = nz/3;
    hblock = 3*h;
    coords = [];
    for uu=1:nblocks
        coords = [coords; coords_ABC(:,1) coords_ABC(:,2) coords_ABC(:,3)+(uu-1)*hblock];
    end

    L = [b/sqrt(2)*nx b*sqrt(3)/2/sqrt(2)*ny b/sqrt(3)*nz+10];

elseif strcmp(surface,'100')

    coords_unitcell_fcc = b*[0 0 0;(1/2) (1/2) 0;(1/2) 0 (1/2);0 (1/2) (1/2)];

    % generate coordinates in FCC lattice
    coords = [];
    for ii = 1:nx
        dx = (ii-1)*b;
        for jj = 1:ny
            dy = (jj-1)*b;
            for kk = 1:nz
                dz = (kk-1)*b;
                coords = [coords; coords_unitcell_fcc + [dx dy dz]];
            end
        end
    end

    L = [b*nx b*ny b*nz+10];
    
end

end