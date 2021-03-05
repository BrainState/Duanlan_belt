function X = matWaveLgCoeff( data )
%MATWAVECOEFF Summary of this function goes here
%   Detailed explanation goes here
coeff=data-data;
for i=size(data,1):-1:1
    coeff(i,:)=perform_wavelet_transform(data(i,:),4,1);
end
len=size(coeff,2);
r=size(coeff,1);

a=2.^(4:-1:1);
startI=round(len./a);
endI=startI*2-2;
endI(end)=len;
X=zeros(8*size(coeff,1),1);

for j=1:4    
    b=sort(coeff(:,startI(j)+1:endI(j)),2,'descend');
    c=b(:,1:2);
    X(2*r*(j-1)+1:2*r*j)=c(:);
end
end

