% File import

% uiimport ('-file');
% x=char(table2array(zdfwin));

%This file generates database of russian dictionary from text version to
%digital. I'd recommend to continue with neural_network_main script.

load('database');

% You can choose what words to pick.
word_length=9;

x=table2array(zdfwin1);
word_array=strings(size(x));
k=1;

for i=1:length(x)
    if(strlength(x(i))==word_length) 
        word_array(k)=x(i);
        k=k+1;
    end
end

char_array=char(word_array(1:k));


%% Text transformation

parced_text=zeros(k,33,word_length);
for i=1:k
    
    parced_text(i,:,:)=parce(char_array(i,:));
    
end

save('parced_text','word_length', 'parced_text');

parced_text2=zeros(k, 33*word_length);

for i=1:k

    for j=1:word_length
        parced_text2(i,(33*(j-1)+1):(33*(j)))=parced_text(i,:,j);
    end
    
end

save('parced_text2','word_length', 'parced_text2');
