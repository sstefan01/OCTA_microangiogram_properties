%This function approximates the surface of the sample and gives the indices
%at the surface of the sample at each (x,y) position.

function [surf1, surf] = sf_ind(II)

S = zeros(size(II,2), size(II,3));

for i = 1:size(II,2)
    for j = 1:size(II,3)

        s = II(:,i,j);
        ind = find(diff(log10(s))== max(diff(log10(s))));
        S(i,j) = ind(1);
    end
end

surf = medfilt2(S, [10 10]);
surf1 = surf;

[sx,sy] = size(surf1);

[x,y] = meshgrid(1:size(II,3), 1:size(II,2));
x = reshape(x, size(x,1)*size(x,2),1);
y = reshape(y, size(y,1)*size(y,2),1);
surf1 = reshape(surf1, sx*sy,1);

[sf1, gof1] = fit([x, y],surf1,'poly11', 'Robust','LAR');
[sf2, gof2] = fit([x, y],surf1,'poly22','Robust','LAR');

if gof1.rsquare > gof2.rsquare
    surf1 = sf1.p00 + sf1.p10*x + sf1.p01*y;
else
    surf1 = sf2.p00 + sf2.p10*x + sf2.p01*y + sf2.p20*x.^2 + sf2.p11*x.*y + sf2.p02*y.^2;
end
surf1 = sf1.p00 + sf1.p10*x + sf1.p01*y;
surf1 = reshape(surf1,sx,sy);
surf1 = round(surf1);
end