function [n,r] = boxcount(c,varargin)



c = logical(squeeze(c));

dim = ndims(c); 



width = max(size(c));    % largest size of the box
p = log(width)/log(2);   % nbre of generations

if p~=round(p) || any(size(c)~=width)
    p = ceil(p);
    width = 2^p;
    switch dim
        case 1
            mz = zeros(1,width);
            mz(1:length(c)) = c;
            c = mz;
        case 2
            mz = zeros(width, width);
            mz(1:size(c,1), 1:size(c,2)) = c;
            c = mz;
        case 3
            mz = zeros(width, width, width);
            mz(1:size(c,1), 1:size(c,2), 1:size(c,3)) = c;
            c = mz;            
    end
end

n=zeros(1,p+1); % pre-allocate the number of box of size r


        n(p+1) = sum(c(:));
        for g=(p-1):-1:0
            siz = 2^(p-g);
            siz2 = round(siz/2);
            for i=1:siz:(width-siz+1)
                for j=1:siz:(width-siz+1)
                    for k=1:siz:(width-siz+1)
                        c(i,j,k)=( c(i,j,k) || c(i+siz2,j,k) || c(i,j+siz2,k) ...
                            || c(i+siz2,j+siz2,k) || c(i,j,k+siz2) || c(i+siz2,j,k+siz2) ...
                            || c(i,j+siz2,k+siz2) || c(i+siz2,j+siz2,k+siz2));
                    end
                end
            end
            n(g+1) = sum(sum(sum(c(1:siz:(width-siz+1),1:siz:(width-siz+1),1:siz:(width-siz+1)))));
        end


n = n(end:-1:1);
r = 2.^(0:p); % box size (1, 2, 4, 8...)

if any(strncmpi(varargin,'slope',1))
    s=-gradient(log(n))./gradient(log(r));
    semilogx(r, s, 's-');
    ylim([0 dim]);
    xlabel('r, box size'); ylabel('- d ln n / d ln r, local dimension');
    title([num2str(dim) 'D box-count']);
elseif nargout==0 || any(strncmpi(varargin,'plot',1))
    loglog(r,n,'s-');
    xlabel('r, box size'); ylabel('n(r), number of boxes');
    title([num2str(dim) 'D box-count']);
end
