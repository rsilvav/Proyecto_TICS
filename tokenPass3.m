% Token Passing
% Caso n = 3
close all
clear
clc

settings;
contador = 1;
token = 1;
size_dt = 0:1/fs:1;
txt = fopen('tics.txt','r+'); % Nombre imagen, destinatario
prompt_img = 'twitter.png';

dir_destino = 3; % por decir alguna...
direccion_dec = 1; % 1, 2 ó 3 en número decimal

while true
    % Escucha
    disp('Escuchando')
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
    [r_ttl,r_dir] = get_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4);
    disp(['ttl recibido = ' num2str(r_ttl) ' direccion = ' num2str(r_dir)])
%     s_ttl = r_ttl - 1;
%     r_senal = sin(0*size_dt);

    if token == 1
        r_ttl = 4;
        r_dir = direccion_dec;
        token = 0;
    end
    
    if r_ttl == 4 && r_dir == direccion_dec         % Escucha su direccion
        
        if direccion_dec == 1 || direccion_dec == 3 % Caso dir=1 o dir=3, envia 2
            direccion = [0 1 0 0];
            dir_dec = 2;
            s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
            r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
            soundsc(r_senal+s_dir,fs,16);
            disp(['Enviando dirección ' num2str(dir_dec)])
            pause(1.5);
        elseif direccion_dec == 2                   % Caso dir=2
            if contador == 1
                direccion = [1 0 0 0];
                dir_dec = 1;
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
                r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
                soundsc(r_senal+s_dir,fs,16);
                disp(['Enviando dirección ' num2str(dir_dec)])
                pause(1.5);
                contador = contador + 2;
            elseif contador == 3
                direccion = [1 1 0 0];
                dir_dec = 3;
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
                r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
                soundsc(r_senal+s_dir,fs,16);
                disp(['Enviando dirección ' num2str(dir_dec)])
                pause(1.5);
                contador = 1;
            end
        end
        
    elseif r_ttl > 0 && r_ttl < 3 && r_dir == direccion_dec
        if direccion_dec == 1 || direccion_dec == 3
            direccion = [0 1 0 0];
            s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
        elseif direccion_dec == 2
            if contador == 1
                direccion = [1 0 0 0];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
                contador = contador + 2;
            elseif contador == 3
                direccion = [1 1 0 0];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
                if contador > 1
                    contador = 1;
                end
            end
        end
        disp('Receptor')
        RX
        pause(2)
        
        if dir_destino == direccion_dec % Si era el destinatario, no
            break                       % repite la transmision
        end
        
        r_trigger = sin(2*pi*(0)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
        soundsc(r_trigger+s_dir,fs,16);
        TX % Repiten la transmisión de la imagen
    end
    imagen = fgetl(txt);
    if imagen ~= -1
        destino = fgetl(txt);
        if str2double(destino) == dir_destino
            fprintf(txt,' interrupt');
            frewind(txt)
            if direccion_dec == 1
                direccion = [1 0 0 0];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
            elseif direccion_dec == 2
                direccion = [0 1 0 0];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
            elseif direccion_dec == 3
                direccion = [1 1 0 0];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
            end
            r_trigger = sin(2*pi*(0)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);
            soundsc(r_trigger+s_dir,fs,16); % Primero en enviar la imagen
            pause(1.5)
            TX
            end
%             TX
        end
%     end
    frewind(txt)
    disp(imagen)
    disp(destino)
end % while true
