function ed = nodes(S, skg)

    E = [];
    G = [];


    E = cellfun(@(x) [x(1,:); x(end,:)] ,S ,'UniformOutput' ,false);
    E = cell2mat(E');
    E = unique(E, 'rows');

    ep = bwmorph3(skg, 'endpoints');
    ep2 = rem_easy(skg);
    ep = ep + ep2>0;
    [m,n,v] = ind2sub(size(skg), find(ep(:)==1));
    E_p = [m,n,v];

    E(ismember(E,E_p, 'rows')==1,:) = [];

    %find which vessel segments are connected to each endpoint

    parfor i = 1:size(E,1)
        e = E(i,:);
        c = cellfun(@(x)sum((ismember(x,e, 'rows'))),S);
        ed{i} = find(c>0);
    end
end
