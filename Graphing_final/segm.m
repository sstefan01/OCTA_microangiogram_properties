function [S,G] = segm(Jt)

bp = bwmorph3(Jt, 'branchpoints');


k = Jt.*(~bp);

ke = bwmorph3(k, 'endpoints');
ind = find(ke ==1);

CC = bwconncomp(k);
c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
%CC.PixelIdxList((c==1)) = [];

kk = zeros(size(Jt));
for i = 1:length(CC.PixelIdxList)
kk(CC.PixelIdxList{i}) = 1;
end

CC = bwconncomp(kk);

ke = bwmorph3(kk, 'endpoints');
ind = find(ke ==1);

h = 1;
rem = [];
S = cell(1, length(CC.PixelIdxList));
for i = 1:length(CC.PixelIdxList)
    
    it = find(ismember(CC.PixelIdxList{i},ind));
    if isempty(it) ==1
        rem(h) = i;
        h = h+1;
        continue
    end
    [m,n,v] = ind2sub(size(Jt),CC.PixelIdxList{i});
    [m_e, n_e, v_e] = ind2sub(size(Jt),CC.PixelIdxList{i}(it(1)));
    r = [m n v];
    er = [m_e, n_e, v_e]; 
    r(ismember(r,er,'rows'),:) = [];
    S{i} = [er; r];
end

if isempty(rem) == 0
    S(rem) = [];
end
x = dec2bin(0:(2^3)-1)-'0';
x(1,:) = [];

for i = 1:length(S)
    A = S{i};
    V = S{i}(1,:);
    for j = 1:size(A,1)-1
        A(ismember(A,V(j,:), 'rows'),:) = [];
        D = abs(A - repmat(V(j,:),size(A,1),1));
        V(j+1,:) = A(ismember(D,x,'rows'),:);
    end
    S{i} = V;
end


% CC = bwconncomp(bp);
% c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
% ind = [CC.PixelIdxList{c==1}];
% [m,n,v] = ind2sub(size(Jt),ind);

[m, n, v] = ind2sub(size(Jt),find(bp == 1));
% 
% for i = 1:length(ind)
%     for j = 1:length(S)
%         var = S{j}([1,end],:);
% 
%         D = abs(var - repmat([m(i) n(i) v(i)] ,2,1));
%         p = find(ismember(D,x,'rows'));
% 
%         if p == 1
%             S{j} = [[m(i) n(i) v(i)]; S{j}];
%         elseif p == 2
%             S{j} = [S{j}; [m(i) n(i) v(i)]];
%         end
%         
%     end
% end
% end
% 
%'Adding branchpoints back'


for i = 1:length(m)
c = cellfun(@(x)(x([1,end],:)),S,'UniformOutput',false);
d =  cellfun(@(x)(abs(x - repmat([m(i) n(i) v(i)] ,2,1))), c, 'UniformOutput',false);
f =  cellfun(@(v)(find(ismember(v,x, 'rows'))),d,'UniformOutput',false);
g = cellfun(@(x)(isempty(x)),f);
g= find(g==0);
it = 1;
for h = 1:length(g)
    if length(f{g(it)}) == 2
        %'loop'
        G(it) = g(it);
        g(it) = [];
    else
        it = it+1;
    end
end
f = cell2mat(f(g));
for kk = 1:length(g)
    if f(kk) == 1
        S{g(kk)} = [[m(i) n(i) v(i)];S{g(kk)} ];

    elseif f(kk) == 2
        S{g(kk)} = [S{g(kk)};[m(i) n(i) v(i)] ];

    end
    
     %hold on
      %plot(S{g(kk)}(:,2), S{g(kk)}(:,1), 'linewidth',1.5)
      %drawnow
    

end
       
        

end


%    [b1, b2, b3] = ind2sub(size(bp),find(bp ==1));
%     bi = [b1 b2 b3];
%     
% for i = 1:length(bi)
%       V = find_connect(Jt,bi(i,:));
%       cc = cellfun(@(x)(sum(ismember(V,x, 'rows'))),S);
%       ind = find(cc>0);
%       S{ind} = [S{ind}; bi(i,:)];
% end


% bpp = imdilate(bp,ones(3,3,3));
% [m1,n1,v1]= find(k==bpp);
% r = [m1,n1,v1];
% cc = cellfun(@(x)(find(ismember(x,r, 'rows'))),S);

% for i = 1:length(S)
%     V = S{i};
%     ep = bwmorph3(V, 'endpoints');
%     v = V(ep,:);
% end
    
%     bp = bwmorph3(Jt, 'branchpoints');
%     CC = bwconncomp(bp);
%     c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
%     h = zeros(size(bp));
%     f = find(c<4);
%     for p = 1:length(f)
%      h(CC.PixelIdxList{p}) = 1;
%     end
%     


