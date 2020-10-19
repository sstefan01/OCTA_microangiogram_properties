zd = round(size(V,1)*0.2);
dep = cellfun(@(x) x(:,1) ,S ,'UniformOutput' ,false);
pial = cellfun(@(x) sum(ismember(1:zd, x)), dep);
b0 = find(pial);
b0 = b0(D(b0) > nanmean(D));
P = b0;
it = 2;
b_s = S(b0);
B{1} = b0;
mD(1) = mean(D(b0));
mL(1) = mean(full_l(b0));
mT(1) = mean(tort(b0));

while true
    b = [];
    for i = 1:length(b_s)
        s = b_s{i};
        c = cellfun(@(x) sum(ismember(x, s, 'rows')), S);
        sb = find(c);
        sb(ismember(sb,P)) = [];
        if isempty(sb) == 0
            b = [b sb];
        end
    end
    b = unique(b);
    B{it} = b;
    mD(it) = mean(D(b));
    mL(it) = mean(full_l(b));
    mT(it) = mean(tort(b));
    it = it + 1;
    P = [P b];
    b_s = S(b);
    if isempty(b_s) ==1
        break
    end
end

branch = cellfun(@(x) length(x), B);
