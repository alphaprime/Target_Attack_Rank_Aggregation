%% Convex_Complete_Batch_Target_Attack: function description
function [w] = Convex_Complete_Batch_Target_Attack(A, y, theta_target, w_s, Rho, T)
	
	[M, N] = size(A);
	w = zeros(M, T);
	mu = zeros(N, T);
	C = A * theta_target - y;
	B = diag(C) * A;
	G = B * B';
	w(:, 1) = w_s;
	
	for t = 1:T-1
		% update w
		tmp_1 = eye(M) + Rho * G;
		tmp_2 = w_s - B * mu(:, t);
		w(:, t+1) =  Proj_positive(tmp_1 \ tmp_2);

		% update dual variable
		mu(:, t+1) = mu(:, t) + Rho * B' * w(:, t+1);
	end
end