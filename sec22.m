disp('SECTION 22 RUNNING...');  

if ~exist('ciz','var')
    ciz = zeros(nd,nv,MX,MY,MZ);
    for id=1:nd
        for iv=1:nv
            for IX=1:MX
                for IY=1:MY
                    for IZ=1:MZ
                        II = cII{id,iv,IX,IY,IZ};  [~,im] = max(mean(II(:,:),2));
                        ciz(id,iv,IX,IY,IZ) = im;  
                    end
                end
            end
        end
    end    
end

id = 1;  iv = 1;  IX = 1;  IY = 1;  IZ = 1;
% fig = figure('units','normalized','outerposition',[0.5 0 0.5 1]);  
figure(1);
colormap(gray);
while true

    II = cII{id,iv,IX,IY,IZ};  Iz = mean(II(:,:),2);  Cz = std(II(:,:),1,2)./Iz;
    DD = cDD{id,iv,IX,IY,IZ};  
    Ms = cMs{id,iv,IX,IY,IZ};
    Mf = cMf{id,iv,IX,IY,IZ};
    Me = cMe{id,iv,IX,IY,IZ};
    D = cD{id,iv,IX,IY,IZ}*1e12;  % Dz = mean(D(:,:),2);
    ALP = cALP{id,iv,IX,IY,IZ};
    R = cR{id,iv,IX,IY,IZ};
    MfD = Mf.*D;  MfDz = mean(MfD(:,:),2);

    iz = ciz(id,iv,IX,IY,IZ);
    [nz,nx,ny] = size(Ms);
            subplot(4,3,1);  cla;
                plot(Iz);  line(iz,Iz(iz),'marker','o');  
%                     ax = gca;  ax.YScale = 'log';  ax.YTick = 10.^[1:10];  
                axis tight;  grid on;  ylabel('intensity');  title([cdid{id} ' iz=' num2str(iz) ' iv=' num2str(iv) ' IX=' num2str(IX) ' IY=' num2str(IY) ' IZ=' num2str(IZ)]);
%                     plot(Cz);  line(iz,Cz(iz),'marker','o');  axis tight;  grid on;  ylabel('contrast');  xlabel('z');
            subplot(4,3,3);  cla;
%                 line(1:nz,mean(MfD(:,:,3),2),'color',[1 1 1]/2);
%                 line(1:nz,mean(MfD(:,:,end/4),2),'color',[1 1 1]/2);
%                 line(1:nz,mean(MfD(:,:,end/2),2),'color',[1 1 1]/2);
%                 line(1:nz,mean(MfD(:,:,end/4*3),2),'color',[1 1 1]/2);
%                 line(1:nz,mean(MfD(:,:,end-2),2),'color',[1 1 1]/2);
                line(1:nz,MfDz,'linewidth',2);
                line(iz,MfDz(iz),'marker','o');  axis tight;  grid on;  ylabel('MfD at five Y points');  xlabel('z');
                title(['aid=' aid]);

    limII = [MeanLow(log(II(:)),.1) MeanHigh(log(II(:)),.9)];  limDD = [MeanLow(log(DD(:)),.1) MeanHigh(log(DD(:)),.9)];

            subplot(4,3,4);  cla;  hold on;  PlotImage(squeeze(log(II(iz,:,:)))',0,limII);  title('II');  
            subplot(4,3,5);  cla;  hold on;  PlotImage(squeeze(log(DD(iz,:,:)))',0,limDD);  title('DD');
            subplot(4,3,6);  cla;  hold on;  PlotImage(squeeze(R(iz,:,:))',0,limR);  title(['R ' mat2str(limR)]);
            subplot(4,3,7);  cla;  hold on;  PlotImage(squeeze(Ms(iz,:,:))',0,[0 1]);  title('Ms');
            subplot(4,3,8);  cla;  hold on;  PlotImage(squeeze(Mf(iz,:,:))',0,[0 1]);  title('Mf');
            subplot(4,3,9);  cla;  hold on;  PlotImage(squeeze(Me(iz,:,:))',0,[0 1]);  title('Me');

            subplot(4,3,10);  cla;  hold on;  PlotImage(squeeze(D(iz,:,:))',0,limD);  title(['D ' mat2str(limD)]);
            subplot(4,3,11);  cla;  hold on;  PlotImage(squeeze(MfD(iz,:,:))',0,limMfD);  set(gca,'colormap',jet);  title(['Mf*D ' mat2str(limMfD)]);
            subplot(4,3,12);  cla;  hold on;  PlotImage(squeeze(ALP(iz,:,:))',0,[0 2]);  title('\alpha [0 2]');
%             subplot(4,3,12);  hold on;  PlotImage(squeeze(Mf(iz,:,:).*D(iz,:,:).*(sign(R(iz,:,:)-thrR)+1)/2)',0,limMfD);  ylabel(['Mf*D R>' num2str(thrR) ' ' mat2str(limMfD)]);

    if waitforbuttonpress
        cc = get(gcf,'CurrentCharacter');
        if strcmp(cc,'q')
            break;
        elseif strcmp(cc,'f')
            id = min(id+1,nd);
        elseif strcmp(cc,'s')
            id = max(id-1,1);
        elseif strcmp(cc,'d')
            ciz(id,iv,IX,IY,IZ) = min(iz+diz,nz);      
        elseif strcmp(cc,'e')
            ciz(id,iv,IX,IY,IZ) = max(iz-diz,1);
        elseif strcmp(cc,'y')
            iv = min(iv+1,nv);
        elseif strcmp(cc,'h')
            iv = max(iv-1,1);
        elseif strcmp(cc,'u')
            IX = min(IX+1,MX);
        elseif strcmp(cc,'j')
            IX = max(IX-1,1);
        elseif strcmp(cc,'i')
            IY = min(IY+1,MY);
        elseif strcmp(cc,'k')
            IY = max(IY-1,1);
        elseif strcmp(cc,'o')
            IZ = min(IZ+1,MZ);
        elseif strcmp(cc,'l')
            IZ = max(IZ-1,1);
        end
    end            
end
% close(fig);

figure('Position',[1 1 10 10]*85);  clf;  colormap(gray);
iv = 1;  IX = 1;  IY = 1;  IZ = 1;
for id=1:nd
    II = cII{id,iv,IX,IY,IZ};
    Mf = cMf{id,iv,IX,IY,IZ};
    D = cD{id,iv,IX,IY,IZ}*1e12;  % Dz = mean(D(:,:),2);
    MfD = Mf.*D;
    iz = ciz(id,iv,IX,IY,IZ);

    [nz,nx,ny] = size(Mf);
    subplot(4,nd,id);  cla;  hold on;  PlotImage(squeeze(log(II(iz,:,:)))',false,[.1 .9],true);  xlabel(['iz=' num2str(iz)]);  title(cdid{id});  if (id == 1), ylabel('II'); end  
    subplot(4,nd,nd+id);  cla;  hold on;  PlotImage(squeeze(Mf(iz,:,:))',false,[0 1]);  if (id == 1), ylabel('Mf [0 1]'); end
    subplot(4,nd,nd*2+id);  cla;  hold on;  PlotImage(squeeze(D(iz,:,:))',false,limD);  if (id == 1), ylabel(['D ' mat2str(limD)]); end
    subplot(4,nd,nd*3+id);  cla;  hold on;  PlotImage(squeeze(MfD(iz,:,:))',false,limMfD);  set(gca,'colormap',jet);  if (id == 1), ylabel(['MfD ' mat2str(limMfD)]); end
end

disp('SECTION 22 COMPLETED.');
