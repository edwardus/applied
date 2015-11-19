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
symbols_t= repmat(QPSK([1:4]),32,1);
z_len= N + N + N + N;
M=length(y_hat)-z_len+1 %length of h

% Processing

y_hat = y_hat(M+1:M+N+128); % removal of the cyclic prefix

r=fft(y_hat);
r_t=r(1:128);
r=r(128+1:end);
% H_est = zeros(1,N);
% for i=1:N
% 
%     H_est(i) =(conj(r_t)./symbols_t);
% 
% end


H_est =(conj(r_t)./symbols_t);
H_est_re=mean(real(H_est));
H_est_Im=mean(imag(H_est));
H_est = H_est_re+1i*H_est_Im


figure(2)



freqz(H_est)

s_hat=r./(conj(H_est));

b_hat=zeros(1,2*N);

    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
end  

end

    



