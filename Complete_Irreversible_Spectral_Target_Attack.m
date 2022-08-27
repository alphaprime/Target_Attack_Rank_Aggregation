% Complete_Irreversible_Spectral_Target_Attack: function description
function [w_hat] = Complete_Irreversible_Spectral_Target_Attack(target, w)
	n = length(target);
	w_hat = zeros(length(w), 1);
	P = Irreversible_Transition_Matrix(target, n);
	A = Construct_Transition_Matrix(w, n);
	dmax = max(sum(A, 2));
    
    win_id = 1;
    lose_id = 2;
    for idx = 1:length(w)
        w_hat(idx) = round(P(lose_id, win_id) * (A(lose_id, win_id) + A(win_id, lose_id)) * dmax);
        % w_hat(idx) = round(P(lose_id, win_id) * dmax);
        if lose_id < n
            lose_id = lose_id + 1;
            if lose_id == win_id
                lose_id = lose_id + 1;
            end
        else
            lose_id = 1;
            win_id = win_id + 1;
        end
    end
end