function [b_hat,s_hat,H] = receiver(y_hat,h,fall)
if fall==1
%% Parameters
m=2;
N=128;
M=60; %Make sure we use the same M in transmitter and receiver

%% Processing
y_hat = y_hat(M+1:M+N); % removal of the cyclic prefix

r=fft(y_hat); %OFDM^-1

H = fft(h,N); % The transfer function H(w)

s_hat=r./(conj(H))'; % Eq

b_hat=zeros(1,2*N); % Creating estimated bit vector
plot(H)
    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n))); %QPSK^-1
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values

elseif fall==2
%% Parameters
m=2;
N=128;
M=9; %Make sure we use the same M in transmitter and receiver

%% Processing
length(y_hat)
y_hat = y_hat(M+1:M+N); % removal of the cyclic prefix

r=fft(y_hat);

H = fft(h,N); % The transfer function H(w)

s_hat=r./(conj(H))';

b_hat=zeros(1,2*N);
plot(H)
    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
    
else
%% Parameters
m=2;
N=128;
M=9; %Make sure we use the same M in transmitter and receiver

%% Processing
length(y_hat)
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
plot(H)
    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
    

end

    
end


