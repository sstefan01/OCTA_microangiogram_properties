function [S, g] = segm3(skg)
skg = padarray(skg, [1 1 1],0);
% skg(1:2,:,:) = 0;
% skg(:,1:2,:) = 0;
% skg(:,:,1:2) = 0;
% skg(end-1:end,:,:) = 0;
% skg(:,end-1:end,:) = 0;
% skg(:,:,end-1:end) = 0;

skgg = skg;

bp = bwmorph3(skg, 'branchpoints');
ep = bwmorph3(skg, 'endpoints');

[m,n,v] = ind2sub(size(skg),find(bp(:)==1));
[me,ne,ve] = ind2sub(size(skg),find(ep(:)==1));

bp = [m n v];
ep = [me ne ve];

bp = [bp;ep];
it = 0;
nit = 0;
ch = [];
for i = 1:size(bp,1)
    while true
    b1 = bp(i,1);
    b2 = bp(i,2);
    b3 = bp(i,3);
    
    b11 = bp(i,1);
    b22 = bp(i,2);
    b33 = bp(i,3);
    skg(b1,b2,b3) = 1;

    
    nh = skg(b1-1:b1+1, b2-1:b2+1, b3-1:b3+1);
    nh(2,2,2) = 0;
    if sum(nh(:)) == 0
        skg(b1,b2,b3) = 0;
        break
    end
    
    
    s = [b1 b2 b3];
    while true
        nh = skg(b1-1:b1+1, b2-1:b2+1, b3-1:b3+1);
        nh(2,2,2) = 0;
        [d1, d2, d3] = ind2sub(size(nh),find(nh(:)==1));
        d = [d1 d2 d3];
        d = d+[b1 b2 b3] - 2;
        d(ismember(d, [b11 b22 b33], 'rows'),:) = [];
        if isempty(d)
            it = it+1;
            nit = nit+1;
            
            S{it} = s;
            ch(nit) = it;
            break
        end
        b1 = d(1,1);
        b2 = d(1,2);
        b3 = d(1,3);
        s = [s; [b1 b2 b3]];
        
        skg(b1,b2,b3) = 0;
        
        if ismember([b1 b2 b3],bp, 'rows') 
            it = it+1;
            S{it} = s - 1;
            if size(s,1) > 3
                skg(b1,b2,b3) = 1;
            end
                
            break
        end
        
        if ismember([b1 b2 b3],ep, 'rows') 
            it = it+1;
            S{it} = s - 1;
            break
        end
        

        
        
        
    end
    
    
    end
end
    

bp = bwmorph3(skgg, 'branchpoints');
ep = bwmorph3(skgg, 'endpoints');
x = dec2bin(0:(2^3)-1)-'0';
x(1,:) = [];
it = 1;
g = [];
for i = 1:length(ch)
    s = S{ch(i)};
    
    if ismember(abs((s(1,:) - s(end,:))),x, 'rows') & size(s,1) > 2
        g(it) = ch(i);
        it = it+1;
        continue
    end
    s11 = s(1,1);
    s22 = s(1,2);
    s33 = s(1,3);
    
    while true
        if bp(s11,s22,s33) == 1 | ep(s11,s22,s33) == 1
            break
        end
            nh = skgg(s11-1:s11+1, s22-1:s22+1, s33-1:s33+1);
            nh(2,2,2) = 0;
            [d1, d2, d3] = ind2sub(size(nh),find(nh(:)==1));
             d = [d1 d2 d3];
            d = d+[s11 s22 s33] - 2;
            d(ismember(d, s, 'rows'),:) = [];
            
            if isempty(d) 
                break
            end

            s11 = d(1,1);
            s22 = d(1,2);
            s33 = d(1,3);
            s = [[s11 s22 s33];s];
    end

    s11 = s(end,1);
    s22 = s(end,2);
    s33 = s(end,3);

    while true
        if bp(s11,s22,s33) == 1 | ep(s11,s22,s33) == 1
            break
        end

            nh = skgg(s11-1:s11+1, s22-1:s22+1, s33-1:s33+1);
            nh(2,2,2) = 0;
            [d1, d2, d3] = ind2sub(size(nh),find(nh(:)==1));
             d = [d1 d2 d3];
            d = d+[s11 s22 s33] - 2;
            d(ismember(d, s, 'rows'),:) = [];
            if isempty(d) 
                break
            end
            s11 = d(1,1);
            s22 = d(1,2);
            s33 = d(1,3);
            s = [s; [s11 s22 s33]];
    end

    S{ch(i)} = s-1;

end

S(g) = []; %removing loops

skg = skg(2:end-1,2:end-1,2:end-1);
S2 = segm(skg);
S = [S S2];

end
   