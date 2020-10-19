function Sc = gap_correct_vectors(skel,seg,S)

L = 15;
ls = 20;
ang = 45;

L_seg = 10;
ls_seg = 20;

T = zeros(size(skel,1),size(skel,2),size(skel,3),3,3);
e1 = bwmorph3(skel, 'endpoints');
e2 = rem_easy(skel);
ep = e1 + e2 > 0;
siz = size(T);
rad = bwdist(~seg).*skel;

for i = 1:length(S)
    if mod(i,100) == 0
        disp([num2str(i) '/' num2str(length(S))]);
    end
    s = S{i};

    sd = [smooth(s(:,1)), smooth(s(:,2)), smooth(s(:,3))];
    
    e1 = ep(s(1,1),s(1,2), s(1,3));
    e2 = ep(s(end,1),s(end,2), s(end,3));

    
    if e1 == 1
        V = sd(1,:) - sd(2,:);
        [Ts,x,y,z] = ep_tens(s(1,:), siz,V,  L,ls,ang);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
    end

    if e2 == 1
        V = sd(end,:) - sd(end-1,:);
        [Ts,x,y,z] = ep_tens(s(end,:), siz,V,  L,ls,ang);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
    end

    if size(s,1) > 6 && e1 == 1
        s(1:6,:) = []; 
        [Ts,x,y,z] = seg_tens(s,siz,rad, L_seg,ls_seg);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
        continue
    end

    if size(s,1) > 6 && e2 == 1
        s(end-6+1:end,:) = []; 
        [Ts,x,y,z] = seg_tens(s,siz,rad, L_seg,ls_seg);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
        continue
    end
    
    if size(s,1) > 12 && e1 == 1 && e2 == 1
        s(1:6,:) = []; 
        s(end-6+1:end,:) = []; 
        [Ts,x,y,z] = seg_tens(s,siz,rad, L_seg,ls_seg);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
    continue
    end

    if size(s,1) > 5
        [Ts,x,y,z] = seg_tens(s,siz,rad,L_seg,ls_seg);
        T(x,y,z,:,:) = T(x,y,z,:,:) + Ts;
    end

end



q = T(:,:,:,1,1) +  T(:,:,:,2,2) + T(:,:,:,3,3);%trace
p1 = T(:,:,:,1,2).^2 + T(:,:,:,1,3).^2 + T(:,:,:,2,3).^2;
p2 = (T(:,:,:,1,1) - q).^2 + (T(:,:,:,2,2) - q).^2 + (T(:,:,:,3,3) - q).^2 + 2 .* p1;
p = sqrt(p2 / 6);
p = max(p, 1e-8);
I = (repmat(reshape(eye(3,3),1,1,1,3,3), size(T,1), size(T,2), size(T,3)));

B = (1 ./ p) .* (T - q .* I) ;   % I is the identity matrix


a = B(:,:,:,1,1);
b = B(:,:,:,1,2);
c = B(:,:,:,1,3);

d = B(:,:,:,2,1);
e = B(:,:,:,2,2);
f = B(:,:,:,2,3);

g = B(:,:,:,3,1);
h = B(:,:,:,3,2);
i = B(:,:,:,3,3);
 
detB = a.*(e.*i - f.*h) - b.*(d.*i - f.*g) + c.*(d.*h - e.*g);
rr = detB / 2;
ang = acos(rr)/3;
ang(rr <= -1) = pi / 3;
ang(rr >1) = 0;


eig1 = q + 2 * p .* cos(ang);
eig3 = q + 2 * p .* cos(ang + (2*pi/3));
eig2 = 3 * q - eig1 - eig3;


E2 = 0;

e22 = abs(eig1) > abs(eig2)  & abs(eig2) > abs(eig3);
E2 = E2 + e22.*eig2;

e22 = abs(eig3) > abs(eig2)  & abs(eig2) > abs(eig1);
E2 = E2 + e22.*eig2;

e21 = abs(eig3) > abs(eig1)  & abs(eig1) > abs(eig2);
E2 = E2 + e21.*eig1;
e21 = abs(eig2) > abs(eig1)  & abs(eig1) > abs(eig3);
E2 = E2 + e21.*eig1;

e23 = abs(eig1) > abs(eig3)  & abs(eig3) > abs(eig2);
E2 = E2 + e23.*eig3;
e23 = abs(eig2) > abs(eig3)  & abs(eig3) > abs(eig1);
E2 = E2 + e23.*eig3;

E1 = 0;

e11 = abs(eig1) >= abs(eig2)  & abs(eig1) >= abs(eig3);
E1 = E1 + e11.*eig1;

e12 = abs(eig2) >= abs(eig1)  & abs(eig2) >= abs(eig3);
E1 = E1 + e12.*eig2;

e13 = abs(eig3) >= abs(eig1)  & abs(eig3) >= abs(eig2);
E1 = E1 + e13.*eig3;

Sc = E1-E2;
Sc = Sc +skel;
