
%��δ�����з���Դ��λ�ǵ�MLEM�ؽ�



%����ϵͳ�������
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%������Ҫ�Լ�����һ���洢��������·��
%pth='D:\������';


%ѡ��Ҫ�ؽ��ĽǶȣ�������Ե����Ƕȣ�ȡһ��ֵ�Ϳ���
%�˴�Ϊ������������ֻ�ѳ��ȱ�ʾ����
theta_value=1:15:121;
phi_value=1:15:301;

% theta_value = [90];
% phi_value = [180];

%����svd�ؽ�
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

%�������������õı���result%ά������Ϊĳ�Ƕ��´洢��ͼ��xita��phi,��Ϊ21��

result_local_mlem = zeros(61,61,9,21);
result_local_mlem_order = zeros(6,9,21);%��¼ȡ��local_mlem���ĽǺͷ����С
result_local_mlem_image = zeros(181,360,9,21);
result_local_mlem_edge = zeros(181,360,9,21);

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
        result_local_mlem_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD��ǰͶӰҲ����,��������
        
        proj=reshape(proj,[320,1]);
        proj = add_noise(proj);
        
        svd_re_f = V * s_1 * U'* proj;
        
        %�ж��м���Դ
        %judge
        %�汾2.0�н�С�����Ϊ��߿�Ϊ�޶ȵľ���
        tic;
        range_box = m_box_ss2(svd_re_f);
        toc;
        
        
        disp(range_box)
        %disp(range_box);
        %disp(m_box(svd_re_f));
        %sm1ΪС����
        sm1 = sm_3d(1:320,range_box(1):range_box(2),range_box(3):range_box(4));
        sm1 = reshape(sm1,[320,range_box(5) * range_box(6)]);
        %��ʼMLEM�����ؽ�
        recon = ones(size(sm1,2),1); %�������õ����ĳ�ʼֵ���ǵð�����ĳ�SVD�ؽ��Ľ������
        
        t1 = clock;
        for k = 1:50000 %����������Ҫ�����ؽ�����ʱ�����
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%������жϵ����Ƿ�����
%                  break
%             end
            recon=recon1;
            t2 = clock;
            %���ؽ�ʱ��ĵ�����Ԥ����һ������
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

save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem.mat','result_local_mlem') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem_order.mat','result_local_mlem_order') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_ss2\noise\result_local_mlem_image.mat','result_local_mlem_image')


