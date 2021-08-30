%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parcial - Sueños
% NOMBRE: Leonardo Olmedo - lgo1980
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
  Sueños  
Un consorcio internacional nos pidió que relevemos su negocio, que consiste en hacer el seguimiento de los sueños que tiene cada una de las personas 
y los personajes que están destinados a cumplir esos sueños. 
Punto 1 (2 puntos)
Queremos reflejar que 
* Gabriel cree en Campanita, el Mago de Oz y Cavenaghi*/
creeEn(gabriel,campanita).
creeEn(gabriel,magoDeOz).
creeEn(gabriel,cavenaghi).
%* Juan cree en el Conejo de Pascua
creeEn(juan,conejoDePascua).
%* Macarena cree en los Reyes Magos, el Mago Capria y Campanita
creeEn(macarena,reyesMagos).
creeEn(macarena,magoCapria).
creeEn(macarena,campanita).
%* Diego no cree en nadie
%Por teoria de universo cerrado con Diego no se genera nada

/*
Conocemos tres tipos de sueño
* ser un cantante y vender una cierta cantidad de “discos” (≅ bajadas)
* ser un futbolista y jugar en algún equipo 
* ganar la lotería apostando una serie de números

Queremos reflejar entonces que*/
%* Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
suenios(gabriel,loteria([5,9])).
suenios(gabriel,futbolista(arsenal)).
%* Juan quiere ser un cantante que venda 100.000 “discos”
suenios(juan,cantante(100000)).
%* Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos
suenios(macarena,cantante(10000)).

/*
1. Generar la base de conocimientos inicial
2. Indicar qué conceptos entraron en juego para cada punto.
*/

/*
Punto 2 (4 puntos)
Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. 
La dificultad de cada sueño se calcula como*/
%   * 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
dificultadDelSuenios(Persona,Dificultad):-
  suenios(Persona,cantante(CantidadDiscos)),
  CantidadDiscos > 500000,
  Dificultad is 6.
dificultadDelSuenios(Persona,Dificultad):-
  suenios(Persona,cantante(_)),
  Dificultad is 4.
%   * ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
dificultadDelSuenios(Persona,Dificultad):-
  suenios(Persona,loteria(Numeros)),
  length(Numeros,CantidadNumeros),
  Dificultad is CantidadNumeros * 10.
%   * lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.
dificultadDelSuenios(Persona,Dificultad):-
  suenios(Persona,futbolista(Equipo)),
  equipoChico(Equipo),
  Dificultad is 3.
dificultadDelSuenios(Persona,Dificultad):-
  suenios(Persona,futbolista(Equipo)),
  not(equipoChico(Equipo)),
  Dificultad is 16.

equipoChico(arsenal).
equipoChico(aldosivi).
/* 
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y 
quiere ser futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. En cambio Juan y Macarena tienen 4 puntos de dificultad 
(cantantes con menos de 500.000 discos)
*/
personaAmbiciosa(Persona):-
  suenios(Persona,_),
  findall(Dificultad,dificultadDelSuenios(Persona,Dificultad),Dificultades),
  sum_list(Dificultades,Suma),
  Suma > 20.

/*
Punto 3 (4 puntos)
Queremos saber si un personaje tiene química con una persona. Esto se da
* si la persona cree en el personaje y...
* para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
* para el resto, 
   * todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
   * y la persona no debe ser ambiciosa

No puede utilizar findall en este punto.
El predicado debe ser inversible para todos sus argumentos.
Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal,
que es un sueño de dificultad 3 - menor a 5), y los Reyes Magos, el Mago Capria y Campanita
tienen química con Macarena porque no es ambiciosa.
*/
quimicaCon(Persona,Personaje):-
  creeEn(Persona,Personaje),
  condicionDeQuimica(Persona,Personaje).

condicionDeQuimica(Persona,Personaje):-
  Personaje \= campanita,
  forall(suenios(Persona,Suenio), suenioPuro(Suenio)),
  not(personaAmbiciosa(Persona)).

condicionDeQuimica(Persona,campanita):-
  dificultadDelSuenios(Persona,Dificultad),
  Dificultad < 5.

suenioPuro(futbolista(_)).
suenioPuro(cantante(CantidadDiscos)):-
  CantidadDiscos < 200000.

/*
  Punto 4 (2 puntos)
Sabemos que
* Campanita es amiga de los Reyes Magos y del Conejo de Pascua
* el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades


Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
* si una persona tiene algún sueño
* el personaje tiene química con la persona y...
   * el personaje no está enfermo
   * o algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del personaje principal


Debe evitar repetición de lógica.
El predicado debe ser totalmente inversible.
Debe considerar cualquier nivel de amistad posible (la solución debe ser general).
Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
* el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
* Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo de Cavenaghi que no está enfermo.
*/
enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).
amigo(campanita,reyesMagos).
amigo(campanita,conejoDePascua).
amigo(conejoDePascua,cavenaghi).

alegrarPersona(Personaje,Persona):-
  suenios(Persona,_),
  quimicaCon(Persona,Personaje),
  funcion(Personaje).

funcion(Personaje):-
  not(enfermo(Personaje)).
funcion(Personaje):-
  buscarBackup(Personaje,PersonajeBackuo),
  not(enfermo(PersonajeBackuo)).

buscarBackup(Personaje,PersonajeBackup):-
  amigo(Personaje,PersonajeBackup).
buscarBackup(Personaje,PersonajeBackup):-
  amigo(Personaje,PersonajeAmigo),
  buscarBackup(PersonajeAmigo,PersonajeBackup).

:- begin_tests(utneanos).

  test(a_que_persona_le_gusta_cavenagui,set(Persona=[gabriel])):-
    creeEn(Persona,cavenaghi).
  test(persona_que_quiere_ser_futbolista,set(Persona=[gabriel])):-
    suenios(Persona,futbolista(_)).
  test(juan_tiene_una_dificultad_de_suenio_4,nondet):-
    dificultadDelSuenios(juan,4).
  test(macarena_tiene_una_dificultad_de_suenio_4,nondet):-
    dificultadDelSuenios(macarena,4).
  test(gabriel_tiene_una_dificultad_de_suenio_20,nondet):-
    dificultadDelSuenios(gabriel,20).
  test(personas_que_son_ambiciosas,set(Persona=[gabriel])):-
    distinct(personaAmbiciosa(Persona)).
  test(personas_que_no_son_ambiciosas,fail):-
    distinct(personaAmbiciosa(juan)).
  test(personas_que_tienen_quimica_con_campanita,set(Persona=[gabriel,macarena])):-
    quimicaCon(Persona,campanita).
  test(personajes_que_tienen_quimica_con_macarena,set(Personaje=[reyesMagos,magoCapria,campanita])):-
    quimicaCon(macarena,Personaje).
  test(magoCapria_alegra_a_macarena,nondet):-
    alegrarPersona(magoCapria,macarena).
  test(campanita_alegra_a_macarena,nondet):-
    alegrarPersona(campanita,macarena).

:- end_tests(utneanos).