%% Irreversible_Transition_Matrix: function description
function [Q] = Irreversible_Transition_Matrix(target, n)
	P = zeros(n);

	% Keep Positive, Summing to 1 and Ascent Order
    minV = min(target);
    if minV < 0
        Vs = target - minV;
    else
        Vs = target;
    end
    Vs = Vs / sum(Vs);
    [Vs, Idx] = sort(Vs);
    
	for i = 1:n
        Res = 0;
		for j = 1:n
			if j < i && i < n
				P(i, j) = 0;
                Res = Res + P(i, j);
                continue;
			end
			if j == i && i < n
				P(i, j) = ( Vs(i) - Vs(1) ) / ( Vs(i) + Vs(n) );
                Res = Res + P(i, j);
                continue;
			end
			if j < n && i == n
                tmp = 1;
                for k = 1:(j - 1)
                    tmp = tmp * ( ( Vs(n) - Vs(k) ) / ( Vs(k) + Vs(n) ) );
                end
				P(i, j) = Vs(j) * ( Vs(1) + Vs(n) ) / ( Vs(n) * ( Vs(j) + Vs(n) ) ) * tmp;
                Res = Res + P(i, j);
                continue;
			end
			if j > i && j < n
                tmp = 1;
                for k = (i + 1) : (j - 1)
                    tmp = tmp * ( (Vs(n) - Vs(k)) / (Vs(k) + Vs(n)) );
                end
                P(i, j) = 2 * Vs(j) * ( Vs(1) + Vs(n) ) / ( ( Vs(i) + Vs(n) ) * ( Vs(j) + Vs(n) ) ) * tmp;
                Res = Res + P(i, j);
                continue;
			end
            if j == n
                P(i, j) = 1 - Res;
                continue;
            end
		end
	end

    % Construct Transformation Matrix
    T = zeros(n);
    Inv_Idx = flip(Idx);
    for i = 1:n
        T(Inv_Idx(i), n - i + 1) = 1;
    end
    Q = T * P * T';

end