close all;
clear;
clc;

% Number of Node
n = 10;
% Iteration of Game
Iter = 50;
% Number of trails
T = 50;
% Ratio of Outlier
mu = [0, 0.05, 0.1, 0.15, 0.2];
% Original weights of each edge/ comparison
w = cell(T, length(mu));
w_h = cell(T, length(mu), n - 1);
w_r = cell(T, length(mu), n - 1);
w_n = cell(T, length(mu), n - 1);
w_p = cell(T, length(mu), n - 1);
theta_target = cell(T, length(mu), n - 1);
ranking_target = cell(T, length(mu), n - 1);
theta_attack = cell(T, length(mu), n - 1);
theta_r = cell(T, length(mu), n - 1);
theta_n = cell(T, length(mu), n - 1);
theta_p = cell(T, length(mu), n - 1);
ranking_attack = cell(T, length(mu), n - 1);
ranking_r = cell(T, length(mu), n - 1);
ranking_n = cell(T, length(mu), n - 1);
ranking_p = cell(T, length(mu), n - 1);
score = cell(T, length(mu), n - 1);
score_r = cell(T, length(mu), n - 1);
score_n = cell(T, length(mu), n - 1);
score_p = cell(T, length(mu), n - 1);

for t = 1:T
    for s = 1:length(mu)
        [A, y, w{t, s}, true_r] = data_generation(n, mu(s));

        Max_Len = sum(w{t, s});

        %%%%% HodgeRank %%%%%
        hodge_theta = HodgeRank(A, y, w{t, s});
        hodge_ranking = score_to_ranking(hodge_theta);  

        for i = 1:n - 1
            %%%%% Target Attack %%%%%
            target = hodge_ranking(i + 1);  

            % Operate theta_0 into theta_target
            theta_target{t, s, i} = zeros(n, 1);
            tmp = hodge_ranking';
            tmp(find(tmp == target)) = [];
            tmp = [target, tmp];    

            % % Perfect Feedback 
            % for j = 1:length(tmp)
            %     theta_target{t, s, i}(tmp(j)) = hodge_theta(hodge_ranking(j));
            % end

            % Imperfect Feedback
            rank_theta = sort(rand(n, 1), 'ascend');    

            for j = 1:length(tmp)
                theta_target{t, s, i}(tmp(j)) = rank_theta(hodge_ranking(j));
            end

            ranking_target{t, s, i} = tmp; 

            % Attack Operation
            w_e = Convex_Complete_Batch_Target_Attack(A, y, theta_target{t, s, i}, w{t, s}, 1, Iter);  

            w_h{t, s, i} = ceil(w_e(:, Iter) / sum(w_e(:, Iter)) * sum(w{t, s}));

            w_r{t, s, i} = Random_Attack(w{t, s}, n, Max_Len);

            w_n{t, s, i} = Naive_Attack(w{t, s}, n, theta_target{t, s, i}, Max_Len);

            w_p{t, s, i} = Pobabilistic_Attack(w{t, s}, n, theta_target{t, s, i}, Max_Len, 0.75);

            % Ranking with Poisoned Data
            theta_attack{t, s, i} = HodgeRank(A, y, w_h{t, s, i});
            ranking_attack{t, s, i} = score_to_ranking(theta_attack{t, s, i});
            score{t, s, i} = eval_ranking(tmp, ranking_attack{t, s, i}');

            theta_r{t, s, i} = HodgeRank(A, y, w_r{t, s, i});
            ranking_r{t, s, i} = score_to_ranking(theta_r{t, s, i});
            score_r{t, s, i} = eval_ranking(tmp, ranking_r{t, s, i}');

            theta_n{t, s, i} = HodgeRank(A, y, w_n{t, s, i});
            ranking_n{t, s, i} = score_to_ranking(theta_n{t, s, i});
            score_n{t, s, i} = eval_ranking(tmp, ranking_n{t, s, i}');

            theta_p{t, s, i} = HodgeRank(A, y, w_p{t, s, i});
            ranking_p{t, s, i} = score_to_ranking(theta_p{t, s, i});
            score_p{t, s, i} = eval_ranking(tmp, ranking_p{t, s, i}');
        end
    end
end