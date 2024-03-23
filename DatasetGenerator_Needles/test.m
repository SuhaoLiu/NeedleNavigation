phantom = imread("D:\UserFiles\Slicer_WangNing&LiShiChao\AblationSurgery\AblationSurgery\AblationSurgeryWizard\test\39.png");
phantom = rgb2gray(phantom);
phantom= rescale(phantom, 0, 1.5);

[needle_model, needle_simu] = needle_simulation(1.3125, 100, 3, 30, [0, 78]);
imageWithNeedle = image_multiply(phantom, needle_simu);

figure
subplot(2, 2, 1)
imshow(needle_model)
colormap(gray(256))
axis equal

subplot(2, 2, 2)
imshow(needle_simu)
colormap(gray(256))
axis equal

subplot(2, 2, 3)
imshow(phantom)
colormap(gray(256))
axis equal

subplot(2, 2, 4)
imshow(imageWithNeedle)
colormap(gray(256))
axis equal