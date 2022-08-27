%% Spectral_Ranking: Rank Centrality
function [Pi] = Spectral_Ranking(w, n)
    A = Construct_Transition_Matrix(w, n);
    dmax = max(sum(A, 2));
    % right probabilistic transition matrix
    P = A ./ (A + A' + 1e-6);
    Diag = diag(1 - sum(P, 2) / dmax);
    % each row summing to 1
    P = Diag + P / dmax;
    % Eigen Decomposition
    [~, D, W] = eig(P);
    [~, idx] = max(diag(D));
    Pi = abs(W(:, idx));
    % Power Method
    % q = rand(n, 1);
    % q = q / norm(q,2);
    % v = 0;
    % while abs(v-1) > 1e-20
    %     z = P * q;
    %     q = z / norm(z, 2);
    %     v = q' * P * q;
    % end
    % Pi = q;
end