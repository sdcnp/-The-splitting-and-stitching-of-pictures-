clc;
clear all;
input_mat = 'D:\code\input\hz.mat';
output_folder = 'D:\code\target';
submat_size = 500;
overlap_size = 250;

split_mat(input_mat, output_folder, submat_size, overlap_size);

function split_mat(input_mat, output_folder, submat_size, overlap_size)
    % input_mat: the input mat filename
    % output_folder: the output folder to save the sub-mat files
    % submat_size: the size of the sub-images in pixels
    % overlap_size: the size of the overlapping region in pixels

    % Load the input mat file
    mat = load(input_mat);
    % Assumes that the loaded mat file contains an image in a variable named 'mat'
    mat = mat.hz;
    %πÈ“ªªØ
    a=max(max(abs(mat)));
    mat=mat/a;

    % Compute the number of rows and columns of sub-images
    [mat_height, mat_width, ~] = size(mat);
    num_rows = floor((mat_height-overlap_size) / (submat_size-overlap_size));
    num_cols = floor((mat_width-overlap_size) / (submat_size-overlap_size));

    % Compute the size of the sub-images
    submat_height = submat_size;
    submat_width = submat_size;

    % Compute the position of each sub-image and crop it
    count = 1;
    for i = 1:num_rows
        for j = 1:num_cols
            % Compute the position of the sub-image
            y = (i-1)*(submat_height-overlap_size)+1;
            x = (j-1)*(submat_width-overlap_size)+1;

            % Crop the sub-image
            data = mat(y:min(y+submat_height-1,mat_height), x:min(x+submat_width-1,mat_width), :);

            % Save the sub-image as a mat file
            if i<10 && j<10
                filename = fullfile(output_folder, sprintf('0%d-0%d.mat', i, j));
            elseif i<10 && j>=10 
                filename = fullfile(output_folder, sprintf('0%d-%d.mat', i, j));
            elseif i>=10 && j<10
                filename = fullfile(output_folder, sprintf('%d-0%d.mat', i, j));
            else
                filename = fullfile(output_folder, sprintf('%d-%d.mat', i, j));
            end
            save(filename, 'data');

            count = count + 1;
        end
    end
end


