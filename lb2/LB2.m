% clc
% clear
% close all

% Simple linear classifier. No activation function, just k*x.

load('data');
x=data.training.inputs;
t=data.training.targets;

v_pic=data.validation.inputs;
v_ans=data.validation.targets;

k=zeros(size(t,1),size(x,1));

n_samples=size(x,2);

n_iter=10000;

alpha=0.01;
ev=zeros(1, n_iter);
e=zeros(1, n_iter);

for N=1:n_iter
    
    y=k*x;
    dy=y-t;
    
    e(N)=sum((dy(:)).^2)/n_samples;
      
    v=k*v_pic;
    dv=v-t;
    ev(N)=sum((dv(:)).^2)/n_samples;
    
    
    dk=dy*x';
    
    k=k-alpha*dk/n_samples;
    
end

title('Error:');
    plot(e)
    hold on
    plot(ev)
    hold off
title('Error:');    
legend('Educational', 'Validation');
cor =0;

z_pic=data.test.inputs;
z_ans=data.test.targets;

zy=k*z_pic;

for i = 1:1000
      [~,ind1] = max(z_ans(:,i));
	[~,ind2] = max(zy(:, i));

    if( ind1 == ind2 )
       cor=cor+1;
    end
    
end
formatSpec = 'Recognized correctly from test samples: %4.2f %% \n';
    fprintf(formatSpec, cor*100/n_samples)



    