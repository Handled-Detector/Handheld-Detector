load('svd_econ.mat');
s_1 = zeros(320,320);
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%创建储存结果所用的变量result%维度依次为某角度下存储的图像、xita、phi,分为21份

result_local_mlem_gauss_edge = zeros(181,360,9,21);
result_local_mlem_edge_gauss_image = zeros(181,360,9,21);
result_local_mlem_gauss_svd = zeros(181,360,9,21);


theta_value=1:15:121;
phi_value=1:15:301;


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
        result_local_mlem_edge_gauss_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD的前投影也在这,有噪声的
        proj = add_noise(proj);
        svd_re_f = V * s_1 * U'* proj;
        
        proj=reshape(proj,[320,1]);
        %sm1为小矩阵
        %版本2.0中将小矩阵改为半高宽为限度的矩阵
        svd_re_f = reshape(svd_re_f,[181,360]);
        %尝试取反后再取edge
        [xita,phi]=find(svd_re_f==max(max(svd_re_f)));
        svd_re_f =  svd_re_f(xita,phi)*ones(181,360)- svd_re_f;
        
        w=fspecial('gaussian',[10 20],1);
        tic;
        svd_re_f=imfilter(svd_re_f,w);    
        w2=fspecial('prewitt');
        %svd_re_f=imfilter(svd_re_f,w2);
        edge_image = edge(svd_re_f,'sobel');
        toc;
        result_local_mlem_gauss_svd(:,:,i,j) = svd_re_f;
        %[x,y]=find(svd_re_f==max(max(svd_re_f)));
        %disp(x);
        %disp(y);
        
        
        result_local_mlem_gauss_edge(:,:,i,j) = edge_image;
    end
end
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_gauss_edge.mat','result_local_mlem_gauss_edge') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_edge_gauss_image.mat','result_local_mlem_edge_gauss_image') 
save('D:\大三下小学期\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_gauss_svd.mat','result_local_mlem_gauss_svd') 
