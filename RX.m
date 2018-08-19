close all
clear
clc
settings;
%==================================== Grabar
disp('Presionar tecla para grabar')
pause
disp('Grabando...')
tf = 50; % duracion de la grabacion (segs)
recorder = audiorecorder(fs, 16, 1);
recordblocking(recorder, tf);
senal = recorder.getaudiodata;
%load('audio.mat'); % directo!
%largo 15
%50 pepe

%150 pollo
%==================================== Header
header_dt = 0:1/fs:header_f;
header_p = [sin(2*pi*header1*header_dt), sin(2*pi*header2*header_dt), sin(2*pi*header3*header_dt)];
ventana_t = 4; % segundos de ventana
detect_header = senal(1:ventana_t*fs);
% 'acor' contiene la correlacion para cada desplazamiento de 'lag'
[corr, lag] = xcorr(detect_header, header_p);
[~,I] = max(abs(corr)); % encontrar la max correlacion con todo el dato
lag_dev = lag(I); % desviacion en frames donde esta la maxima corr


%==================================== Dimension imagen
header_ini = abs(lag_dev) + length(header_p); % encontrar donde encuentra dimesiones + mensaje
frames_dim = info_size_f * fs; % lo que dura las dimensiones en tiempo
body = senal(header_ini:header_ini + frames_dim - 1);
Z = fft(body); % FFT
Z1 = Z(1:(frames_dim/2)+1);
Z1(2:end-1) = 2*Z1(2:end-1);
Z1 = abs(Z1);
Z12 = abs(Z1);
Z13 = abs(Z1);

%================ calcular primer indice, ancho
F_ = fs*(0:(frames_dim/2))/frames_dim;
index = (ancho+400 > F_) & (F_ >= ancho-400); % frecuencia pedida, ancho
F_ = F_(index);
Z1 = Z1(index);
[~,f_i] = max(Z1);
F_(f_i);
%================ calcular segundo indice, alto

F_2 = fs*(0:(frames_dim/2))/frames_dim;
index2 = (alto+400> F_2) & (F_2 >= alto-400); % filtra a modo de dejar la frecuencia pedida, alto
F_2 = F_2(index2);
Z12 = Z12(index2);
[~,f_i2] = max(Z12);
F_3 = fs*(0:(frames_dim/2))/frames_dim;
index3 = (len+400> F_3) & (F_3 >= len-400); % filtra a modo de dejar la frecuencia pedida, alto
F_3 = F_3(index3);
Z13 = Z13(index3);
[~,f_i3] = max(Z13);
dim(1) = round((F_(f_i)-ancho)/10); %recuperar numero en si de la dimension
dim(2) = round((F_2(f_i2)-alto)/10);
dim(3) = round((F_3(f_i3)-len)/10);
aux = dim;



%==================================== Mensaje
%if dim(1)==dim(2) % si es cuadrada
if 1>0
    i_time = header_ini + length(body);
    rojo = zeros(1,dim(1)*dim(2));
    verde = zeros(1, dim(1)*dim(2));
    azul = zeros(1, dim(1)*dim(2));
    txt = zeros(1, dim(1)*dim(2));
    pix_dt=0:1/fs:info_pixel_f;
    pix_w = length(pix_dt);
    f_val = (0:pix_w/2) * fs/pix_w;
    msg = senal(i_time:end);
    %======== PLOT FFT
    frames_dim = length(senal);
    NFFT = 2^nextpow2(frames_dim);
    Y = fft(senal, NFFT)/frames_dim;
    f = fs/2*linspace(0,1,NFFT/2+1);
    figure(2)
    plot(f, 2*abs(Y(1:NFFT/2+1)));
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud')
%==================================== Loop de pixees
    for i = 1:dim(1)*dim(2)
        sample = msg((i-1)*pix_w+1:i*pix_w);
        Y = fft(sample); % saca fft por columnas
        Y1 = Y(1:round(pix_w/2) + 1);
        Y1 = abs(Y1);
%========= Por cada pixel, revisar 8 bits de cada canal
        for k=1:8
%========= filtra las bandas correspondiente para cada bit de
%cada canal, dejando los indices de los elementos filtrados
            indices_rojos =((Rf+k*delta-80)>= f_val) & (f_val >= Rf+(k-1)*delta-20); %indicando los anchos de banda
            indices_verdes =((Gf+k*delta-80)>= f_val) & (f_val >= Gf+(k-1)*delta-20);
            indices_azules =((Bf+k*delta-80)>= f_val) & (f_val >= Bf+(k-1)*delta-20);
            indices_texto =((Tf+k*delta-80)>= f_val) & (f_val >= Tf+(k-1)*delta-20);
%========= deja en una matriz solo los elementos filtrados
            Rf_val = f_val(indices_rojos);
            Gf_val = f_val(indices_verdes);
            Bf_val = f_val(indices_azules);
            Tf_val = f_val(indices_texto);
            [~,ind_rojo] = max (abs(Y1(indices_rojos))); % buscar la maxima amplitud de frec del espectro y deja el indice
            [~,ind_verde] = max (abs(Y1(indices_verdes)));
            [~,ind_azul] = max (abs(Y1(indices_azules)));
            [~,ind_texto] = max (abs(Y1(indices_texto)));
            pix(k)=round((Rf_val(ind_rojo)-Rf-delta*(k-1))/dif);
            pix(k+8)=round((Gf_val(ind_verde)-Gf-delta*(k-1))/dif);
            pix(k+16)=round((Bf_val(ind_azul)-Bf-delta*(k-1))/dif);
            pix(k+24)=round((Tf_val(ind_texto)-Tf-delta*(k-1))/dif);
        end
        rojo(i) = bi2de(pix(1:8)); % valor rojo del pixel
        verde(i) = bi2de(pix(9:16)); % valor verde del pixel
        azul(i) = bi2de(pix(17:24)); % valor azul del pixel
        txt(i) = bi2de(pix(25:32)); %valor texto
    end
end

red8 = uint8(reshape(rojo, dim(1),dim(2) )); % Matriz con rojos
green8 = uint8(reshape(verde, dim(1),dim(2) )); % verdes
blue8 = uint8(reshape(azul, dim(1),dim(2))); % azules
txt = reshape(txt, dim(1),dim(2));
xmsg = reshape(txt, 1,16*16);

red_ini=1;
red_end=dim(3);
step = floor(dim(1)*dim(2)./dim(3));
received = [];
% for p=0:dim(3)-1
% chr_aux = xmsg(red_ini+step*p:red_ini+step*(p+1)-1)
% r_char = mode(chr_aux);
% received = cat(2,received,r_char);
% end
for p=1:dim(3)
    received = [];
    i_aux = p;
    while i_aux<dim(1)*dim(2)
        received=cat(2,received,xmsg(i_aux));
        i_aux = i_aux+dim(3);
    end
    ax = received;
    recibido(p)= mode(received);
end
men = native2unicode(recibido);

% texto

%% ==================================== Plots
x0 = 1;
y0 = 1;
width = 6;
height = 6;

figure1 = figure(1);
set(figure1,'Units','inches');
set(figure1,'Position',[x0 y0 width height]);
figure1.PaperPositionMode='auto';

subplot(1,2,1)
 imshow(imread(img));
 xlabel('Normal')
 subplot(1,2,2)
 imshow(cat(3,red8',green8',blue8'));
 xlabel('Recibida')
%imshow(cat(3,red8',green8',blue8'));
%xlabel('Recibida')