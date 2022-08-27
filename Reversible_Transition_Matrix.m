% Reversible_Transition_Matrix: function description
function [Q] = Reversible_Transition_Matrix(target, n)
    % Keep Positive, Summing to 1 and Ascent Order
    minV = min(target);
    if minV < 0
        Vs = target - minV;
    else
        Vs = target;
    end
    Vs = Vs / sum(Vs);
    [Vs, Idx] = sort(Vs);

    Alpha = zeros(n, 1);
    Beta = zeros(n, 1);
    PI = repmat(Vs, 1, n);

    % Construct three sequences
    for k = 1:n - 1
        Beta(k + 1) = 1 - PI(k, k);
        PI(:, k+1) = PI(:, k) / Beta(k + 1);
        Alpha(k + 1) = 1 - (PI(k, k) / Beta(k + 1));
    end

    % Recursively Construction
    P_all = cell(n, 1);
    P_all{n} = 0;
    for k = n - 1:-1:1
        Tmp = zeros(n - k + 1);
        Tmp(1, 1) = 0;
        Tmp(1, 2:n - k + 1) = PI(k + 1:n, k)' / Beta(k + 1);
        Tmp(2:n - k + 1, 1) = 1 - Alpha(k + 1);
        Tmp(2:n - k + 1, 2:n - k + 1) = Alpha(k + 1) * P_all{k + 1};
        P_all{k} = Tmp;
    end

    % Probabilistic Transition Matrix
    P = P_all{1};
    P(n, n) = 1 - sum(P_all{1}(n, :));

    % Construct Transformation Matrix
    T = zeros(n);
    Inv_Idx = flip(Idx);
    for i = 1:n
        T(Inv_Idx(i), n - i + 1) = 1;
    end
    Q = T * P * T';
end