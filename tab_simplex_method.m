format short
clear, clc, close all;

% This code is based on Dr Garg Youtube

% Example matrices A, b, and c
Noofvariables = 3; % This define x1, x2 and x3
c = [-25 -7 -24];
info = [3 1 -5; -5 1 3];
b = [8; 5];
s = eye(size(info,1));

% A = [-2, 1, 1, 0; 1, 1, 0, 1];
% b = [2; 3];
% c = [-1; -2; 0; 0];


A = [info s b];

Cost = zeros(1,size(A,2));
Cost(1:Noofvariables) = c;

% Basic variables
BV = Noofvariables + 1:1:size(A,2)-1;

% Calculate zj-cj row
zjcj = Cost(BV) * A - Cost;

% For print table
zcj = [zjcj;A];
simpleTable = array2table(zcj);
simpleTable.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','x_3','s_1','s_2','sol'}

% Simplex Table Start
RUN = true;
while RUN

if any(zjcj < 0);
    fprintf(' The Current BFS is not Optimal \n')
    fprintf('\n ======== The Next Iteration Result =========== \n')

    display('Old Basic Variable (BV) = ');
    display(BV);

    %% Find the entering variable
    zc = zjcj(1:end-1);
    [EnterCol, pvt_col] = min(zc);
    fprintf(' The Minimum Element in zj-cj row is %d Corresponding to column %d\n', EnterCol, pvt_col);
    fprintf('Entering Variable is %d\n ', pvt_col);

    %% Finding the leaving variable
    sol = A(:, end);
    Column = A(:, pvt_col);
    if all(Column <= 0)
            error('LPP is UNBOUNDED. All entries <= 0 in column %d', pvt_col)
    else
        
    for i = 1:size(Column,1)
        if Column(i) > 0
            ratio(i) = sol(i)./Column(i);
        else 
            ratio(i) = inf;
        end 
    end
        %% Finding the Minimum
        [MinRatio, pvt_row] = min(ratio);
        fprintf('Minimum ratio corresponding to Pivot row is %d', pvt_row);
        fprintf('Leaving variable is %d', BV(pvt_row));
    end
    
    BV(pvt_row) = pvt_col;
 display('New Basic Variable (BV) = ');
 display(BV);

 %% Pivot Key
 pvt_key = A(pvt_row, pvt_col);

 % Update the Table for the Next Iteration
 A(pvt_row, :) = A(pvt_row,:)./pvt_key;

 for i = 1:size(A,1)
     if i ~=pvt_row
         A(i,:) = A(i,:) - A(i, pvt_col).*A(pvt_row, :);
     end
 end
 
 zjcj = zjcj - zjcj(pvt_col).*A(pvt_row,:);
     
 % For print table
 zcj = [zjcj;A];
 simpleTable = array2table(zcj);
 simpleTable.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','x_3','s_1','s_2','s_3','sol'}

BFS = zeros(1, size(A,2));
BFS(BV) = A(:, end);
BFS(end) = sum(BFS.* Cost);
Current_BFS = array2table(BFS);
Current_BFS.Properties.VariableNames(1:size(Current_BFS,2)) = {'x_1','x_2','x_3','s_1','s_2','s_3','sol'}

else
    RUN= false;
    fprintf('======================================= \n')
    fprintf(' The Current BFS is Optimal \n')
    fprintf('======================================= \n')
end

end
