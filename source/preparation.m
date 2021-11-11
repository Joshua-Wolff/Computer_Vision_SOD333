function [HauteurRef, LargeurRef, histoRef, x_init, y_init, T,filenames, Cmap] = preparation(previsualisation, plot_histo, sequence, Nb)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % lecture de l'ensemble des images %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % numero de la premiere image a traiter
    START = 1;

    % chargement du nom des images de la sequence
    filenames = dir([sequence '*.png']);
    filenames = sort({filenames.name});
    T = length(filenames);

    %%%%%%%%%%%%%%%%%%%%
    % Previsualisation %
    %%%%%%%%%%%%%%%%%%%%

    if previsualisation


        % chargement de la premiere image
        tt = START;
        im = imread([sequence filenames{tt}]);

        figure;
        set(gcf,'DoubleBuffer','on');

        imagesc(im);
        text(10,10,strcat(num2str(tt),'/',num2str(T)),'Color','r');
        disp('pause apres chaque image (taper sur une touche pour continuer)');
        disp(['---------- ' filenames{tt} ' ---------------' ]);
        pause;

        while tt <= T-1
        % chargement de l'image suivante
           tt = tt+1;
           im = imread([sequence filenames{tt}]);
           if isempty(im)
              break;
           end
        % affichage de l'image et de son numero dans la sequence
           imagesc(im);
           text(10,10,strcat(num2str(tt),'/',num2str(T)),'Color','r');
           disp(['---------- ' filenames{tt} ' ---------------' ]);
           pause;
        end

        disp('fin de la pre-visualisation (taper sur une touche pour quitter)');
        pause
        close
        disp('fin de la pre-visualisation');

    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Affichage de la première image %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % chargement la premiere image
    tt = START;
    im = imread([sequence filenames{tt}]);

    % affichage de la premiere image
    figure;
    set(gcf,'DoubleBuffer','on');
    imagesc(im);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Selection (a la souris) de la zone a suivre %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('Cliquer 4 points dans l''image pour definir la zone a suivre.');
    zone = zeros(2,4);
    compteur=1;
    while(compteur ~= 5)
        [x,y,button] = ginput(1);
        zone(1,compteur) = x;
        zone(2,compteur) = y;
        text(x,y,'X','Color','r');
        compteur = compteur+1;
    end
    newzone = zeros(2,4);
    newzone(1,:) = sort(zone(1,:));
    newzone(2,:) = sort(zone(2,:));
    % definition des parametres de la zone a suivre
    % x haut gauche, y haut gauche, largeur, hauteur
    zoneAT = zeros(1,4);
    zoneAT(1) = newzone(1,1);
    zoneAT(2) = newzone(2,1);
    zoneAT(3) = newzone(1,4)-newzone(1,1);
    zoneAT(4) = newzone(2,4)-newzone(2,1);
    % affichage du rectangle
    rectangle('Position',zoneAT,'EdgeColor','r','LineWidth',3);
    LargeurRef = zoneAT(3);
    HauteurRef = zoneAT(4);
    x_init = zoneAT(1) + LargeurRef/2;
    y_init = zoneAT(2) + HauteurRef/2;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù%%%%%%%%%%%
    % Calcul de l'histogramme de couleur associé %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    littleim = imcrop(im,zoneAT(1:4));
    [~,Cmap] = rgb2ind(littleim,Nb,'nodither');
    littleim = rgb2ind(littleim,Cmap,'nodither');
    histoRef = imhist(littleim,Cmap);
    histoRef = histoRef/sum(histoRef);

    % affichage de l’histogramme
    if plot_histo
        figure;
        imhist(littleim,Cmap);
    end


end