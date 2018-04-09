%%  Neural network training
close all;

load('parced_text2');
load('variables');

% This is more advanced script for more accurate learning. We upload
% coeffitients from previous script (neural_network_main) and making them
% more accurate. There is also validation 

n_training=floor(0.5*size(parced_text2, 1));


x=[parced_text2(1:10:end,1:(33*(word_length-1))); parced_text2(2:10:end,1:(33*(word_length-1))); parced_text2(3:10:end,1:(33*(word_length-1))); parced_text2(4:10:end,1:(33*(word_length-1))); parced_text2(5:10:end,1:(33*(word_length-1))); parced_text2(6:10:end,1:(33*(word_length-1))); parced_text2(7:10:end,1:(33*(word_length-1))); parced_text2(8:10:end,1:(33*(word_length-1))); parced_text2(9:10:end,1:(33*(word_length-1)))];
t=[parced_text2(1:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(2:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(3:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(4:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(5:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(6:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(7:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(8:10:end,(33*(word_length-1)+1:(33*word_length))); parced_text2(9:10:end,(33*(word_length-1)+1:(33*word_length)))];

x_test=parced_text2(10:10:end,1:(33*(word_length-1)));
t_test=parced_text2(10:10:end,(33*(word_length-1)+1:(33*word_length)));


x_test=x_test';
t_test=t_test';

x=x';
t=t';

n_hid01=100;
n_hid12=50;
n_y=33;

n_class=size(x,1);
n_samples=size(x,2);
n_samples_test=size(x_test, 2);

n_iter=300;

% k0=(rand(n_hid01,n_class)-0.5)*0.001;
% k1=(rand(n_hid12,n_hid01)-0.5)*0.001;
% k2=(rand(n_y,n_hid12)-0.5)*0.001;

sgn_k0=k0*0;
sgn_k1=k1*0;
sgn_k2=k2*0;

a_up=1.2;
a_dn=0.5;

a_lim=[10^-7 10^5];

alpha_k0=k0*0;
alpha_k1=k1*0;
alpha_k2=k2*0;

k0_min = k0*0;
k1_min = k1*0;
k2_min = k2*0;


e=zeros(n_iter, 1);
e_test=zeros(n_iter, 1);
e_min=10;

for N=1:n_iter

    h01=logsig(k0*x);
    h12=logsig(k1*h01);
    y=logsig(k2*h12);
    y_test=logsig(k2*logsig(k1*logsig(k0*x_test)));

    

    dy=y-t;
    

    
    dk2=dy*h12'/n_samples;
    dh12=(dy'*k2)';
    dh12=dh12.*h12.*(1-h12); % Производня от logsig
    
    dk1=dh12*h01'/n_samples;
    dh01=(dh12'*k1)';
    dh01=dh01.*h01.*(1-h01); % Производня от logsig
    
    dk0=dh01*x'/n_samples;
    
    e(N)=sum((t(:)-y(:)).^2)/n_samples; 
    e_test(N)=sum((t_test(:)-y_test(:)).^2)/n_samples_test; 
    hold on
    plot(e, 'b');
    plot(e_test, 'r');
    hold off
    title('Error:');
    legend('Education', 'Validation');
    drawnow;
    
    if(mod(N,10)==0)
        if(e_min>e_test(N))
            e_min=e_test(N);
            k0_min = k0;
            k1_min = k1;
            k2_min = k2;
        end
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

k0 = k0_min;
k1 = k1_min;
k2 = k2_min;

% save('variables', 'k0', 'k1', 'k2');


%% Neural network test

load('variables');
load('parced_text2');


k0 = k0_min;
k1 = k1_min;
k2 = k2_min;

x_test=parced_text2(10:10:end,1:(33*(word_length-1)));
t_test=parced_text2(10:10:end,(33*(word_length-1)+1:(33*word_length)));

x_test=x_test';
t_test=t_test';

n_test=size(y_test, 2);

y_test=logsig(k2*logsig(k1*logsig(k0*x_test)));

y_test_max=zeros(1, n_samples_test);
t_test_max=zeros(1, n_samples_test);

counter=0;

unparced_word_t=char(zeros(1,7));
unparced_word_y=char(zeros(1,7));

for i=1:size(y_test, 2)
   
    for j=1:word_length
        unparced_word_t(j)=unparce(parced_text(10*i,:,j));
    end
    
    for j=1:word_length-1
        unparced_word_y(j)=unparce(x_test((33*(j-1)+1):(33*(j)),i));
    end
    unparced_word_y(word_length)=unparce(y_test(:,i));
    fprintf('%c', unparced_word_t);
    fprintf('---');
    fprintf('%c', unparced_word_y);
       
    [~, y_test_max(i)]=max(y_test(:, i));
    [~, t_test_max(i)]=max(t_test(:, i));
    if(y_test_max(i)==t_test_max(i)) 
        counter=counter+1; 
    else
        fprintf('\n');
        for m=1:33
        if(y_test(m,i)>0.05) fprintf('%f --- %f -- %c\n',m,y_test(m, i), myint2charRUS(m));
        end
        end
    end
    
    
    fprintf('\n');

end

fprintf('Percent correct: %f%% \n',counter/n_test*100);


