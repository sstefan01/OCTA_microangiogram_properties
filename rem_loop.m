function [skel, de] = rem_loop(S,O, skel)

[a,b] = sort(O, 'ascend');

ind = b(a<0.5);
itt = 1;

skel = bwskel(logical(skel));
ep = bwmorph3(skel, 'endpoints');

for i = 1:length(ind)
    
    s = S{ind(i)};
    bp = bwmorph3(skel, 'branchpoints');


    skg = skel;
    for j = 1:size(s,1)
        skg(s(j,1),s(j,2),s(j,3)) = 0;
    end
    %skg = imclose(skg, ones(2,2,2));
    skg = skg + bp > 0;
    
    %skg = bwskel(logical(skg), 'MinBranchLength',3);

    epp = bwmorph3(skg, 'endpoints');
    
    
    a = epp == ep;
    if sum(a(:)<1) == 0
        %sum(abs(epp(:) - ep(:))) == 0
        skel = skg;
        de(itt) = ind(i);
        itt = itt+1;
    end
    
    
end


