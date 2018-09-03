function s_direcc = senal_direccion(direccion,size_dt,s1,s2,s3,s4)
    s_direcc = sin(0*size_dt);
    if direccion(1) == 1
        s_direcc = s_direcc+sin(2*pi*(s4)*size_dt);
    end
    if direccion(2) == 1
        s_direcc = s_direcc+sin(2*pi*(s3)*size_dt);
    end
    if direccion(3) == 1
        s_direcc = s_direcc+sin(2*pi*(s2)*size_dt);
    end
    if direccion(4) == 1
        s_direcc = s_direcc+sin(2*pi*(s1)*size_dt);
    end
end