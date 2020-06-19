function F = D2GaussFunction(x,xdata)
 F = x(1)*exp(   -((xdata(:,:,1)).^2/(2*x(2)^2) + (xdata(:,:,2)).^2/(2*x(2)^2) )    );