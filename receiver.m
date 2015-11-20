function [b_hat,s_hat] = receiver(y_hat,h,fall)
%% Parameters
m=2;
N=128;
known = 0;

if fall==1
M=60; %Make sure we use the same M in transmitter and receiver
known = 1;
end

if fall==2
M=9; %Make sure we use the same M in transmitter and receiver
known = 1;
end

if known ==1
%% Processing
y_hat = y_hat(M+1:M+N); % removal of the cyclic prefix

r=fft(y_hat);

H = fft(h,N); % The transfer function H(w)

s_hat=r./(conj(H))';

b_hat=zeros(1,2*N);
    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
end

if known ==0
%% Parameters

QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);

pilot= QPSK(repmat([1:4],1,4));
z_len= (N + 16)*2
M=length(y_hat)-z_len+1
%% Processing
y_hat = y_hat(M+1:M+N+16) % removal of the cyclic prefix

r=fft(y_hat);
% r_t=r(1:16);
% r=r(16+1:end);

H_estimated=zeros(1,N);

for i=1:8
    H_estimated([(i-1)*16+1:(i-1)*16+16])=r([(i-1)*16+1:(i-1)*16+16])./pilot;
    pilot=r([(i)*16+1:(i)*16+16])./H_estimated([(i-1)*16+1:(i-1)*16+16]);
end
figure(3)
freqz(H_estimated)
s_hat=r./(conj(H_estimated))';


b_hat=zeros(1,2*N);

    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
end  

end

    



