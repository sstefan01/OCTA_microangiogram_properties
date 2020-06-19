function Z = gen_gauss(MdataSize,d)
%% ---------User Input---------------------
%MdataSize = 6; % Size of nxn data matrix
% parameters are: [Amplitude, x0, sigmax, y0, sigmay, angel(in rad)]

x = [1,0,d,0,d,0]; %centroid parameters


%% ---Generate centroid to be fitted--------------------------------------

[X,Y] = meshgrid(-MdataSize/2:MdataSize/2);
xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

%---Generate noisy centroid---------------------
Z = D2GaussFunctionRot1(x,xdata);
end