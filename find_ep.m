function [mm, ep] = find_ep(skg, S1)

    ep1 = bwmorph3(skg, 'endpoints');
    ep2 = rem_easy(skg);
    ep = ep1 + ep2 > 0;
    epp = zeros(size(ep));
    epp(5:end-5,5:end-5,5:end-5) = ep(5:end-5,5:end-5,5:end-5);

    [m,n,v] = ind2sub(size(skg),find(epp == 1));
    r = [m n v];
    c = cellfun(@(x)(sum(ismember(x,r, 'rows'))),S1); %segments that contain endpoints
    mm = find(c>0);
    
    [m,n,v] = ind2sub(size(skg),find(ep == 1));
    r = [m n v];
    c = cellfun(@(x)(sum(ismember(x,r, 'rows'))),S1); %segments that contain endpoints
    ep = find(c>0);
    
end

% 
% clear ep
% % segments that are at the boundary
% it = 1;
% for j = mm
%     mx = max(S1{j});
%     mi = min(S1{j});
% 
%     if sum(mi < 5) > 0 || sum(mx(1:2) > l12) >0 || mx(3) > l3
%         ep(it) = j;
%         it = it +1;
%     end
% end
% 
% % segments that are not at the boundary but have endpoints
% it = 1;
% for j = mm
%     mx = max(S1{j});
%     mi = min(S1{j});
% 
%     if sum(mi < 6) == 0 && sum(mx(1:2) > l12) == 0 && mx(3) < l3 && mi(3) > 6
%         mp(it) = j; %middle points
%         it = it +1;
%     end
% end
% end
