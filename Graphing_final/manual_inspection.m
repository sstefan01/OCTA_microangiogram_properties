function Stot = manual_inspection(S, skel, Enh)

x = rand(1,length(S)+100);
y = rand(1,length(S)+100);
z = rand(1,length(S)+100);
col = [x',y',z'];

xx = 1:100:size(Enh, 2);
yy = 1:100:size(Enh, 3);

if xx(end) < size(Enh,2)
    xx = [xx size(Enh,2)];
end

if yy(end) < size(Enh,2)
    yy = [yy size(Enh,3)];
end


mp = find_ep(skel, S); %middle endpoints
it = 1;

Stot = [];
for i = 1:length(xx)-1
    for j = 1:length(yy)-1
        if i > 1
            X = xx(i)-20:xx(i+1);
        else
            X = xx(i):xx(i+1);
        end
        
        if j > 1
           Y = yy(j)-20:yy(j+1);
        else
           Y = yy(j):yy(j+1);
        end
        
        depx = cellfun(@(x) x(:,2), S ,'UniformOutput' ,false);
        sx = cellfun(@(x) sum(ismember(X, x)), depx);
        
        depy = cellfun(@(x) x(:,3), S ,'UniformOutput' ,false);
        sy = cellfun(@(x) sum(ismember(Y, x)), depy);

        s = S(sx>0 & sy>0);
        mp = find_ep(skel, s); %middle endpoints
        
        St = clickT(s,Enh(1:end, X, Y),1,col,mp, skel,Y, X);
        Stot = [Stot St];

    end
    
     
       
end

 c = cellfun(@(x)(sum(sum(x,2))), Stot);
 Stot(c==0) = [];

