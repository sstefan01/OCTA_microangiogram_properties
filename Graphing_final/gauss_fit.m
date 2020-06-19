function [diam, r] = gauss_fit(Z)

%% ---------User Input---------------------
MdataSize = size(Z,1) - 1; % Size of nxn data matrix
% parameters are: [Amplitude, x0, sigmax, y0, sigmay, angel(in rad)]
x0 = [1,2]; %Inital guess parameters



%% ---Generate centroid to be fitted--------------------------------------


[X,Y] = meshgrid(-MdataSize/2:MdataSize/2);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

%---Generate noisy centroid---------------------

Z = fillmissing(Z, 'linear',2);
Z = fillmissing(Z, 'linear',1);

%% --- Fit---------------------

    

    lb = [0,0];
    ub = [50,MdataSize];
    opts = optimset('Display','off');
    [x,resnorm,residual,exitflag] = lsqcurvefit(@D2GaussFunction,x0,xdata,Z,lb,ub,opts);
    
    diam = 2.355*(x(2)); %FWHM
    %c = [x(2) x(4)];

    
    z = sum((Z(:) - mean(Z(:)).^2));
    r = 1 - resnorm/z;
 
    %F = x(1)*exp(   -((xdata(:,:,1)).^2/(2*x(2)^2) + (xdata(:,:,2)).^2/(2*x(2)^2) )    );

    
end
