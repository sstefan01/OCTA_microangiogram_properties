Enhz = (mean(Enh(:,:),2));
 figure(1);  clf;  colormap(gray);
     set(gcf,'Visible','on')
title('Select depth of interest')
xlabel('Depth (px)')

plot(Enhz)
hold on
z1 = ginput(1);
z1 = round(z1(1));

yp = linspace(min(Enhz), max(Enhz), 10);
xp = ones(10,1)*z1;
plot(xp,yp, 'color', 'red')

z2 = ginput(1);
z2 = round(z2(1));
yp = linspace(min(Enhz), max(Enhz), 10);
xp = ones(10,1)*z2;
plot(xp,yp, 'color', 'red')



