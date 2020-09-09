%�������
function[result] = add_noise(Proj)
%����Ϊһά�ľ����������
Replicates=1;
Nmean=sum(Proj)*0.01*3.7e10*10;%��ʾ0.01���10���ӵ�����
calib=Nmean/sum(Proj);
Noise_Proj=zeros(length(Proj),1);
for n=1:length(Proj)
    y1=calib*Proj(n);
    Noise_Proj(n)=poissrnd(y1*ones(1,Replicates))/calib;
end

result = Noise_Proj;
end
