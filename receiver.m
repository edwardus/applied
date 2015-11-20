function [b_hat,s_hat] = receiver(y_hat,y_hat_p,h,fall,synch)
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
y_hat = y_hat(M+1:M+N); % removal of the cyclic prefix and delay

r=fft(y_hat);

H = fft(h,N); % The transfer function H(w)
% scatterplot(r)
% title('Scatterplot of r - i.e s affected by the channel')

s_hat=r./(conj(H))';


% scatterplot(s_hat)
% title('Scatterplot of received symbols - noisy')

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
h=0;
QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);

s_pilot = QPSK(repmat(1,1,128));
z_len= N*2+synch;
M=length(y_hat)-z_len+1
%% Processing
y_hat = y_hat(M+1:M+N); % removal of the cyclic prefix
y_hat_p = y_hat_p(M+1:M+N);

r=fft(y_hat);
r_p=fft(y_hat_p);


H_estimated  = r_p./s_pilot;

figure(3)
freqz(H_estimated)
title('Estimated H_2(w) - noise free')

s_hat=r./(H_estimated);


% H_estimated=zeros(N,1);
% 
% for i=1:8
%     H_estimated([(i-1)*16+1:(i-1)*16+16])=r([(i-1)*16+1:(i-1)*16+16])./pilot;
%     pilot=r([(i)*16+1:(i)*16+16])./H_estimated([(i-1)*16+1:(i-1)*16+16]);
% end
% figure(3)
% freqz(H_estimated)
% title('Estimated H_1(w) - noisy channel')

b_hat=zeros(1,2*N);

    for n=1:N
     b_hat((n*2-1))=sign(real(s_hat(n)));
     b_hat((n*2))=sign(imag(s_hat(n)));
    end
    
b_hat(b_hat==0)=3; %just for debugging
b_hat(b_hat==-1)=0; %replace the -1 values    
end  

end

    



