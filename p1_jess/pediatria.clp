(deftemplate NIN
 (slot dni (default nil))
 (slot tos(default nil))
 (slot mocos(default nil))
 (slot fiebre(default nil))
 (slot vomitos(default nil))
 (slot estornudos(default nil))
 (slot respiracion(default nil))
 (slot dolor_barriga(default nil))
 (slot hinchazon(default nil))
 (slot diarrea(default nil))
 (slot picores(default nil))
 (slot puntos_rojos(default nil))
 (slot diagnostico_bronquitis (default nil))
 (slot diagnostico_varicela (default nil))
 (slot diagnostico_gastroenteritis (default nil))
 (slot diagnostico_reaccion_alergica (default nil))
    
)
(do-backward-chaining NIN)

(deffacts ninos 
 (NIN (dni a41a) (tos si) (diarrea no))
 (NIN (dni a41b) (mocos no) (fiebre si))
 (NIN (dni a41c) (diarrea si) (tos no))
 (NIN (dni a41d) (hinchazon si) (vomitos si) (picores si))
    )


(defrule bronquitis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (mocos si) (tos si) (estornudos si) (fiebre si) (respiracion dificultosa) (diagnostico_bronquitis nil))
 => (modify ?c (diagnostico_bronquitis si))
 (printout t " ----------------- ")
 (printout t "El nino " ?cod  " tiene bronquitis " )
 (printout t " ------------------------------------------- \n" crlf))

(defrule varicela_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (puntos_rojos si) (fiebre si) (picores si) (diagnostico_varicela nil))
 => (modify ?c (diagnostico_varicela si))
     (printout t " ----------------- ")
 (printout t "El nino " ?cod  " tiene varicela" )
 (printout t " ------------------------------------------- \n" crlf))

(defrule gastroenteritis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (vomitos si) (diarrea si) (dolor_barriga si) (diagnostico_gastroenteritis nil))
 => (modify ?c (diagnostico_gastroenteritis si))
     (printout t " ----------------- ")
 (printout t "El nino " ?cod  " tiene gastroenteritis" )
     (printout t " ------------------------------------------- \n" crlf))

(defrule reaccion_alergica_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (hinchazon si) (picores si) (respiracion dificultosa) (diagnostico_reaccion_alergica nil))
 => (modify ?c (diagnostico_reaccion_alergica si))
     (printout t " ----------------- ")
 (printout t "El nino " ?cod  " tiene una reaccion alergica" )
     (printout t " ------------------------------------------- \n" crlf))


;Regla por si el nino no tiene nada
(defrule paracetamol ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (diagnostico_bronquitis no) (diagnostico_gastroenteritis no)
      	(diagnostico_varicela no) (diagnostico_reaccion_alergica no))
 => ;(modify ?c (diagnostico paracetamol))
     (printout t " ----------------- ")
 (printout t "El nino " ?cod  " parece no tener nada grave, le recomiendo que se tome un paracetamol. 
        Si lo requiere, le pido cita con un especialista" )
     (printout t " ------------------------------------------- \n" crlf))


;Se esta muriendo....
(defrule todo ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (diagnostico_bronquitis si) (diagnostico_gastroenteritis si)
      	(diagnostico_varicela si) (diagnostico_reaccion_alergica si))
    
 => ;(modify ?c (diagnostico paracetamol))
     (printout t " ----------------- ")
 (printout t "El nino " ?cod  " TIENE DE TODO, le ingresamos de urgencia. ¡Aguante! \n" )
     (printout t " ------------------------------------------- \n" crlf))


; Derivaciones
;Regla por si el nino no tiene nada, para llegar a paracetamol
(defrule no_bronquitis ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (mocos ?mocos) (tos ?tos) (estornudos ?estornudos) (fiebre ?fiebre) 
        (respiracion ?respiracion) (diagnostico_bronquitis nil))
    (test
    	(or (eq ?tos no)  (eq ?mocos no ) (eq ?estornudos no ) (eq ?fiebre no) (eq ?respiracion buena) (eq ?respiracion bien)) 
	)
    
 => (modify ?c (diagnostico_bronquitis no))
    ;(printout t " no bronquitis" crlf)
	)

(defrule no_varicela ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (puntos_rojos ?puntos_rojos) (fiebre ?fiebre) (picores ?picores)  (diagnostico_varicela nil))
    (test
    	(or (eq ?puntos_rojos no)  (eq ?fiebre no ) (eq ?picores no )) 
	)
    
 => (modify ?c (diagnostico_varicela no))
    ;(printout t " no varicela" crlf)
    )

(defrule no_gastroenteritis ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (vomitos ?vomitos) (diarrea ?diarrea) (dolor_barriga ?dolor_barriga)  (diagnostico_gastroenteritis nil))
    (test
    	(or (eq ?vomitos no)  (eq ?diarrea no ) (eq ?dolor_barriga no )) 
	)
    
 => (modify ?c (diagnostico_gastroenteritis no))
    ;(printout t " no gastroenteritis" crlf)
    )

(defrule no_reaccion_alergica ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?c <- (NIN (dni ?cod) (hinchazon ?hinchazon) (picores ?picores) (respiracion ?respiracion)  (diagnostico_reaccion_alergica nil))
    (test
    	(or (eq ?hinchazon no)  (eq ?picores no ) (eq ?respiracion buena) (eq ?respiracion bien)) 
	)
    
 => (modify ?c (diagnostico_reaccion_alergica no))
    ;(printout t " no r_alergica" crlf)
    )


(defrule mocos_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIN (dni ?codigo) (tos si) (estornudos si))
 =>
 (modify ?g (mocos si))) 

(defrule dolor_barriga_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIN (dni ?codigo) (vomitos si) (diarrea si))
 =>
 (modify ?g (dolor_barriga si))) 

(defrule respiracion_dif_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIN (dni ?codigo) (tos si) (estornudos si))
 =>
 (modify ?g (respiracion dificultosa))) 

(defrule picores_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIN (dni ?codigo) (puntos_rojos si))
 =>
    ;(printout t "El nino " ?codigo  " deduzco que tiene picores" crlf)
 (modify ?g (picores si)))

; -------
; preguntas
(defrule pregunta_vomito ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (vomitos nil) (diagnostico_gastroenteritis nil)) )
 ?g <- (NIN (dni ?cod) (vomitos nil) (diarrea ?diarrea) (dolor_barriga ?dbarriga) (diagnostico_gastroenteritis nil))
    (test (neq ?diarrea no))
    (test (neq ?dbarriga no))
 => (printout t "EL nino " ?cod " tiene vomitos? (si/no) ")
 (modify ?g (vomitos (read))))

(defrule pregunta_tos ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (tos nil) ) )
 ?g <- (NIN (dni ?cod) (tos nil) (mocos ?mocos) (estornudos ?estornudos) (fiebre ?fiebre) (respiracion ?respiracion)(diagnostico_bronquitis nil))
    (test (neq ?mocos no))
    (test (neq ?estornudos no))
    (test (neq ?fiebre no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene tos? (si/no) ")
 (modify ?g (tos (read))))

(defrule pregunta_mocos ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (mocos nil) ) )
 ?g <- (NIN (dni ?cod) (mocos nil) (tos ?tos) (estornudos ?estornudos) (fiebre ?fiebre) (respiracion ?respiracion)(diagnostico_bronquitis nil))
    (test (neq ?tos no))
    (test (neq ?estornudos no))
    (test (neq ?fiebre no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene mocos? (si/no) ")
 (modify ?g (mocos (read))))

(defrule pregunta_estornudos ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (estornudos nil) ) )
 ?g <- (NIN (dni ?cod) (estornudos nil) (tos ?tos) (mocos ?mocos) (fiebre ?fiebre) (respiracion ?respiracion)(diagnostico_bronquitis nil))
    (test (neq ?tos no))
    (test (neq ?mocos no))
    (test (neq ?fiebre no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene estornudos? (si/no) ")
 (modify ?g (estornudos (read))))

(defrule pregunta_fiebre_bronquitis ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 1))
 (exists (need-NIN (dni ?cod) (fiebre nil) ) )
 ?g <- (NIN (dni ?cod) (fiebre nil) (tos ?tos ) (mocos ?mocos) (estornudos ?estornudos) (respiracion ?respiracion)(diagnostico_bronquitis nil))
    (test (neq ?tos no))
    (test (neq ?mocos no))
    (test (neq ?estornudos no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene fiebre? (si/no) ")
 (modify ?g (fiebre (read))))

(defrule pregunta_fiebre_varicela ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (fiebre nil) ) )
 ?g <- (NIN (dni ?cod) (fiebre nil) (puntos_rojos ?puntos_rojos) (picores ?picores) (diagnostico_varicela nil))
    (test (neq ?puntos_rojos no))
    (test (neq ?picores no))
 => (printout t "EL nino " ?cod " tiene fiebre? (si/no) ")
 (modify ?g (fiebre (read))))

(defrule pregunta_puntos_rojos ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (puntos_rojos nil) ) )
 ?g <- (NIN (dni ?cod) (puntos_rojos nil) (fiebre ?fiebre) (picores ?picores) (diagnostico_varicela nil))
    (test (neq ?fiebre no))
    (test (neq ?picores no))
 => (printout t "EL nino " ?cod " tiene puntos rojos? (si/no) ")
 (modify ?g (puntos_rojos (read))))

(defrule pregunta_picores_varicela ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (picores nil) ) )
 ?g <- (NIN (dni ?cod) (picores nil) (puntos_rojos ?puntos_rojos) (fiebre ?fiebre) (diagnostico_varicela nil))
    (test (neq ?puntos_rojos no))
    (test (neq ?fiebre no))
 => (printout t "EL nino " ?cod " tiene picores? (si/no) ")
 (modify ?g (picores (read))))

(defrule pregunta_picores_reaccion_alergica ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 1))
 (exists (need-NIN (dni ?cod) (picores nil) ) )
 ?g <- (NIN (dni ?cod) (picores nil) (hinchazon ?hinchazon) (respiracion ?respiracion) (diagnostico_reaccion_alergica nil))
    (test (neq ?hinchazon no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene picores? (si/no) ")
 (modify ?g (picores (read))))

(defrule pregunta_diarrea ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (diarrea nil) ) )
 ?g <- (NIN (dni ?cod) (diarrea nil) (vomitos ?vomitos) (dolor_barriga ?dolor_barriga) (diagnostico_gastroenteritis nil))
    (test (neq ?vomitos no))
    (test (neq ?dolor_barriga no))
 => (printout t "EL nino " ?cod " tiene diarrea? (si/no) ")
 (modify ?g (diarrea (read))))

(defrule pregunta_hinchazon ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (hinchazon nil) ) )
 ?g <- (NIN (dni ?cod) (hinchazon nil) (picores ?picores) (respiracion ?respiracion) (diagnostico_reaccion_alergica nil))
    (test (neq ?picores no))
    (test (neq ?respiracion bien))
    (test (neq ?respiracion buena))
 => (printout t "EL nino " ?cod " tiene hinchazon? (si/no) ")
 (modify ?g (hinchazon (read))))


(defrule pregunta_respiracion_reaccion_alergica ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (respiracion nil) ) )
 ?g <- (NIN (dni ?cod) (respiracion nil) (picores ?picores) (hinchazon ?hinchazon) (diagnostico_reaccion_alergica nil))
    (test (neq ?picores no))
    (test (neq ?hinchazon no))
 => (printout t "Como es la respiracion del nino " ?cod "(buena/bien o dificultosa)? ")
 (modify ?g (respiracion (read))))

(defrule pregunta_respiracion_bronquitis ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIN (dni ?cod) (respiracion nil) ) )
 ?g <- (NIN (dni ?cod) (respiracion nil) (mocos ?mocos) (estornudos ?estornudos) (fiebre ?fiebre) (tos ?tos)(diagnostico_bronquitis nil))
    (test (neq ?tos no))
    (test (neq ?mocos no))
    (test (neq ?fiebre no))
    (test (neq ?estornudos no))
 => (printout t "Como es la respiracion del nino " ?cod "(buena/bien o dificultosa)? ")
 (modify ?g (respiracion (read))))

(reset)
(facts)
(run) 