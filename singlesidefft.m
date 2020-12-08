function [F] = singlesidefft(X)
%SINGLESIDEFFT use FFT on data after background subtraction and plot the
%amplitude-frequency graph
%   X is data after background subtraction of dimension n*2m. The x data
%   should be lineraly seperated.
%   F returns the single side amplitude-frequency spectrum of X.

% obtain the number of data
s=size(X);
l=zeros(s(2)/2); % length of signal
T=zeros(s(2)/2);    % sampling period
fs=zeros(s(2)/2);    % sampling frequency
F=zeros(floor(s(1)/2)+1,s(2));  % output spectrum
for i=1:s(2)/2
    l(i)=length(X(:,2*i-1));
    T(i)=(max(X(:,2*i-1))-min(X(:,2*i-1)))/(l(i)-1);
    fs(i)=1/T(i);
    Y1=abs(fft(X(:,2*i)))/l(i);
    Y2=Y1(1:floor(l(i)/2)+1);
    Y2(2:end-1)=2*Y2(2:end-1);
    f=fs(i)*(0:floor(l(i)/2))/l(i);
    F(:,2*i-1)=f';
    F(:,2*i)=Y2';
    figure
    plot(f,Y2)
    title(sprintf('amplitude spectrum of data #%1.0f',i))
    xlabel('f(T)')
    ylabel('A(a.u.)')
    clear f Y1 Y2
end

