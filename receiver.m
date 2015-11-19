function [b_hat,s_hat,H] = receiver(y_hat,h)

%% Parameters
m=2;
N=128;
 %Make sure we use the same M in transmitter and receiver
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);
symbols_t= QPSK([1:4]);

z_len= N + N; %case 2 
z_len= N+60; %N+9
h_len= length(y_hat)-length(z)+1;

M=h_len; %case 2
M=length(h); %case 1

%% Processing

y_hat = y_hat(M+1:M+N+4); % removal of the cyclic prefix

r=fft(y_hat);
r_t=r(1:4);
r=r(4+1:end);

length(r)
% length(r_t)
length(symbols_t)
H = fft(h,N); % The transfer function H(w)
% H_estimated=r_t./symbols_t;

s_hat=r./(conj(H))';

b_hat=zeros(1,2*N);

    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values

    
end


