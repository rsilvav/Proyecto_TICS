function [r] = check(v_r)
    settings;
    vecinos = v_r(1,:);
    r_vecinos = v_r(2,:);
    stop = v_r(3,:);
    counter = v_r(4,:);
    my_dir = v_r(5,:);
    ttls = [ttl1 ttl2 ttl3 ttl4];
    len_ttls = length(ttls);
    tf = 1.5; % duracion de la grabacion (segs)
    size_dt = 0:1/fs:1;
    tf = 1.5; % duracion de la grabacion (segs)
    len = length(vecinos);
    resolver = 0;
    for i = 1:len
        dir = vecinos(i);
        if dir ~0     
            direccion = de2bi(dir,4);
            s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
            disp(['chequear vecino ' num2str(dir)])
            soundsc(s_dir,fs,16);
            pause(1.5);
            recorder = audiorecorder(fs, 16, 1);
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
            if r_dir == dir 
                r_vecinos(i) = r_dir;
                resolver = 1;
            end
            
            if resolver == 1;
                display('call resolver')
                direccion = [1 1 1 1];
                s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
                soundsc(s_dir,fs,16);
                pause(1.5);
                recorder = audiorecorder(fs, 16, 1);
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
                if r_ttl > 1
                    display('duplicados')
                    for k=0:len_ttls-1
                        xdir = 2^k;
                        xdireccion = de2bi(xdir,4);
                        resolver = senal_direccion(xdireccion,size_dt,s1,s2,s3,s4);
                        soundsc(resolver,fs,16);
                        pause(1.5);           
                        recorder = audiorecorder(fs, 16, 1);
                        recordblocking(recorder, tf);
                        pause(0.5);
                        senal = recorder.getaudiodata;
                         %======== PLOT FFT
                        Y = fft(senal, NFFT)/frames_dim;
                        a_fft = abs(Y(1:NFFT/2+1));
                        [aux_ttl aux_dir] = get_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4);
                        repetido = vecinos(vecinos==aux_dir);
                        len_rep = length(repetido);
                        if aux_dir ~= 0 && len_rep == 0 && aux_ttl == 0
                            vecinos = cat(2,vecinos,aux_dir);
                            r_vecinos = cat(2,r_vecinos,0);
                            counter = zeros(length(vecinos(1)),length(vecinos));
                            my_dir = mi_dir*ones(length(vecinos(1)),length(vecinos));
                        end
                    end
                    r = [vecinos; r_vecinos;stop;counter;my_dir];
                    r = check(r);
                    resolver = 0;
                elseif r_ttl == 1
                    display('1 Respuesta')
                    counter = counter + ones(length(vecinos(1)),length(vecinos));
                    %r_vecinos = zeros(length(vecinos(1)),length(vecinos));
                    r = [vecinos; r_vecinos;stop;counter;my_dir];
                    
                    if counter == 3*ones(length(vecinos(1)),length(vecinos));
                        %display('Besser')
                        len = length(vecinos(1));
                        for l=1:len;
                            vecinos(l) = 0;
                        end
                    else
                        r = check(r);
                    end
                    resolver = 0;
                elseif r_ttl == 0
                    display('0 Respuestas');
                    counter = counter +1;
                    vecinos(i) = mydir(i);
                    r = [vecinos;r_vecinos;stop;counter;mydir];
                    r = check(r);
                end      
            end
        end 
    end
    r = [vecinos;r_vecinos;stop;counter;mydir];
end