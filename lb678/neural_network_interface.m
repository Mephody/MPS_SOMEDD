close all;

load('variables');
load('parced_text2');

str=char('эллинофи');

str_int=parce(str);
str_int_reshaped=zeros(1, 33*(word_length-1));
    for j=1:word_length-1
        str_int_reshaped((33*(j-1)+1):(33*(j)))=str_int(:,j);
    end
    
    
result=logsig(k2*logsig(k1*logsig(k0*str_int_reshaped')));

fprintf('%c%c', str, unparce(result));
fprintf("\n");


%% 
% z=char(1,2048);
% 
% for i=1:2048
%     z(i)=char(i);
%     fprintf('%d  ---  %c \n', i, z(i));
% end

%% 

for i=1:33
    if(result(i)>0.05) fprintf('%f --- %f -- %c\n',i,result(i), myint2charRUS(i));
    end
end


