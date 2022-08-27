%% Construct_Transition_Matrix: function description
function [A] = Construct_Transition_Matrix(w, n)
	A = zeros(n);
	win_id = 1;
	lose_id = 2;
	for idx = 1:length(w)
		A(lose_id, win_id) = w(idx);
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