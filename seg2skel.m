function skel = seg2skel(S, Enh)
skel = zeros(size(Enh));

for i = 1:length(S)
    s = S{i};
    if sum(s(:))>0
        for j= 1:size(s,1)
         skel(s(j,1), s(j,2), s(j,3)) = 1;
        end
    end
end

