/*

main.pl corresonde al archivo principal para ejecutar el sistema experto WazeLog.

*/

:-consult('wazeLogDB.pl').
:-consult('bfs.pl').
:-style_check(-singleton).

% BNF -------------------------------------------------------------------------------------------------------------------------------------

% Descripción		:	recibe una lista de palabras y una lista vacía y verifica si es una oración gramaticalmente correcta según la estructura establecida
% Nombre de Regla	:	oracion([A],[B])
% Parámetro			:	lista para revisar y lista vacía
% Uso				:	se utiliza para validar oraciones
oracion(A,B):-
	sintagma_nominal(A,C),
	sintagma_verbal(C,B).

% Descripción		:	recibe una lista de palabras y una lista vacía; elimina el primer sintagma nominal encontrado y devuelve el resto de las palabras
% Nombre de Regla	:	sintagma_nominal([A],[B])
% Parámetro			:	lista a revisar y lista vacía
% Uso				:	se utiliza para encontrar el primer sintagma nominal en una lista de palabras
sintagma_nominal(A,B):-
	determinante_n(A,C),
	sustantivo_m(C,B).

% Descripción		:	recibe una lista de palabras y una lista vacía; elimina el primer sintagma verbal encontrado y devuelve el resto de las palabras
% Nombre de Regla	:	sintagma_verbal([A],[B])
% Parámetro			:	lista a revisar y lista vacía
% Uso				:	se utiliza para encontrar el primer sintagma verbal en una lista de palabras
sintagma_verbal(A,B):-
	verbo(A,B).
sintagma_verbal(A,B):-
	verbo(A,C),
	sintagma_nominal(C,B).

% ValidaciÓn Gramatical, Saludo, Despedida ------------------------------------------------------------------------------------------------

% Descripción		:	valida si la oración digitada por el usuario está gramaticalmente correcta según el BNF establecido
% Nombre de Regla	:	validacion_gramatical()
% Parámetro			:	lista a revisar
% Uso				:	Se utiliza para verificar gramaticalmente una oración, de lo contrario, devolver un mensaje al usuario
validacion_gramatical(Oracion):-
	oracion(Oracion,[]),
	!.
validacion_gramatical(Oracion):-
	respuesta_si_no(Oracion, Valor),
	!.
validacion_gramatical(Oracion):-
	nl, 
	writeln('Oracion gramaticalmente incorrecta'), 
	despedida().

validar_lugar(Lugar):- lugar(Lugar), !.
validar_lugar(Lugar):- nl, writeln('El lugar que se indica no se encuentra en nuestra base de conocimiento. Por favor, revisar el Manual de Usuario.'), despedida().

respuesta_saludo(Nombre):-
	write('Hola '),
	write(Nombre).

despedida():-
	nl, nl,
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----- Gracias por utilizar WazeLog. Ejecuta comenzar(). para reiniciar -----'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'), fail.

ruta_a_tomar(Nombre, [Ruta|Distancia]):-
	write('De acuerdo '), write(Nombre),
	write('. La ruta a tomar es: '), separar_ruta(Ruta), nl,
	tiempo_estimado(Distancia, TiempoEstimado), tiempo_en_presa(Distancia, TiempoEnPresa),
	write('Tiempo estimado: '), write(TiempoEstimado), write(' minutos'), nl,
	write('Tiempo si hay presa: '), write(TiempoEnPresa), write(' minutos').


separar_ruta([]):- write('FIN :D').
separar_ruta([Lugar|Resto]):- 
	write(Lugar), write(' -> '), separar_ruta(Resto).


% Operaciones Basicas ------------------------------------------------------------------------------------------------------------

lista_vacia(List, Empty) :-
    length(List, Len),
    (   Len =< 1
    ->  Empty = true
    ;   Empty = false
    ).

respuesta_si_no([Respuesta|Resto], Valor):-
	Respuesta = no -> Valor = true; Valor = false.

input_to_list(L):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs),
	atomic_list_concat(L,' ',A).
input_to_string(A):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs).
list_to_string(List, String):-
	atomic_list_concat(List, ' ', String).

concatenar([],L,L).
concatenar([X|L1],L2,[X|L3]):-
	concatenar(L1,L2,L3).

eliminar_primeros(L,Y,B):- length(X, B), append(X,Y,L).

% Se encarga de obtener el punto de inicio, destino o intermedio
obtener_lugar([X], X).
obtener_lugar([_|Resto], Ultimo):- 
	obtener_lugar(Resto, Ultimo).

tiempo_estimado(Distancia, Tiempo):-
	Tiempo is Distancia * 2.

tiempo_en_presa(Distancia, Tiempo):-
	Tiempo is Distancia * 3.

% --------------------------------- Sistema Experto (SE) ---------------------------------

bienvenida():-
    write('Bienvenido a WazeLog, la mejor logica para llegar a su destino.'),nl,nl.

comenzar:-
    bienvenida(),
	writeln('Indique su nombre:'), 
	input_to_string(Nombre), nl,
	respuesta_saludo(Nombre), 
	comenzar_aux(Nombre).

comenzar_aux(Nombre):-
	encuentro(OracionEncuentro),
	obtener_lugar(OracionEncuentro, Encuentro),
	validar_lugar(Encuentro),
	writeln(Encuentro), !, nl,

	llegada(OracionLlegar),
	obtener_lugar(OracionLlegar, Llegar),
	validar_lugar(Llegar),
	writeln(Llegar), nl,

	intermedio(OracionIntermedio), 
	obtener_lugar(OracionIntermedio, Intermedio),
	writeln(Intermedio), nl,
	rutaEntreTres(Encuentro, Intermedio, Llegar, RutaCorta), 
	ruta_a_tomar(Nombre, RutaCorta), despedida().

encuentro(OracionEncuentro):-
	writeln('. Por favor indicame donde se encuentra.'),
	input_to_list(OracionEncuentro),
	validacion_gramatical(OracionEncuentro).

llegada(OracionLlegar):-
	writeln('¿Donde desea llegar?'), 
	input_to_list(OracionLlegar),
	validacion_gramatical(OracionLlegar).

intermedio(OracionIntermedio):-
	writeln('¿Algun destino intermedio?'), 
	input_to_list(OracionIntermedio),
	validacion_gramatical(OracionIntermedio).


?- write(' '),nl.
?- write('------------------------------- WazeLog -------------------------------'),nl.
?- write('Sistema experto desarrollado por: Mauro Navarro, Isaac Solis, Kun Zheng'),nl.
?- write('Escriba comenzar(). para iniciar.'),nl,nl.