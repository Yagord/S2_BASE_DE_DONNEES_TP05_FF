 DROP TABLE LABORATOIRE CASCADE CONSTRAINTS;
DROP TABLE TRAVAILLER CASCADE CONSTRAINTS;
DROP TABLE PROJET CASCADE CONSTRAINTS;
DROP TABLE CHERCHEUR CASCADE CONSTRAINTS;


CREATE TABLE LABORATOIRE
(
  NumLabo varchar2(8),
  NomLabo varchar2(32),
  constraint pk_laboratoire primary key (NumLabo)
);

CREATE TABLE CHERCHEUR
(
  NumChercheur varchar2(8),
  NomChercheur varchar2(32),
  Specialite varchar2(32),
  NumLabo varchar2(8) constraint nn_chercheur_labo not null,
  constraint pk_chercheur primary key (NumChercheur),
  constraint fk_chercheur_labo foreign key (NumLabo) references LABORATOIRE (NumLabo)
);

CREATE TABLE PROJET
(
  NumProjet varchar2(8),
  NomProjet varchar2(64),
  NumChercheurResp varchar2(8),
  constraint pk_projet primary key (NumProjet),
  constraint fk_projet_cher foreign key (NumChercheurResp) references chercheur (NumChercheur)
);

CREATE TABLE travailler
(
  NumProjet varchar2(8),
  NumChercheur varchar2(8),
  nbJour number,
  constraint pk_travailler primary key (NumProjet,NumChercheur),
  constraint fk_trav_proj foreign key (NumProjet) references projet (NumProjet),
  constraint fk_trav_cher foreign key (NumChercheur) references chercheur (NumChercheur)
);

INSERT INTO LABORATOIRE(NumLabo,NomLabo) VALUES ('labo1','LE2I');
INSERT INTO LABORATOIRE(NumLabo,NomLabo) VALUES ('labo2','LEAD');
INSERT INTO LABORATOIRE(NumLabo,NomLabo) VALUES ('labo3','ICB');

INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch1','Héloïse','bd','labo1');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch2','Madeleine','si','labo2');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch3','Cyprien','oo','labo1');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch4','Philémon','rx','labo3');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch5','Melchior','rx','labo3');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch6','Pétronille','oo','labo1');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch7','George-Henri','oo','labo2');
INSERT INTO Chercheur(NumChercheur,NomChercheur,Specialite,NumLabo) VALUES
  ('cherch8','Donalda','si','labo1');


INSERT INTO projet (NumProjet,NomProjet,NumChercheurResp) VALUES
  ('proj1','Qu''est ce que l''univers?','cherch2');
INSERT INTO projet (NumProjet,NomProjet,NumChercheurResp) VALUES
  ('proj2','Le théorème de Kolmogorov','cherch3');
INSERT INTO projet (NumProjet,NomProjet,NumChercheurResp) VALUES
  ('proj3','Le Web de demain','cherch1');
INSERT INTO projet (NumProjet,NomProjet,NumChercheurResp) VALUES
  ('proj4','Inversion probabiliste bayésienne en analyse d''incertitude',NULL);

  
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj1','cherch1',1);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj2','cherch2',2);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj1','cherch3',2);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj1','cherch4',1);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj1','cherch5',2);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj2','cherch1',1);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj3','cherch2',1);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj2','cherch3',1);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj1','cherch2',2);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj2','cherch5',3);
INSERT INTO travailler (Numprojet,NumChercheur,nbJour) VALUES
  ('proj3','cherch6',2);


/*Partie 1*/
/*1
NumLabo varchar2(8) constraint nn_chercheur_labo not null,
Celle ligne signifie que l'on définit une colonne NumLbo qui une chaine de caractère 2 d'une taille variable inférieure ou égale à 8.
On a ajouté la contrainte not null qui empêche d’enregistrer une valeur nulle dans cette colonne.*/

/*2*/
SELECT Travailler.numProjet, COUNT(Travailler.numChercheur) AS NombreDeChercheurs
FROM Travailler
GROUP BY Travailler.numProjet
HAVING COUNT(Travailler.numChercheur) = 2;

/*3*/
SELECT COUNT(Travailler.numProjet) AS NombreDeProjet
FROM Travailler INNER JOIN Chercheur ON (Travailler.numChercheur = Chercheur.numChercheur)
WHERE Chercheur.nomChercheur = '&ask';

/*4*/
SELECT Projet.numProjet, Projet.nomProjet
FROM Projet
WHERE Projet.numProjet NOT IN (SELECT Projet.numProjet
                                FROM Projet INNER JOIN Travailler ON (Projet.numProjet = Travailler.numProjet));
     
                                
/*Partie 2*/
/*1*/
SET SERVEROUTPUT ON
BEGIN
  FOR l_chercheur IN (SELECT DISTINCT Travailler.numChercheur, Chercheur.nomChercheur
                      FROM Travailler INNER JOIN Chercheur ON (Travailler.numChercheur = Chercheur.numChercheur)) LOOP
    FOR l_projet IN (SELECT COUNT(Travailler.numProjet) AS nbProjets, SUM(nbJour) AS nbJour
                      FROM Travailler
                      WHERE Travailler.numChercheur = l_chercheur.numChercheur) LOOP
      DBMS_OUTPUT.PUT_LINE(l_chercheur.nomChercheur || ' travaille ' || l_projet.nbJour || ' jour(s) par semaine sur ' || l_projet.nbProjets || ' projet(s).');
    END LOOP;
  END LOOP;
END;
/

/*Partie3*/
/*1*/
SET SERVEROUTPUT ON
BEGIN
  FOR l_projet IN (SELECT DISTINCT Travailler.numProjet, Projet.nomProjet
                    FROM Travailler INNER JOIN Projet ON (Travailler.numProjet = Projet.numProjet)) LOOP
    FOR l_nombreHeuresProjet IN (SELECT SUM(Travailler.nbJour) AS nbJour
                                  FROM Travailler
                                  WHERE Travailler.numProjet = l_projet.numProjet) LOOP
      FOR l_chercheur IN (SELECT DISTINCT Travailler.numChercheur, Chercheur.nomChercheur, Travailler.nbJour
                          FROM Travailler INNER JOIN Chercheur ON (Travailler.numChercheur = Chercheur.numChercheur)
                          WHERE Travailler.numProjet = l_projet.numProjet) LOOP
        DBMS_OUTPUT.PUT_LINE(l_chercheur.nomChercheur || ' contribue à hauteur de ' || (l_chercheur.nbJour/l_nombreHeuresProjet.nbJour)*100 || '% dans le projet : ' || l_projet.nomProjet);
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

/*Bonus*/

ALTER TABLE Travailler
ADD Implication FLOAT;
/

SET SERVEROUTPUT ON
DECLARE
  l_implication FLOAT := 0.0;
BEGIN

  FOR l_projet IN (SELECT DISTINCT Travailler.numProjet, Projet.nomProjet
                    FROM Travailler INNER JOIN Projet ON (Travailler.numProjet = Projet.numProjet)) LOOP
    FOR l_nombreHeuresProjet IN (SELECT SUM(Travailler.nbJour) AS nbJour
                                  FROM Travailler
                                  WHERE Travailler.numProjet = l_projet.numProjet) LOOP
      FOR l_chercheur IN (SELECT DISTINCT Travailler.numChercheur, Chercheur.nomChercheur, Travailler.nbJour
                          FROM Travailler INNER JOIN Chercheur ON (Travailler.numChercheur = Chercheur.numChercheur)
                          WHERE Travailler.numProjet = l_projet.numProjet) LOOP
        l_implication := (l_chercheur.nbJour/l_nombreHeuresProjet.nbJour)*100;
        DBMS_OUTPUT.PUT_LINE(l_chercheur.nomChercheur || ' contribue à hauteur de ' || l_implication || '% dans le projet : ' || l_projet.nomProjet);
        UPDATE Travailler
        SET Implication = l_implication
        WHERE numChercheur = l_chercheur.numChercheur;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

SELECT *
FROM Travailler;
/
