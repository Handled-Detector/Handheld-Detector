
%这段代码进行辐射源定位仪的MLEM重建



%读入系统传输矩阵
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%这里需要自己定义一个存储计算结果的路径
%pth='D:\大三下';


%选择要重建的角度，如果测试单个角度，取一个值就可以
%此处为了配合下面代码只把长度表示出来
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
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%创建储存结果所用的变量result%维度依次为某角度下存储的图像、xita、phi,分为21份

result_local_mlem = zeros(61,61,9,21);
result_local_mlem_order = zeros(6,9,21);%记录取的local_mlem的四角和方块大小
result_local_mlem_image = zeros(181,360,9,21);
result_local_mlem_edge = zeros(181,360,9,21);

for i=1:length(theta_value)
    %disp(i)
    for j=1:length(phi_value)
        %disp(i)
        %disp(j)
        theta=theta_value(i);
        phi=phi_value(j);
        
        %生成前投影
        image=zeros(181,360);
        [square_local_image,square_info] = square_random_image();
        image(29 + theta - square_info(2):29 + theta + square_info(2),29 + phi - square_info(1):29 + phi + square_info(1))=square_local_image;
        %保存每次生成的随机源图像
        result_local_mlem_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD的前投影也在这,有噪声的
        
        proj=reshape(proj,[320,1]);
        proj = add_noise(proj);
        
        svd_re_f = V * s_1 * U'* proj;
        
        %判定有几个源
        %judge
        %版本2.0中将小矩阵改为半高宽为限度的矩阵
        tic;
        range_box = m_box_ss2(svd_re_f);
        toc;
        
        
        disp(range_box)
        %disp(range_box);
        %disp(m_box(svd_re_f));
        %sm1为小矩阵
        sm1 = sm_3d(1:320,range_box(1):range_box(2),range_box(3):range_box(4));
        sm1 = reshape(sm1,[320,range_box(5) * range_box(6)]);
        %开始MLEM迭代重建
        recon = ones(size(sm1,2),1); %这是设置迭代的初始值，记得把这个改成SVD重建的结果试试
        
        t1 = clock;
        for k = 1:50000 %迭代次数需要根据重建允许时间调整
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%这个是判断迭代是否收敛
%                  break
%             end
            recon=recon1;
            t2 = clock;
            %做重建时间的调整，预计在一秒钟内
            if etime(t2,t1) > 0.001
                disp(k)
                break
            end
        end
        
        recon_mlem = reshape(recon,[range_box(5),range_box(6)]);
        
        result_local_mlem(1:range_box(5),1:range_box(6),i,j) = recon_mlem;
        result_local_mlem_order(:,i,j) = range_box;

        

    end
    
end

save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem.mat','result_local_mlem') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem_order.mat','result_local_mlem_order') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem_image.mat','result_local_mlem_image')


