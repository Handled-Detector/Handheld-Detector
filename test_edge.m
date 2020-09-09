load('svd_econ.mat');
s_1 = zeros(320,320);
for i = 1:160
   s_1(i,i) = 1 / S(i,i);
end
% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%�������������õı���result%ά������Ϊĳ�Ƕ��´洢��ͼ��xita��phi,��Ϊ21��

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
        
        %����ǰͶӰ
        image=zeros(181,360);
        [square_local_image,square_info] = square_random_image();
        image(29 + theta - square_info(2):29 + theta + square_info(2),29 + phi - square_info(1):29 + phi + square_info(1))=square_local_image;
        %����ÿ�����ɵ����Դͼ��
        result_local_mlem_edge_gauss_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD��ǰͶӰҲ����,��������
        proj = add_noise(proj);
        svd_re_f = V * s_1 * U'* proj;
        
        proj=reshape(proj,[320,1]);
        %sm1ΪС����
        %�汾2.0�н�С�����Ϊ��߿�Ϊ�޶ȵľ���
        svd_re_f = reshape(svd_re_f,[181,360]);
        %����ȡ������ȡedge
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
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_gauss_edge.mat','result_local_mlem_gauss_edge') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_edge_gauss_image.mat','result_local_mlem_edge_gauss_image') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\test_edge\result_local_mlem_gauss_svd.mat','result_local_mlem_gauss_svd') 
