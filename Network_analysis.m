S2 = S;

ed = nodes(S2, skel);
c = cellfun(@(x) length(x),ed);
S2(cell2mat(ed(c==1))) = [];


mp = find_ep(skel, S2);
while isempty(mp) == 0
    S2(mp) = [];
    mp = find_ep(skel, S2);
end
    

skel = seg2skel(S2, skel);
Adj = zeros(length(S2));
for i = 1:length(S2)
    c = cellfun(@(x)sum((ismember(x,S2{i}, 'rows'))),S2); 
    ind = find(c>0);
    ind(ind==i) = [];
    Adj(i, ind) = 1;
end

g = graph(Adj);
metrics = getGraphMetrics(g);






