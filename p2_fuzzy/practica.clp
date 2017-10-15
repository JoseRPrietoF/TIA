
(deftemplate Distancia ;Variable difusa
0 50 metros ;Universo
	(
		(cerca (0 1) (15 0))
		(medio (10 0) (25 1) (35 1) (39 0) )
		(lejos (35 0) (50 1))
	)
)


(deftemplate VelocidadRelativa ;Variable difusa
-30 30 kmh ;Universo
	(
		(alejando (-30 1) (0 0))
		(constante (-30 0) (-10 0) (0 1) (10 0) (30 0) )
		(acercando (-30 0) (0 0) (30 1))
	)
)



(deftemplate PresionFreno ;Variable difusa
0 100 presion ;Universo
	(
		(nula (0 1) (12 1) (24 0))
		(media (40 0) (58 1) (65 1) (88 0))
		(alta (68 0) (82 1))
	)
)

(deftemplate coche
 (slot Distancia (type FUZZY-VALUE Distancia))
 (slot VelocidadRelativa (type FUZZY-VALUE VelocidadRelativa) )
 ;(slot PresionFreno (type FUZZY-VALUE PresionFreno) )
 (slot evaluado (type SYMBOL))) 


(defrule print
(declare (salience 1000)) ;prioridad alta
(Distancia ?t)
=>
;;;(plot-fuzzy-value t "*" ?t)
(plot-fuzzy-value t ".-*+" 0 50 ?t
(create-fuzzy-value Distancia cerca)
(create-fuzzy-value Distancia medio)
(create-fuzzy-value Distancia lejos))) 




(defrule printVelRel
(declare (salience 1000)) ;prioridad alta
(VelocidadRelativa ?t)
=>
;;;(plot-fuzzy-value t "*" ?t)
(plot-fuzzy-value t ".-*+" -30 30 ?t
(create-fuzzy-value VelocidadRelativa alejando)
(create-fuzzy-value VelocidadRelativa constante)
(create-fuzzy-value VelocidadRelativa acercando))) 


(defrule printPresionFreno
(declare (salience 1000)) ;prioridad alta
(PresionFreno ?t)
=>
;;;(plot-fuzzy-value t "*" ?t)
(plot-fuzzy-value t ".-*+" 0 100 ?t
(create-fuzzy-value PresionFreno nula)
(create-fuzzy-value PresionFreno media)
(create-fuzzy-value PresionFreno alta))) 





(deffunction fuzzify (?fztemplate ?value ?delta)
 (bind ?low (get-u-from ?fztemplate))
 (bind ?hi (get-u-to ?fztemplate))
 (if (<= ?value ?low)
 then
 (assert-string
 (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
 else
 (if (>= ?value ?hi)
 then
 (assert-string
 (format nil "(%s (%g 0.0) (%g 1.0))"
 ?fztemplate (- ?hi ?delta) ?hi))
 else
 (assert-string
 (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
 ?fztemplate (max ?low (- ?value ?delta))
 ?value (min ?hi (+ ?value ?delta)) ))
 ))) 

;(defrule start
;(initial-fact)
;=>
;(printout t "Hola mundo!" crlf)
;(assert (Distancia (10 0)))
;(assert (VelocidadRelativa (10 0)))
;(assert (PresionFreno (10 0)))
;)

(defrule leerconsola
 (initial-fact)
=>
 (printout t "Introduzca la distancia en metros" crlf)
 (bind ?Rdist (read))
 (printout t "Introduzca la velocidad relativa en kms/ hora" crlf)
 (bind ?Rkmh (read))
 (assert-string (format nil "(coche (Distancia %s) (VelocidadRelativa %s) (evaluado no))" ?Rdist ?Rkmh))
) 



(defrule presion_alta

 ?f <- (coche (Distancia  cerca) (VelocidadRelativa  acercando)  (evaluado no) )
=>
 (retract ?f)
 (assert (coche (Distancia cerca) (VelocidadRelativa acercando)  (evaluado si)))
 (printout t "Presion alta" crlf)
 (assert  (PresionFreno alta)))

 



(defrule presion_nula
 ?f <- (coche  (Distancia ?d) (VelocidadRelativa alejando)  (evaluado no) )
=>
 (retract ?f)
 (assert  (coche (Distancia ?d) (VelocidadRelativa alejando)  (evaluado si) ))
 (printout t "Presion nula 1" crlf)
 (assert (PresionFreno nula) )) 


 
(defrule presion_media
 ?f <- (coche (Distancia medio) (VelocidadRelativa constante)  (evaluado no) )

=>
 (retract ?f)
 (assert  (coche (Distancia medio) (VelocidadRelativa acercando)  (evaluado si) ))
 (printout t "Presion media 1" crlf)
 (assert (PresionFreno media) )) 
 



;;; PRUEBAS UTILIZADAS
;(deffacts fuzzy-fact
 ;(coche (Distancia cerca) (VelocidadRelativa acercando) (evaluado no)) 
 ;(coche (Distancia cerca) (VelocidadRelativa constante) (evaluado no)) 
 ;(coche (Distancia lejos) (VelocidadRelativa constante) (evaluado no)) 
 ;(coche (Distancia lejos) (VelocidadRelativa acercando) (evaluado no)) 
 ;(coche (Distancia lejos) (VelocidadRelativa alejando) (evaluado no)) 

;)


 
 
(defrule defusificar
 (PresionFreno ?f) 
 => (bind ?e (moment-defuzzify ?f))
 (printout t "pisa el freno al " ?e "% de " (get-u-units ?f) crlf)) 

(reset)
(run)
