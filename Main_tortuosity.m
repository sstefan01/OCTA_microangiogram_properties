

short_l = zeros(length(S),1);
parfor i = 1:length(S)
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
fl = cellfun(@(x)(size(x,1)),S);
tort = fl'./short_l;
    
%%
