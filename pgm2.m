%%%%菲涅尔全息图再现
clc; clear; close all;

%%设定单位
cm=0.01;
mm=0.001;
um=1e-6;

%%预设参数

%传输距离
d=600*mm;


%波长波数
lambda=0.532*um;
k=2*pi/lambda;

%全息图分辨率
M=1024;
N=1024;

%物平面大小
hx=0.7*cm;
hy=0.7*cm;

%全息图路径
img='hologram_300.bmp';
%再现图路径
img_rout=['./rout_',img];
%%中间参数处理

%原始坐标
x=-M/2:1:M/2-1;
y=-N/2:1:N/2-1;

%物平面采样点步长
dhx=hx/M;
dhy=hy/N;

%物、像平面采样点x、y坐标矩阵
x0=ones(N).*x*dhx;
y0=ones(N).*y'*dhy;

%读取图像信息
pic_1=imread(img);
pic_1=mat2gray(pic_1);
%显示原始图
figure(1);
imshow(pic_1);

%物光(全息图像平面光强分布)Eo
Eo=ifft2(fft2(pic_1,N,M).*1);

%记录物光，供之后消除共轭像用
Eo0=Eo;

%参考光
%与x向夹角
xtheta=0;
%与y向夹角
ytheta=0;
%相位分布
Er=exp(-1i*k*d-1i*k*sin(xtheta).*(x0)-1i*k*sin(ytheta).*(y0));

%再现光,采用共轭光
%Er2=conj(Er);
%再现光照射
%Eo=Eo.*Er2;

%消除零级像和共轭像
%Eo=Eo-(abs(Eo0).^2+1).*Er2-Eo0.*conj(Er).*Er2;

%再现光,采用原光
Er2=Er;
%再现光照射
Eo=Eo.*Er2;

%消除零级像和共轭像
%Eo=Eo-(abs(Eo0).^2+1).*Er2-conj(Eo0).*Er.*Er2;
%反向成像
d=-d;

%像平面接收光复振幅
Eg=fftshift(ifft2(fftshift(Eo.*exp(1i*pi/lambda/d*(x0.^2+y0.^2))))).*exp(1i*pi/lambda/d.*(x0.^2+y0.^2))./(1i*lambda*d);
%像平面光强
Eg=abs(Eg).^2;

%再现像输出
pic_3=mat2gray(Eg);
%增强亮度（光强）
%pic_3=20.*pic_3;
imwrite(pic_3,img_rout);
figure(3);
imshow(pic_3);
%title("再现图");
