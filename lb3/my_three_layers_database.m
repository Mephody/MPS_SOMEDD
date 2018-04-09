load('data');

% A little bit more complex system. Uses logsig as activation function and
% has 3 layers. Still making previous job - image classification.

v_pic=data.validation.inputs;
v_ans=data.validation.targets;

x=data.training.inputs;
t=data.training.targets;

n_hid=20;

% Layers coeffitients.
k0=(rand(n_hid,size(x,1))-0.5);
k1=(rand(n_hid,n_hid)-0.5);
k2=(rand(size(t,1), n_hid)-0.5);


n_iter=20000;
alpha=0.00001;
% Alpha - step size.

E=zeros(n_iter,1);
E_v=zeros(n_iter,1);

for N=1:n_iter
    h1=logsig(k0*x);
    h2=logsig(k1*h1);
    y=logsig(k2*h2);
    
    %Error calculating.
    E(N)=sum((y(:)-t(:)).^2);
    y_v=logsig(k2*logsig(k1*logsig(k0*v_pic)));
    E_v(N)=sum((y_v(:)-v_ans(:)).^2);
    
    %Calculating derivatives.
    dy=y-t;
    
    dk2=(h2*dy')';
    
    dh2=k2'*dy;
    dh2=dh2.*h2.*(1-h2);
    
    dk1=dh2*h1';
    
    dh1=k1*dh2;
    dh1=dh1.*h1.*(1-h1);

    dk0=dh1*x';
    
    %Making changes to our coeffitients or (as more popular) learning.
    k0=k0-dk0*alpha*100;    
    
    k1=k1-dk1*alpha*100;
    k2=k2-dk2*alpha;
    
    if(mod(N,100)==0)
        
        plot(E);
        hold on
        plot(E_v, 'r');
        hold off
        drawnow;
        title('Error:');
        legend('Educational', 'Validation');
    end
end




%% 
z_pic=data.test.inputs;
z_ans=data.test.targets;

y_z=logsig(k2*logsig(k1*logsig(k0*z_pic)));
cor=0;

for i=1:size(z_ans,2)
   [~, ind1]=max(y_z(:,i));
   [~, ind2]=max(z_ans(:,i));
   if(ind1==ind2)
       cor=cor+1;
   end
   
end
fprintf('Test data. Recognized correctly: %f %% \n ',cor/90);