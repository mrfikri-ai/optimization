function [xB, optimalSolution] = simplex_method(A, b, c)

% This code applies 8 step of simplex method
% Check carefully the comment

    % Step 1: Initialize the basis and null parts
    B = A(:, 1:size(A, 1)); % Assuming the first n columns form the initial basis
    N = A(:, size(A, 1) + 1:end);
    
    % Iterative steps of the Simplex method
    while true
        % Step 2: Compute xB
        xB = B \ b;
        
        % Step 3: Compute reduced costs
        BNInverse = inv(B) * N;
        hat_c_N = c(size(B, 2) + 1:end)' - c(1:size(B, 2))' * BNInverse;
        
        % Step 4: Check optimality
        if all(hat_c_N >= 0)
            optimalSolution = [xB; zeros(size(N, 2), 1)];
            break; % Optimal solution found
        end
        
        % Step 5: Find the entering variable
        [minVal, s] = min(hat_c_N);
        
        % Step 6: Check for unboundedness
        if all(N(:, s) <= 0)
            error("The problem is unbounded.");
        end
        
        % Step 7: Compute the ratios
        hat_a_s = N(:, s);
        hat_a_s_star = inv(B) * hat_a_s;
        
        % Step 8: Find the leaving variable
        minRatio = inf;
        for j = 1:size(B, 2)
            if hat_a_s_star(j) > 0
                ratio = xB(j) / hat_a_s_star(j);
                if ratio < minRatio
                    minRatio = ratio;
                    r = j;
                end
            end
        end
        
        % Update the basis
        B(:, r) = N(:, s);
    end
end
