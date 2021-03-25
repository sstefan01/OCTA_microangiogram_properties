clear Ps;
II(II==0) = median(II(:));

II1 = imresize3(mat2gray(log(II)), [size(II,1), round(size(II,2)/fszx) round(size(II,3)/fszy)]);
mip_d3 = squeeze(min((II1(end-10:end,:,:)),[],1));
figure; imagesc(squeeze((mip_d3)))
colormap(gray)
axis image
title('Press "q" to select ROI and quit')
X = [];
Y = [];
while true
    waitforbuttonpress
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'q'))
        close gcf
        break
    else
   [x,y] = ginput(1);
   hold on
    scatter(x,y, 'x', 'r')
    X = [X; x];
    Y = [Y; y];
    end
end

X = round(X);
Y = round(Y);

X(X==0) = 1;
Y(Y==0) = 1;

%Y is rows
%X is columns



for i = 1:length(X)
    P = zeros(size(mip));
    P(Y(i),X(i)) = 1;
    P = imdilate(P, strel('disk', 3));
    [m,n] = ind2sub(size(P), find(P(:) == 1));
    c = cellfun(@(x) sum(ismember(m, x(:,2))) && sum(ismember(n, x(:,3))) , S);
    Ps{i} = find(c);
end
 
 

Pen = zeros(length(Ps),1);
for i = 1:length(Ps)
    p = (Ps{i});
    pd = D(p);
    if isempty(pd) == 0
        p_pen = p(pd==max(pd));
        Pen(i) = p_pen(1);
    end
end
Pen(Pen==0) = [];

%%
