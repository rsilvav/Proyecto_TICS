close all
clear
clc
settings; 
%============================ Inits 
imgR = imread(img);
[row, col ,prof]= size(imgR); 
text = unicode2native(img) 
bufer = row*col;
str = ones(1,bufer)*32; 
txtlen= size(text);
txtlen= txtlen(2);
step = floor(bufer./txtlen); 
count = 0;
xchar = 1;

%w=1:bufer
%if count==step & xchar<=txtlen
%str(1,w)=text(xchar); xchar=xchar+1; count=0;
%end

%if xchar<=txtlen
%str(1,w)=text(xchar); end
%count=count+1;
%for
%
%
% end
%

for w=1:bufer str(1,w)=text(xchar); xchar=xchar+1;  
    if xchar>txtlen
        xchar=1
    end
end
str = transpose(reshape(str, 16,16))

%============================ Header del mensaje
head_dt = 0:1/fs:header_f;
header = [sin(2*pi*header1*head_dt), sin(2*pi*header2*head_dt), sin(2*pi*header3*head_dt)];
senal = header;
%============================ Codificar la dimension de la imagen
size_dt = 0:1/fs:info_size_f;
header = sin(2*pi*(ancho+col*10)*size_dt)+ sin(2*pi*(alto+row*10)*size_dt)+ sin(2*pi*(len+txtlen*10)*size_dt); %modulacion de tres frecs
senal = [senal, header];% fusion de ambas
%============================ Mensaje
pixel_dt = 0:1/fs:info_pixel_f; % aca, en frecs
for i=1:row
    for j=1:col
        px=[imgR(i,j,1) imgR(i,j,2) imgR(i,j,3)];% sacar el pixel como un vector de doubles RGB
        px = double(px);
        px_bi=[de2bi(px(1),8) de2bi(px(2),8) de2bi(px(3),8) de2bi(str(i,j),8)];
%decimal a vector de binarios => vector de 24 bits
        for k=1:8
            aux(k)=Rf+double(px_bi(k))*dif+delta*(k-1); %portadoras 
            aux(k+8)=Gf+double(px_bi(k+8))*dif+delta*(k-1); 
            aux(k+16)=Bf+double(px_bi(k+16))*dif+delta*(k-1); 
            aux(k+24)=Tf+double(px_bi(k+24))*dif+delta*(k-1);
        end
        sampling = sin(2 * pi * aux.' * pixel_dt);
        sampling = sum(sampling);
        senal = [senal, sampling];%acumula espectro y fusion end
    end
end
%============================ plot en tiempo y FFT
subplot(2,1,1)
plot(senal) %tiempo 
xlabel('tiempo (segs)') 
ylabel('Amplitud')%
subplot(2,1,2)
frames_dim = length(senal);
NFFT = 2^nextpow2(frames_dim);
Y = fft(senal, NFFT)/frames_dim; 
f = fs/2*linspace(0,1,NFFT/2+1); 
plot(f, 2*abs(Y(1:NFFT/2+1))); 
xlabel('Frecuencia (Hz)') 
ylabel('Amplitud')
%save('audio.mat','senal');
audiowrite('twitter.wav',senal,fs); 
disp('Send...')
%bytes1 = unicode2native(str1)
pause sound(senal, fs)
