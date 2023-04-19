
input_image = 'D:\cod\hz.png';
output_folder = 'D:\codetarget';
subimg_size = 500;
overlap_size = 250;
split_image(input_image, output_folder, subimg_size, overlap_size);


function split_image(input_image, output_folder, subimg_size, overlap_size)
    % input_image: the input image filename
    % output_folder: the output folder to save the sub-images
    % subimg_size: the size of the sub-images in pixels
    % overlap_size: the size of the overlapping region in pixels

    % Read the input image
    img = imread(input_image);

    % Compute the number of rows and columns of sub-images
    [img_height, img_width, ~] = size(img);
    num_rows = floor((img_height-overlap_size) / (subimg_size-overlap_size));
    num_cols = floor((img_width-overlap_size) / (subimg_size-overlap_size));

    % Compute the size of the sub-images
    subimg_height = subimg_size;
    subimg_width = subimg_size;

    % Compute the position of each sub-image and crop it
    count = 1;
    for i = 1:num_rows
        for j = 1:num_cols
            % Compute the position of the sub-image
            y = (i-1)*(subimg_height-overlap_size)+1;
            x = (j-1)*(subimg_width-overlap_size)+1;

            % Crop the sub-image
            subimg = img(y:min(y+subimg_height-1,img_height), x:min(x+subimg_width-1,img_width), :);

            % Save the sub-image
            if i<10 && j<10
                filename = fullfile(output_folder, sprintf('0%d-0%d.png', i, j));
            elseif i<10 && j>=10 
                filename = fullfile(output_folder, sprintf('0%d-%d.png', i, j));
            elseif i>=10 && j<10
                filename = fullfile(output_folder, sprintf('%d-0%d.png', i, j));
            else
                filename = fullfile(output_folder, sprintf('%d-%d.png', i, j));
            end
            imwrite(subimg, filename);

            count = count + 1;
        end
    end
end

