function [coords,adtype] = gencoordsAD(nx,ny,b,surface,btype)

coords = [];
count = 1;

if strcmp(surface,'100')

    if btype(1)==1
        % ATOP
        z = 2.35;
        natop = 0;
        for jj = 1:2*ny
            for ii = 1:nx
                if bitget(jj,1) == 1 % if jj is odd
                    x = b/2 + (ii-1)*b;
                    y = (jj-1)*b/2;
                else % if jj is even
                    x = (ii-1)*b;
                    y = (jj-1)*b/2;
                end
                coords(count,:) = [x y z];
                count = count + 1;
                natop = natop + 1;
            end
        end
    end

    if btype(2)==1
        % BRIDGE
        z = 1.69;
        nbridge = 0;
        for jj = 1:2*ny-1
            for ii = 1:2*nx-1
                x = b/4 + (ii-1)*b/2;
                y = b/4 + (jj-1)*b/2;
                coords(count,:) = [x y z];
                count = count + 1;
                nbridge = nbridge + 1;
            end
        end
    end

    if btype(3)==1
        % HOLLOW
        z = 1.52;
        nhollow = 0;
        for jj = 1:2*ny
            y = (jj-1)*b/2;
            for ii = 1:nx
                if bitget(jj,1) == 1 % if jj is odd
                    x = (ii-1)*b;
                else % if jj is even
                    x = (ii-1)*b+b/2;
                end
                coords(count,:) = [x y z];
                count = count + 1;
                nhollow = nhollow + 1;
            end
        end
    end


elseif strcmp(surface,'111')

    d = b/sqrt(2); % equilateral triangle side
    v = b*sqrt(3)/2/sqrt(2); % height of equilateral triangle
    x0 = d;
    y0 = 2*v/3;
    if btype(1)==1
        % ATOP
        z = 2.15;

        % x0 = d;
        % y0 = 2*v/3;
        natop = 0;
        nbridge = 0;
        nhollow = 0;
        for jj = 1:ny
            for ii = 1:nx
                if bitget(jj,1) == 1 % if jj is odd
                    x = x0 + (ii-1)*d;
                    y = y0 + (jj-1)*v;
                else % if jj is even
                    x = x0 + d/2 + (ii-1)*d;
                    y = y0 + (jj-1)*v;
                end
                coords(count,:) = [x y z];
                count = count + 1;
                natop = natop + 1;
            end
        end
    end

    if btype(2)==1
        % BRIDGE
        z = 1.6;
        natop = 0;
        nbridge = 0;
        nhollow = 0;
        for jj = 1:ny
            for ii = 1:nx
                if bitget(jj,1) == 1 % if jj is odd
                    x1 = x0 + d/4 + (ii-1)*d;
                    y1 = y0 + v/2 + (jj-1)*v;
                    x2 = x0 + 3*d/4 + (ii-1)*d;
                    y2 = y0 + v/2 + (jj-1)*v;
                    x3 = x0 + d/2 + (ii-1)*d;
                    y3 = y0 + (jj-1)*v;
                else % if jj is even
                    x1 = x0 + d/4 + (ii-1)*d;
                    y1 = y0 + v/2 + (jj-1)*v;
                    x2 = x0 + 3*d/4 + (ii-1)*d;
                    y2 = y0 + v/2 + (jj-1)*v;
                    x3 = x0 + (ii-1)*d;
                    y3 = y0 + (jj-1)*v;
                end
                coords(count,:) = [x1 y1 z];
                count = count + 1;
                nbridge = nbridge + 1;
                coords(count,:) = [x2 y2 z];
                count = count + 1;
                nbridge = nbridge + 1;
                coords(count,:) = [x3 y3 z];
                count = count + 1;
                nbridge = nbridge + 1;
            end
        end
    end

    if btype(3)==1
        % HOLLOW
        z = 1.4;
        natop = 0;
        nbridge = 0;
        nhollow = 0;
        for jj = 1:ny
            for ii = 1:nx
                if bitget(jj,1) == 1 % if jj is odd
                    x1 = x0 + d/2 + (ii-1)*d;
                    y1 = y0 + v/3 + (jj-1)*v;
                    x2 = x0 + d + (ii-1)*d;
                    y2 = y0 + 2*v/3 + (jj-1)*v;
                else % if jj is even
                    x1 = x0 + d/2 + (ii-1)*d;
                    y1 = y0 + 2*v/3 + (jj-1)*v;
                    x2 = x0 + d + (ii-1)*d;
                    y2 = y0 + v/3 + (jj-1)*v;
                end
                coords(count,:) = [x1 y1 z];
                count = count + 1;
                nhollow = nhollow + 1;
                coords(count,:) = [x2 y2 z];
                count = count + 1;
                nhollow = nhollow + 1;
            end
        end
    end

end

adtype = [zeros(natop,1)+1; zeros(nbridge,1)+2; zeros(nhollow,1)+3;];

end