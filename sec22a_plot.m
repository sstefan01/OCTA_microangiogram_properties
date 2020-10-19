%         DD1 = DD ./ repmat(max(Dz,Dz(nz1)),[1 nx ny]);
        
%         subplot(3,2,[1 2]);  cla;
        subplot(5,1,1);  cla;
            plot(log10(Dz));  axis tight;  ylim([log10(Dz(end)) max(get(gca,'ylim'))]);  grid on;
            line([1 nz],[1 1]*log10(Dz(zz(2))));  line([1 1]*zz(2),get(gca,'ylim'));  line([1 1]*zz(1),get(gca,'ylim'));  title(mat2str(zz));
%         subplot(3,2,[3 5]);  cla;  hold on;
        subplot(5,1,(2:5));  cla;  hold on;
            PlotImage(log10(squeeze(max(Enh(zz(1):zz(2),:,:),[],1)))',false,[.1 .95],true);  title('MIP');
%         subplot(3,2,[4 6]);  cla;  hold on;
%             PlotImage(log10(squeeze(max(DD1(1:nz1,:,:),[],1)))',false,[.1 .95],true);  title('MIP after normalization');
