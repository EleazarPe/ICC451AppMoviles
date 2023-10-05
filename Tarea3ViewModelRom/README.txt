La tarea fue un poco compleja porque no habiamos tenido contacto previo con lo que son los view model y Room.
Los problemas que tuve se resolvieron faciles, uno que me tomo bastante tiempo fue en los metodos del repository que al llamar a los metodos del dao no estaba ejecutando un hilo en el databaseWriteExecutor y cuando lo coloque ya se resolvieron gran parte de los problemas.

Otro problema con el que me enfrente fue el differ en el adaptador que al cargar los datos no me estaban cargando y me explotaba la pagina pero basicamente el error fue de constructor.

En conclusion la tarea me parece interesante y bastante util para comprener mas como funciona android y me quedo con la duda de que el adaptador con el differ se ve un parpadeo en los items que antes con una funcion que ingresara una lista nueva no pasaba se veia mas fluido.