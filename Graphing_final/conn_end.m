function skel = conn_end(Sc, skel,S)

rem = 0;
ij = 1;
c = dec2bin(0:(2^3)-1)-'0';      
c(1,:) = [];
%find segments with endpoints in middle of imaging volume
mp = find_ep(skel, S);
Sep = S(mp);


%find positions of endpoints
ep1 = bwmorph3(skel, 'endpoints');
ep2 = rem_easy(skel);
ep = ep1 + ep2 > 0;

ep1 = zeros(size(ep));
ep1(3:end-2, 3:end-2, 3:end-2) = ep(3:end-2, 3:end-2, 3:end-2);


for i = 1:length(Sep)
    
    %if one segment directly connects to the endpoint of another segment,
    %do not process the second segment
    if ismember(i, rem)
        continue
    end

    s = Sep{i};

    sd = [smooth(s(:,1)),smooth(s(:,2)),smooth(s(:,3))];
    %ls1 = size(s,1);

    end1 = ep1(s(1,1),s(1,2), s(1,3));
    end2 = ep1(s(end,1),s(end,2), s(end,3));
    %find whether endpoint is at top or bottom of segment
    num = 0;
    
    for itt =1:2 

    if end2 == 1 && itt == 1
        D = sd(end,:) - sd(end-1,:);
        e =  s(end,:);
        
    elseif end1 == 1 && num == 0
        D = sd(1,:) - sd(2,:);
        e =  s(1,:);
        num = 1;
    else
        break
    end
    

    
        it = 0;
        E = e;
        while true
        
            it = it+1;
            N = Sc(e(1)-1:e(1)+1,e(2)-1:e(2)+1,e(3)-1:e(3)+1);
            xx = e(1)-1:e(1)+1;
            yy = e(2)-1:e(2)+1;
            zz = e(3)-1:e(3)+1;

            [x,y,z] = meshgrid(xx,yy,zz);

            x = permute(x, [2 1 3]);
            y = permute(y, [2 1 3]);
            z = permute(z, [2 1 3]);
            d = cat(4,x,y,z);
            op = d - reshape(e,1,1,1,3); 
            b = sum(op.*reshape(D,1,1,1,3),4)>0; %dot product of vectors with direction - must not move backwards
            N = N.*b;
            
         
            
            while true
          
                 if sum(abs(N(:))) == 0
                     break
                 end
                    [m,n,v] = ind2sub(size(N),find(N(:) == max(N(:))));
                    e1(1) = e(1) + m(1) -2 ;
                    e1(2) = e(2) + n(1) -2 ;
                    e1(3) = e(3) + v(1) -2 ;
                    
                 if ismember(e1, s, 'rows') == 0  %make sure it doesn't loop around
                     e = e1;
                     break
                 else
                     N(m,n,v) = 0;
                 end         
            end
            
            if sum(abs(N(:))) == 0
                E = [];
                break
            end

            if max(N(:)) < 0.05
                E = [];
                break
            end

            
            E = [E;e];
            D = E(end,:)- E(end-1,:);
            
            
            if ep1(e(1), e(2), e(3)) == 1
                c1 = cellfun(@(x)(ismember(e, x, 'rows')),Sep);
                ind = find(c1);
                if isempty(ind) == 0
                    for k = 1:length(ind)
                        rem(ij) = ind(k);
                        ij = ij+ 1;
                    end
                end
                break
            end

            if skel(e(1), e(2), e(3)) == 1
                break
            end

            if sum(e<3) > 0
                break
            elseif e(1)> size(skel,1)-3
                break
            elseif e(2)> size(skel,2)-3
                break
            elseif e(3)> size(skel,3)-3
                break
            end
            
            if it>=50 
                E =[];
                break
            end

        end
        
      

    if isempty(E) == 0
        if ismember(abs((E(1,:) - E(end,:))),c, 'rows') && size(E,1) > 2 %loop
            continue
        end

        %E = [smooth(E(:,1)), smooth(E(:,2)),smooth(E(:,3))];
        %E = round(E);

        for j = 1:size(E,1)
            skel(E(j,1),E(j,2),E(j,3)) = 1;
        end

    end

    end

    
%     if size(s,1) > ls1
%         SN{i} = s;
%     end

    
    skel = bwskel(skel>0, 'minbranchlength',5);
end



%skel = imclose(skel, ones(3,3,3));

