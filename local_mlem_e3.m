%��δ�����з���Դ��λ�ǵ�MLEM�ؽ�
%Ϊ��Դ�汾��
%�������Ҫjoint_image�ٷ��ͼ����


%����ϵͳ�������
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%������Ҫ�Լ�����һ���洢��������·��
%pth='D:\������';


%ѡ��Ҫ�ؽ��ĽǶȣ�������Ե����Ƕȣ�ȡһ��ֵ�Ϳ���
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

for i = 1:130
   s_1(i,i) = 1 / S(i,i);
end

% svd_p = sm * image_f;
% svd_re_f = V * s_1 * U'* svd_p ;

%�������������õı���result%ά������Ϊĳ�Ƕ��´洢��ͼ��xita��phi,��Ϊ21��

result_local_mlem_order = zeros(6,10,9,21);%��¼ȡ��local_mlem���ĽǺͷ����С,����ͼ���10��boxes
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
        
        %����ǰͶӰ
        t1 = clock;
        
        [image] = square_random_multi_image();
        
        %����ÿ�����ɵ����Դͼ��
        result_local_mlem_image(:,:,i,j) = image;
        %
        
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD��ǰͶӰҲ����,��������
        
        proj=reshape(proj,[320,1]);
        proj = add_noise(proj);
        t2 = clock;
        
        svd_re_f = V * s_1 * U'* proj;
        
        %�ж��м���Դ
        %judge
        %�汾4�и�Ϊ��Դ��ȡ
        %tic;
        range_box = m_box_e4(svd_re_f);
        %toc;
        
        
        %disp(range_box)
        
        %disp(m_box(svd_re_f));
        
        %sm1ΪС����
        sm1 = joint_boxes(range_box,sm_3d);
        
        %��ʼMLEM�����ؽ�
        recon = ones(size(sm1,2),1); %�������õ����ĳ�ʼֵ���ǵð�����ĳ�SVD�ؽ��Ľ������
        
        t3 = clock;
        for k = 1:50000 %����������Ҫ�����ؽ�����ʱ�����
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%������жϵ����Ƿ�����
%                  break
%             end
            recon=recon1;
            t4 = clock;
            %���ؽ�ʱ��ĵ�����Ԥ����һ������
            if etime(t4,t3) > 1
                %disp(k)
                break
            end
        end
        t5 = clock;
        
        sprintf('%d  %d  %d  ',etime(t5,t0) - etime(t2,t1),etime(t4,t3),etime(t3,t2))
        %����ͼ��ƴ��
        recon_mlem_full = joint_recon_image(recon,range_box);
        %����ͼ�����ģ��
        gauss_recon_mlem_full = after_gauss_image(recon_mlem_full,[10,20],2);
        
        
        
        result_local_mlem_full(:,:,i,j) =  recon_mlem_full;
        result_local_mlem_full_gauss(:,:,i,j) =  gauss_recon_mlem_full;
        result_local_mlem_order(:,1:size(range_box,2),i,j) = range_box;

        
        %break;
    end
    %break;
end

save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\���Ƿǵ���\����\result_local_mlem_full.mat','result_local_mlem_full') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\���Ƿǵ���\����\result_local_mlem_order.mat','result_local_mlem_order') 
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\���Ƿǵ���\����\result_local_mlem_image.mat','result_local_mlem_image')
save('D:\������Сѧ��\SRT\0725\local_mlem_allspace\0802\box_4\box_ss2\noise\���Ƿǵ���\����\result_local_mlem_full_gauss.mat','result_local_mlem_full_gauss')

