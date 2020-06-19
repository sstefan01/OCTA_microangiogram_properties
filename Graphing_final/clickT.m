function S1 = clickT(S1,out,i,col,mp, skel,xx,yy)
    
    ep = bwmorph3(skel, 'endpoints');
    [m,n,v] = ind2sub(size(skel),find(ep == 1));

    handles.figure = figure('Position',[100 100 500 500],'Units','Pixels', 'WindowKeyPressFcn',@pb_kpf);
    
    handles.axes1 = axes('Units','Pixels','Position',[60,100,400,300]);
    handles.i = i;
    handles.S1 = S1;
    handles.col = col;
    handles.out = out;
    handles.mp = mp;
    handles.skel = skel;
    handles.r = [];
    handles.temp = [];
    handles.coltemp = [];
    handles.indtemp = [];
    guidata(handles.figure,handles)

    handles.btn = uicontrol('Style', 'pushbutton', 'String', 'See segment', 'Position', [50 470 100 20],'Callback', @pushbutton_callback);  
    handles.btn2 = uicontrol('Style', 'pushbutton', 'String', 'Connect segments', 'Position', [150 470 100 20],'Callback', @connect_seg);  
    handles.btn3 = uicontrol('Style', 'pushbutton', 'String', 'Quit', 'Position', [50 450 100 20],'Callback', @pushbutton_exit);  

    imagesc(xx,yy,imadjustn(squeeze(out(i,:,:))))
    hold on 
    colormap(gray)
    
    for ii = 1:length(m)
        if m(ii) == i
            scatter(v(ii),n(ii),'x','r')
        end
    end
    
    
    c = cellfun(@(x)(sum(ismember(x(:,1),i))),S1);
    ind = find(c>0);
    H = [];
    
    for j = 1:length(ind)
        s = S1{ind(j)};
        H(j) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', col(ind(j),:)) ;
        
        if ismember(ind(j), mp) == 1
            rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
        end
            
    end
    
    handles.ind = ind;
    handles.Text1 = uicontrol('Style','Text','Position',[180 450 70 20],'String','Segment:');
    guidata(handles.figure,handles)
    
    set(H, 'ButtonDownFcn', {@LineSelected, H, ind, S1,col});
   

    handles = guidata(gcf);
    S1 = handles.S1;
    ind = handles.ind;

    uiwait
    %i = get(handles.btn3,'Value')

    
    
    
function LineSelected(ObjectH, ~, H,ind, S1, col)
    dat = guidata(gcf);
    if isempty(dat.r) == 0
        delete(dat.r)
    end
    set(ObjectH, 'LineWidth', 3);
    set(H(H ~= ObjectH), 'LineWidth', 1.5);
    p = find(H==ObjectH);
    
    handles = guidata(gcf);
    set(handles.Text1,'String',num2str(ind(p)))
    set(handles.Text1,'Value',ind(p))
    p = get(handles.Text1,'Value');
    for ij = 1:length(S1)
        conn(ij) = sum(ismember(S1{ij},S1{p}, 'rows'));
    end

    ne = find(conn);
    hold on
    for ij = 1:length(ne)
        ss = S1{ne(ij)};
        r(ij) = plot(ss(:,3),ss(:,2), 'linewidth', 3, 'Color', col(ne(ij),:)) ;
    end
    dat.r = r;
    guidata(dat.figure,dat)
 
    %SliderValue = get(handles.Text1, 'Value');
    %i = p;
end




function pb_kpf(varargin)
    
    dat = guidata(varargin{1,1});
    i = dat.i;
    
    if strcmp(varargin{1,2}.Key, 'z') 
        if i > 1 
            i = i - 1;
            dat.i = dat.i - 1;
        end
        cla
        imagesc(xx,yy,imadjust(squeeze(dat.out(i,:,:))), 'Parent', dat.axes1)
        hold on 

        c = cellfun(@(x)(sum(ismember(x(:,1),i))),dat.S1);
        ind = find(c>0);
        H = [];
        for j1 = 1:length(ind)
            s = dat.S1{ind(j1)};
            H(j1) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', dat.col(ind(j1),:)) ;
            if ismember(ind(j1), dat.mp) == 1
                rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
            end
        end

        set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col})
    end
    
     if strcmp(varargin{1,2}.Key, 'v') 
        if ~isempty(dat.temp)
            dat.S1{dat.indtemp} = dat.temp;
            hold on; 
            plot(dat.temp(:,3), dat.temp(:,2), 'color', dat.coltemp, 'linewidth', 1.5)
        end
     end

    if strcmp(varargin{1,2}.Key, 'x') 
        if dat.i < size(dat.out,1)
            dat.i = dat.i + 1;
        end

        cla
        imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', dat.axes1)
        hold on 

        c = cellfun(@(x)(sum(ismember(x(:,1),dat.i))),dat.S1);
        ind = find(c>0);
        H = [];
        for j2 = 1:length(ind)
            s = dat.S1{ind(j2)};
            H(j2) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', dat.col(ind(j2),:)) ;
            if ismember(ind(j2), dat.mp) == 1
                rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
            end
        end

        set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col})
    end

    if strcmp(varargin{1,2}.Key, 'backspace') 
        dat.temp = S1{dat.Text1.Value};
        dat.coltemp = dat.col(dat.Text1.Value,:);
        dat.indtemp = dat.Text1.Value;
        dat.S1{dat.Text1.Value} = [0 0 0];
        imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', dat.axes1)
        hold on 

        c = cellfun(@(x)(sum(ismember(x(:,1),i))),dat.S1);
        ind = find(c>0);
    
        H = [];
        for jj = 1:length(ind)
            s = dat.S1{ind(jj)};
            H(jj) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', dat.col(ind(jj),:)) ;
            if ismember(ind(jj), dat.mp) == 1
                rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
            end
        end

        set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col})
    end

    if strcmp(varargin{1,2}.Key, 'return') 
        p = [];

        while true
            [x,y,button] = ginput(1);

            if isempty(button) == 1
                dat.S1{end+1} = pp;
                dat.col(end+1,:) = [ 0 1 0];
                break
            end

            if button == 122 %'z'
                if dat.i > 1 
                    dat.i = dat.i - 1;
                end
            cla
            imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', handles.axes1)
            hold on 

            c = cellfun(@(x)(sum(ismember(x(:,1),dat.i))),dat.S1);
            ind = find(c>0);
            
            H = [];
            for jj = 1:length(ind)
                s = dat.S1{ind(jj)};
                H(jj) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', col(ind(jj),:)) ;

                if ismember(ind(jj), mp) == 1
                    rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
                end
            end
            set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col});

            if size(p,1) > 1
                scatter(p(:,3), p(:,2), 'x', 'g')
                pp = find_line(p);
                plot(pp(:,3), pp(:,2), 'g', 'linewidth', 1.5)
            end
            end

            if button == 120 %'x'
                if dat.i < size(dat.out,1)
                    dat.i = dat.i + 1;
                end
                hold on; cla;
                imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', handles.axes1)
                hold on 

                c = cellfun(@(x)(sum(ismember(x(:,1),dat.i))),dat.S1);
                ind = find(c>0);

                H = [];
                for jj = 1:length(ind)
                    s = dat.S1{ind(jj)};
                    H(jj) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', col(ind(jj),:)) ;

                    if ismember(ind(jj), mp) == 1
                        rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
                    end
                end
                set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col});

                if size(p,1) > 1
                    scatter(p(:,3), p(:,2), 'x', 'g')
                    pp = find_line(p);
                    plot(pp(:,3), pp(:,2), 'g', 'linewidth', 1.5)
                end
            end

            if button == 1
                p = [p; round([dat.i y x])];
                hold on 
                scatter(p(:,3), p(:,2), 'x', 'g')
                if size(p,1) > 1
                    try
                        pp = find_line(p);
                        plot(pp(:,3), pp(:,2), 'g', 'linewidth', 1.5)
                    catch
                        warning('returned empty')
                    end
                end
            end
        end
    end

    
    S1 = dat.S1;
    guidata(varargin{1,1},dat)
%guidata(dat.figure,handles)
%close all

%clickTest %(dat.S1, dat.out,dat.i,dat.col, dat.mp, dat.skel);

end


 function  pushbutton_exit(~, ~, ~)
    handles = guidata(gcf);
    close(gcf);
 end

 function  pushbutton_callback(~, ~, ~)
    dat = guidata(gcf);
    ind = dat.Text1.Value;
    follow_vess(dat.S1{ind},dat.out,yy,xx);
 end
 
  function  connect_seg(~, ~, ~)
    dat = guidata(gcf);
    pp = [];

    for g = 1:3
        cla
        imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', dat.axes1)
        hold on 

        c = cellfun(@(x)(sum(ismember(x(:,1),dat.i))),dat.S1);
        ind = find(c>0);
        
        H = [];
        for jj = 1:length(ind)
            s = dat.S1{ind(jj)};
            H(jj) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', dat.col(ind(jj),:)) ;

            if ismember(ind(jj), mp) == 1
                rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
            end
        end

        set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col});
        pp(g) = get(dat.Text1, 'Value');
        if g <3
            waitfor(dat.Text1,'Value');
        end
    end
    pp = pp(2:3);
    sline = conn_line_point(dat.S1,pp);
    dat.S1{end+1} = sline;
    dat.col(end+1,:) = [1 0 0];
    guidata(dat.figure,dat)
    S1 = dat.S1;
    
    imagesc(xx,yy,imadjust(squeeze(dat.out(dat.i,:,:))), 'Parent', dat.axes1)
    hold on 

    c = cellfun(@(x)(sum(ismember(x(:,1),dat.i))),dat.S1);
    ind = find(c>0);

    for jj = 1:length(ind)
        s = dat.S1{ind(jj)};
        H(jj) = plot(s(:,3),s(:,2), 'linewidth', 1.5, 'Color', dat.col(ind(jj),:)) ;

        if ismember(ind(jj), mp) == 1
            rectangle('Position',[min(s(:,3))-1, min(s(:,2))-1, (max(s(:,3))-min(s(:,3)))+2,(max(s(:,2))-min(s(:,2)))+2], 'EdgeColor','r')
        end
    end

    set(H, 'ButtonDownFcn', {@LineSelected, H, ind, dat.S1,dat.col});
  end
end


