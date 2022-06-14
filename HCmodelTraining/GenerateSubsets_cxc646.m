function [tra, tes] = GenerateSubsets_cxc646(method,data_set,data_labels,shuffle,n)
% tra, tes  are the idicies used to create train/test set
% X_train of n-th fold = data_set[tra{n},:]
% Nargin
if nargin < 4
    shuffle = 1;
end
if nargin < 5
    n = 3; % 3-fold cross-validation
end
tra = cell(n,1);
tes = cell(n,1);

% Check input size
[row,~] = size(data_set);
[row_y,cols_y] = size(data_labels);
if row ~= row_y
    error('Data set must have same number of samples with coresponding label')
elseif cols_y ~= 1
    error('Label input must be in the shape of m by 1 ')
end
% If shuffle is on
if shuffle
    idx = randperm(row);
else
    idx = 1:rows;
end

switch method
    case 'nFold'
        index_arr = [1:n].*round(row./n);
        index_arr(end) = row;
        start_pos = 1;
        end_pos = index_arr(1);
        count = 2;
        for i = 1:n
            tes{i} = idx(start_pos:end_pos);
            tra{i}= idx(setdiff(1:row,start_pos:end_pos,'stable'));
            start_pos = end_pos+1;
            end_pos = index_arr(min(count,length(index_arr)));
            count = count + 1;
        end
        
        
end
end