
function SL = follow_vess(s,ds, xx,yy)


SL = zeros(25);
figure(2)
ax = axes;

for i = 1:size(s,1)-1

   sd = [smooth(s(:,1)), smooth(s(:,2)), smooth(s(:,3))];

   p1 = s(i,1);
   p2 = s(i,2)-xx(1)+1;
   p3 = s(i,3)-yy(1)+1;
   


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

    imagesc(imadjust(slice), 'Parent', ax)
     colormap(jet)
   
    title(num2str(i))
    pause(0.5)
    

   
    SL = SL + slice;
    
    %itt = itt + 1;
end
SL = SL/max(SL(:));
figure(2)
imagesc(SL)
colormap(gray)
end