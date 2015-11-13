function y = receiver(y_hat,h)

%% Parameters
m=2;
N=128;
M=60; %Make sure we use the same L in transmitter and receiver



%% Processing
y_hat = y_hat(M+1:end); % removal of the cyclic prefix
y_hat = y_hat(1:end-M+1);

h_hat = fft(h,N);

y_hat=fft(y_hat,N);

x=ifft(y_hat./h_hat',N);

y=x';

% y=fft(y,N);
% 
% %% Demodulation
% 
% vecot = zeros(1,N);
% 
% for i = 1:N
%     if real(y(i))>0 && imag(y(i))>0
%         vecot(i)=0;
%     end
%     if real(y(i))>0 && imag(y(i))<0
%         vecot(i)=1;
%     end
%     if real(y(i))<0 && imag(y(i))>0
%         vecot(i)=2;
%     end
%     if real(y(i))<0 && imag(y(i))<0
%         vecot(i)=3;
%     end
% end
% 
% 
% %% Decimals to bits
% 
% bits = de2bi(vecot, m, 'left-msb');
% 
% y=bits;


end


