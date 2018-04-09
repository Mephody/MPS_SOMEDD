%%  Neural network training

% NN the same as previous. A little bit another task. We have to find a
% regularity in word building, so NN sometimes goes mad and you need to
% relaunch it. We dont have validation here, just training and test
% samples.
% I do not recommend to launch this script. It's better to start with the
% next one (neural_network_test_as_validation).

load('parced_text2');

n_training=floor(0.8*size(parced_text2, 1));

x=parced_text2(1:n_training,1:(33*(word_length-1)));
t=parced_text2(1:n_training,(33*(word_length-1)+1:(33*word_length)));

x=x';
t=t';

n_hid01=100;
n_hid12=50;
n_y=33;

n_class=size(x,1);
n_samples=size(x,2);
n_iter=800;

k0=(rand(n_hid01,n_class)-0.5)*0.001;
k1=(rand(n_hid12,n_hid01)-0.5)*0.001;
k2=(rand(n_y,n_hid12)-0.5)*0.001;


sgn_k0=k0*0;
sgn_k1=k1*0;
sgn_k2=k2*0;

a_up=1.2;
a_dn=0.5;

a_lim=[10^-7 10^5];

alpha_k0=k0*0;
alpha_k1=k1*0;
alpha_k2=k2*0;


e=zeros(n_iter, 1);

for N=1:n_iter
    
    h01=logsig(k0*x);
    h12=logsig(k1*h01);
    y=logsig(k2*h12);

    dy=y-t;
   
    dk2=dy*h12'/n_samples;
    dh12=(dy'*k2)';
    dh12=dh12.*h12.*(1-h12); 
    
    dk1=dh12*h01'/n_samples;
    dh01=(dh12'*k1)';
    dh01=dh01.*h01.*(1-h01);
    
    dk0=dh01*x'/n_samples;
    
    e(N)=sum((t(:)-y(:)).^2)/n_samples; 
    plot(e);
    title('Educational error:');
    drawnow;
    
    if(e(N)<0.1) 
        break;
    end

    dif=(sgn_k1~=sign(dk1));
    alpha_k1(dif)=alpha_k1(dif)*a_dn;
    alpha_k1(~dif)=alpha_k1(~dif)*a_up;
    alpha_k1(alpha_k1>a_lim(2))=a_lim(2);
    alpha_k1(alpha_k1<a_lim(1))=a_lim(1);
    sgn_k1=sign(dk1);
    
    dif=(sgn_k2~=sign(dk2));
    alpha_k2(dif)=alpha_k2(dif)*a_dn;
    alpha_k2(~dif)=alpha_k2(~dif)*a_up;
    alpha_k2(alpha_k2>a_lim(2))=a_lim(2);
    alpha_k2(alpha_k2<a_lim(1))=a_lim(1);
    sgn_k2=sign(dk2);

    dif=(sgn_k0~=sign(dk0));
    alpha_k0(dif)=alpha_k0(dif)*a_dn;
    alpha_k0(~dif)=alpha_k0(~dif)*a_up;
    alpha_k0(alpha_k0>a_lim(2))=a_lim(2);
    alpha_k0(alpha_k0<a_lim(1))=a_lim(1);
    sgn_k0=sign(dk0);


    k0=k0-dk0.*alpha_k0;    
    k1=k1-dk1.*alpha_k1;
    k2=k2-dk2.*alpha_k2;     
    
end

save('variables', 'k0', 'k1', 'k2');

%% Neural network test

x_test=parced_text2(n_training:end,1:(33*(word_length-1)));
t_test=parced_text2(n_training:end,(33*(word_length-1)+1:(33*word_length)));

x_test=x_test';
t_test=t_test';



y_test=logsig(k2*logsig(k1*logsig(k0*x_test)));
n_test=size(y_test, 2);

y_test_max=zeros(1, n_test);
t_test_max=zeros(1, n_test);

counter=0;

for i=1:size(y_test, 2)
    [~, y_test_max(i)]=max(y_test(:, i));
    [~, t_test_max(i)]=max(t_test(:, i));
    if(y_test_max(i)==t_test_max(i)) counter=counter+1;
    end
end

fprintf('Percent correct: %f%% \n',counter/n_test*100);



