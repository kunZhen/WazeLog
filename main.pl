/*

main.pl corresonde al archivo principal para ejecutar el sistema experto WazeLog.

*/

:-consult('wazeLogDB.pl').
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
	is_list(Oracion),
	lista_vacia(Oracion, true),
	writeln('De acuerdo, entonces su ruta... '),nl,
	inicio_aux(),
	!.
validacion_gramatical(Oracion):-
	nl, 
	writeln('Oracion gramaticalmente incorrecta'),
	nl,
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----- Gracias por utilizar WazeLog. Ejecuta comenzar(). para reiniciar -----'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'), fail.

respuesta_saludo(Nombre):-
	write('Hola '),
	write(Nombre).

despedida():-
	writeln('Gracias por utilizar WazeLog, esperamos que haya sido de su agrado.').

% Operaciones Basicas ------------------------------------------------------------------------------------------------------------

lista_vacia(List, Empty) :-
    length(List, Len),
    (   Len =< 1
    ->  Empty = true
    ;   Empty = false
    ).

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



% --------------------------------- Sistema Experto (SE) ---------------------------------

bienvenida():-
    write('Bienvenido a WazeLog, la mejor logica para llegar a su destino.'),nl,nl.

comenzar():-
    bienvenida(),
	writeln('Indique su nombre:'), 
	input_to_string(Nombre), nl,
	respuesta_saludo(Nombre), 
	comenzar_aux().

comenzar_aux():-
	encuentro(OracionEncuentro),
	obtener_lugar(OracionEncuentro, Encuentro),
	writeln(Encuentro), !, nl,

	llegada(OracionLlegar),
	obtener_lugar(OracionLlegar, Llegar),
	writeln(Llegar), nl,

	intermedio(OracionIntermedio), 
	writeln('Se llegoooooo').

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