function skel1 = recenter(skel1, dj)


dj = padarray(dj, [1,1,1],0);
skel1 = padarray(skel1,[1 1 1],0);

sk = zeros(size(skel1));
itt = 0;



    ep1 = bwmorph3(skel1, 'endpoints');
    ep2 = rem_easy(skel1);
    ep = ep1 + ep2 > 0;
    
 while sum(abs(sk(:) - skel1(:))) > 0 && itt < 100

    [m,n,v] = ind2sub(size(skel1),find(skel1 == 1 & ep == 0));
    po = [m n v];
    sk = skel1;
    itt = itt +1;
    AC = [];
    
    for i = 1:length(m)
              
        
        m1 = po(i,1);
        n1 = po(i,2);
        v1 = po(i,3);

        nh = skel1(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);
%         ee = ep(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);
        if sum(nh(:)) == 1
            continue
        end
        
        D = dj(m1-1:m1+1, n1-1:n1+1, v1-1:v1+1);


        % check if pixel can be removed
        nh_g = nh;
        nh_g(2,2,2) = 0;
        
        [q,w,e] = ind2sub(size(nh_g),find(nh_g==1));
        qq = [q w e];
        
        CC = bwconncomp(nh_g);
        ep_nh1 = bwmorph3(nh, 'endpoints');
        ep_nh2 = rem_easy(nh);
        ep_nh = ep_nh1 + ep_nh2 > 0;
        
%         ep_nhg1 = bwmorph3(nh_g, 'endpoints');
%         ep_nhg2 = rem_easy(nh_g);
%         ep_nhg = ep_nhg1 + ep_nhg2 > 0;
        
        
        if CC.NumObjects == 1 && ep_nh(2,2,2) == 0%sum(abs(ep_nhg(:) - ee(:))) == 0 %don't create new endpoints  by deleting
            skel1(m1,n1,v1) = 0;
            dj(m1,n1,v1) = 0;

        else % check if pixel can be moved
            
            Nh = [];
            for ii = 1:size(qq,1)
                nh2 = zeros(3,3,3);
                nh2(qq(ii,1),qq(ii,2), qq(ii,3)) = 1;
                Nh{ii} = imdilate(nh2, ones(3,3,3));
            end
    
            r = Nh{1};
            for ii = 1:length(Nh) -1 
                r = (r == 1 & Nh{ii+1} == 1);
            end

            if find(r ==1) == 14 %if movement of pixel is not possible, activate pixel

                dd = D.*(~nh_g);
                
               ind = find(dd(:) == max(dd(:)));
                [d1,d2, d3] = ind2sub(size(nh_g), ind(1));
                d1 = m1+(d1-2);
                d2 = n1+(d2-2);
                d3 = v1+(d3-2);
                
                if dj(d1,d2,d3) > dj(m1,n1,v1)
                    skel1(d1,d2,d3) = 1;
                    AC = [AC; d1 d2 d3];
                    continue
                end
 
                %'activate'
           
            elseif ep(m1,n1,v1) == 0 %movement is possible
                dv = D.*r;
                ind =  find(dv(:) == max(dv(:)));
                [d1,d2, d3] = ind2sub(size(dv), ind(1));
                d1 = m1+(d1-2);
                d2 = n1+(d2-2);
                d3 = v1+(d3-2);
                
                if dj(d1,d2,d3) > dj(m1,n1,v1) 
                    skel1(m1,n1,v1) = 0;
                    dj(m1,n1,v1) = 0;
                    skel1(d1,d2,d3) = 1;
                end
               
            end
         end

    end

    disp(['Iteration: ' num2str(itt)])
 end
skel1 = bwskel(skel1>0, 'minbranchlength', 5);
skel1 = skel1(2:end-1,2:end-1,2:end-1);
%skel1 = rem_seq(skel1);
end
 
