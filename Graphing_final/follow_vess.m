
function SL = follow_vess(s,ds, xx,yy)


SL = zeros(25);

for i = 1:size(s,1)-1

   sd = [smooth(s(:,1)), smooth(s(:,2)), smooth(s(:,3))];

   p1 = s(i,1);
   p2 = s(i,2)-xx(1)+1;
   p3 = s(i,3)-yy(1)+1;
   
%test(p1,p2,p3) = 1;

%   n1_1 = [];
%   n1_2 = [];
%   n1_3 = [];
% if i > 2 & i < size(s,1)-1
% for j = -2:0
%     if i+j <= size(s,1)
%        n1_1(j+3) = s(i+j+1,1)-s(i+j,1);
%        n1_2(j+3) = s(i+j+1,2)-s(i+j,2);
%        n1_3(j+3) = s(i+j+1,3)-s(i+j,3);
%     end
% end
%    
% 
%    n1 = mean(n1_1);
%    n1 = round(n1(1));
%    n2 = mean(n1_2);
%    n2 = round(n2(1));
%    n3 = round(mean(n1_3));
%    n3 = n3(1);
% elseif i == 1      
%     n1 = s(i+1,1)-s(i,1);
%     n2 = s(i+1,2)-s(i,2);
%     n3 = s(i+1,3)-s(i,3);
% end

    n1 = sd(i+1,1)-sd(i,1);
    n2 = sd(i+1,2)-sd(i,2);
    n3 = sd(i+1,3)-sd(i,3);

    slice  = extralice(ds,p1,p2,p3,n1,n2,n3,12);
   
%     [I_SSD,I_NCC] = template_matching(sl1,slice);
%     [c1, c2] = find(I_NCC == max(I_NCC(:)));
%     c = [c1 c2];
%      q1 = round(subX(c(1), c(2)));
% 
% %     
%      q2 = round(subY(c(1), c(2)));
% 
% %     
%      q3 = round(subZ(c(1), c(2)));
%     qq = [q1 q2 q3];
%     
%     if isempty(q) == 0
%         if ismember(qq, q, 'rows') 
%             qq = [qq(1) + n1, qq(2) + n2, qq(3) + n3];
%         end
%     end
%     
%     if i == 1
%       %  qq = [p1 p2 p3];
%     end
%     
%     if q1 > qq(1) + 1
%         q1 = qq(1) + 1;
%     elseif q1 < qq(1) - 1
%         q1 = qq(1) - 1;
%     end
%     
%     if q2 > qq(2) + 1
%         q2 = qq(2) + 1;
%     elseif q2 < qq(2) - 1
%         q2 = qq(2) - 1;
%     end
%     
%     if q3> qq(3) + 1
%         q3 = qq(3) + 1;
%     elseif q3 < qq(3) - 1
%         q3 = qq(3) - 1;
%     end
%     
%     q = [q; [q1 q2 q3]];
    %colormap(gray)
    
%     sl1 = gen_gauss(14,2);
%     sl2 = gen_gauss(14,3);
%     
    z = ~isnan(slice);
    slice(isnan(slice))=-1; 
    slm = slice(slice>=0);
    ms = max(slm(:));
    if isempty(ms) ==1 
        ms = 1;
    end
    slice = slice/ms;
    slice(slice <0)= 0; 

    imagesc(imadjust(slice))
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