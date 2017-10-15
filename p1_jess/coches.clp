(deftemplate VEHICULOS
 (slot codigo)
 (slot arranca (allowed-values nil si no))
 (slot bateria (allowed-values nil bien mal))
 (slot deposito (allowed-values nil vacio lleno))
 (slot luces (allowed-values nil si no))
 (slot diagnostico (default nil))) ;Slot que indica si el diagnóstico está hecho (solución)
(do-backward-chaining VEHICULOS)

(deffacts coches (VEHICULOS (codigo coche1) (arranca no))
 (VEHICULOS (codigo coche2) (arranca no) (bateria bien))
 (VEHICULOS (codigo coche3) (arranca no) (luces si))
 (VEHICULOS (codigo coche4) (arranca no) (deposito lleno)))

(defrule starter ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (VEHICULOS (codigo ?cod) (arranca no) (bateria bien) (deposito lleno))
 => (modify ?coche (diagnostico starter))
 (printout t "Hay un problema en el starter del vehiculo " ?cod crlf))

(defrule gasolina ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (VEHICULOS (codigo ?cod) (arranca no) (deposito vacio))
 => (modify ?coche (diagnostico deposito))
 (printout t "Hay que repostar el coche " ?cod crlf))

(defrule bateria ; maxima prioridad, ya que soluciona el diagnostico
 (declare (salience 100) (no-loop TRUE) )
 ?coche <- (VEHICULOS (codigo ?cod) (arranca no) (bateria mal))
 => (modify ?coche (diagnostico bateria))
 (printout t "Hay un problema en la bateria del coche " ?cod crlf))

(defrule bateria1 ; prioridad alta, ya que permite deducir nuevos hechos
 (declare (salience 50))
 ?coche <- (VEHICULOS (luces si) (diagnostico nil))
 => (modify ?coche (bateria bien)))

(defrule bateria2 ; prioridad alta, ya que permite deducir nuevo hechos
 (declare (salience 50))
 ?coche <- (VEHICULOS (luces no) (diagnostico nil))
    
 => (modify ?coche (bateria mal))) 
(defrule preguntaluces ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-VEHICULOS (codigo ?cod) (luces nil)))
 ?g <- (VEHICULOS (codigo ?cod) (luces nil) (diagnostico nil))
 => (printout t "Dime si se encienden luces (si no) del " ?cod " :")
 (modify ?g (luces (read))))

(defrule preguntadeposito ; prioridad mínima, ya que son preguntas al usuario por hechos no conocidos ni deducibles
 (declare (salience 0))
 (exists (need-VEHICULOS (codigo ?cod) (deposito nil)))
 ?g <- (VEHICULOS (codigo ?cod) (deposito nil) (diagnostico nil))
 => (printout t "Dime estado deposito (lleno o vacio) del " ?cod " :")
 (modify ?g (deposito (read))))
(reset)
(facts)
(run) 
