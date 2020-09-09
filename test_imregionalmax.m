load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
load('svd_econ.mat');

s_1 = zeros(320,320);
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
%mask = floor(rand(181,360)*100);
image=zeros(181,360);
image(35:45,35:45) = ones(11,11);
image(80:95,180:195) = ones(16,16);
image(120:135,300:310) = ones(16,11);

image=reshape(image,[181*360,1]);
proj=sm * image;
%SVD��ǰͶӰҲ����,��������
proj=reshape(proj,[320,1]);
proj = add_noise(proj);

svd_re_f = V * s_1 * U'* proj;
svd_re_f = reshape(svd_re_f,[181,360]);

w=fspecial('gaussian',[181 360],60);    
svd_re_f_gauss=imfilter(svd_re_f,w); 

w2=fspecial('gaussian',[30 30],30); %ע�������gaussģ���Ĳ�������ȡ̫С   
image=imfilter(svd_re_f,w2); 
image = edge(image,'sobel');%imageΪ����ͼ��
imagesc(image)


tic;
a = imregionalmax(svd_re_f_gauss);
toc;
%imagesc(a)