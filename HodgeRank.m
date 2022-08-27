%% HodgeRank_1: Close-form solution
function [theta] = HodgeRank(A, y, w)
	W = diag(sqrt(w));
	P_Inv = pinv(A' * W * A);
	theta = P_Inv * A' * W * y;
end