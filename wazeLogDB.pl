/*

wazeLogDB.pl corresponde a la base de conocimiento de la aplicación WazeLog, la cual contiene las reglas gramaticales para validar las oraciones digitadas por el usuario.

*/

:-style_check(-singleton).

determinante_n([Yo|S], S).
determinante_n([en|S], S).
determinante_n([a|S], S).
determinante_n([por|S], S).

sustantivo_m([me|S], S).
sustantivo_m([quiero|S], S).

sustantivo_m([SanJose|S], S).
sustantivo_m([Coralillo|S], S).
sustantivo_m([TresRios|S], S).
sustantivo_m([MusgoVerde|S], S).
sustantivo_m([Cartago|S], S).
sustantivo_m([Pacayas|S], S).
sustantivo_m([Paraiso|S], S).
sustantivo_m([Cervantes|S], S).
sustantivo_m([Orosi|S], S).
sustantivo_m([Cachi|R], R).
sustantivo_m([JuanVinas|R], R).
sustantivo_m([Turrialba|R], R).

verbo([encuentro|S], S).
verbo([llegar|S], S).
verbo([pasar|S], S).