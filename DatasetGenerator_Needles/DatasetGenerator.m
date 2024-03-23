clear all
close all

rotate_angle = 30;
needleNumber = 360/rotate_angle;

imagelist = dir('.\image\*.png');
namelist = {imagelist.name}';
nlSize = size(namelist);

for i = 1:needleNumber
    fprintf('simulating needle %d ...', i)
    tic
    [needle_model, needle_simu] = needle_simulation(1.3125, 100, 3.2, 30*i, [0, 78]);
    toc
    for j = 1:nlSize(1)
        fprintf('loading and processing picture %d ...', j)
        tic
        fig = imread(['.\image\', char(namelist(j))]);
        fig = rgb2gray(fig);
        fig = rescale(fig, 0, 1.5);
        toc

        fprintf('multiplying and saving test and label %d (%d, %d)...', (i-1)*nlSize(1) + j, i, j)
        tic
        test = fig .* needle_simu;
        imwrite(test, ['.\dataset\test\', num2str((i-1)*nlSize(1) + j), '.png'])
        imwrite(needle_model, ['.\dataset\label\', num2str((i-1)*nlSize(1) + j), '.png'])
        toc

        clear fig
    end

    clear needle_model needle_simu
end

