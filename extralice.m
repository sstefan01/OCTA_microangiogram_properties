function [slice, sliceInd, subX, subY, subZ, hspVecXvec] = extralice(volume,centerX,centerY,centerZ,normX,normY,normZ,radius)



if nargin < 7
   disp('requires at least 7 parameters');
   return;
end

if nargin < 8
    % sets the size for output slice radius*2+1.
    radius = 50;
end



pt = [centerX,centerY,centerZ];
vec = [normX,normY,normZ];

%initialize needed parameters
%size of volume.
volSz=size(volume); 
%a very small value.
epsilon = 1e-12; 
figure(3)
%assume the slice is initially at [0,0,0] with a vector [0,0,1] and a silceSize.
hsp = surf(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1),zeros(2*radius+1));
hspInitialVector = [0,0,1];

%normalize vectors;
hspVec = hspInitialVector/norm(hspInitialVector);
hspVec(hspVec ==0) = epsilon;
vec = vec/norm(vec);
vec(vec == 0)=epsilon;

%this does not rotate the surface, but initializes the subscript z in hsp.
rotate(hsp,[0,0,1],0);

hspVecXvec = cross(hspVec, vec)/norm(cross(hspVec, vec));
acosineVal = acos(dot(hspVec, vec));

%help prevents errors (i.e. if vec is same as hspVec),
hspVecXvec(isnan(hspVecXvec)) = epsilon;
acosineVal(isnan(acosineVal)) = epsilon;

%rotate to the requested orientation
rotate(hsp,hspVecXvec(:)',180*acosineVal/pi);

%get the coordinates
xd = get(hsp,'XData');
yd = get(hsp,'YData');
zd = get(hsp,'ZData');
close(3) 
%translate;
subX = xd + pt(1);
subY = yd + pt(2);
subZ = zd + pt(3);

%round the subscripts to obtain its corresponding values and indices in the volume.
xd = round(subX)';
yd = round(subY)';
zd = round(subZ)';


%obtain the requested slice intensitis and indices from the input volume.
xdSz=size(xd);
sliceInd=NaN(xdSz);
slice=NaN(xdSz);%zeros(xdSz);%*NaN;
for i = 1:xdSz(1)
    for j = 1:xdSz(2)
        if xd(i,j) > 0 && xd(i,j)<= volSz(1) &&...
             yd(i,j) > 0 && yd(i,j)<= volSz(2) &&...
             zd(i,j) > 0 && zd(i,j)<= volSz(3),
         sliceInd(i,j) = sub2ind(volSz,xd(i,j),yd(i,j),zd(i,j));
         slice(i,j) = volume(xd(i,j),yd(i,j),zd(i,j));
       
        end
    end 
    
end




