
function ret = GetSorted(A, ratio, dim)
if nargin < 3
	dim = 0;
end

	if dim == 0
		sqA = sort(A(:),'ascend');
		ret = sqA(round(ratio*length(sqA)));
	else
		nd = ndims(A);
		A = shiftdim(A,dim-1);  sz = size(A);  sz(1) = 1;
		A = sort(A,1,'ascend');		
		ret = reshape( A(round(ratio*size(A,1)),:) ,sz);
		ret = shiftdim(ret,nd-dim+1);
	end
