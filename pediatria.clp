(deftemplate NIÑO
 (slot dni)
 (slot tos)
 (slot mocos)
 (slot fiebre)
 (slot vomitos)
 (slot estornudos)
 (slot respiracion)
 (slot dolor_barriga)
 (slot hinchazon)
 (slot diarrea)
 (slot picores)
 (slot puntos_rojos)
 (slot diagnostico (default nil))
)
(do-backward-chaining NIÑO)

(deffacts niños (NIÑO (dni a41a) (tos si) (diarrea no))
 (NIÑO (dni a41b) (mocos no) (fiebre si))
 ;(NIÑO (dni a41c) (diarrea si) (tos no) (vomitos si))
 (NIÑO (dni a41c) (diarrea si) (tos no))
 (NIÑO (dni a41d) (hinchazon si) (vomitos si) (picores si))
    )


(defrule bronquitis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NIÑO (dni ?cod) (mocos si) (tos si) (estornudos si) (fiebre si) (respiracion dificultosa))
 => (modify ?coche (diagnostico bronquitis))
 (printout t "El niño " ?cod  " tiene bronquitis" crlf))


(defrule varicela_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NIÑO (dni ?cod) (puntos_rojos si) (fiebre si) (picores si) )
 => (modify ?coche (diagnostico varicela))
 (printout t "El niño " ?cod  " tiene varicela" crlf))

(defrule gastroenteritis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NIÑO (dni ?cod) (vomitos si) (diarrea si) (dolor_barriga si) )
 => (modify ?coche (diagnostico gastroenteritis))
 (printout t "El niño " ?cod  " tiene gastroenteritis" crlf))

(defrule reaccion_alergica_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NIÑO (dni ?cod) (hinchazon si) (picores si) (respiracion dificultosa) )
 => (modify ?coche (diagnostico gastroenteritis))
 (printout t "El niño " ?cod  " tiene una reaccion alergica" crlf))

; Derivaciones

(defrule mocos_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIÑO (dni ?codigo) (tos si) (estornudos si))
 =>
 (modify ?g (mocos si))) 

(defrule dolor_barriga_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NIÑO (dni ?codigo) (vomitos si) (diarrea si))
 =>
 (modify ?g (dolor_barriga si))) 

; -------
; preguntas
(defrule pregunta_vomito ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NIÑO (dni ?cod) (vomitos nil) ) )
 ?g <- (NIÑO (dni ?cod) (vomitos nil) (diagnostico nil))
 => (printout t "EL niño " ?cod " tiene vomitos?")
 (modify ?g (vomitos (read))))


(reset)
(facts)
(run) 