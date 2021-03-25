function S = manual_inspection_large_FOV(S, Enh)

x = rand(1,length(S)+500);
y = rand(1,length(S)+500);
z = rand(1,length(S)+500);
col = [x',y',z'];
h = rgb2hsv(col);
col(h(:,3)<0.4 | h(:,3) > 0.9,:) = [];

S = clickT(S,Enh(1:end, :, :),1,col,1:size(Enh,3), 1:size(Enh,2),[1 1] );
c = cellfun(@(x)(sum(sum(x,2))), S);
 S(c==0) = [];
 B = cellfun(@(x) num2str(x(:)'),S,'UniformOutput',false);
 [~,idx] = unique(B);
 S = S(idx);
end
