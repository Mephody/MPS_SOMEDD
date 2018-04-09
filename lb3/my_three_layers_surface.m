% A little bit more complex task. We need to approximate function. Still
% have 3 layers, same structure as previous. Needs a little bit of time for
% education. We are using new method of step size calculating now. It's
% evaluating on previous derivative directions more, then on current
% values. There was problems with educations due to bad entry point (i 
% found a good one and saved it to file) so be carefull with uncommenting 
% lines 25 - 30 and 33.


n_grid=100;

[x1,x2]=meshgrid(linspace(0,1,n_grid),linspace(0,1,n_grid));

x1=x1(:)';
x2=x2(:)';

n_samples=length(x1);
x=[x1; x2];
t=cos(5*x(1,:)).^2+sin(9*x(2,:)).^2;

t=t-min(t);
t=t/max(t);

n_hid=20;

% k0=(rand(n_hid,2)-0.5);
% b0=(rand(n_hid,1)-0.5);
% 
% k1=(rand(n_hid,n_hid)-0.5);
% 
% k2=(rand(1, n_hid)-0.5);

load('data_variables.mat');
% save('data_variables.mat','k0', 'b0', 'k1', 'k2');

n_iter=100000;
alpha=0.00005;

E=zeros(n_iter,1);


moment=0.9;

v_b0=b0*0;
v_k0=k0*0;
v_k1=k1*0;


v_k2=k2*0;


for N=1:n_iter
    h1=logsig(k0*x+repmat(b0,1,n_samples));
    h2=logsig(k1*h1);
    y=logsig(k2*h2);
    
    E(N)=sum((y-t).^2)/n_samples;
    
    dy=y-t;
    
    dk2=(h2*dy')';
    
    dh2=k2'*dy;
    dh2=dh2.*h2.*(1-h2);
    dk1=dh2*h1';
    
    dh1=k1*dh2;
    dh1=dh1.*h1.*(1-h1);
    
    db0=mean(dh1,2);
    dk0=dh1*x';

    v_k0=v_k0*moment+dk0*(1-moment);
    v_b0=v_b0*moment+db0*(1-moment);
    
    v_k1=v_k1*moment+dk1*(1-moment);
    
    v_k2=v_k2*moment+dk2*(1-moment);
    
    b0=b0-v_b0*alpha*50;
    k0=k0-v_k0*alpha*50;    
    k1=k1-v_k1*alpha*50;    
        
    k2=k2-v_k2*alpha; 
    
    
    if(mod(N,50)==0)
        subplot(3,1,[1 2]);

        surf(reshape(t-y,n_grid,n_grid),'FaceColor',[0.2 0.2 1]); 

        camlight right

        view(142,36);
        subplot(3,1,3);
        plot(E);
        drawnow;
    end

end

