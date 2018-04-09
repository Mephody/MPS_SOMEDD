% One of the most complex tasks in our course. This laboratory work got more
% than a month to debug and control all processes in it. This is a simple
% dimension reduction machine. I still dont think it's working as it should,
% but i think it's something really close to result. The goal is quite simple -
% to reduce layers dimensions up to 2 and expand it back to 256.
% This NN has 6 layers (structure can be seen in next 10 rows). At first we
% educate the first and the last layers, then we educate middle layers 
% (external layers stays as they are) and, finally, we educate internal
% layers. 
% This NN also has bad entry points so be carefull with uncommenting lines
% 31 - 36. A new method of educating was examined here. We have step size
% for each individual coeffitient, so we can come to minimum of error
% function quite close.

load('data');


x=data.training.inputs;

t=x;

n_class=size(t,1);

n_hid12=256;%256 х 1000
n_hid23=32;%32 х 1000
n_hid34=2;%2 х 1000
n_hid45=32;%32 х 1000
n_hid56=256;%256 х 1000


% k1=(rand(n_hid12,n_class)-0.5)*0.001;
% k2=(rand(n_hid23,n_hid12)-0.5)*0.001;
% k3=(rand(n_hid34,n_hid23)-0.5)*0.001;
% k4=(rand(n_hid45,n_hid34)-0.5)*0.001;
% k5=(rand(n_hid56,n_hid45)-0.5)*0.001;
% k6=(rand(n_class,n_hid56)-0.5)*0.001;

load('best_k');

n_samples=size(x,2);

n_iter=1000;

sgn_k1=k1*0;
sgn_k2=k2*0;
sgn_k3=k3*0;
sgn_k4=k4*0;
sgn_k5=k5*0;
sgn_k6=k6*0;

a_up=1.2;
a_dn=0.5;

a_lim=[10^-7 10^5];

alpha_k1=k1*0;
alpha_k2=k2*0;
alpha_k3=k3*0;
alpha_k4=k4*0;
alpha_k5=k5*0;
alpha_k6=k6*0;

for i=1:n_samples% зануление
    
    for k=1:75
    x(randi([1 size(x,1)], 1, 1) ,i)=0;
    end
    
    
end

%%External


n_pic=5;
m_pic=5;
e=zeros(n_iter,4);




subplot(1,3,1);
for N=1:n_iter

    h12=logsig(k1*x);

    y=logsig(k6*h12);

    dy=y-t;
    
    dk6=dy*h12'/n_samples;
    
    dh12=(dy'*k6)';
    dh12=dh12.*h12.*(1-h12); 
    
    dk1=dh12*x'/n_samples;
    
    e(N,1)=sum((t(:)-y(:)).^2)/n_samples; 
    plot(e(:,1));
    title('Error (external):');
    drawnow;
    

    dif=(sgn_k1~=sign(dk1));
    alpha_k1(dif)=alpha_k1(dif)*a_dn;
    alpha_k1(~dif)=alpha_k1(~dif)*a_up;
    alpha_k1(alpha_k1>a_lim(2))=a_lim(2);
    alpha_k1(alpha_k1<a_lim(1))=a_lim(1);
    sgn_k1=sign(dk1);

    dif=(sgn_k6~=sign(dk6));
    alpha_k6(dif)=alpha_k6(dif)*a_dn;
    alpha_k6(~dif)=alpha_k6(~dif)*a_up;
    alpha_k6(alpha_k6>a_lim(2))=a_lim(2);
    alpha_k6(alpha_k6<a_lim(1))=a_lim(1);
    sgn_k6=sign(dk6);
    
    k1=k1-dk1.*alpha_k1;
    k6=k6-dk6.*alpha_k6;     


end


%% 

%%Middle


h12=logsig(k1*x);

for i=1:n_samples
    
    for k=1:50
    h12(randi([1 size(h12,1)], 1, 1) ,i)=0;
    end
    
end

subplot(1,3,2);
for N=1:n_iter

    h45=logsig(k2*h12);
    h56=logsig(k5*h45);
    y=logsig(k6*h56);

    dy=y-t;
    
    dk6=dy*h56'/n_samples;
    dh56=(dy'*k6)';
    dh56=dh56.*h56.*(1-h56);
    
    dk5=dh56*h45'/n_samples;
    dh45=(dh56'*k5)';
    dh45=dh45.*h45.*(1-h45);
    
    dk2=dh45*h12'/n_samples;
    dh12=(dh45'*k2)';
    dh12=dh12.*h12.*(1-h12); 
    
    dk1=dh12*x'/n_samples;
    
    e(N,2)=sum((t(:)-y(:)).^2)/n_samples; 
    plot(e(:,2));
    title('Error (middle):');
    drawnow;

    dif=(sgn_k2~=sign(dk2));
    alpha_k2(dif)=alpha_k2(dif)*a_dn;
    alpha_k2(~dif)=alpha_k2(~dif)*a_up;
    alpha_k2(alpha_k2>a_lim(2))=a_lim(2);
    alpha_k2(alpha_k2<a_lim(1))=a_lim(1);
    sgn_k2=sign(dk2);

    dif=(sgn_k5~=sign(dk5));
    alpha_k5(dif)=alpha_k5(dif)*a_dn;
    alpha_k5(~dif)=alpha_k5(~dif)*a_up;
    alpha_k5(alpha_k5>a_lim(2))=a_lim(2);
    alpha_k5(alpha_k5<a_lim(1))=a_lim(1);
    sgn_k5=sign(dk5);

    k2=k2-dk2.*alpha_k2;     
    k5=k5-dk5.*alpha_k5; 



end

%% 

%%Internal

    h12=logsig(k1*x);
    h23=logsig(k2*h12); 

for i=1:n_samples
    
    for k=1:9
    h23(randi([1 size(h23,1)], 1, 1) ,i)=0;
    end
    
    
end


subplot(1,4,3);
for N=1:n_iter

    h34=logsig(k3*h23);
    h45=logsig(k4*h34);
    h56=logsig(k5*h45);
    y=logsig(k6*h56);

    dy=y-t;
    
    dk6=dy*h56'/n_samples;
    dh56=(dy'*k6)';
    dh56=dh56.*h56.*(1-h56); 
    
    dk5=dh56*h45'/n_samples;
    dh45=(dh56'*k5)';
    dh45=dh45.*h45.*(1-h45);

    dk4=dh45*h34'/n_samples;
    dh34=(dh45'*k4)';
    dh34=dh34.*h34.*(1-h34);
    
    dk3=dh34*h23'/n_samples;
    dh23=(dh34'*k3)';
    dh23=dh23.*h23.*(1-h23);
    
    dk2=dh23*h12'/n_samples;
    dh12=(dh23'*k2)';
    dh12=dh12.*h12.*(1-h12);
    
    dk1=dh12*x'/n_samples;
    
    e(N,3)=sum((t(:)-y(:)).^2)/n_samples; 
    plot(e(:,3));
    title('Error (internal):');
    drawnow;

    dif=(sgn_k3~=sign(dk3));
    alpha_k3(dif)=alpha_k3(dif)*a_dn;
    alpha_k3(~dif)=alpha_k3(~dif)*a_up;
    alpha_k3(alpha_k3>a_lim(2))=a_lim(2);
    alpha_k3(alpha_k3<a_lim(1))=a_lim(1);
    sgn_k3=sign(dk3);

    dif=(sgn_k4~=sign(dk4));
    alpha_k4(dif)=alpha_k4(dif)*a_dn;
    alpha_k4(~dif)=alpha_k4(~dif)*a_up;
    alpha_k4(alpha_k4>a_lim(2))=a_lim(2);
    alpha_k4(alpha_k4<a_lim(1))=a_lim(1);
    sgn_k4=sign(dk4);
   
    k3=k3-dk3.*alpha_k3;     
    k4=k4-dk4.*alpha_k4; 

end

% save('k_before_all', 'k1', 'k2', 'k3', 'k4', 'k5', 'k6');




%% Result
     
figure;
        for M=1:n_pic
            for K=1:m_pic
                subplot(n_pic,m_pic,(M-1)*m_pic+K);
                x_show=y(:,(M-1)*m_pic+K)';

                imshow(reshape(x_show,16,16)'); shading flat;
                colormap('gray');      
            end
        end
       
%% Input data

x=data.training.inputs;
        
figure;
        for M=1:n_pic
            for K=1:m_pic
                subplot(n_pic,m_pic,(M-1)*m_pic+K);
                x_show=x(:,(M-1)*m_pic+K)';

                imshow(reshape(x_show,16,16)'); shading flat;
                colormap('gray');      
            end
        end
title('Input images: ');   
        
        
        
%% Graph of classes


    x=data.training.inputs;
    h12=logsig(k1*x);
    h23=logsig(k2*h12);    
    h34=logsig(k3*h23);
    h45=logsig(k4*h34);
    h56=logsig(k5*h45);
    y=logsig(k6*h56);        
          
figure;
    

hold on;

plot(h34(1, 1:10:1000), h34(2, 1:10:1000), 'o');
plot(h34(1, 2:10:1000), h34(2, 2:10:1000), '+');
plot(h34(1, 3:10:1000), h34(2, 3:10:1000), '*');
plot(h34(1, 4:10:1000), h34(2, 4:10:1000), '.');
plot(h34(1, 5:10:1000), h34(2, 5:10:1000), 'x');
plot(h34(1, 6:10:1000), h34(2, 6:10:1000), 's');
plot(h34(1, 7:10:1000), h34(2, 7:10:1000), 'd');
plot(h34(1, 8:10:1000), h34(2, 8:10:1000), '^');
plot(h34(1, 9:10:1000), h34(2, 9:10:1000), 'v');
plot(h34(1, 10:10:1000), h34(2, 10:10:1000), 'p');


hold off;
title('Graph of classes:');   
legend('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
% save('best_k', 'k1', 'k2', 'k3', 'k4', 'k5', 'k6');
