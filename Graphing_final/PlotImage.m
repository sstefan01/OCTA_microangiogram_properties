% img: 2D image
% btick : xtick?
% limC
% brel : limC is relative MeanLow/High?
% dar  : data aspect ratio [px py pz]
% alp  : alpha data

% ret  : resultant limC

function ret = PlotImage(img, btick, limC, brel, dar, alp)

    if nargin >= 6
        imagesc(img,'AlphaData',alp,'AlphaDataMap','none');  
    else
        imagesc(img);  
    end
	axis image;  
	
	if nargin >= 2
		if ~btick
			set(gca,'XTick',[]);  set(gca,'YTick',[]);  
		end
    end
    
	if nargin >= 3
		if nargin >= 4
			if brel
                lim = [GetSorted(img,limC(1)) GetSorted(img,limC(2))];
                if diff(lim) > 0
                    set(gca,'CLim',lim);
                end
            else
    			set(gca,'CLim',limC);
			end
		else
			set(gca,'CLim',limC);
		end
    end
    
    if nargin >= 5
        if numel(dar) == 3
            set(gca,'DataAspectRatio',dar);
        end
    end
	
	ret = get(gca,'CLim');
