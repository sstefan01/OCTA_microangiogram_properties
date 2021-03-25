
function Stot = manual_inspection(S, skel, Enh)

x = rand(1,length(S)+500);
y = rand(1,length(S)+500);
z = rand(1,length(S)+500);

col = [x',y',z'];
h = rgb2hsv(col);
col(h(:,3)<0.4 | h(:,3) > 0.9,:) = [];

xx = 1:100:size(Enh, 2);
yy = 1:100:size(Enh, 3);

if xx(end) < size(Enh,2)
    xx = [xx size(Enh,2)];
end

if yy(end) < size(Enh,3)
    yy = [yy size(Enh,3)];
end


mp = find_ep(skel, S); %middle endpoints
it = 1;

Stot = [];
sp = [];
it = 0;

lx = length(xx)-1;
ly = length(yy)-1;
for i = 1:lx
    for j = 1:ly
        
        it = it+1;

        if i > 1
            X = xx(i)-20:xx(i+1);
        elseif xx(i+1)+20 < size(Enh,2)
            X = xx(i):xx(i+1)+20;
        else
            X = xx(i): xx(i+1);
        end
        
        if j > 1
           Y = yy(j)-20:yy(j+1);
        elseif yy(j+1) + 20 < size(Enh,3)
           Y = yy(j):yy(j+1)+20;
        else
            Y = yy(j):yy(j+1);
        end
        
         if i == lx && x(end)> 120
            X= x(end)-120:x(end);
        end
        
         if j == ly && y(end)> 120
            Y= y(end)-120:y(end);
        end
        
        
        depx = cellfun(@(x) x(:,2), S ,'UniformOutput' ,false);
        sx = cellfun(@(x) sum(ismember(X, x)), depx);
        
        depy = cellfun(@(x) x(:,3), S ,'UniformOutput' ,false);
        sy = cellfun(@(x) sum(ismember(Y, x)), depy);

        s = S(sx>0 & sy>0); %inside tile
        [St, ex] = clickT(s,Enh(1:end, X, Y),1,col,Y, X,[it lx*ly] );
        S(sx>0 & sy>0) = [];
        S = [St S];
        
        if ex == 1
            Stot = S;
            c = cellfun(@(x)(sum(sum(x,2))), Stot);
             Stot(c==0) = [];
             B = cellfun(@(x) num2str(x(:)'),Stot,'UniformOutput',false);
             [~,idx] = unique(B);
             Stot = Stot(idx);

            return
        end

    end
    
     
       
end
  Stot = S;
 c = cellfun(@(x)(sum(sum(x,2))), Stot);
 Stot(c==0) = [];
 B = cellfun(@(x) num2str(x(:)'),Stot,'UniformOutput',false);
 [~,idx] = unique(B);
 Stot = Stot(idx);

