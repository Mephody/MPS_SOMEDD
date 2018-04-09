clc
clear

%Simple image comparator. Not even a neural network.


load('data.mat');
N = 1000;
K = 9000;

cor = 0;

b_pic = data.test.inputs;
b_ans = data.test.targets;

a_pic = data.training.inputs;
a_ans = data.training.targets;


for i = 1:N
    
    y = sum((repmat(b_pic(:,i),1,N)-a_pic).^2);
    [~,ind] = min(y);

    if(all(a_ans(:,ind) == b_ans(:,i)))
       cor=cor+1;
    else
%        Uncomment this if you want to see similar images.
%        Otherwise this'll print an percent of images, that were recognized
%        correctly.
%        figure;
%        subplot(1,2,1);
%        pcolor(reshape(a_pic(:, ind),16,16)); colormap('gray');
%        subplot(1,2,2);
%        pcolor(reshape(b_pic(:, i),16,16)); colormap('gray');

    end
    
    
end
formatSpec = '%4.2f %% \n';
    fprintf(formatSpec, cor*100/N)
%pcolor(reshape(data.test.inputs(:, 1),16,16)); color('gray');



