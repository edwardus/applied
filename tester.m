
%% Test File

%Parameters
ErrorsPerSigma = zeros(1,1001);
s_maxTOT=zeros(1,1001);
counter = 0;
N=128;

sigma=0;

%Test area


counter = counter +1; 
fall=3;

[z,z_p,bits,symbols]=transmitter(fall);

[y_hat,y_hat_p,h,sigma2] = channel(z,z_p,2,sigma);

[b_hat,s_hat] = receiver(y_hat,y_hat_p,h,fall);

% s_max=max(abs(symbols-s_hat)); %This is a good measure, should be included 
                               %the report imo 

%scatterplot(s_hat)
    
BitErrors = 0;
for i=1:2*N
    if bits(i)~=b_hat(i)
        BitErrors=BitErrors+1;
    end
end
%errorbits=abs(bits-b_hat)
ErrorsPerSigma(counter) = BitErrors;
%s_maxTOT(counter)=s_max;

BitErrors

%%
sigma = 0:0.001:1;
% subplot(2,1,1)
plot(sigma,ErrorsPerSigma)
legend('Bit errors')
title('Bit errors vs Sigma (h_2)')
xlabel('Noise level')
ylabel('Bit errors')
set(gca, 'fontsize',20)
% subplot(2,1,2)
% plot(sigma,s_maxTOT,'k*')
% legend('Distance of ideal and estimated symbols')
% xlabel('Noise level')
% ylabel('Distance')
% set(gca, 'fontsize',20)



disp(['The total number of bit errors are: ' int2str(BitErrors) char(10)...
    'The current noise level is: ' num2str(sigma2) 'dB' char(10)...
    'And the maximum differance between transmitted and received symbol is: ' num2str(s_max) char(10)])




%%
sigma = 0:0.001:1;
subplot(2,1,1)
plot(sigma,ErrorsPerSigma)
legend('Bit errors')
title('Bit errors vs Sigma (h_2)')
xlabel('Noise level')
ylabel('Bit errors')
set(gca, 'fontsize',20)
subplot(2,1,2)
plot(sigma,s_maxTOT,'k*')
legend('Distance of ideal and estimated symbols')
xlabel('Noise level')
ylabel('Distance')
set(gca, 'fontsize',20)

