%第一步：抽样
image0 = imread('2019091020332421.jpg');
%转为灰度图（若已为灰度图则忽略）
%image0 = rgb2gray(image0);
image0 = im2double(image0);
M=1080;
N=1920;


%输出原图
figure;
subplot(2,2,1);
imshow(image0);
title('原图')

%加入随机位相信息
PI = 3.14159;
image1 = image0;
phase = 2i*PI*rand(M,N);
image1 = image1.*exp(phase);

%输出随机位相图
subplot(2,2,2);
imshow(image1);
title('随机位相图');

%第二步：计算编码
%第一次逆傅里叶变换
image2 = ifft2(ifftshift(image1));

%迭代过程
for t=1:1:1000
    %迭代判据
    imgangle = angle(image2);                       %取位相
    image = exp(1i*imgangle);
    image = fftshift(fft2(image));                  %还原
    imgabs = abs(image)./max(max(abs(image)));
    sim = corrcoef(image0,imgabs);                  %取相关系数
    if sim(1,2) >= 0.9995
        %满足条件，跳出循环
        break
    else
        %开始迭代
        %单位振幅
        imgangle = angle(image2);
        image2 = exp(1i*imgangle);

        %正傅里叶变换
        image3 = fftshift(fft2(image2));

        %赋反馈振幅
        imgabs = abs(image3)./max(max(abs(image3)));
        imgangle = angle(image3);
        image3 = exp(1i*imgangle);
        image3 = image3.*(image0+rand(1,1)*(image0-imgabs));

        %逆傅里叶变换
        image2 = ifft2(ifftshift(image3));
        
    end
end

%第三步：输出位相全息图
%取位相
imgangle = angle(image2);                       
image4 = exp(1i*imgangle);

%还原
image4 = fftshift(fft2(image4));                          
imgabs = abs(image4)./max(max(abs(image4)));

%存储位相全息图
imgangle = (imgangle+PI)/(2*PI);
imwrite(imgangle,'Hepburn.jpg')

%输出位相全息图
subplot(2,2,3);
imshow(imgangle);
title('位相全息图')

%输出还原图
subplot(2,2,4);
imshow(imgabs);
title('还原图')
