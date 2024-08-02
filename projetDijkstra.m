function distances = projetDijkstra()
    % Coordonnées des villes: Longitude et latitude
    coords = [-2.370, 12.250;   % Koudougou
              -1.530, 12.370;   % Ouagadougou
              -4.290, 11.180;   % Bobo
              -0.360, 11.770;   % Tenkodogo
              -2.420, 13.570;   % Ouahigouya
              -3.470, 12.460;   % Dedougou
              -1.090, 13.090;   % Kaya
              -2.270, 12.960;   % Yako
              -0.030, 14.040;   % Dori
              -3.080, 13.070]; % Tougan

    % La matrice d'adjacence représentant les distances entre les villes
    D = [0,100,242,Inf,Inf,128,Inf,92,Inf,131;
         100,0,360,183,Inf,Inf,98,106,Inf,Inf;
         242,360,0,Inf,Inf,176,Inf,Inf,Inf,Inf;
         Inf,183,Inf,0,Inf,Inf,187,Inf,Inf,Inf;
         Inf,Inf,Inf,Inf,0,Inf,161,73,297,94;
         128,Inf,176,Inf,Inf,0,Inf,Inf,Inf,98;
         Inf,98,Inf,187,161,Inf,0,127,167,Inf;
         92,106,Inf,Inf,73,Inf,127,0,Inf,Inf;
         Inf,Inf,Inf,Inf,297,Inf,167,Inf,0,Inf;
         131,Inf,Inf,Inf,94,98,Inf,Inf,Inf,0];
    
    n = size(D, 1);
    
    % Demander à l'utilisateur de choisir la ville de départ
    disp('Villes disponibles :');
    for i = 1:n
        disp([num2str(i), ': ', nom_ville(i)]);
    end
    ville_depart = input('Choisissez le numéro de votre ville de départ : ');
    
    distances = dijkstra(D, ville_depart);
    
    % Affichage des chemins les plus courts
    disp(['Les chemins les plus courts depuis ', nom_ville(ville_depart), ' :']);
    for i = 1:n
        if i ~= ville_depart
            if isinf(distances(i))
                disp([nom_ville(ville_depart), ' -> ', nom_ville(i), ' : Chemin inaccessible']);
            else
                disp([nom_ville(ville_depart), ' -> ', nom_ville(i), ' : ', num2str(distances(i))]);
            end
        end
    end
    
    % Affichage du graphe avec les coordonnées des villes et les connexions
    figure;
    scatter(coords(:, 1), coords(:, 2), 100, 'filled');
    hold on;
    for i = 1:n
        for j = i+1:n
            if D(i, j) ~= Inf
                if is_shortest_path(i, j, ville_depart, distances, D)
                    % Si le chemin est le plus court, colorer en rouge
                    line([coords(i, 1), coords(j, 1)], [coords(i, 2), coords(j, 2)], 'Color', 'r', 'LineWidth', 2);
                else
                    % Sinon, colorer en bleu (chemin non optimal)
                    line([coords(i, 1), coords(j, 1)], [coords(i, 2), coords(j, 2)], 'Color', 'b');
                end
                % Ajout des étiquettes de distance
                text((coords(i, 1) + coords(j, 1)) / 2, (coords(i, 2) + coords(j, 2)) / 2, num2str(D(i, j)), 'Color', 'r');
            end
        end
    end
    
    % Ajout d'annotations pour mettre en évidence les chemins les plus courts
    for i = 1:n
        if i ~= ville_depart && ~isinf(distances(i))
            chemin = strcat(nom_ville(ville_depart), ' -> ', nom_ville(i), ' : ', num2str(distances(i)));
            text(coords(i, 1), coords(i, 2), chemin, 'BackgroundColor', 'yellow', 'Margin', 1);
        end
    end
    
    for i = 1:size(coords, 1)
        text(coords(i, 1), coords(i, 2), nom_ville(i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    
    % Ajout de la légende sans le chemin non optimal
    legend('Villes', 'Chemin le plus court', 'Location', 'northeast');
    
    title('Carte des villes :');
    xlabel('Longitude');
    ylabel('Latitude');
    grid on;
    hold off;
end 

% Implémentation de l'algorithme de Dijkstra
function distances = dijkstra(D, start_node)
    n = size(D, 1);
    distances = inf(1, n);
    distances(start_node) = 0;
    visited = false(1, n);
 
    for i = 1:n
        u = find_min_distance(distances, visited);
        visited(u) = true;
        for v = 1:n
            if ~visited(v) && D(u, v) ~= 0 && distances(u) + D(u, v) < distances(v)
                distances(v) = distances(u) + D(u, v);
            end
        end
    end
end
 
% La fonction find_min_distances détermine les distances minimales
function u = find_min_distance(distances, visited)
    min_dist = inf;
    u = -1;
    for i = 1:length(distances)
        if ~visited(i) && distances(i) < min_dist
            min_dist = distances(i);
            u = i; 
        end
    end
end

% Vérifie si le chemin entre les villes i et j fait partie du chemin le plus court
function result = is_shortest_path(i, j, ville_depart, distances, D)
    if distances(i) + D(i, j) == distances(j) || distances(j) + D(j, i) == distances(i)
        result = true;
    else
        result = false;
    end
end
 
% Fonction pour obtenir le nom de la ville à partir de son indice
function nom = nom_ville(indice)
    villes = {'Koudougou', 'Ouagadougou', 'Bobo', 'Tenkodogo', 'Ouahigouya', ...
              'Dedougou', 'Kaya', 'Yako', 'Dori', 'Tougan'};

    nom = villes{indice};
end
