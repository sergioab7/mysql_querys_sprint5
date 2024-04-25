-- Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre;
-- Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE telefono IS NULL AND tipo = 'alumno';
--Retorna el llistat dels alumnes que van néixer en 1999.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE YEAR(fecha_nacimiento) = 1999 AND tipo = 'alumno';

--Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE telefono IS NULL AND tipo = 'profesor' AND RIGHT(nif, 1) = 'K';

--Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT nombre
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

--Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS nom_departament
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN departamento d ON pr.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY p.apellido1, p.apellido2, p.nombre;

--Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin
FROM alumno_se_matricula_asignatura am
LEFT JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
LEFT JOIN asignatura a ON am.id_asignatura = a.id
WHERE am.id_alumno = (SELECT id FROM persona WHERE nif = '26902806M');

--Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
LEFT JOIN grado g ON a.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

--Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT p.nombre, p.apellido1, p.apellido2
FROM persona p
LEFT JOIN alumno_se_matricula_asignatura am ON p.id = am.id_alumno
LEFT JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT d.nom AS nom_departament, p.primer_cognom, p.segon_cognom, p.nom
FROM professors p
LEFT JOIN departaments d ON p.departament_id = d.id
ORDER BY nom_departament, p.primer_cognom, p.segon_cognom, p.nom;


-- Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.primer_cognom, p.segon_cognom, p.nom
FROM professors p
LEFT JOIN departaments d ON p.departament_id = d.id
WHERE d.id IS NULL;


-- Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nom AS nom_departament
FROM departaments d
LEFT JOIN professors p ON d.id = p.departament_id
WHERE p.id IS NULL;


-- Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.primer_cognom, p.segon_cognom, p.nom
FROM professors p
LEFT JOIN assignatures_professors ap ON p.id = ap.professor_id
WHERE ap.id IS NULL;

-- Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.nom AS nom_assignatura
FROM assignatures a
LEFT JOIN assignatures_professors ap ON a.id = ap.assignatura_id
WHERE ap.id IS NULL;

-- Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT d.nom AS nom_departament
FROM departaments d
LEFT JOIN professors p ON d.id = p.departament_id
LEFT JOIN assignatures_professors ap ON p.id = ap.professor_id
LEFT JOIN assignatures a ON ap.assignatura_id = a.id
WHERE a.id IS NULL;


-- Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) AS total_alumnes
FROM alumnes;

-- Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) AS alumnes_1999
FROM alumnes
WHERE YEAR(data_naixement) = 1999;

-- Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nom AS nom_departament, COUNT(p.id) AS nombre_professors
FROM departaments d
INNER JOIN professors p ON d.id = p.departament_id
GROUP BY d.id, d.nom
ORDER BY nombre_professors DESC;

-- Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nom AS nom_departament, COUNT(p.id) AS nombre_professors
FROM departaments d
LEFT JOIN professors p ON d.id = p.departament_id
GROUP BY d.id, d.nom
ORDER BY nombre_professors DESC;

-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nom AS nom_grau, COUNT(a.id) AS nombre_assignatures
FROM graus g
LEFT JOIN assignatures_graus ag ON g.id = ag.grau_id
LEFT JOIN assignatures a ON ag.assignatura_id = a.id
GROUP BY g.id, g.nom
ORDER BY nombre_assignatures DESC;

-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nom AS nom_grau, COUNT(a.id) AS nombre_assignatures
FROM graus g
LEFT JOIN assignatures_graus ag ON g.id = ag.grau_id
LEFT JOIN assignatures a ON ag.assignatura_id = a.id
GROUP BY g.id, g.nom
HAVING COUNT(a.id) > 40
ORDER BY nombre_assignatures DESC;

-- Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nom AS nom_grau, a.tipus AS tipus_assignatura, SUM(a.credits) AS total_credits
FROM graus g
LEFT JOIN assignatures_graus ag ON g.id = ag.grau_id
LEFT JOIN assignatures a ON ag.assignatura_id = a.id
GROUP BY g.id, g.nom, a.tipus;

-- Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT YEAR(data_inici) AS any_inici_curs, COUNT(DISTINCT alumne_id) AS nombre_alumnes_matriculats
FROM matricules
GROUP BY YEAR(data_inici);

-- Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT p.id, p.nom, p.primer_cognom, p.segon_cognom, COUNT(ap.assignatura_id) AS nombre_assignatures
FROM professors p
LEFT JOIN assignatures_professors ap ON p.id = ap.professor_id
GROUP BY p.id, p.nom, p.primer_cognom, p.segon_cognom
ORDER BY nombre_assignatures DESC;

-- Retorna totes les dades de l'alumne/a més jove.
SELECT *
FROM alumnes
ORDER BY data_naixement DESC
LIMIT 1;

-- Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.id, p.nom, p.primer_cognom, p.segon_cognom
FROM professors p
LEFT JOIN assignatures_professors ap ON p.id = ap.professor_id
WHERE p.departament_id IS NOT NULL AND ap.id IS NULL;
