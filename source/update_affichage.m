
function particles = update_affichage(im, i, particles, N, LargeurRef, HauteurRef, poids_n)

    % Affichage de la nouvelle image
    imagesc(im);
    
    % Initialisation des composante de la particule moyenne
    x = 0;
    y = 0;
    s = 0;
    
    for n=1:N      
           % Affiche de la particule si son poids est positif
           if poids_n(n) > -10
            zone = ZoneRectangle(particles(i,:,:), n, LargeurRef, HauteurRef);   
           	rectangle('Position',zone,'EdgeColor','r','LineWidth',1);
           end
           
           % Mise a jour des coordonnées de la particule moyenne
           x = x + particles(i,n,1) *  poids_n(n);
           y = y + particles(i,n,2) *  poids_n(n);
           s = s + particles(i,n,3) *  poids_n(n);
    end
    
    % Stockage de la particule moyenne dans le tableau de particule et
    particles(i,N+1,1) = x;
    particles(i,N+1,2) = y;
    particles(i,N+1,3) = s;
    
    % Affichage de la particule moyenne
    zone = ZoneRectangle(particles(i,:,:), N+1, LargeurRef, HauteurRef);
    rectangle('Position',zone,'EdgeColor','b','LineWidth',3);
end