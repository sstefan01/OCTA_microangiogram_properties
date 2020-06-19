
function mD = find_diam(s,ds)


SL = zeros(25);
x = 1:25;
D = zeros(length(s)-1,1);
R = zeros(length(s)-1,1);
sd = [smooth(s(:,1)), smooth(s(:,2)), smooth(s(:,3))];
parfor i = 1:size(s,1)-1

  
   p1 = s(i,1);
   p2 = s(i,2);
   p3 = s(i,3);

    n1 = sd(i+1,1)-sd(i,1);
    n2 = sd(i+1,2)-sd(i,2);
    n3 = sd(i+1,3)-sd(i,3);

    slice  = extralice(ds,p1,p2,p3,n1,n2,n3,12);
    slice(isnan(slice))=-1; 
    slm = slice(slice>=0);
    ms = max(slm(:));
    if isempty(ms) ==1 
        ms = 1;
    end
    slice = slice/ms;
    slice(slice <0)= 0; 

%     imagesc(imadjust(slice))
%    colormap(jet)
%    
%     title(num2str(i))
%     pause(0.5)
%     

   
    SL = SL + slice;
    
    sl = mean(slice(12:14,:),1);
    if sum(isnan(sl(:))) > 5
        continue
    else
        sl = fillmissing(sl, 'nearest');
    end
    sl = sl-min(sl);
    [~, gof] = fit(x',sl','gauss1', 'Lower',[0,2,1],'Upper',[1,23,8],'StartPoint',[0.8 13 4]);
    pm = find(sl == max(sl(:)));
    pm = pm(1);
    [~,b1] = min(abs(sl(1:pm)-max(sl)/2));
    [~,b2] = min(abs(sl(pm:end)-max(sl)/2));
    b2 = b2(1)+pm-1;
    fwhm = abs(b1(1)-b2);
    D(i) = fwhm;
    R(i) = gof.rsquare;
    %itt = itt + 1;
end
SL = SL/max(SL(:));
mD = mean(D(R>0.8));
end

