%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selection des meta-données %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Previsualisation de la sequence
PREVISUALISATION = false;
% Affichage de l'histogramme de reference
PLOT_HISTO = false;
% repertoire contenant la sequence a traiter
SEQUENCE = './seq1/seq1/';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des paramètres %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 100;
Nb = 10;
lambda = 20;
c1 = 1000;
c2 = 500;
c3 = 100;

%%%%%%%%%%%%%%%
% Preparation %
%%%%%%%%%%%%%%%
[HauteurRef, LargeurRef, histoRef, x_init, y_init, T, filenames, Cmap] = preparation(PREVISUALISATION, PLOT_HISTO, SEQUENCE, Nb);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des particules %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Récupération de la premiere particule
first_part = [x_init y_init 100];

% Création du tableau des particles à l'état initial, c'est à dire N fois
% la première particule
part_0 = [first_part];
for k = 1:N-1
    part_0 = [part_0; first_part];
end

% Création du tableau des particules en 3d: temps*numéro
% particule*coordonnée
particles = part_0;
particles(:,:,2) = part_0;
particles = permute(particles, [3,1,2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diffusion des particules %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pause
for i=2:T
    
    disp("Instant : " + i)
    
    % Diffusion
    particles(i,:,:) = diffusion(particles(i,:,:), c1, c2, c3, N);

    %Cacul des poids
    im = imread([SEQUENCE filenames{i}]);
    [histo_n, poids_n] = histogramme(particles(i,:,:), N, histoRef, Nb, im, LargeurRef, HauteurRef, lambda, Cmap);
    
    % Affichage 
     particles = update_affichage(im, i, particles, N, LargeurRef, HauteurRef, poids_n);

    % Rééchantillonage
    particles(i + 1,:,:) = resample(particles, N, i, poids_n);
    
    pause
    
end