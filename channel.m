function y = channel(z,mode)

%% Filter through channel impulse response and add noise
sigma=1; %Noise level

    if mode==1
       
      h=zeros(1,128);
        for i = 1:60
            h(i)=0.8.^i;
        end
        
     end

    if mode==2
      
       h=zeros(1,128);
       
       h(1) = 0.5;
       h(9) = 0.5;
       
        
        
    end
y_len = length(z)+length(h)-1;


w = 1/sqrt(2)*sigma*(randn(y_len,1) + 1i*randn(y_len,1)); %Additive noise

y=conv(z,h)+w;


end