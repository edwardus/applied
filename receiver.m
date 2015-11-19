function [b_hat,s_hat,H_estimated,H] = receiver(y_hat,h)

%% Parameters
m=2;
N=128;
N_t=60;
M=length(h); %Make sure we use the same M in transmitter and receiver
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);
symbols_t= QPSK([[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4],[1:4]]);

%% Processing

y_hat = y_hat(M+1:M+N+N_t); % removal of the cyclic prefix
y_hat_t = y_hat(1:N_t)
y_hat = y_hat(N_t+1:end)

r=fft(y_hat);
r_t=fft(y_hat_t);

H = fft(h,N); % The transfer function H(w)
H_estimated=r_t/symbols_t;

r=fft(y_hat,N);

s_hat=r./(conj(H))';

b_hat=zeros(1,2*N);
plot(H)
    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values

    
end


