/*

wazeLogDB.pl corresponde a la base de conocimiento de la aplicación WazeLog, la cual contiene las reglas gramaticales para validar las oraciones digitadas por el usuario.

*/

:-style_check(-singleton).

lugar(sanJose).
lugar(corralillo).
lugar(tresRios).
lugar(musgoVerde).
lugar(cartago).
lugar(pacayas).
lugar(paraiso).
lugar(cervantes).
lugar(orosi).
lugar(cachi).
lugar(juanVinas).
lugar(turrialba).

% Conexiones de 1 vía
conexion(tresRios, sanJose, 8).
conexion(cartago, tresRios, 8).
conexion(cartago, paraiso, 10).
conexion(paraiso, cervantes, 4).
conexion(cervantes, juanVinas, 5).
conexion(juanVinas, turrialba, 4).
conexion(turrialba, pacayas, 18).

% Conexiones de 2 vías
conexion(sanJose, corralillo, 22).
conexion(corralillo, sanJose, 22).
conexion(sanJose, cartago, 20).
conexion(cartago, sanJose, 20).
conexion(corralillo, musgoVerde, 6).
conexion(musgoVerde, corralillo, 6). 
conexion(musgoVerde, cartago, 10).
conexion(cartago, musgoVerde, 10).

conexion(pacayas, cartago, 13).
conexion(cartago, pacayas, 13).
conexion(pacayas, tresRios, 15).
conexion(tresRios, pacayas, 15).
conexion(pacayas, cervantes,  8).
conexion(cervantes, pacayas, 8).

conexion(cachi, cervantes, 7).
conexion(cervantes, cachi, 7).
conexion(cachi, paraiso, 10).
conexion(paraiso, cachi, 10).
conexion(cachi, orosi, 12).
conexion(orosi, cachi, 12).
conexion(cachi, turrialba, 40).
conexion(turrialba, cachi, 40).

conexion(paraiso, orosi, 8).
conexion(orosi, paraiso, 8).

determinante_n([yo|S], S).
determinante_n([tambien|S], S).
determinante_n([en|S], S).
determinante_n([a|S], S).
determinante_n([por|S], S).
determinante_n([actualmente|S], S).

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
sustantivo_m([cachi|S], S).
sustantivo_m([juanVinas|S], S).
sustantivo_m([turrialba|S], S).

verbo([encuentro|S], S).
verbo([deseo|S], S).
verbo([ubico|S], S).
verbo([hallo|S], S).
verbo([estoy|S], S).
verbo([estar|S], S).
verbo([llegar|S], S).
verbo([ir|S], S).
verbo([pasar|S], S).
verbo([circular|S], S).
verbo([transitar|S], S).

negacion(['no'|_]).
