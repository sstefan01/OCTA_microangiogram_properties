function S = make_graph(S, skg, ed)
    
    ep = bwmorph3(skg, 'endpoints');
    ep2 = rem_easy(skg);
    ep = ep + ep2>0;
    bp = bwmorph3(skg, 'branchpoints');

    %expect ~3 (maybe 4, but not 2) vessels to be connected to each node
 

    l_ed = cellfun(@(x) length(x),ed); 

    f = find(l_ed == 2);

    pk = [];
    V = [];
    it = 0;
    for i = 1:length(f)
        v = ed{f(i)};
        v1 = S{v(1)};
        v2 = S{v(2)};
    if ismember(v(1), V) == 1
        continue
    end
     if ismember(v(2), V) == 1
        continue
    end
    V = [V v(1) v(2)];
    it = it +1;

    l_v1 = size(v1,1);
    l_v2 = size(v2,1);


    if l_v1 < l_v2
        vv = v1;
        v1 = v2;
        v2 = vv;
    end

        id1 = find(ismember(v1,v2, 'rows'));
        id2 = find(ismember(v2,v1, 'rows'));

        if id1 > 1
            if id2 == 1
                S_new = [v1; v2];
            else
                 S_new = [v1; flipud(v2)];
            end
        else
            if id2 == 1
               S_new = [flipud(v2); v1];
            else
               S_new = [v2;v1];
            end
        end

        S_new(sum(abs(diff(S_new, 1)),2) == 0,:) = [];


        m1 = S_new(1,1);
        n1 = S_new(1,2);
        v1 = S_new(1,3);
        if (bp(m1, n1, v1 ) == 0 & ep(m1, n1, v1) == 0) == 1
            nh = skg(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);
            [d1, d2, d3] = ind2sub(size(nh), find(nh == 1));
            D = [d1 d2 d3] - [2 2 2] + [m1 n1 v1];
            D(ismember(D, S_new, 'rows')==1,:) = [];

            for jj = 1:size(D,1)
                if bp(D(jj,1), D(jj,2), D(jj,3)) == 1 | ep(D(jj,1), D(jj,2), D(jj,3)) == 1
                    S_new = [D(jj,:); S_new];
                    break
                end
            end
        end

        m1 = S_new(end,1);
        n1 = S_new(end,2);
        v1 = S_new(end,3);
        if (bp(S_new(end,1), S_new(end,2), S_new(end,3)) == 0 & ep(S_new(end,1), S_new(end,2), S_new(end,3)) == 0) == 1
            nh = skg(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);
            [d1, d2, d3] = ind2sub(size(nh), find(nh == 1));
            D = [d1 d2 d3] - [2 2 2] + [m1 n1 v1];
            D(ismember(D, S_new, 'rows')==1,:) = [];

            for jj = 1:size(D,1)
                if bp(D(jj,1), D(jj,2), D(jj,3)) == 1 || ep(D(jj,1), D(jj,2), D(jj,3)) == 1
                    S_new = [S_new; D(jj,:)];
                    break
                end
            end
        end

        S{v(1)} = S_new;
        S{v(2)} = S_new;

        pk(it) = v(2);
        kp(it) = v(1);
        %pk{i} = [v(1) v(2)];
    end


    S(pk) = [];
end
    
 