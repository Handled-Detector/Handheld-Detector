function [result] = joint_boxes(range_box,sm_3d)
%�ú�������Ϊ���и��box�ķ�Χ�����Ϊ�и�õ�ϵͳ����
len = size(range_box,2);
if len == 1
    sm1 = sm_3d(1:320,range_box(1):range_box(2),range_box(3):range_box(4));
    sm2 = reshape(sm1,[320,range_box(5) * range_box(6)]);
else
    for i = 1 : len
        sm1 = sm_3d(1:320,range_box(1,i):range_box(2,i),range_box(3,i):range_box(4,i));
        sm1 = reshape(sm1,[320,range_box(5,i) * range_box(6,i)]);
        if i == 1
            sm2 = sm1;
        else
            sm2(:,end+1:end+size(sm1,2)) = sm1;
        end
    end
end
result = sm2;

