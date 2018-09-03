close all
clear
clc
settings;

size_dt = 0:1/fs:1;
r_senal = sin(0*size_dt);
token = 0;
direccion = [0 0 0 1];
s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
if token == 1
    ttl = 4;
    r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt); 
    soundsc(r_senal+s_dir,fs,16);
    pause(1.5);
end

counter = 0;
 while true
    %===== Grabar
    tf = 1.5; % duracion de la grabacion (segs)
    recorder = audiorecorder(fs, 16, 1);
    %set(recorder,'TimerPeriod',1,'TimerFcn',{@audioTimer});
    recordblocking(recorder, tf);
    pause(0.5);
    senal = recorder.getaudiodata;
    %======== PLOT FFT
    frames_dim = length(senal);
    NFFT = 2^nextpow2(frames_dim);
    Y = fft(senal, NFFT)/frames_dim;
    f = fs/2*linspace(0,1,NFFT/2+1);
    a_fft = abs(Y(1:NFFT/2+1));
    [r_ttl r_dir] = get_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4);
    disp(['ttl recibido = ' num2str(r_ttl) ' direccion = ' num2str(r_dir)])
    s_ttl = r_ttl - 1;
    r_senal = sin(0*size_dt);
    if r_ttl == 4 && r_dir > 0
        disp(['ttl enviado = ' num2str(s_ttl)])
        r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt); 
    elseif r_ttl == 3 && r_dir > 0
        disp(['ttl enviado = ' num2str(s_ttl)])
        r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt);
    elseif r_ttl == 2 && r_dir > 0
        disp(['ttl enviado = ' num2str(s_ttl)])
        r_senal = sin(2*pi*(ttl4)*size_dt);
    elseif r_ttl == 1 && r_dir > 0
        disp(['ttl enviado = ' num2str(s_ttl)])
        r_senal = sin(0*size_dt);
    elseif r_ttl == 0 || r_dir == 0
        counter = counter+1;
        %break;
        if counter == 3 && token ==1
            r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
            soundsc(r_senal+s_dir,fs,16);
            pause(1.5);
        elseif counter == 6 && token ==1
            r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
            soundsc(r_senal+s_dir,fs,16);
            pause(1.5);
        elseif counter == 9 && token ==1
             break;
        end
    end
    if r_ttl>1 && r_dir > 0 
        soundsc(r_senal+s_dir,fs,16);
        pause(1.5);
    end
 end
%======== PLOT FFT
%Yxx = fft(r_senal, NFFT)/(length(r_senal));

figure(2)
%subplot(1,2,1)
% xlabel('FFT senal')
%plot(f, 2*a_fft);
 plot(f, 2*abs(Y(1:NFFT/2+1)));
%xlabel('Senal')
%plot(t,senal);
 %subplot(1,2,2)
% xlabel('FFT senal')
%plot(f, 2*xa_fft);
 %plot(f, 2*abs(Yx(1:NFFT/2+1)));
% xlabel('Frecuencia (Hz)')
% ylabel('Amplitud')
%subplot(1,3,3)
%plot(f, 2*abs(Yxx(1:NFFT/2+1)));