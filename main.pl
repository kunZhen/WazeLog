/*

main.pl corresonde al archivo principal para ejecutar el sistema experto WazeLog.

*/

:-consult('wazeLogDB.pl').
:-consult('bfs.pl').
:-style_check(-singleton).

% BNF -------------------------------------------------------------------------------------------------------------------------------------

% Recibe una lista de palabras y una lista vacía y verifica si es una oración gramaticalmente correcta según la estructura establecida; se utiliza para validar oraciones
oracion(A,B):-
	sintagma_nominal(A,C),
	sintagma_verbal(C,B).

% Recibe una lista de palabras y una lista vacía; elimina el primer sintagma nominal encontrado y devuelve el resto de las palabras; se utiliza para encontrar el primer sintagma nominal en una lista de palabras
sintagma_nominal(A,B):-
	determinante_n(A,C),
	sustantivo_m(C,B).

% Recibe una lista de palabras y una lista vacía; elimina el primer sintagma verbal encontrado y devuelve el resto de las palabras; se utiliza para encontrar el primer sintagma verbal en una lista de palabras
sintagma_verbal(A,B):-
	verbo(A,B).
sintagma_verbal(A,B):-
	verbo(A,C),
	sintagma_nominal(C,B).

% Validación, Saludo, Despedida, Indicaciones de Ruta ------------------------------------------------------------------------------------------------

% Valida si la oración digitada por el usuario está gramaticalmente correcta según el BNF establecido; se utiliza para verificar gramaticalmente una oración, de lo contrario, devolver un mensaje al usuario
validacion_gramatical(Oracion):-
	oracion(Oracion,[]),
	!.

:- discontiguous validacion_gramatical/1.
validacion_gramatical(Nombre, Oracion, Encuentro, Llegar):-
	negacion(Oracion), 
	bfs(Encuentro, Llegar, RutaCorta), 
	ruta_a_tomar(Nombre, RutaCorta),
	!.

validacion_gramatical(Nombre, Oracion, Encuentro, Llegar):- 
	validacion_gramatical(Oracion), !. 

validacion_gramatical(Oracion):-
	nl, 
	writeln('Oracion gramaticalmente incorrecta'), 
	despedida().

% Valida si el lugar digitado por el usuario se encuentra en la base de conocimiento; de lo contrario, devolvera un mensaje al usuario
validar_lugar(Lugar):- lugar(Lugar), !.
validar_lugar(Lugar):- nl, writeln('El lugar que se indica no se encuentra en nuestra base de conocimiento. Por favor, revisar el Manual de Usuario.'), despedida().

% Saluda al usuario
respuesta_saludo(Nombre):-
	write('Hola '),
	write(Nombre).

% Se despide del usuario
despedida():-
	nl, nl,
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----- Gracias por utilizar WazeLog. Ejecuta comenzar(). para reiniciar -----'),
	writeln('----------------------------------------------------------------------------'),
	writeln('----------------------------------------------------------------------------'), fail.

% Encargado de mostrar la ruta a tomar con su respectivo tiempo estimado y en caso de haber presa
ruta_a_tomar(Nombre, [Ruta|Distancia]):-
	write('De acuerdo '), write(Nombre),
	write('. La ruta a tomar es: '), separar_ruta(Ruta), nl,
	tiempo_estimado(Distancia, TiempoEstimado), tiempo_en_presa(Distancia, TiempoEnPresa),
	write('Tiempo estimado: '), write(TiempoEstimado), write(' minutos'), nl,
	write('Tiempo si hay presa: '), write(TiempoEnPresa), write(' minutos'), despedida().

% Se encarga de escribir en consolta cada lugar de la ruta
separar_ruta([]):- write('FIN :D').
separar_ruta([Lugar|Resto]):- 
	write(Lugar), write(' -> '), separar_ruta(Resto).


% Otras operaciones ------------------------------------------------------------------------------------------------------------

% Encargado de convertir una línea de entrada en una lista de palabras.
input_to_list(L):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs),
	atomic_list_concat(L,' ',A).

% Encargado de convertir una línea de entrada en un string.
input_to_string(A):-
	read_line_to_codes(user_input,Cs),
	atom_codes(A,Cs).

% Encargado de obtener el punto de partida, final y el intermedio
obtener_lugar([X], X).
obtener_lugar([_|Resto], Ultimo):- 
	obtener_lugar(Resto, Ultimo).

% Encargados de obtener el tiempo estimado y en caso de haber presa
tiempo_estimado(Distancia, Tiempo):-
	Tiempo is Distancia * 2.

tiempo_en_presa(Distancia, Tiempo):-
	Tiempo is Distancia * 3.

% ------------------------------------------ Sistema Experto (SE) ------------------------------------------

bienvenida():-
    write('Bienvenido a WazeLog, la mejor logica para llegar a su destino.'),nl,nl.

% Consulta por consola para iniciar el sistema experto; muestra el mensaje de bienvenida y solicita el nombre del usuario
comenzar:-
    bienvenida(),
	writeln('Indique su nombre:'), 
	input_to_string(Nombre), nl,
	respuesta_saludo(Nombre), 
	comenzar_aux(Nombre).

% Sigue con la conversación, permite obtener el punto de partida, llegada y si hay una parada. 
comenzar_aux(Nombre):-
	encuentro(OracionEncuentro),
	obtener_lugar(OracionEncuentro, Encuentro),
	validar_lugar(Encuentro), nl,

	llegada(OracionLlegar),
	obtener_lugar(OracionLlegar, Llegar),
	validar_lugar(Llegar), nl,

	intermedio(OracionIntermedio), 
	validacion_gramatical(Nombre, OracionIntermedio, Encuentro, Llegar), nl,
	obtener_lugar(OracionIntermedio, Intermedio), nl,
	rutaEntreTres(Encuentro, Intermedio, Llegar, RutaCorta), 
	ruta_a_tomar(Nombre, RutaCorta).

% Encuentros, Llegadas y Parada -----------------------------------------------------------------------------
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
	input_to_list(OracionIntermedio).

% Información del desarrollo de WazeLog ---------------------------------------------------------------------
?- write(' '),nl.
?- write('------------------------------- WazeLog -------------------------------'),nl.
?- write('Sistema experto desarrollado por: Mauro Navarro, Isaac Solis, Kun Zheng'),nl.
?- write('Escriba comenzar(). para iniciar.'),nl,nl.