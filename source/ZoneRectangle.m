function zone = ZoneRectangle(particles, n, LargeurRef, HauteurRef)
    % Calcul de la zone du rectangle associé à la particule n
        
    % Initialisation de la zone
    zone = zeros(1,4);
    
    % definition des parametres de la zone a suivre
    % x bas gauche, y bas gauche, largeur, hauteur
    zone(3)= particles(1,n,3)/100 * LargeurRef;
    zone(4)= particles(1,n,3)/100 * HauteurRef;
    zone(1)= particles(1,n,1) - zone(3)/2;
    zone(2)= particles(1,n,2) - zone(4)/2;
    
end