(deftemplate edad 0 100 anos ; definición de la variable fuzzy "edad"
 ( (joven (10 0) (15 1) (25 1) (30 0))
 (adulta (20 0) (30 1) (60 1) (70 0))
 (madura (60 0) (70 1))))
 
(deftemplate estatura 0 250 cm
((bajo (0 1) (100 1) (150 0))
 (medio (100 0) (150 1) (170 1) (180 0))
 (alto (170 0) (180 1))))
 
(deftemplate aptitud 0 10 unidades
((baja (0 1) (5 0))
 (media (3 0) (4 1) (6 1) (10 0))
 (alta (5 0) (10 1))))
 
(deftemplate persona
 (slot nombre (type SYMBOL))
 (slot edad (type FUZZY-VALUE edad))
 (slot estatura (type FUZZY-VALUE estatura))
 (slot aptitud (type FUZZY-VALUE aptitud) )
 (slot evaluado (type SYMBOL)))
 
(deffacts fuzzy-fact
 (persona (nombre adan) (edad adulta) (estatura alto) (aptitud baja) (evaluado no))
 (persona (nombre eva) (edad joven) (estatura medio) (aptitud baja) (evaluado no))
 (persona (nombre moises) (edad adulta) (estatura bajo) (aptitud baja) (evaluado no))
 (persona (nombre david) (edad joven) (estatura alto) (aptitud baja)(evaluado no))
 (persona (nombre samuel) (edad not joven) (estatura more-or-less alto ) (aptitud
	baja)(evaluado no))
 (persona (nombre salome) (edad very joven) (estatura extremely alto ) (aptitud
	baja)(evaluado no)))

(defrule ejemplo ;asignar_aptitud_jugar_baloncesto
 ?f <- (persona (nombre ?n) (edad joven) (estatura alto) (evaluado no) )
=>
 (retract ?f)
 (assert (persona (nombre ?n) (edad joven) (estatura alto) (aptitud alta) (evaluado si))))
 
 
(defrule ejemplo3 ;asignar_aptitud_jugar_baloncesto
 ?f <- (persona (nombre ?n) (edad adulta) (estatura medio) (evaluado no) )
=>
 (retract ?f)
 (assert (persona (nombre ?n) (edad adulta) (estatura medio) (aptitud media) (evaluado si))))
 
(defrule ejemplo2 ;asignar_aptitud_jugar_baloncesto
 ?f <- (persona (nombre ?n) (edad madura) (estatura bajo) (evaluado no) )
=>
 (retract ?f)
 (assert (persona (nombre ?n) (edad madura) (estatura bajo) (aptitud baja) (evaluado si))))
 
(defrule defusificar
 (persona (nombre ?nombre) (aptitud ?f) (evaluado si))
 => (bind ?e (maximum-defuzzify ?f))
 (printout t "nombre " ?nombre " tiene una aptitud de " ?e crlf)) 
