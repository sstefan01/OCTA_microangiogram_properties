function S = conn_line_point(S1,p)

try
p1 = S1{p(1)}; %endpoint line
p2 = S1{p(2)}; %other line


v1 = sum((p2 - p1(1,:)).^2,2);
v1_pos = find(v1 == min(v1));

v2 = sum((p2 - p1(end,:)).^2,2);
v2_pos = find(v2 == min(v2));

if min(v1) < min(v2)
    p1 = p1(1,:);
    p2 = p2(v1_pos,:); 
else
    p1 = p1(end,:);
    p2 = p2(v2_pos,:); 
end


    d = norm(p2-p1);
    u = (p2-p1)/norm(p2-p1);  % unit vector, p1 to p2
    xyz = round(p1+[0:1:d-1]'.*u);
    xyz = [p1; xyz];
    xyz = [p2; xyz];

    for jj = 1:size(xyz,1)
        bin1(xyz(jj,1), xyz(jj,2), xyz(jj,3)) = 1;
    end
    bin1 = imclose(bin1, ones(2,2,2));
    bin1 = padarray(bin1, [1 1 1],0);
    [co1, co2, co3] = ind2sub(size(bin1),find(bin1(:) == 1));
    S = [co1,co2,co3];
% end
S = S-1;
catch
    warning('There was an error')
    S = [0 0 0];
end
%bin1 = bwskel(bin1>0);

% s = segm(bin1);
% if length(s)>1
%         c = cellfun(@(x)(min(sum((x.^2),2))),s);
%         [~,b] = sort(c);
%         S = [];
%         for i = 1:length(c)
%             S = [S; s{b(i)}];
%         end
%         S = [S;p2];
% elseif length(s)==1
%     S = s{1};
%     S = [S;p2];
% else


% bin1 = padarray(bin1,[1 1 1],0);
% bin1 = imclose(bin1, ones(1,1,1));
% 
% [co1, co2, co3] = ind2sub(size(bin1),find(bin1(:) == 1));
% co = [co1,co2,co3];
% 
% m1 = p1(1)+1;
% n1 = p1(2)+1;
% v1 = p1(3)+1;
% 
% co(ismember(co,[m1 n1 v1],'rows'),:)=[];
% E1 = [m1 n1 v1];
% while true
%     nh = bin1(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);
%     [d1,d2, d3] = ind2sub(size(nh), find(nh==1));
%     d1 = m1+(d1-2);
%     d2 = n1+(d2-2);
%     d3 = v1+(d3-2);
% 
%     d = [d1 d2 d3];
%     nw = d(ismember(d,co,'rows'),:);
% 
%     E = [nw(1,1) nw(1,2) nw(1,3)];
%     E1 = [E1; E];
%     
%     m1 = E(1);
%     n1 = E(2);
%     v1 = E(3);
%     
%     if sum(abs((E) - (p2+1))) == 0
%         break
%     end
%     co(ismember(co,[m1 n1 v1],'rows'),:) =[];
%     
% end
% 
% E1 = E1 - 1;


end

