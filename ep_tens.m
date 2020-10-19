function [Ts,x,y,z] = ep_tens(e, s,V, L,ls,ang)


if mod(L,2) == 1
    L = L+1;
end



xx = e(1)-ls/2:e(1)+ls/2;
yy = e(2)-ls/2:e(2)+ls/2;
zz = e(3)-ls/2:e(3)+ls/2;

x1 = xx(xx>0 & xx < s(1));
y1 = yy(yy>0 & yy < s(2));
z1 = zz(zz>0 & zz < s(3));

[x,y,z] = meshgrid(x1,y1,z1);



x = permute(x, [2 1 3]);
y = permute(y, [2 1 3]);
z = permute(z, [2 1 3]);
d = cat(4,x,y,z);

V = V/norm(V);
OP = d - reshape(e,1,1,1,3);
np = sqrt(sum(OP.^2,4));
OP = OP./np;

v = reshape(V, 1,1,1,3);
theta = acos(sum(repmat(v, size(OP,1), size(OP,2), size(OP,3), 1).*OP,4));
theta = max(theta, 1e-10);
r = (np.*theta)./(2*sin(theta/2));
c = L^3/(4*sin(theta).^2);
sig = L;
phi = 2*sin(theta)/L;
W = 2*OP.*sum(repmat(v, size(OP,1), size(OP,2), size(OP,3), 1).*OP,4) - v;

w = exp(-(r.^2 + c.*phi.^2)./sig.^2);
w(theta>(ang/180*pi)) = 0;
ws = w.*W;
%ws = fillmissing(ws,'nearest');
Ts = find_tensor(ws);
x = min(x(:)): max(x(:));
y = min(y(:)): max(y(:));
z = min(z(:)):max(z(:));

end