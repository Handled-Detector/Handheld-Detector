function [result] = joint_recon_image(recon,range_box)
%�ú�������Ϊ������Ľ�������Ϊȫͼ��recon_image
len = size(range_box,2);
result = zeros(181,360);
if len == 1
    range_image = range_box(5)*range_box(6);
    %���е�Դ���
    recon_one_source = reshape(recon(1:range_image),[range_box(5),range_box(6)]);
    %��Ӳ�ֵĵ�Դ��ȫͼ�У��˴�ʹ�õ�Ϊ����
    %result(range_box(1):range_box(2),range_box(3):range_box(4)) = recon_one_source + result(range_box(1):range_box(2),range_box(3):range_box(4));
    result(range_box(1):range_box(2),range_box(3):range_box(4)) = recon_one_source;
else
    for i  = 1:len
        range_image = range_box(5,i)*range_box(6,i);
        %���е�Դ���
        recon_one_source = reshape(recon(1:range_image),[range_box(5,i),range_box(6,i)]);
        %����������
        recon(1:range_image) = [];
        %��Ӳ�ֵĵ�Դ��ȫͼ��,�˴�Ϊ����
        %result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i)) = recon_one_source + result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i));
        result(range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i)) = recon_one_source;
    end




end
