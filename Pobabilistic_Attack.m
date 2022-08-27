%% Pobabilistic_Attack: function description
function [w_hat] = Pobabilistic_Attack(w, n, target, Max_Len, rho)
    % Random Sampling
    l_id = randi([1, n], Max_Len, 1);
    r_id = randi([1, n], Max_Len, 1);
    pair = [l_id, r_id];
    idx = find(pair(:, 1) == pair(:, 2));
    pair(idx, :) = [];
    count = 0;
    while count < length(idx)
        tmp = randsample(1:n, 2);
        if tmp(1) == tmp(2)
            continue;
        else
            pair(end + 1, :) = tmp;
            count = count + 1;
        end
    end

    % Operation
    flag = zeros(Max_Len, 1);
    for c = 1:Max_Len
        i = pair(c, 1);
        j = pair(c, 2);
        prob = target(i) / (target(i) + target(j));
        if prob > rho
            flag(c) = 1;
        elseif prob < rho
            flag(c) = -1;
        else
            flag(c) = 0;
        end
    end

    % Modification
    w_hat = w;
    for c = 1:Max_Len
        i = pair(c, 1);
        j = pair(c, 2);
        if i < j
            id = (i - 1) * (n - 1) + j - 1;
        else
            id = (i - 1) * (n - 1) + j;
        end
        if flag(id) == 1
            w_hat(id) = w_hat(id) + 1;
        elseif flag(id) == -1 && w_hat(id) > 0
            w_hat(id) = w_hat(id) - 1;
        end
    end