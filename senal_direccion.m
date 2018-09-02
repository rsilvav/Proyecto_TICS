function s_direcc = senal_direccion(direccion,size_dt,ttl1,ttl2,ttl3,ttl4)
    s_direcc = sin(0*size_dt);
    if direccion(1) == 1
        s_direcc = s_direcc+sin(2*pi*(ttl4+50)*size_dt);
    end
    if direccion(2) == 1
        s_direcc = s_direcc+sin(2*pi*(ttl3+50)*size_dt);
    end
    if direccion(3) == 1
        s_direcc = s_direcc+sin(2*pi*(ttl2+50)*size_dt);
    end
    if direccion(4) == 1
        s_direcc = s_direcc+sin(2*pi*(ttl1+50)*size_dt);
    end
end