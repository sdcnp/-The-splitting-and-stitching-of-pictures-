clear all;
close all;
% 输入的图片要求是n*tile_size-（n-1）overlap_size=width&height
% 输入图片所在的路径
image_path = 'D:\code';

% 输入参数
width = 1000;  % 图像宽度
height = 2000;  % 图像高度
tile_size = 500; % 拆分后小图像的大小
overlap_size = 250;% 重叠大小
eledge = 225;% 去除的边缘大小，既实际重叠部分只有overlap_size-eledge

% 获取指定路径下的所有图片文件
image_files = dir(fullfile(image_path, '*.mat'));

% 将文件名存储在一个字符串数组中
file_names = {image_files.name}';

% 使用正则表达式获取文件名中的数字
file_numbers = regexp(file_names, '\d+', 'match');

% 将文件名按照数字排序
[~, sorted_indices] = sortrows(cellfun(@(x) str2double(x{1}), file_numbers));

% 按照排序后的索引获取排好序的文件名
file_names = file_names(sorted_indices);
n_images = length(image_files);

% 计算拆分后小图像的行列数
num_tiles_row = uint16((height-overlap_size)/overlap_size);
num_tiles_col = uint16((width-overlap_size)/overlap_size);

% 初始化大图像
result = zeros(height, width);
result1 = zeros(height, width);
top_row = 1;
bottom_row = tile_size;
n=1;
% 拼接小图像
for i = 1:num_tiles_row
    % 计算左侧和右侧不重叠和重叠的部分
    for j = 1:num_tiles_col
        % 读取小图像
        tile_name=file_names{sorted_indices(n)};
        path=fullfile(image_path, file_names{sorted_indices(n)});
        tile = load(path);
        tile=tile.data;
        %tile=double(tile);
        n=n+1;
        left_col = 1;
        right_col = overlap_size;
        overlap_left = left_col + ((j-1)*overlap_size);
        overlap_right = right_col + ((j-1)*overlap_size);
        if j >= 2 && j ~= num_tiles_col % 第<n列
            overlapr=tile(top_row:bottom_row,(eledge+1):overlap_size);

            result(top_row:bottom_row, (overlap_left+eledge):overlap_right) = ...
                ((0.5*overlapl)+(0.5*overlapr));
            result(top_row:bottom_row, (overlap_right+1):(overlap_right+eledge)) = ...
            tile(top_row:bottom_row,(overlap_size+1):(overlap_size+eledge));
            overlapl=tile(top_row:bottom_row,(tile_size - overlap_size + eledge)+1:tile_size) ;
        elseif j == num_tiles_col % 第n列
            overlapr=tile(top_row:bottom_row,(eledge+1):overlap_size);

            result(top_row:bottom_row, (overlap_left+eledge):overlap_right) = ...
                ((0.5*overlapl)+(0.5*overlapr));
            result(top_row:bottom_row, (overlap_right+1):width) = ...
                tile(top_row:bottom_row,overlap_size+1:tile_size); 
        else % 第一列
            result(top_row:bottom_row, left_col:(right_col + eledge)) = ...
                tile(top_row:bottom_row, left_col:(tile_size - overlap_size + eledge));
            overlapl=tile(top_row:bottom_row,(tile_size - overlap_size + eledge)+1:tile_size) ;
        end   
    end
    % 计算上侧和下侧不重叠和重叠的部分
    if i >= 2 && i ~= num_tiles_row % 第<n行
        overlapw=result(top_row+eledge:(bottom_row-overlap_size),1:width);
        result1((top_row+(overlap_size*i)-overlap_size+eledge):(overlap_size*i),1:width)=...
            (0.5*overlapw+0.5*overlaps);
        result1((overlap_size*i+1):(overlap_size*i+eledge),1:width)=...
            result((top_row+overlap_size):(tile_size-overlap_size+eledge),1:width);
        overlaps=result((top_row+overlap_size+eledge):bottom_row,1:width);  
    elseif i == num_tiles_row  % 第n行
        overlapw=result(top_row+eledge:(bottom_row-overlap_size),1:width);

        result1((top_row+(overlap_size*i)-overlap_size+eledge):(overlap_size*i),1:width)=...
            (0.5*overlapw+0.5*overlaps);
        overlaps=result((top_row+overlap_size):bottom_row,1:width);
        result1(top_row+(overlap_size*i):height,1:width)=overlaps;  
    else % 第一行
        overlaps=result((top_row+overlap_size+eledge):bottom_row,1:width);
        result1=result;
    end
    %imshow(result1);%显示拼接过程，可注释
    result = zeros(size(result));
end

%result1 =rgb2gray(result1);%3维变一维
a=6.918321609497070;
denoise=result1*a;
I=mat2gray(denoise,[-1,1]);
% 显示拼接后的大图像
imshow(I);
imwrite(I,['D:\code','denoise.png']);
save(['D:\code','denoise.mat'], 'denoise');
