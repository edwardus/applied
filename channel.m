function [y_hat,y_hat_p,h,sigma] = channel(z,z_p,mode,sigma)

%% Filter through channel impulse response and add noise
sigma; %Noise level
N=128;
y_hat_p=[];
    if mode==1
       
      h=zeros(1,60); 
        for i = 1:60
            h(i)=0.8.^(i-1);
        end
        
     end

    if mode==2
      
       h=zeros(1,9); 
       
       h(1) = 0.5;
       h(9) = 0.5; 
    end
    
y_len = length(z)+length(h)-1;

w = 1/sqrt(2)*sigma*(randn(y_len,1) + 1i*randn(y_len,1)); %Additive noise

y_hat=conv(z,h)+w;
if length(z_p)>1;
    y_hat_p=conv(z_p,h)+w;
end
figure(1)
freqz(fft(h,N))
% figure(2)
% plot(real(y_hat))
% title('Transmitted signal passed through h')
end