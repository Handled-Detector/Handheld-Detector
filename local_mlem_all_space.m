%clear all

%作者：胡一凡
%日期：2020.2.23
%这段代码进行辐射源定位仪的MLEM重建

%读入系统传输矩阵
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%这里需要自己定义一个存储计算结果的路径
%pth='D:\大三下';


%选择要重建的角度，如果测试单个角度，取一个值就可以
%此处为了配合下面代码只把长度表示出来
theta_value=1:1:2;
phi_value=1:1:2;

% theta_value = [90];
% phi_value = [180];

%进行svd重建
% image_f = zeros(181,360);
% image_f(theta_value+1,phi_value) = 1;
% image_f = reshape(image_f,[181*360,1]);
load('svd_econ.mat');
s_1 = zeros(320,320);
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%创建储存结果所用的变量result%维度依次为某角度下存储的图像、xita、phi,分为21份

result_local_mlem = zeros(21*21,121,301);

for i=1:length(theta_value)
    disp(i)
    for j=1:length(phi_value)
        theta=theta_value(i);
        phi=phi_value(j);
        
        %生成前投影
        image=zeros(181,360);
        image(theta+29,phi+29)=1;
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD的前投影也在这
        svd_re_f = V * s_1 * U'* proj;
        svd_re_f = reshape(svd_re_f,[181,360]);
        [x,y]=find(svd_re_f==max(max(svd_re_f)));
        disp(x);
        disp(y);
        proj=reshape(proj,[320,1]);
        %sm1为小矩阵
        sm1 = sm_3d(1:320,x-10:x+10,y-10:y+10);
        sm1 = reshape(sm1,[320,21*21]);
        %开始MLEM迭代重建
        recon = ones(size(sm1,2),1); %这是设置迭代的初始值，记得把这个改成SVD重建的结果试试
        
        
        for k = 1:50000 %迭代次数需要根据重建允许时间调整
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%这个是判断迭代是否收敛
%                  break
%             end
            recon=recon1;
        end
        
        recon_mlem = recon;
        
        result_local_mlem(:,theta,phi) = recon_mlem;

        

    end
    
end

save('result_local_mlem','result_local_mlem')        











