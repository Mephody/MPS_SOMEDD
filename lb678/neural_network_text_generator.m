close all;

load('variables');
load('parced_text');
load('parced_text2');

% This is scipt for fun only. It treis to predict the next letter in a
% word. After this word becomes a base to another iteration of algorithm.

str=char('абиссине');

str_int=parce(str);
str_int_reshaped=zeros(1, 33*(word_length-1));
    for j=1:word_length-1
        str_int_reshaped((33*(j-1)+1):(33*(j)))=str_int(:,j);
    end
    
for i=1:10
    result=logsig(k2*logsig(k1*logsig(k0*str_int_reshaped')));
    [~,result_max_index]=max(result);
    conc_matrix=zeros(1, 33);
    conc_matrix(1, result_max_index)=1;
    str_int_reshaped=[str_int_reshaped(34:end), conc_matrix];
    
    for j=1:word_length-1
        fprintf('%c',unparce(str_int_reshaped((33*(j-1)+1):(33*j))));
    end
        
    
    fprintf('%c',unparce(result));
    fprintf("\n");
end