clear all;
close all;
% �����ͼƬҪ����n*tile_size-��n-1��overlap_size=width&height
% ����ͼƬ���ڵ�·��
image_path = 'D:\code\';

% �������
width = 2000;  % ͼ����
height = 5000;  % ͼ��߶�
tile_size = 500; % ��ֺ�Сͼ��Ĵ�С
overlap_size = 250;% �ص���С
eledge = 225;% ȥ���ı�Ե��С����ʵ���ص�����ֻ��overlap_size-eledge

% ��ȡָ��·���µ�����ͼƬ�ļ�
image_files = dir(fullfile(image_path, '*.png'));

% ���ļ����洢��һ���ַ���������
file_names = {image_files.name}';

% ʹ��������ʽ��ȡ�ļ����е�����
file_numbers = regexp(file_names, '\d+', 'match');

% ���ļ���������������
[~, sorted_indices] = sortrows(cellfun(@(x) str2double(x{1}), file_numbers));

% ����������������ȡ�ź�����ļ���
file_names = file_names(sorted_indices);
n_images = length(image_files);

% �����ֺ�Сͼ���������
num_tiles_row = uint16((height-overlap_size)/overlap_size);
num_tiles_col = uint16((width-overlap_size)/overlap_size);

% ��ʼ����ͼ��
result = uint8(zeros(height, width));
result1 = uint8(zeros(height, width));
top_row = 1;
bottom_row = tile_size;
n=1;
% ƴ��Сͼ��
for i = 1:num_tiles_row
    % ���������Ҳ಻�ص����ص��Ĳ���
    for j = 1:num_tiles_col
        % ��ȡСͼ��
        tile_name=file_names{sorted_indices(n)};
        path=fullfile(image_path, file_names{sorted_indices(n)});
        tile = imread(path);
        tile =rgb2gray(tile);
        n=n+1;
        left_col = 1;
        right_col = overlap_size;
        overlap_left = left_col + ((j-1)*overlap_size);
        overlap_right = right_col + ((j-1)*overlap_size);
        if j >= 2 && j ~= num_tiles_col % ��<n��
            overlapr=tile(top_row:bottom_row,(eledge+1):overlap_size);
            overlapl=double(overlapl);
            overlapr=double(overlapr);
            result(top_row:bottom_row, (overlap_left+eledge):overlap_right) = ...
                uint8((0.5*overlapl)+(0.5*overlapr));
            result(top_row:bottom_row, (overlap_right+1):(overlap_right+eledge)) = ...
            tile(top_row:bottom_row,(overlap_size+1):(overlap_size+eledge));
            overlapl=tile(top_row:bottom_row,(tile_size - overlap_size + eledge)+1:tile_size) ;
        elseif j == num_tiles_col % ��n��
            overlapr=tile(top_row:bottom_row,(eledge+1):overlap_size);
            overlapl=double(overlapl);
            overlapr=double(overlapr);
            result(top_row:bottom_row, (overlap_left+eledge):overlap_right) = ...
                uint8((0.5*overlapl)+(0.5*overlapr));
            result(top_row:bottom_row, (overlap_right+1):width) = ...
                tile(top_row:bottom_row,overlap_size+1:tile_size); 
        else % ��һ��
            result(top_row:bottom_row, left_col:(right_col + eledge)) = ...
                tile(top_row:bottom_row, left_col:(tile_size - overlap_size + eledge));
            overlapl=tile(top_row:bottom_row,(tile_size - overlap_size + eledge)+1:tile_size) ;
        end   
    end
    % �����ϲ���²಻�ص����ص��Ĳ���
    if i >= 2 && i ~= num_tiles_row % ��<n��
        overlapw=result(top_row+eledge:(bottom_row-overlap_size),1:width);
        overlaps=double(overlaps);
        overlapw=double(overlapw);
        result1((top_row+(overlap_size*i)-overlap_size+eledge):(overlap_size*i),1:width)=...
            uint8(0.5*overlapw+0.5*overlaps);
        result1((overlap_size*i+1):(overlap_size*i+eledge),1:width)=...
            result((top_row+overlap_size):(tile_size-overlap_size+eledge),1:width);
        overlaps=result((top_row+overlap_size+eledge):bottom_row,1:width);  
    elseif i == num_tiles_row  % ��n��
        overlapw=result(top_row+eledge:(bottom_row-overlap_size),1:width);
        overlaps=double(overlaps);
        overlapw=double(overlapw);
        result1((top_row+(overlap_size*i)-overlap_size+eledge):(overlap_size*i),1:width)=...
            uint8(0.5*overlapw+0.5*overlaps);
        overlaps=result((top_row+overlap_size):bottom_row,1:width);
        result1(top_row+(overlap_size*i):height,1:width)=overlaps;  
    else % ��һ��
        overlaps=result((top_row+overlap_size+eledge):bottom_row,1:width);
        result1=result;
    end
    %imshow(result1);%��ʾƴ�ӹ��̣���ע��
    result = uint8(zeros(size(result)));
end

% ��ʾƴ�Ӻ�Ĵ�ͼ��
imshow(result1);
%result1 =rgb2gray(result1);%3ά��һά
a=6.918321609497070;

result1 = im2double(result1)*2-1;
denoise=result1*a;
I=mat2gray(denoise,[-1,1]);
imwrite(I,['D:\code','denoise.png']);
save(['D:\code','denoise.mat'], 'denoise');
