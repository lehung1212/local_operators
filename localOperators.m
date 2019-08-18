%% CSC 262 Lab: Local Operator
%% Overview:
% In this lab, we explore local pixel operations including gamma, bias, 
% and gain adjustments. We also aquaint outselves with histogram 
% equalization.

% Clear all previously loaded variables
clearvars;

%Our Image:
%load the demo image as img_cman
img_cman = imread('cameraman.tif');

%create the double version of the image
dimg_cman = im2double(img_cman);
%figure(4);
%imshow(dimg_cman);
%figure(2);


%% Gamma corrected, Bias altered, and Gain altered images and observations (A.4, A.6, and A.8)
% our gamma corrected image has higher brightness than the orginal image 
% while our gain adjusted image has higher contrast with gain value of 2. 
% Our bias altered image has bias value 0.25 and is brighter that the
% original image.

%create gamma corrected image using equation 3.7 in Szeliski
gc_dimg_cman = dimg_cman .^ (1/2.2);

%creat bias altered image using equation 3.3 in Szeliski with bias value
%0.25
ba_dimg_cman = (1 * dimg_cman) + 0.25;

%create gain adjusted image using equation 3.3 in Szeliski with gain of 2
ga_dimg_cman = (2 * dimg_cman) + 0.0;

%display all three images in the same figure for compare and contrast.
figure(1)
subplot (2, 2, 1), imshow(dimg_cman);
title("original image");
subplot (2, 2, 2), imshow(gc_dimg_cman);
title("gamma corrected image");
subplot(2, 2, 3), imshow(ba_dimg_cman);
title("bias altered image");
subplot(2, 2, 4), imshow(ga_dimg_cman);
title("gain altered image");


%% Histogram of our image (B.7)

figure(4);
%Create histogram of the image using 0-255 as the bins, assigned it to a
%variable Xhist for 
Xhist = hist(double(img_cman(:)), 0:255);
%graph a bar chart of the values in Xhist
bar(0:255, Xhist);
%label the barchart accordingly
xlabel("Brightness Level");
ylabel("Pixel Count");
title("Image Brightness Bar Chart");


%% Observation from the histogram (B.8)
% the brightness level with the most pixel count is 14 (count 1685).
% we would observe the most significant detail improvement in the ranges
% 0-20 and 160-170 as they have the highest pixel density with similar
% brightness.

%Image mapping:
squareImg = zeros(128,'uint8');  % Black background
squareImg(32:96,32:96) = 2;      % Square
squareImg(48:80,48:80) = 1;      % Hole 


%% Plot of cumulative distribution function (D.2)

figure(5)
%calculate the cumulative distribution function from histogram count Xhist
img_cdf = cumsum(Xhist);
%plot the cdf against brightness
plot(0:255, cumsum(Xhist)/274.5);
%lable the cdf plot accordingly
xlabel("Brightness Level");
ylabel("Cumulative Sum");
title("Cumulative Distribution of Image Brightness");

%% Explanation of transfer function (D.3)
% regions with steep slopes are 0 to 20 and 160 to 185. These regions
% correspond to the parts of the histograms with high pixel count. The
% diagonal region is from 100 to 160, and the other regions have
% approximately near horizontal slopes. When we use the CDF as a transfer
% function, we expect an increase in brightness from 10 to 60, and from 160
% to 240. We also expect a decrease in brightness from the remaining
% ranges. We normalized the distribution of cumsum to maximum value of 255,
% and plot it against a diagonal line to obtain this result.

%% Histogram-equalized image and observations (D.8)
% after we histogram-equalized the image, the image intensity is adjusted 
% such that the contrast of the image is significantly higher. We can see
% details in the man's coat that is invisible in the original image. 
figure(6)

%normalize our cdf to maximum value of 255 by dividing every point 
%by the largest value in the distribution over 255.
img_scdf = img_cdf/(max(img_cdf/255)); %257.003921569;

%cast the values using conversion function uint8
map_two = uint8(img_scdf);

%create image that has undergone histogram equalization
new_img = map_two(double(img_cman)+1);

%display the equalized image
imshow(new_img);

%displat original image for comparision
imshow(img_cman);

%% Histogram and observations (D.9)
% the histogram of the new image is much flatter than that of the old one.
% While the overall features is unchanged, the distribution is much more
% even, less clumped into large peaks. The cumulative distribution function
% also has the interesting feature of being almost diagonal. 
figure(7)
%create and display the histogram for the newly equalized image
new_hist = hist(double(new_img(:)), 0:255);
new_bar = bar(0:255, new_hist);
new_bar;
xlabel("Brightness Level");
ylabel("Pixel Counts");
title("Histogram Of the New Image")

%create and display the cumulative distribution function for the equalized
%image.
figure(8)
plot(0:255, cumsum(new_hist));
xlabel("Brightness Level");
ylabel("Cumulative Sum");
title("Cumulative Distribution of the New Image Brightness");

%% Conclusion
% We found that histogram equalization is a method that can be used to
% enhance an image's contrast. It brings the histogram of the image closer
% to that of a flat image. We also learn a method to create an image
% histogram using the functions available in Matlab. Finally, we observed
% diffrent image alteration techniques and understand their behaviors.

%% Acknowledgements
% We referenced the houghlab.m script by Professor Jerod Weinman 
% as well as our own imageFormationLab.m  to format our lab report properly. 