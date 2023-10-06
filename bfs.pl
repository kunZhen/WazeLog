% Predicado para calcular la ruta mas corta
parcialBFS(Inicio, Fin, Ruta, Distancia) :-
    parcialBFS(Inicio, Fin, [Inicio], 0, RutaInversa, Distancia),
    reverse(RutaInversa, Ruta).

% Caso base
parcialBFS(Nodo, Nodo, Ruta, Distancia, Ruta, Distancia).

% Caso recursivo para el calculo de la ruta mas corta 
parcialBFS(Inicio, End, Ruta, Distancia, Ruta_final, Distancia_Final) :-
    conexion(Inicio, Nodo_siguiente, Distancia_hasta_siguiente),
    \+ member(Nodo_siguiente, Ruta), % Evitar ciclos
    Nueva_distancia is Distancia + Distancia_hasta_siguiente,
    parcialBFS(Nodo_siguiente, End, [Nodo_siguiente | Ruta], Nueva_distancia, Ruta_final, Distancia_Final).

% Predicado para encontrar la ruta corta entre el punto de partida y final
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

eliminarUltimoElemento([_], []).
eliminarUltimoElemento([X|Xs], [X|Resto]) :- eliminarUltimoElemento(Xs, Resto). 

% Predicado para calcular la ruta entre dos nodos, se emplea en la rutaEntreTres para calcular el punto de inicio a la parada y luego de la parada al destino 
rutaEntre(Inicio, Final, Ruta, Distancia) :-
    parcialBFS(Inicio, Final, Ruta, Distancia).

% Se encarga de devolver la ruta mas corta del punto de inicio, parada y final
rutaEntreTres(Inicio, Intermedio, Final, Ruta, Distancia) :-
    rutaEntre(Inicio, Intermedio, Ruta1, Distancia1),
    rutaEntre(Intermedio, Final, Ruta2, Distancia2),
    eliminarUltimoElemento(Ruta1, Ruta1_ultimoEliminar), % Elimina el ultimo elemento de Ruta1 
    append(Ruta1_ultimoEliminar, Ruta2, Ruta), % Combina rutas
    Distancia is Distancia1 + Distancia2. 

% Encuentra todas las rutas entre tres nodos y las junta en una lista
rutaEntreTres(Inicio, Intermedio, Final, RutaCorta) :-
    findall([Ruta, Distancia], rutaEntreTres(Inicio, Intermedio, Final, Ruta, Distancia), TodasRutas), minimo(TodasRutas, RutaCorta).
