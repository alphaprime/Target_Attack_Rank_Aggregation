%% reciprocal_rank: 
function score = reciprocal_rank(r_true, pred)

	ind = find(pred == r_true(1));

	score = 1 / ind;

end