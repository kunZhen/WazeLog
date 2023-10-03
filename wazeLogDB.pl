/*

wazeLogDB.pl corresponde a la base de conocimiento de la aplicación WazeLog, la cual contiene las reglas gramaticales para validar las oraciones digitadas por el usuario.

*/

:-style_check(-singleton).

determinante_n([yo|S], S).
determinante_n([en|S], S).
determinante_n([a|S], S).
determinante_n([por|S], S).

sustantivo_m([me|S], S).
sustantivo_m([quiero|S], S).

sustantivo_m([sanJose|S], S).
sustantivo_m([coralillo|S], S).
sustantivo_m([tresRios|S], S).
sustantivo_m([musgoVerde|S], S).
sustantivo_m([cartago|S], S).
sustantivo_m([pacayas|S], S).
sustantivo_m([paraiso|S], S).
sustantivo_m([cervantes|S], S).
sustantivo_m([orosi|S], S).
sustantivo_m([cachi|R], R).
sustantivo_m([juanVinas|R], R).
sustantivo_m([turrialba|R], R).

verbo([encuentro|S], S).
verbo([llegar|S], S).
verbo([pasar|S], S).