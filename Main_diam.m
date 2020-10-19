

D = zeros(length(S),1);
for i = 1:length(S)
    D(i) = find_diam(S{i}, V);
    if mod(i,100) == 0
        disp([num2str(i) '/' num2str(length(S))])
    end
end

D(isnan(D)) = nanmedian(D);
D = D*3;
%%
