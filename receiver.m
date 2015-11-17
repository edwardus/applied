function b_hat = receiver(y_hat,h,y_len)

%% Parameters
m=2;
N=128;
M=length(h); %Make sure we use the same M in transmitter and receiver


%% Processing
y_hat = y_hat((M+1):end); % removal of the cyclic prefix
%y_hat = y_hat(M:M+N-1); //what about this one?

y_hatl=length(y_hat)
y_hat = y_hat(1:(end-(M-1)));
y_hatl=length(y_hat)
h_hat = fft(h,N);
y_hatl=length(y_hat)
r=fft(y_hat);
rl=length(r)
s_hat=r.*conj(h_hat)'
b_hat=zeros(1,2*N);

    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values

    
end


