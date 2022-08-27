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
        spectral_theta = Spectral_Ranking(w{t, s}, n);
        spectral_ranking = score_to_ranking(spectral_theta);

        for i = 1:n - 1
            %%%%% Target Attack %%%%%
            target = spectral_ranking(i + 1);

            % Operate theta_0 into theta_target
            theta_target{t, s, i} = zeros(n, 1);
            tmp = spectral_ranking';
            tmp(find(tmp == target)) = [];
            tmp = [target, tmp];

            % Perfect Feedback 
            for j = 1:length(tmp)
                theta_target{t, s, i}(tmp(j)) = spectral_theta(spectral_ranking(j));
            end 

            ranking_target{t, s, i} = tmp;

            % Attack Operation
            w_e = Complete_Irreversible_Spectral_Target_Attack(theta_target{t, s, i}, w{t, s});

            w_h{t, s, i} = ceil(w_e / sum(w_e) * sum(w{t, s}));

            w_r{t, s, i} = Random_Attack(w{t, s}, n, Max_Len);

            w_n{t, s, i} = Naive_Attack(w{t, s}, n, theta_target{t, s, i}, Max_Len);

            w_p{t, s, i} = Pobabilistic_Attack(w{t, s}, n, theta_target{t, s, i}, Max_Len, 0.75);

            % Ranking with Poisoned Data
            theta_attack{t, s, i} = Spectral_Ranking(w_h{t, s, i}, n);
            ranking_attack{t, s, i} = score_to_ranking(theta_attack{t, s, i});
            score{t, s, i} = eval_ranking(tmp, ranking_attack{t, s, i}');

            theta_r{t, s, i} = Spectral_Ranking(w_r{t, s, i}, n);
            ranking_r{t, s, i} = score_to_ranking(theta_r{t, s, i});
            score_r{t, s, i} = eval_ranking(tmp, ranking_r{t, s, i}');

            theta_n{t, s, i} = Spectral_Ranking(w_n{t, s, i}, n);
            ranking_n{t, s, i} = score_to_ranking(theta_n{t, s, i});
            score_n{t, s, i} = eval_ranking(tmp, ranking_n{t, s, i}');

            theta_p{t, s, i} = Spectral_Ranking(w_p{t, s, i}, n);
            ranking_p{t, s, i} = score_to_ranking(theta_p{t, s, i});
            score_p{t, s, i} = eval_ranking(tmp, ranking_p{t, s, i}');
        end
    end
end