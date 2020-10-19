
function [skel2] = make_skel(b, data1)

skel1 = bwskel(b>0,'MinBranchLength',6);

CC = bwconncomp(skel1);
c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
CC.PixelIdxList((c<4)) = [];
skk = zeros(size(skel1));
for i = 1:length(CC.PixelIdxList)
    skk(CC.PixelIdxList{i}) = 1;
end
skel1 = skk;

skel1 = bwskel(skel1>0,'MinBranchLength',6);





dj = mat2gray(data1);

%  for i = 1:3
%     dj = imgaussfilt3(dj, 0.5);
%  end

dj = dj.*b;

dj = padarray(dj, [1,1,1],0);
skel1 = padarray(skel1,[1 1 1],0);
disp('Recentering #1...')

skel2 = recenter(skel1, dj);
skel2 = bwskel(logical(skel2), 'MinBranchLength',6);

CC = bwconncomp(skel2);
c = cellfun(@(x)(numel(x)),CC.PixelIdxList);
CC.PixelIdxList((c<4)) = [];
skk = zeros(size(skel2));
for i = 1:length(CC.PixelIdxList)
    skk(CC.PixelIdxList{i}) = 1;
end
skel2 = skk;

% j = imdilate(skel2, strel('sphere',3));
% 
% data1 = padarray(data1, [1 1 1],0);
% 
% dj = (data1).*j;
% 
% 
% dj = padarray(dj, [1,1,1],0);
% skel2 = padarray(skel2, [1,1,1],0);
% 
% disp('Recentering #2...')
% skel2 = recenter(skel2, dj);
% 
% skel2 = skel2(3:end-2,3:end-2, 3:end-2);

skel2 = skel2(2:end-1, 2:end-1, 2:end-1);
end

