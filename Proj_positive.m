%% Proj_positive: function description
function [w] = Proj_positive(w)
	w = (w >= 0) .* w;
end