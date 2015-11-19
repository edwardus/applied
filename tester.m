
%% Test File
N=128;

[z,z_t,ofdm,bits,symbols]=transmitter();

[y_hat,y_hat_t,h,sigma] = channel(z,z_t,2);

[b_hat,s_hat] = receiver(y_hat,y_hat_t,h);
s_max=max(abs(symbols-s_hat)); %This is a good measure, should be included 
                              %the report imo 
BitErrors = 0;
for i=1:2*N
    if bits(i)~=b_hat(i)
        BitErrors=BitErrors+1;
    end
end


disp(['The total number of bit errors are: ' int2str(BitErrors) char(10)...
    'The current noise level is: ' num2str(sigma) 'dB' char(10)...
    'And the maximum differance between transmitted and received symbol is: ' num2str(s_max) char(10)])

%%
figure(1)
subplot(2,1,1)
plot(b_hat)

subplot(2,1,2)
plot(bits)

