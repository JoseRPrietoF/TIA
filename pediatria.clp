(deftemplate NI�O
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
(do-backward-chaining NI�O)

(deffacts ni�os (NI�O (dni a41a) (tos si) (diarrea no))
 (NI�O (dni a41b) (mocos no) (fiebre si))
 ;(NI�O (dni a41c) (diarrea si) (tos no) (vomitos si))
 (NI�O (dni a41c) (diarrea si) (tos no))
 (NI�O (dni a41d) (hinchazon si) (vomitos si) (picores si))
    )


(defrule bronquitis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NI�O (dni ?cod) (mocos si) (tos si) (estornudos si) (fiebre si) (respiracion dificultosa))
 => (modify ?coche (diagnostico bronquitis))
 (printout t "El ni�o " ?cod  " tiene bronquitis" crlf))


(defrule varicela_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NI�O (dni ?cod) (puntos_rojos si) (fiebre si) (picores si) )
 => (modify ?coche (diagnostico varicela))
 (printout t "El ni�o " ?cod  " tiene varicela" crlf))

(defrule gastroenteritis_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NI�O (dni ?cod) (vomitos si) (diarrea si) (dolor_barriga si) )
 => (modify ?coche (diagnostico gastroenteritis))
 (printout t "El ni�o " ?cod  " tiene gastroenteritis" crlf))

(defrule reaccion_alergica_rule ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (NI�O (dni ?cod) (hinchazon si) (picores si) (respiracion dificultosa) )
 => (modify ?coche (diagnostico gastroenteritis))
 (printout t "El ni�o " ?cod  " tiene una reaccion alergica" crlf))

; Derivaciones

(defrule mocos_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NI�O (dni ?codigo) (tos si) (estornudos si))
 =>
 (modify ?g (mocos si))) 

(defrule dolor_barriga_rule
    (declare (salience 20)(no-loop TRUE))
?g <- (NI�O (dni ?codigo) (vomitos si) (diarrea si))
 =>
 (modify ?g (dolor_barriga si))) 

; -------
; preguntas
(defrule pregunta_vomito ; prioridad m�nima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-NI�O (dni ?cod) (vomitos nil) ) )
 ?g <- (NI�O (dni ?cod) (vomitos nil) (diagnostico nil))
 => (printout t "EL ni�o " ?cod " tiene vomitos?")
 (modify ?g (vomitos (read))))


(reset)
(facts)
(run) 