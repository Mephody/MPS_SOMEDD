function [ int_matrix ] = parce( char_lineral_matrix )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

return_matrix=zeros(33, length(char_lineral_matrix));

for i=1:length(char_lineral_matrix)
    
    switch(char_lineral_matrix(i))
        
        case 'à'
            return_matrix(1, i)=1;
        case 'á'
            return_matrix(2, i)=1;
        case 'â'
            return_matrix(3, i)=1;
        case 'ã'
            return_matrix(4, i)=1;
        case 'ä'
            return_matrix(5, i)=1;
        case 'å'
            return_matrix(6, i)=1;
        case '¸'
            return_matrix(7, i)=1;
        case 'æ'
            return_matrix(8, i)=1;
        case 'ç'
            return_matrix(9, i)=1;
        case 'è'
            return_matrix(10, i)=1;
        case 'é'
            return_matrix(11, i)=1;
        case 'ê'
            return_matrix(12, i)=1;
        case 'ë'
            return_matrix(13, i)=1;
        case 'ì'
            return_matrix(14, i)=1;
        case 'í'
            return_matrix(15, i)=1;
        case 'î'
            return_matrix(16, i)=1;
        case 'ï'
            return_matrix(17, i)=1;
        case 'ð'
            return_matrix(18, i)=1;
        case 'ñ'
            return_matrix(19, i)=1;
        case 'ò'
            return_matrix(20, i)=1;
        case 'ó'
            return_matrix(21, i)=1;
        case 'ô'
            return_matrix(22, i)=1;
        case 'õ'
            return_matrix(23, i)=1;
        case 'ö'
            return_matrix(24, i)=1;
        case '÷'
            return_matrix(25, i)=1;
        case 'ø'
            return_matrix(26, i)=1;
        case 'ù'
            return_matrix(27, i)=1;
        case 'ú'
            return_matrix(28, i)=1;
        case 'û'
            return_matrix(29, i)=1;
        case 'ü'
            return_matrix(30, i)=1;
        case 'ý'
            return_matrix(31, i)=1;
        case 'þ'
            return_matrix(32, i)=1;
        case 'ÿ'
            return_matrix(33, i)=1;
        
            
        
        
    end;
    
end;

int_matrix=return_matrix;

end

