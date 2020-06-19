   
function S = find_line(p)
S = [];
try
pp = [];
bin1 = 0;

    for ii = 1:size(p,1)-1
        p1 = p(ii,:);
        p2 = p(ii+1,:);
        d = norm(p2-p1);
        u = (p2-p1)/norm(p2-p1);  % unit vector, p1 to p2
        xyz = round(p1+[0:1:d-1]'.*u);
        for jj = 1:size(xyz,1)
            bin1(xyz(jj,1), xyz(jj,2), xyz(jj,3)) = 1;
        end
    end
       % bin1 = imclose(bin1, ones(2,2,2));
        bin1 = bwskel(bin1>0);
        s = segm3(bin1);
        c = cellfun(@(x)(min(sum((x.^2),2))),s);
        [~,b] = sort(c);
        S = [];
        for i = 1:length(c)
            S = [S; s{b(i)}];
        end
        if isempty(S) == 1
            S = [0 0 0];
        end
catch
    warning('Something did not work');
end

if isempty(S) == 1
    S = [0 0 0];
end
        
end

