%Subsequently removes branches until no branches that are less than 5
%pixels exist.

function Jt = rem_seq(Jt)

c = 0;
it = 0;

Jt = bwskel(Jt>0);


while min(c) < 7
    it = it + 1;
    bp = bwmorph3(Jt, 'branchpoints');
    ep1 = bwmorph3(Jt, 'endpoints');
    ep2 = rem_easy(Jt);
    ep = ep1+ep2 > 0;
    %ep= ep1;
    r = find(ep==1);
    k = Jt.*(~bp);
    G = k;
    CC = bwconncomp(k);

    c = cellfun(@(x)(sum(ismember(x,r))),CC.PixelIdxList); %segments that contain endpoints
    CC.PixelIdxList(c==0) = []; %if no endpoint, ignore from further analysis
    c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
    i = find(c==min(c));
    i = i(1);
    if min(c) < 7
        G([CC.PixelIdxList{i}]) = 0; %get rid of this segment
    end
    G = G + bp > 0;
    Jt = G;

   

   % Jt = rem_point(Jt); %removes any points that can be removed without comprising connectivity
end

%remove free segments that are less than 10 pixels
    CC = bwconncomp(Jt);
    c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
    c = find(c>10);
    J = zeros(size(Jt));

    for  i = 1:length(c)
        J(CC.PixelIdxList{c(i)}) = 1;
    end
        Jt = J; 
        Jt = bwskel(Jt>0);

end