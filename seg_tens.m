function [Ts,x,y,z] = seg_tens(s,siz,R, L, ls)

r = zeros(size(s,1),1);
for i = 1:size(s,1)
    r(i) = R(s(i,1),s(i,2),s(i,3)) + 1;
end


minx = min(s(:,1))-ls/2;
maxx = max(s(:,1))+ls/2;

miny = min(s(:,2))-ls/2;
maxy = max(s(:,2))+ls/2;

minz = min(s(:,3))-ls/2;
maxz = max(s(:,3))+ls/2;


xx = minx:maxx;
yy = miny:maxy;
zz = minz:maxz;

x1 = xx(xx>0 & xx < siz(1));
y1 = yy(yy>0 & yy < siz(2));
z1 = zz(zz>0 & zz < siz(3));

[x,y,z] = meshgrid(x1,y1,z1);

x = permute(x, [2 1 3]);
y = permute(y, [2 1 3]);
z = permute(z, [2 1 3]);
d = cat(4,x,y,z);

dd = repmat(d,1,1,1,1,size(s,1));
ss = s';
ss = reshape(ss,1,1,1,3,size(s,1));
dist = squeeze(sum((dd-ss).^2,4));

[a,b] = min(dist, [],4);
a = max(a,1e-8);
sb = reshape(s(b,:), size(d,1),size(d,2),size(d,3),size(d,4));
V = d - sb;
V = V./sqrt(a);
bin = (a>(r(b)));
bin = repmat(bin,1,1,1,3);
V2 = V.*bin;
V2 = V2.*exp(-(a - r(b)).^2/L^2); 

V = V.*(~bin) + V2;
Ts = find_tensor(V);
x = min(x(:)): max(x(:));
y = min(y(:)): max(y(:));
z = min(z(:)):max(z(:));



%%