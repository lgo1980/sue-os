%1)
creeEn(gabriel,campanita).
creeEn(gabriel,magoDeOz).
creeEn(gabriel,cavenaghi).
creeEn(juan,conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena,campanita).

sueniaEn(gabriel,ganarLoteria([5,9])).
sueniaEn(gabriel,futbolista(arsenal)).
sueniaEn(juan,cantante(100000)).
sueniaEn(macarena,cantante(10000)).

%2)
equipoChico(aldosivi).
equipoChico(arsenal).


dificultad(cantante(Discos),6):-
  Discos>500000.
  
dificultad(cantante(Discos),4):-
  Discos=<500000.
  
  
dificultad(ganarLoteria(Numeros),Dificultad):-
 length(Numeros,Cantidad),
 Dificultad is Cantidad*10.
 
dificultad(futbolista(Equipo),3):-
  equipoChico(Equipo).

dificultad(futbolista(Equipo),16):-
  not(equipoChico(Equipo)).



persona(Persona):-
  creeEn(Persona,_).
  
esAmbicioso(Persona):-
  persona(Persona),
  findall(Dificultad,(sueniaEn(Persona,Suenio),dificultad(Suenio,Dificultad)),Dificultades),
  sumlist(Dificultades,Suma),
  Suma>20.
  
%3)

tieneQuimica(Personaje,Persona):-
  creeEn(Persona,Personaje),
  esCompatible(Persona,Personaje).

esCompatible(Persona,Personaje):-
 Personaje \= campanita,
 forall(sueniaEn(Persona,Suenio),puro(Suenio)),
 not(esAmbicioso(Persona)).  

esCompatible(Persona,campanita):-
 sueniaEn(Persona,Suenio),
 dificultad(Suenio,Dificultad),
 Dificultad<5.
 
 
puro(futbolista(_)).

puro(cantante(Discos)):-
  Discos<200000.
   

%4)

esAmigo(campanita,reyesMagos).
esAmigo(campanita,conejoDePascua).
esAmigo(conejoDePascua,cavenaghi).

personajeDeBackup(Alguien,Otro):-
  esAmigo(Alguien,Otro).
  
personajeDeBackup(Alguien,Otro):-
  esAmigo(Alguien,Persona),
  personajeDeBackup(Persona,Otro).
  

%puedeAlegrar(Personaje,Persona):-
 % sueniaEn(Persona,_),
  %tieneQuimica(Personaje,Persona),
  %not(estaEnfermo(Personaje)).
  
puedeAlegrar(Personaje,Persona):-
  sueniaEn(Persona,_),
  tieneQuimica(Personaje,Persona),
  apto(Personaje).

apto(Personaje):-
  not(estaEnfermo(Personaje)).

apto(Personaje):-
  personajeDeBackup(Personaje,Alguien),
  not(estaEnfermo(Alguien)).  
  
estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).