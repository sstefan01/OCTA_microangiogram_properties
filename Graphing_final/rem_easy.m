function [ep, skel1] = rem_easy(skel1)

skel1 = padarray(skel1, [1 1 1],0);
e1(:,:,1) = zeros(3,3);
e1(:,:,2) = [0 0 0; 0 1 0; 1 1 1];
e1(:,:,3) = zeros(3,3);

e2 = rot90(e1,1);
e3 = rot90(e1,2);
e4 = rot90(e1,3);
e5 = permute(e1,[1 3 2]);
e6 = permute(e1,[2 3 1]);
e7 = permute(e1,[3 2 1]);
e8 = permute(e1,[3 1 2]);
e9 = rot90(e5,2);
e10 = rot90(e5,3);

e11(:,:,1) = [0 0 0; 0 0 0; 1 1 1];
e11(:,:,2) = [0 0 0; 0 1 0; 0 0 0];
e11(:,:,3) = zeros(3,3);
e12 = rot90(e11);
e13 = rot90(e12,2);
e14 = rot90(e12,3);
e15(:,:,1) = zeros(3,3);
e15(:,:,2) = [0 0 0; 0 1 0; 0 0 0];
e15(:,:,3) = [1 0 0; 0 1 0; 0 0 1];
e16 = rot90(e15);
e17(:,:,1) = [1 0 0; 0 1 0; 0 0 1];
e17(:,:,2) = [0 0 0; 0 1 0; 0 0 0];
e17(:,:,3) = zeros(3,3);
e18 = rot90(e17);

E{1} = e1;
E{2} = e2;
E{3} = e3;
E{4} = e4;
E{5} = e5;
E{6} = e6;
E{7} = e7;
E{8} = e8;
E{9} = e9;
E{10} = e10;
E{11} = e11;
E{12} = e12;
E{13} = e13;
E{14} = e14;
E{15} = e15;
E{16} = e16;
E{17} = e17;
E{18} = e18;
f = ones(3,3,3);
f(1,1,1) = 0;
f(1,1,2) = 0;
f(1,1,3) = 0;
f(3,1,1) = 0;
f(3,1,2) = 0;
f(3,1,3) = 0;
f(3,3,1) = 0;
f(3,3,2) = 0;
f(3,3,3) = 0;
f(1,3,1) = 0;
f(1,3,2) = 0;
f(1,3,3) = 0;

ep = zeros(size(skel1));

[m,n,v] = ind2sub(size(skel1),find(skel1 == 1));

    
for i = 1:length(m)

    m1 = m(i);
    n1 = n(i);
    v1 = v(i);
    nh = skel1(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);


    for j = 1:length(E)
        if isequal(nh,E{j})
            skel1(m1,n1,v1) = 0;
            break
        end
    end

   % nh_g = nh;
    %nh_g(2,2,2) = 0;
    %CC = bwconncomp(nh_g);
    %if (CC.NumObjects == 1) && (sum(nh_g(:)) == 2)
     %   ep(m1,n1,v1) = 1;
    %end

end

ep = ep(2:end-1,2:end-1,2:end-1);
end