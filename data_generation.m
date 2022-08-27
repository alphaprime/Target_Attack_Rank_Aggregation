%% data_generation: function description
function [A, y, w, true_r] = data_generation(n, ratio_outlier)
	% rng(1, 'twister' );
	N = n * (n - 1);

	% All possible comparison
	% Each row (i,j, y) means a comparison between i and j,
	% its true label is y, which is all 1
	% Ground truth is n > n-1 > ... > 1
	y = ones(N, 1);
	% The design matrix or the gradient flow on the graph
	A = zeros(N, n);	

	% For each node i, generate all the possible comparisons
	for i = 1 : n
	    Z = zeros(n, n);
		Z(:, i) = 1;
		for j = 1 : n 
			Z(j, j) = -1;
		end
		Z(i, :) = []; 
		A((n - 1) * (i-1) + 1 : (n - 1) * (i - 1) + n - 1, :) = Z;
	end	

	% True Ranking
	true_r = n : -1 : 1;	

	inlier_index = zeros(N / 2, 1);
	outlier_index = zeros(N / 2, 1);
	clean_pair = zeros(N, 2);
	k1 = 1;
	k2 = 1;	

	for c = 1:N
		i = find(A(c, :) == 1);
		j = find(A(c, :) == -1);
		if i < j
			outlier_index(k1) = c;
			k1 = k1 + 1;
		else
			inlier_index(k2) = c;
			k2 = k2 + 1;
		end
		clean_pair(c, 1) = i;
		clean_pair(c, 2) = j;
	end
	% Unique comparisons
	Id_unique_inlier = randperm(length(inlier_index), length(inlier_index));
	Id_unique_outlier = randperm(length(outlier_index), ceil(length(outlier_index) * ratio_outlier));
	Id_unique = [inlier_index(Id_unique_inlier); outlier_index(Id_unique_outlier)];	

	N_unique = length(Id_unique);	

	% Weight for each comparison
	mul_min = 10;
	mul_max = 200;
	multi = randi([mul_min, mul_max], length(Id_unique), 1);
	w = zeros(N, 1);
	w(Id_unique) = multi;	

	sample_pair = zeros(N_unique, 2);	

	for c = 1 : N_unique
		sample_pair(c, 1) = find(A(Id_unique(c), :) == 1);
		sample_pair(c, 2) = find(A(Id_unique(c), :) == -1);
	end	

	% Test Connection
	candi = [unique(sample_pair(:, 1)); unique(sample_pair(:, 2))];
	candi = unique(candi);
	unsel_id = true(1, n);
	unsel_id(candi) = false;
	candi_num = length(candi);
	unsel_id = find(unsel_id == 1);	

	% Keep Connection
	if ~isempty(unsel_id)
	    for n = 1:length(unsel_id)
	        ss = find(candi ~= unsel_id(n));
	        tt = randperm(length(ss), 1);
	        idx = find(clean_pair(:, 1) == unsel_id(n) & clean_pair(:, 2) == candi(ss(tt)));
	        sample_pair = [sample_pair; clean_pair(idx, :)];
	        Id_unique = [Id_unique; idx];
	    end
		% Generation the new data with sample_pair
		mul_min = 10;
		mul_max = 200;
		multi = randi([mul_min, mul_max], length(Id_unique), 1);
		w = zeros(N, 1);
		w(Id_unique) = multi;
	end

end