function [r_ttl r_dir] = get_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4)
    r_ttl = 0;
    r_dir = 0;
    [c1 i_ttl1] = min(abs(f-ttl1));
    [c2 i_ttl2] = min(abs(f-ttl2));
    [c3 i_ttl3] = min(abs(f-ttl3));
    [c4 i_ttl4] = min(abs(f-ttl4));
    
    if a_fft(i_ttl1) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_ttl = r_ttl + 1;
    end
    if a_fft(i_ttl2) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_ttl = r_ttl + 1;
    end
    if a_fft(i_ttl3) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_ttl = r_ttl + 1;
    end
    if a_fft(i_ttl4) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_ttl = r_ttl + 1;
    end
    
    [c1 i_d1] = min(abs(f-ttl1+50));
    [c2 i_d2] = min(abs(f-ttl2+50));
    [c3 i_d3] = min(abs(f-ttl3+50));
    [c4 i_d4] = min(abs(f-ttl4+50));
    
    if a_fft(i_d1) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_dir = r_dir+8;
    end
    if a_fft(i_d2) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_dir = r_dir+4;
    end
    if a_fft(i_d3) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_dir = r_dir+2;
    end
    if a_fft(i_d4) >= mean(a_fft(i_ttl1-10:end))+2*std(a_fft(i_ttl1-10:end))
        r_dir = r_dir+1;
    end
end