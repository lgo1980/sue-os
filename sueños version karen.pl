%---------------------------1
creeEn(gabriel,campanita).
creeEn(gabriel,elMagoDeOz).
creeEn(gabriel,cavenaghi).
creeEn(juan,elConejoDePascua).
creeEn(macarena,losReyesMagos).
creeEn(macarena,elMagoCapria).
creeEn(macarena,campanita).

tieneSuenio(gabriel,ganarLoteria([5,9])).
tieneSuenio(gabriel,futbolista(arsenal)).
tieneSuenio(juan,cantante(100000)).
tieneSuenio(macarena,cantante(10000)).


%-------------------B
%concepto que entró en juego: Universo Cerrado.

%---------------------------2
esAmbiciosa(Persona):-
	creeEn(Persona,_),
	findall(Dificultad,(tieneSuenio(Persona,Suenio),dificultadSuenio(Suenio,Dificultad)),Dificultades),
	sumlist(Dificultades,Sumatoria),
	Sumatoria > 20.

dificultadSuenio(cantante(Numero),6):-
	Numero > 500000.
dificultadSuenio(cantante(Numero),4):-
	Numero < 500000.
dificultadSuenio(ganarLoteria(Lista),Dificultad):-
	length(Lista,CantidadDeNumeros),
	Dificultad is 10 * CantidadDeNumeros. 
dificultadSuenio(futbolista(Equipo),3):-
	equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo),16):-
	not(equipoChico(Equipo)).
	
equipoChico(arsenal).
equipoChico(aldosivi).
%---------------------------3
tieneQuimica(Personaje,Persona):-
	creeEn(Persona,Personaje),
	condicion(Persona,Personaje).

condicion(Persona,campanita):-
	tieneSuenio(Persona,Suenio),
	dificultadSuenio(Suenio,Dificultad),
	Dificultad < 5.
	
condicion(Persona,Personaje):-
	Personaje \= campanita,
	not(esAmbiciosa(Persona)),
	sueniosPuros(Persona).
	
sueniosPuros(Persona):-
	forall(tieneSuenio(Persona,Suenio),esPuro(Suenio)).
	
esPuro(futbolista(_)).
esPuro(cantante(Numero)):-
	Numero < 200000.
%---------------------------4
esAmigo(campanita,losReyesMagos).
esAmigo(campanita,elConejoDePascua).
esAmigo(elConejoDePascua,cavenaghi).

estaEnfermo(campanita).
estaEnfermo(losReyesMagos).
estaEnfermo(elConejoDePascua).

puedeAlegrar(Personaje,Persona):-
	tieneSuenio(Persona,_),
	tieneQuimica(Personaje,Persona),
	condicionAlegrar(Personaje).

condicionAlegrar(Personaje):-
	not(estaEnfermo(Personaje)).

condicionAlegrar(Personaje):-
	estaEnfermo(Personaje),
	esAmigo(Personaje,Backup),
	backup(Backup).

backup(Backup):- 
	not(estaEnfermo(Backup)).
	
backup(Backup):-
	estaEnfermo(Backup),
	esAmigo(Backup,AmigoBack),
	backup(AmigoBack).
	