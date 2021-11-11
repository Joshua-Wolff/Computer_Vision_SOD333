function [histo, poids] = histogramme(particles, N, histoRef, Nb, im, LargeurRef, HauteurRef, lambda, Cmap) 
    % Calcul des histogrammes et des poids des particules 
    
    % Initialisation des listes des histogrammes et des listes de poids
    histo = [];
    poids = [];
    
    % Boucle sur les particules
    for n=1:N
        
        % Calcul de la zone de la particule et vérification de sa validité
        zone = ZoneRectangle(particles, n, LargeurRef, HauteurRef);
        zone_valid = ZoneDansImage(im, zone);
        
        % Si la particule est valide, on calcul son histogramme, sinon on
        % lui attribue un histogramme nul et on fixe plus tard son poids à
        % zero
        if zone_valid
            
            impart = imcrop(im,zone);
            impart = rgb2ind(impart,Cmap,'nodither');
            histo_n = imhist(impart,Cmap);
            histo_n = histo_n/sum(histo_n);
        else
            histo_n = zeros(Nb);
        end

        % bug fix
        valid = zone_valid;
        if size(histo_n) ~= Nb
            histo_n = zeros(Nb);
            valid = false;
        end
        
        % Stockage de l'histogramme de la particule n dans la liste des
        % hitsogrammes
        histo = [histo, histo_n];
        
        % Si la particule est valide on calcule son poids, sinon on le fixe
        % à zero
        if valid
            poids = [poids, [exp(-lambda * dist_hist(histo_n, histoRef, Nb)^2)]];
        else
            poids = [poids, [0]];
        end
    end
    
    % Normalisation des poids
    poids = poids/sum(poids);
end



function d = dist_hist(histo, ref, Nb)

    % Calcul de la distance entre deux histogrammes %
    d = 0;
    
    % Boucle sur les couleurs pour calculer la somme comprise dans la distance 
    for i=1:Nb
        d = d + sqrt(histo(i) * ref(i));
    end
    
    d = sqrt(1 - d);
    
end

function res = ZoneDansImage(im, zone)
    % Verifie que la zone est dans l'image %

    % Initialisation du résultat
    res = true;
    
    % On vérifie qie les coordonées de la zone sont positives
    if zone(1) < 0 || zone(2) < 0
        res = false;
    end
    
    % On récupére les valeurs extremes de l'image
    size_im = size(im);
    x_max = size_im(2);
    y_max = size_im(1);
    
    % On vérifie qu'on ne dépassse pas les valeurs extremes
    if zone(1) + zone(3) > x_max || zone(2) + zone(4) > y_max
        res = false;
    end
end