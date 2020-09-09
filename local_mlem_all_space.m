%clear all

%���ߣ���һ��
%���ڣ�2020.2.23
%��δ�����з���Դ��λ�ǵ�MLEM�ؽ�

%����ϵͳ�������
load('System_Matrix_MURAkeV.mat');

sm=reshape(System_Matrix,[320,65160]);
sm_3d = reshape(System_Matrix,[320,181,360]);
%������Ҫ�Լ�����һ���洢��������·��
%pth='D:\������';


%ѡ��Ҫ�ؽ��ĽǶȣ�������Ե����Ƕȣ�ȡһ��ֵ�Ϳ���
%�˴�Ϊ������������ֻ�ѳ��ȱ�ʾ����
theta_value=1:1:2;
phi_value=1:1:2;

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

result_local_mlem = zeros(21*21,121,301);

for i=1:length(theta_value)
    disp(i)
    for j=1:length(phi_value)
        theta=theta_value(i);
        phi=phi_value(j);
        
        %����ǰͶӰ
        image=zeros(181,360);
        image(theta+29,phi+29)=1;
        image=reshape(image,[181*360,1]);
        proj=sm * image;
        %SVD��ǰͶӰҲ����
        svd_re_f = V * s_1 * U'* proj;
        svd_re_f = reshape(svd_re_f,[181,360]);
        [x,y]=find(svd_re_f==max(max(svd_re_f)));
        disp(x);
        disp(y);
        proj=reshape(proj,[320,1]);
        %sm1ΪС����
        sm1 = sm_3d(1:320,x-10:x+10,y-10:y+10);
        sm1 = reshape(sm1,[320,21*21]);
        %��ʼMLEM�����ؽ�
        recon = ones(size(sm1,2),1); %�������õ����ĳ�ʼֵ���ǵð�����ĳ�SVD�ؽ��Ľ������
        
        
        for k = 1:50000 %����������Ҫ�����ؽ�����ʱ�����
            recon1 = (sm1' * (proj./(sm1 * recon  + eps) + eps)) .* recon ./(sum(sm1,1)'  + eps);
%              if (sum(abs(recon1-recon))./sum(recon))<0.00000007%������жϵ����Ƿ�����
%                  break
%             end
            recon=recon1;
        end
        
        recon_mlem = recon;
        
        result_local_mlem(:,theta,phi) = recon_mlem;

        

    end
    
end

save('result_local_mlem','result_local_mlem')        











