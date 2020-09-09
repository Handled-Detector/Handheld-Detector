%这段代码进行辐射源定位仪的MLEM重建
%为多源版本的
%跑完后不需要joint_image再缝合图像了


%读入系统传输矩阵
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%这里需要自己定义一个存储计算结果的路径
%pth='D:\大三下';


%选择要重建的角度，如果测试单个角度，取一个值就可以
theta_value=1:15:121;
phi_value=1:15:301;

% theta_value = [90];
% phi_value = [180];

%进行svd重建
% image_f = zeros(181,360);
% image_f(theta_value+1,phi_value) = 1;
% image_f = reshape(image_f,[181*360,1]);
load('svd_econ.mat');
s_1 = zeros(320,320);

for i = 1:130
   s_1(i,i) = 1 / S(i,i);
end

% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%创建储存结果所用的变量result%维度依次为某角度下存储的图像、xita、phi,分为21份

result_local_mlem_order = zeros(6,10,9,21);%记录取的local_mlem的四角和方块大小,单张图最多10个boxes
result_local_mlem_image = zeros(181,360,9,21);
result_local_mlem_full = zeros(181,360,9,21);
result_local_mlem_full_gauss = zeros(181,360,9,21);

for i=1:length(theta_value)
    %disp(i)
    for j=1:length(phi_value)
        %disp(i)
        %disp(j)
        
        t0 = clock;
        
        theta=theta_value(i);
        phi=phi_value(j); 
        
        %生成前投影
        t1 = clock;
        
        [image] = square_random_multi_image();
        
        %保存每次生成的随机源图像
        result_local_mlem_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD的前投影也在这,有噪声的
        
        proj=reshape(proj,[320,1]);
        proj = add_noise(proj);
        t2 = clock;
        
        svd_re_f = V * s_1 * U'* proj;
        
        %判定有几个源
        %judge
        %版本4中改为多源提取
        %tic;
        range_box = m_box_e4(svd_re_f);
        %toc;
        
        
        %disp(range_box)
        
        %disp(m_box(svd_re_f));
        
        %sm1为小矩阵
        sm1 = joint_boxes(range_box,sm_3d);
        
        %开始MLEM迭代重建
        recon = ones(size(sm1,2),1); %这是设置迭代的初始值，记得把这个改成SVD重建的结果试试
        
        t3 = clock;
        for k = 1:50000 %迭代次数需要根据重建允许时间调整
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%这个是判断迭代是否收敛
%                  break
%             end
            recon=recon1;
            t4 = clock;
            %做重建时间的调整，预计在一秒钟内
            if etime(t4,t3) > 1
                %disp(k)
                break
            end
        end
        t5 = clock;
        
        sprintf('%d  %d  %d  ',etime(t5,t0) - etime(t2,t1),etime(t4,t3),etime(t3,t2))
        %进行图像拼接
        recon_mlem_full = joint_recon_image(recon,range_box);
        %进行图像后处理，模糊
        gauss_recon_mlem_full = after_gauss_image(recon_mlem_full,[10,20],2);
        
        
        
        result_local_mlem_full(:,:,i,j) =  recon_mlem_full;
        result_local_mlem_full_gauss(:,:,i,j) =  gauss_recon_mlem_full;
        result_local_mlem_order(:,1:size(range_box,2),i,j) = range_box;

        
        %break;
    end
    %break;
end

save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\覆盖非叠加\后处理\result_local_mlem_full.mat','result_local_mlem_full') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\覆盖非叠加\后处理\result_local_mlem_order.mat','result_local_mlem_order') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\覆盖非叠加\后处理\result_local_mlem_image.mat','result_local_mlem_image')
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\覆盖非叠加\后处理\result_local_mlem_full_gauss.mat','result_local_mlem_full_gauss')

