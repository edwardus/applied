function [b_hat,s_hat] = receiver(y_hat,option,synch)
%% Parameters
m=2;
N=128;
known = 0;
M=80;
R=10;


if option==1
    h_len=60; %Make sure we use the same M in transmitter and receiver
    known = 1;
end

if option==2
    h_len=9; %Make sure we use the same M in transmitter and receiver
    known = 1;
end

if known ==1
    
    b_hat = KnownChannel(y_hat);
    
    return;
end

if known ==0
%% Parameters
    
    QPSK = [-1-1i; -1+1i; 1-1i; 1+1i]./sqrt(2);
    
    s_pilot= QPSK(repmat(1,1,N));
   
    z_len= (N*2+160)+synch;

    z_len_up = z_len *R;
    
    h_len=length(y_hat)-z_len_up+1;
%     M=h_len;

%% Demodulation
fs = 22050;
fc = 4000;
figure(8); plot(y_hat)

 [~,index_start] = max(y_hat);
 
  index_start = index_start + N -1;
  
  figure(10); plot(y_hat(index_start:end))


   y_hat = y_hat(1:end-h_len+1);



n = ((0:length(y_hat)-1)/fs).';
figure(2); plot(y_hat)
y_hat = y_hat.*exp(-1i*2*pi*fc*n);
 figure(3); plot(fft(y_hat))
%% Design a LP decimation filter (Decimation)
B = firpm(32,2*[0 0.5/R*0.9 0.5/R*1.6 1/2],[1 1 0 0]);
y_hat = filter(B,1,y_hat);

%% Down-sampling


D = 10; %D = R
y_hat = y_hat(1:D:end);
  figure(4);  plot(y_hat)
%% Processing
    
    
    
    y_hat_p = y_hat(M+1:M+N);
    
    y_hat = y_hat(M+N+1+M:M+2*N+M); % removal of the cyclic prefix
    
    r=fft(y_hat); %length N
    r_p=fft(y_hat_p);
    
    
    H_estimated  = r_p./s_pilot; %length N
    
    % figure(3)
    % freqz(H_estimated)
    % title('Estimated H_1(w) - noise free')
    
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

    



