function S = rem_small(skg)

S = segm3(skg);
ed = nodes(S, skg);
S = make_graph(S, skg, ed);

l_ed = cellfun(@(x) length(x),ed);
f = find(l_ed == 2);

while isempty(f) == 0

    l_ed = cellfun(@(x) length(x),ed); 
    f = find(l_ed == 2);    
    ed = nodes(S, skg);
    S = make_graph(S, skg, ed);

end



