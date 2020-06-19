function T = find_tensor(ws)

T(:,:,:,1,1) = ws(:,:,:,1).*ws(:,:,:,1);
T(:,:,:,1,2) = ws(:,:,:,1).*ws(:,:,:,2);
T(:,:,:,1,3) = ws(:,:,:,1).*ws(:,:,:,3);
T(:,:,:,2,1) = ws(:,:,:,2).*ws(:,:,:,1);
T(:,:,:,2,2) = ws(:,:,:,2).*ws(:,:,:,2);
T(:,:,:,2,3) = ws(:,:,:,2).*ws(:,:,:,3);
T(:,:,:,3,1) = ws(:,:,:,3).*ws(:,:,:,1);
T(:,:,:,3,2) = ws(:,:,:,3).*ws(:,:,:,2);
T(:,:,:,3,3) = ws(:,:,:,3).*ws(:,:,:,3);
end