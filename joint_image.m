load('result_local_mlem_order.mat');
load('result_local_mlem.mat');
result_local_mlem_full = zeros(181,360,9,21);
for i  = 1:9
    for j = 1:21
        order = result_local_mlem_order(:,i,j);
        result_local_mlem_full(order(1):order(2),order(3):order(4),i,j) = result_local_mlem(1:order(5),1:order(6),i,j);
    end
end
save('result_local_mlem_full','result_local_mlem_full')