

short_l = zeros(length(S),1);
for i = 1:length(S)
    b = [];
    s = S{i};
    e1 = s(1,:);
    e2 = s(end,:);
    b(e2(1), e2(2), e2(3)) = 1;
    b(e1(1), e1(2), e1(3))= 0;
    d = bwdist(b, 'chessboard');
    short_l(i) = d(e1(1), e1(2), e1(3));
    if mod(i,100) == 0
        disp([num2str(i) '/' num2str(length(S))])
    end
end
full_l = cellfun(@(x)(size(x,1)),S);
tort = full_l./short_l;
    
tort_uniq = unique(tort);
c = cool(length(tort_uniq));

mip_d3 = squeeze(max(V,[],1));
figure; imagesc(squeeze((mip_d3)))
hold on
for i = 1:length(S)
    ind = find(tort(i) == tort_uniq);
    plot(S{i}(:,3), S{i}(:,2), 'linewidth', 1.5, 'color', c(ind,:))
end
colormap(gray)

%%
