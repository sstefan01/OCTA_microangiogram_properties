function metrics = getGraphMetrics(graphObj)
	adjMat = adjacency(graphObj);
	% Some algorithms require any self-edges to be removed from the
	% adjacency matrix
    
	adjMatDiagless = adjMat - diag(diag(adjMat));
	metrics.isDirected = isa(graphObj,'digraph');

	metrics.distances = distances(graphObj);
	metrics.nodeCt = size(metrics.distances,1);
	metrics.edgeCt = size(graphObj.Edges,1);
	% avgPathLength will be Inf if graph is not fully, strongly connected
	% Disregarding self-edges, there are nodeCt*(nodeCt-1) unique paths in
	% the graph
	metrics.avgPathLength = sum(metrics.distances(:))/(metrics.nodeCt*(metrics.nodeCt-1));
	% diameter will be Inf if graph is not fully, strongly connected
	metrics.diameter = max(metrics.distances(:));
	[eigenvecs,eigenvalsMat] = eig(full(adjMat));
	% Transform the diagonal matrix into a column vector
	eigenvals = diag(eigenvalsMat);
	[metrics.maxEigenvalue,indxr] = max(eigenvals);
	% The MATLAB-generated eigenvector might be all nonpositive values, so
	% a negation of the eigenvector in this case is desirable
	% We compare positive and negative sums because sometimes 0s are
	% rounded as very tiny values of the opposite sign from the rest of the
	% vector
	negate = sum(eigenvecs(:,indxr)<0) > sum(eigenvecs(:,indxr)>0);
	metrics.eigenCentralities = eigenvecs(:,indxr).*((-1)^negate);
	% Summing each row works for both undirected and directed graphs
	degrees = sum(adjMatDiagless,2);
	% Divide each degree by the maximum degree possible
	metrics.degreeCentralities = degrees./(metrics.nodeCt-1);
	% Some closeness centralities may be 0 if graph is not fully, strongly 
	% connected
	% Closeness is the inverse of farness. Farness is the average of all
	% shortest paths (not including self-edges) originating from a node.
	metrics.closenessCentralities = (metrics.nodeCt-1)./sum(metrics.distances,2);
	% Ensure that graph is fully connected for distance distribution
	% calculations
	if(isfinite(metrics.diameter))
		distVals = 1:metrics.diameter;
		if(~metrics.isDirected)
			distVec = triu(metrics.distances);
		else
			distVec = metrics.distances;
		end
		% Remove self-edges from 'distVec'; also linearizes matrix into a 
		% vector form
		distVec = distVec(0 ~= distVec);
		qNodePairs = zeros(size(distVals));
		for ind=distVals
			% qNodePairs(ind) contains the quantity of node pairs that have
			% shortest path length of ind between them.
			qNodePairs(ind) = sum(distVec == ind);
		end
		metrics.distanceDistribution = table(distVals.',qNodePairs.','VariableNames',{'Distance','QuantityOfNodePairs'});
	end
	% Necessary to avoid NaN values
	degreesSafeDividing = degrees;
	% This essentially prevents 0./0 generating a NaN by changing the
	% operation to be 0./1, which equals 0.
	degreesSafeDividing(0==degreesSafeDividing) = 1;
	% Sum the degrees of each nodes neighbors through matrix multiplication
	% and then divide by the total number of neighbors each node has.
	metrics.assortativityByNode = (adjMatDiagless*degrees)./degreesSafeDividing;
	degComboMat = zeros(max(degrees),metrics.nodeCt);
	non0mask = 0 ~= degrees;
	% Create a linear indexing vector which will index all points (i,j) in
	% the matrix such that the jth node has degree i.
	indxr = sub2ind(size(degComboMat),degrees(non0mask),find(non0mask));
	degComboMat(indxr) = 1;
	% Some complicated math, but effectively degComboMat*adjMatDiagless
	% yields a matrix where entry (i,j) equals the number of instances
	% where the jth node is a neighbor of any node of degree i.
	% degByDegSafeDividing(n) then equals the total number of neighbors
	% to any node of degree n, where double counting is allowed (e.g. if 
	% node 2 has edges with nodes 3 & 4, both of which are of degree 1, 
	% then node 2 is counted as two neighbors, i.e. 
	% degByDegSafeDividing(1) = 2)
	degByDegSafeDividing = sum(degComboMat*adjMatDiagless,2);
	degByDegSafeDividing(0==degByDegSafeDividing) = 1;
	metrics.assortativityByDegree = (degComboMat*adjMatDiagless*degrees)./degByDegSafeDividing;
    metrics.clsness = centrality(graphObj, 'closeness');
    metrics.btwness = centrality(graphObj, 'betweenness');
end