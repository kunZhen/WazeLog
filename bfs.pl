% Predicado para calcular la ruta mas corta
parcialBFS(Inicio, Fin, Ruta, Distancia) :-
    parcialBFS(Inicio, Fin, [Inicio], 0, RutaInversa, Distancia),
    reverse(RutaInversa, Ruta).

% Caso base
parcialBFS(Nodo, Nodo, Ruta, Distancia, Ruta, Distancia).

% Caso recursivo
parcialBFS(Inicio, End, Ruta, Distancia, Ruta_final, Distancia_Final) :-
    conexion(Inicio, Nodo_siguiente, Distancia_hasta_siguiente),
    \+ member(Nodo_siguiente, Ruta), % Evitar ciclos
    Nueva_distancia is Distancia + Distancia_hasta_siguiente,
    parcialBFS(Nodo_siguiente, End, [Nodo_siguiente | Ruta], Nueva_distancia, Ruta_final, Distancia_Final).

% Predicado para encontrar
bfs(Inicio, Fin, RutaCorta) :-
    findall([Ruta, Distancia], parcialBFS(Inicio, Fin, Ruta, Distancia), TodasRutas), minimo(TodasRutas, RutaCorta).

% Se encarga de obtener el punto de inicio, destino o intermedio
obtener_distancia([X], X).
obtener_distancia([_|Resto], Ultimo):- 
	obtener_distancia(Resto, Ultimo).

% Caso base: El minimo de una lista con un solo elemento es ese elemento.
minimo([Minimo], Minimo).

% Caso recursivo: Comparamos el primer elemento con el minimo del resto de la lista.
minimo([PrimerElemento|Resto], Minimo) :-
    minimo(Resto, MinimoResto),
    obtener_distancia(PrimerElemento, DistanciaRuta1),
    obtener_distancia(MinimoResto, DistanciaRuta2),
    (DistanciaRuta1 < DistanciaRuta2 -> Minimo = PrimerElemento ; Minimo = MinimoResto).

% Example:
% Find all routes between two different nodes, like "sanJose" and "turrialba"
% Call bfs(sanJose, turrialba, Rutas).

eliminarUltimoElemento([_], []).
eliminarUltimoElemento([X|Xs], [X|Resto]) :- eliminarUltimoElemento(Xs, Resto). 

% Predicate to calculte the route between two nodes
rutaEntre(Inicio, Final, Ruta, Distancia) :-
    parcialBFS(Inicio, Final, Ruta, Distancia).

rutaEntreTres(Inicio, Intermedio, Final, Ruta, Distancia) :-
    rutaEntre(Inicio, Intermedio, Ruta1, Distancia1),
    rutaEntre(Intermedio, Final, Ruta2, Distancia2),
    eliminarUltimoElemento(Ruta1, Ruta1_ultimoEliminar), % Elimina el ultimo elemento de Ruta1 
    append(Ruta1_ultimoEliminar, Ruta2, Ruta), % Combina rutas
    Distancia is Distancia1 + Distancia2. 

rutaEntreTres(Inicio, Intermedio, Final, RutaCorta) :-
    findall([Ruta, Distancia], rutaEntreTres(Inicio, Intermedio, Final, Ruta, Distancia), TodasRutas), minimo(TodasRutas, RutaCorta).

% Example of use:
% Calcule the route between "sanJose", "cartago" y "turrialba"
% Call rutaEntreTres(sanJose, cartago, turrialba, RutaCorta).

%Predicado para calcular la ruta entre 3 nodos: inicio, intermedio, y final.
todasRutasEntre(Inicio,Intermedio,Final,Rutas,Distancia):-
    findall((Ruta,Distancia),rutaEntreTres(Inicio,Intermedio,Final,Ruta,Distancia),Rutas).

encuentra_ruta_menor_distancia_en_rutas(Rutas, RutaMenorDistancia, DistanciaMenor) :-
    % Encuentra la distancia minima en la lista de rutas
    findall(Distancia, member((_, Distancia), Rutas), Distancias),
    min_list(Distancias, DistanciaMenor), % Encuentra la distancia mínima
    % Encuentra la primera ruta que tiene la distancia mínima
    member((RutaMenorDistancia, DistanciaMenor), Rutas).