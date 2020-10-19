net_reg = load('net_regress');
net_unet = load('net_unet');
load('net12_16_final.mat')

[s1, s2, s3] = size(DD2);
m1 = mod([s1 s2 s3],32);
p1 = 0; p2 = 0; p3 = 0;

if m1(1) > 0
    p1 = 32-m1(1);
end

if m1(2) > 0
    p2 = 32-m1(2);
end

if m1(3) > 0
    p3 = 32-m1(3);
end

if sum(m1) > 0
    DD2 = padarray(DD2, [p1 p2 p3], 'post');
end

DD2(DD2 == 0) = 1;
logDD = log(DD2);
logDD(logDD(:) == 0) = min(logDD(:));
logDD = mat2gray(logDD);

Enh1 = activations(net_reg.net, logDD, 'regressionoutput', 'executionenvironment', 'cpu');
Enh2 = activations(net_unet.net, logDD, 'reg', 'executionenvironment', 'cpu'); %too big to run on gpu

Enh = max(Enh1,Enh2);
Enh = Enh(1:s1,:,:);
m1 = mod(s1,12);
if m1 > 0
    p1 = 12 - m1;
    Enh = padarray(Enh,[p1 0 0], 'post');
end

seg_approx = semanticseg(Enh,net12_16_final, 'executionenvironment', 'cpu');
seg_approx = double(seg_approx) - 1;
seg = imclose(seg_approx,ones(5,5,5));

seg = seg(1:s1,1:s2,1:s3);
Enh = Enh(1:s1,:,:);
logDD = logDD(1:s1,1:s2,1:s3);

seg = imgaussfilt3(seg,1) > 0.3;

c(:,:,:,1) = logDD;
c(:,:,:,2) = Enh;
c(:,:,:,3) = seg;
seg_corr = activations(corrnet,c,'dice', 'executionenvironment','cpu');
seg2 = max(seg_corr(1:s1,1:s2,1:s3,2),seg);
seg = seg2>0.5;
seg = imclose(seg,ones(3,3,3));

CC  = bwconncomp(seg);
numPixels = cellfun(@numel,CC.PixelIdxList);
ind = find(numPixels > 100);
res = zeros(size(seg));
for i = 1:length(ind)
    res(CC.PixelIdxList{ind(i)}) = 1;
end
%%

V = Enh;
skel1 = make_skel(res,V );
S1 = segm3(skel1); %finds segments
c = cellfun(@(x) size(x,1), S1);
S1(c==2)=[];
skel1 = seg2skel(S1, res);
skel1 = imclose(skel1, ones(3,3,3));
skel1 = bwskel(skel1>0, 'Minbranchlength',5);
%S1 = segm3(skel1); % 
S1 = rem_small(skel1);

[skel2, Sc] = main_tensor_connect(skel1,S1,res);
skel2 = recenter(skel2, V.*imdilate(skel2, ones(3,3,3)));
S2 = segm3(skel2);
%skel3 = recenter(skel2, V.*imdilate(skel2, ones(3,3,3)));
%S3 = segm3(skel3); %
c = cellfun(@(x) size(x,1), S2);
S2(c==2)=[];
skel2 = seg2skel(S2, res);
skel2 = imclose(skel2, ones(3,3,3));
skel2 = bwskel(skel2>0, 'Minbranchlength',5);
S2 = segm3(skel2); % 
skel2 = seg2skel(S2, skel2);
mp1 = find_ep(skel2, S2);
lmp1 = length(mp1);

S2 = rem_small(skel2);
[skel3, Sc] = main_tensor_connect(skel2,S2,res);
skel3 = recenter(skel3, V.*imdilate(skel3, ones(3,3,3)));
%S3 = segm3(skel3);
S3 = rem_small(skel3);
c = cellfun(@(x) size(x,1), S3);
S3(c==2)=[];
skel3 = seg2skel(S3, res);
skel3 = imclose(skel3, ones(3,3,3));
skel3 = bwskel(skel3>0, 'Minbranchlength',5);
S3 = segm3(skel3);
skel3 = seg2skel(S3, skel3);
mp2 = find_ep(skel3, S3);
lmp2 = length(mp2);
S3 = rem_small(skel3);

[skel4, Sc] = main_tensor_connect(skel3,S3,res);
S4 = segm3(skel4);
c = cellfun(@(x) size(x,1), S4);
S4(c==2)=[];
skel4 = seg2skel(S4, res);
skel4 = imclose(skel4, ones(3,3,3));
skel4 = bwskel(skel4>0, 'Minbranchlength',5);
S4 = rem_small(skel4);
%%
[O, O2] = rem_nongauss_whole(S4,V); 
O = max(O,O2);
[skel5] = rem_loop(S4,O, skel4); 
S5 = segm3(skel5);


S6 = S5;
skel6 = skel5;
ls = length(S5);
ls2 = 0;

while ls ~= ls2
    ep = find_ep(skel6, S6); %find segments containing endpoints
    [O, O2] = rem_nongauss_whole(S6(ep), V);
    O = max(O, O2);
    ls = length(S6);
    S6(ep(O<0.5)) = []; %removing segments with endpoints that are not vessels
    ls2 = length(S6);
    skel6 = seg2skel(S6, V);
    S6 = segm3(skel6);
end

S7 = rem_small(skel6);
%%
[skel8, Sc] = main_tensor_connect(skel6,S7,res);
S8 = segm3(skel8);

%%


 c = cellfun(@(x) size(x,1), S4);
 S4(c==2)=[];
 skel4 = seg2skel(S4, res);
 skel4 = imclose(skel4, ones(3,3,3));
 skel4 = bwskel(skel4>0, 'Minbranchlength',5);
S4 = segm3(skel4);
skel4 = seg2skel(S4, skel4);
mp2 = find_ep(skel4, S4);
lmp2 = length(mp2);

[skel5, Sc] = main_tensor_connect(skel4,S4,res);

S5 = segm3(skel5);
c = cellfun(@(x) size(x,1), S4);
S4(c==2)=[];
skel4 = seg2skel(S4, res);
skel4 = imclose(skel4, ones(3,3,3));
skel4 = bwskel(skel4>0, 'Minbranchlength',5);
S4 = segm3(skel4);
skel4 = seg2skel(S4, skel4);
mp2 = find_ep(skel4, S4);
lmp2 = length(mp2);


S4 = S3;
skel4 = skel3;
ls = length(S4);
ls2 = 0;

while ls ~= ls2
    ep = find_ep(skel4, S4); %find segments containing endpoints
    [O, O2] = rem_nongauss_whole(S4(ep), V);
    O = max(O, O2);
    ls = length(S4);
    S4(ep(O<0.5)) = []; %removing segments with endpoints that are not vessels
    ls2 = length(S4);
    skel4 = seg2skel(S4, V);
    S4 = segm3(skel4);
end


%%
skel5 = skel4;
S5 = rem_small(skel5);
[skel6, Sc] = main_tensor_connect(skel5,S5,res);

CC = bwconncomp(skel6);
c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
fin_skel = zeros(size(skel6));
fin_skel(CC.PixelIdxList{c==max(c)}) =1;


%%


% Removes loops (segments with O < 0)



 %sequentially removes segments that are endpoints which are less than 7px
S3 = segm3(skel3);





S2 = segm3(skel2);
[O, O2] = rem_nongauss_whole(S2,V); 
O = max(O,O2);
[skel3] = rem_loop(S2,O, skel2); 



