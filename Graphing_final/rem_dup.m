

parfor i = 1:length(S)
    s = S{i};
    c = cellfun(@(x)sum((ismember(s,x, 'rows'))),S);
    ind = find(c == size(s,1));
    if length(ind) > 1
        Dup{i} = ind;
    end
        
end


d = cellfun(@(x)length(x),Dup);
Dup = Dup(d>0);

for i = 1:length(Dup)
     if size(S{Dup{i}(1)},1) == size(S{Dup{i}(2)},1)
         de(i) = Dup{i}(1);
     end
end
