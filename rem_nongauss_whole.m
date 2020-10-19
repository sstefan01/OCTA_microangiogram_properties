% this removes segments which on average don't have very gaussian-like
% cross-sections


function O = rem_nongauss_whole(S1, ds)

    sl1 = gen_gauss(14,2);
    sl2 = gen_gauss(14,3);
    O = zeros(length(S1),1);
    O2 = zeros(length(S1),1);

for h = 1:length(S1)  
    
    if mod(h,200) == 0
        disp(['Processed: ' num2str(h) '/' num2str(length(S1))]);
    end

    s = S1{h};
    sd = [smooth(s(:,1)), smooth(s(:,2)), smooth(s(:,3))];

    su2 = zeros(size(s,1)-1,1);
    su22 = zeros(size(s,1)-1,1);
    
    % if the vessel segment is of small length, then assess it for removal
    % (i.e. give it a small O value)
    if size(s,1) < 7
        O(h) = 0;
        O2(h) = 0;
        continue
    end
    
    
    
for i = 1:size(s,1)-1
    
    p1 = s(i,1);
    p2 = s(i,2);
    p3 = s(i,3);

    
    n1 = sd(i+1,1)-sd(i,1);
    n2 = sd(i+1,2)-sd(i,2);
    n3 = sd(i+1,3)-sd(i,3);


    slice = extralice(ds,p1,p2,p3,n1,n2,n3,7);
    z = ~isnan(slice);
    slice(isnan(slice))=-1; 
    slm = slice(slice>=0);
    ms = max(slm(:));
    if isempty(ms) ==1 
        ms = 1;
    end
    slice = slice/ms;
    slice(slice <0)= 0; 
    
    sli1 = sl1.*z;
    sli2 = sl2.*z;
    Su = corrcoef(sli1(sli1(:)>0), slice(sli1(:)>0));
    su2(i) = min(Su(:));
    Su = corrcoef(sli2(sli2(:)>0), slice(sli2(:)>0));
    su22(i) = min(Su(:));
    

end


O(h) = mean(su2);
O2(h) = mean(su22);
end

O = max(O,O2);
close all