(deftemplate gato
 (slot nombre)
 (slot color)
 (slot raza)
 (slot come))

(deffacts ejemplo
 (gato (nombre felix))
 (gato (nombre rita) (come bellotas))
 (gato (nombre rufo) (come pienso))
 (gato (nombre macario) (come leche))
 (gato (nombre petra) (color blanco)) )
(do-backward-chaining gato)

(defrule comida1
?f <- (gato (come bellotas) )
 =>
 (modify ?f (color negro)))

(defrule comida2
?f <- (gato (come leche) )
 =>
 (modify ?f (color blanco))) 

(defrule pregunta
 (declare (salience -1))
 (exists (need-gato (nombre ?n) ))
?g <- (gato (nombre ?n) (color nil))
 =>
 (printout t "Dame color del gato " ?n ": ")
 (modify ?g (color (read)))) 

(defrule respuesta
 (declare (no-loop TRUE) (salience 10))
 ?f <- (gato (nombre ?n) (color blanco) )
 =>
 (modify ?f (raza albina))
 (printout t "La raza del gato " ?n " es albina" crlf))

(reset)
(run)