function [needle_model, needle_sim] = needle_simulation(pixel_size, length, diameter, angle, shift)

%TODO:resolution问题

%parameters
Nmodel = 256;
Nacq = 256;
readoutDirection = 'z';
echoTime = 3;
samplingInterval = 2;

radius = diameter/2;
radius_pixel = radius/pixel_size;
length_pixel = length/pixel_size;

% Create a cylindrical mask
[x,y,z] = meshgrid(linspace(-1,1,Nmodel),linspace(-1,1,Nmodel),linspace(-1,1,Nmodel));
cylinderMask = sqrt(x.^2 + y.^2) < (2/256)*radius_pixel & abs(z) <= (2/256)*length_pixel/2;

% Create simulation model: Density 1 in background, density 0 inside cylinder
model = struct();
model.protonDensity = ones(Nmodel,Nmodel,Nmodel);
model.protonDensity(cylinderMask) = 0;

susWater = -9e-6;
susTitanium = 100e-6;

susceptibility = susWater * ones(Nmodel,Nmodel,Nmodel);
susceptibility(cylinderMask) = susTitanium;

% Calculate susceptibility relative to background susceptibility to avoid boundary artifacts
susceptibility = susceptibility - susWater;

model.resolution = [Nacq/Nmodel Nacq/Nmodel Nacq/Nmodel];
model.deltaB0 = calculateFieldShift(susceptibility, model.resolution);

% Acquisition parameters
acquisition = struct();
acquisition.kspaceSamplingTimes = calculateCartesianSamplingTimes('gradientecho', [Nacq Nacq Nacq], readoutDirection, echoTime, samplingInterval);
acquisition.resolution = [1 1 1];

% Model shift & rotate
rawmodel = rot90(squeeze(model.protonDensity(:,fftCenter(Nmodel),:)),-1);
modelS = imcomplement(rawmodel);
modelS = imtranslate(modelS, shift);
modelSR = imrotate(modelS, angle, 'bilinear','crop');
modelSR = imcomplement(modelSR);
modelSR = rescale(modelSR, 0, 1.5);

% Simulation
%% Vertical_Central
kspace = forecast(model, acquisition);
image = ifftc(kspace);
rawimage = rot90(abs(squeeze(image(:,fftCenter(Nacq),:))), -1);
%% Shift & Rotate
imageS = imcomplement(rawimage);
imageS = imtranslate(imageS, shift);
imageSR = imrotate(imageS, angle, 'bilinear','crop');
imageSR = imcomplement(imageSR);
imageSR = rescale(imageSR, 0, 1.5);

needle_model = modelSR;
needle_sim = imageSR; 
end




