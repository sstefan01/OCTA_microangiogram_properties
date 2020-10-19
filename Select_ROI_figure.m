mip_d3 = squeeze(max(V,[],1));
figure(1); imagesc(squeeze((mip_d3)))
colormap(gray)
axis image
title('Press "q" to select ROI and quit')
roi = drawrectangle;
while true

    waitforbuttonpress;
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'q'))
        break
    end
end

x1 = round(roi.Position(2));
x2 = x1+ round(roi.Position(4));
y1 = round(roi.Position(1));
y2 = y1+round(roi.Position(3));

close(1)

