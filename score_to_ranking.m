%% score_to_ranking: function description
function r = score_to_ranking(theta)
    n = length(theta);
	[~, idx] = sort(theta, 'descend');
	r = idx;
% 	r(idx) = r;
end