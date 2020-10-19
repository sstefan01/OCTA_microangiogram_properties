disp('SECTION 22a RUNNING ...');
% SetParPool(6);

% zz
    [nz,nx,ny] = size(Enh);
    Dz = mean(Enh(:,:),2);
    if ~exist('zz','var')
        zz = ones(1,2);
        thrD = max(Dz)/DR;
        idx = sign(Dz-thrD);  idx = find(diff(idx)==-2);  
        if length(idx) >= 1
            zz(2) = idx(1);
        else
            zz(2) = size(DD,1);
        end
    end
    
% UI
    figure(1);  clf;  colormap(gray);  pause(.1);
    while true
        
        sec22a_plot;
    
        if waitforbuttonpress
            cc = get(gcf,'CurrentCharacter');
            if strcmp(cc,'q')        
                break;
            elseif strcmp(cc,'g')
                gi = ginput(1);
                zz(2) = max(round(gi(1)),zz(1)+1);
            elseif strcmp(cc,'s')
                zz(2) = max(zz(2)-dz,zz(1)+1);
            elseif strcmp(cc,'f')
                zz(2) = zz(2)+dz;
            end
        end

    end 

    figure('position',[1 1 10 10]*85);  colormap(gray);
    sec22a_plot;
    
disp('SECTION 22a COMPLETED.');