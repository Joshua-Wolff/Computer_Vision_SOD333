function new_part = diffusion(particles, c1, c2, c3, N) 
    % Diffusion des particules selon l'équation d'état %
    new_part = particles;
    for n=1:N
        new_part(1,n,1) = new_part(1,n,1) + normrnd(0,sqrt(c1));
        new_part(1,n,2) = new_part(1,n,2) + normrnd(0,sqrt(c2));
        new_part(1,n,3) = new_part(1,n,3) + normrnd(0,sqrt(c3));
    end
end