cx = cellfun(@(x) sum(ismember(x1:x2, x(:,2))),S);
cy = cellfun(@(x) sum(ismember(y1:y2, x(:,3))),S);
cx = cx>0;
cy = cy>0;

S_small = S(cx & cy);
D_small = D(cx & cy);
ds_uniq = unique(D_small);

skel_small = seg2skel(S_small, V(:,x1:x2,y1:y2));



e1 = bwmorph3(skel_small, 'endpoints');
e2 = rem_easy(skel_small);
ep = e1 + e2 > 0;


[m,n,v] = ind2sub(size(skel_small), find(ep(:)==1));
e = [m n v];

c = cellfun(@(x)sum(ismember(e, x, 'rows')),S_small);
S_small(c==2) = [];
D_small(c==2) = [];
