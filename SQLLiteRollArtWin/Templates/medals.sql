

DROP VIEW IF EXISTS BDD_medaille_free;
create view BDD_medaille_free as

 SELECT  b.name , b.Societa, element, c.name as programme, 
    case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END as num_licence_athlete, f.num_licence, a.bonus,
count(element) as niveau

  FROM  Gara a , Classifica_Intestazione  b, segments c, Athletes d, PanelJudge e, Judges f
 where a.ID_GaraParams = b.ID_GaraParams and a.ID_Segment = b.ID_Segment AND A.numpartecipante = B.numstartinglist
 and b.name = d.name and b.ID_GaraParams = e.ID_GaraParams and e.ID_Judge = f.ID_Judge and e.Role = 'Referee'
 and a.id_segment = c.id_segments and A.pen not in ('<<<', '<<') and a.bonus not like ('%*%') and qoe_0 <> -3
 and a.Element not in ('ChSt', 'FoSq', 'ClSq', 'Tr', 'ASq', 'comp', 'U', 'S', 'Br', 'Iv', 'CBD', 'CFD', 'HBD', 'HFD')
 and substr(a.Element, 1, 2 ) <> 'NL'
  and substr(a.Element, 1, 2 ) <> 'St'  and c.id_segments in (1, 2)
  group by b.name, b.societa, element , c.name, case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END
Union
 SELECT  b.name , b.Societa, element, c.name as programme, 
    case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END as num_licence_athlete, f.num_licence, a.bonus, count(element) as niveau

  FROM  Gara a , Classifica_Intestazione  b, segments c, Athletes d, PanelJudge e, Judges f
 where a.ID_GaraParams = b.ID_GaraParams and a.ID_Segment = b.ID_Segment AND A.numpartecipante = B.numstartinglist
 and b.name = d.name and b.ID_GaraParams = e.ID_GaraParams and e.ID_Judge = f.ID_Judge and e.Role = 'Referee'
 and a.id_segment = c.id_segments and a.bonus not like ('%*%')
 and a.Element in ('U', 'S', 'Br', 'Iv', 'CBD', 'CFD', 'HBD', 'HFD')
 and substr(a.Element, 1, 2 ) <> 'NL'
  and substr(a.Element, 1, 2 ) <> 'St'  and c.id_segments in (1, 2)
  group by b.name, b.societa, element , c.name,  case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END

  Union
 SELECT  b.name , b.Societa, element, c.name as programme, 
    case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END as num_licence_athlete, f.num_licence, a.bonus,
count(element) as niveau

  FROM  Gara a , Classifica_Intestazione  b, segments c, Athletes d, PanelJudge e, Judges f
 where a.ID_GaraParams = b.ID_GaraParams and a.ID_Segment = b.ID_Segment AND A.numpartecipante = B.numstartinglist
  and b.name = d.name and b.ID_GaraParams = e.ID_GaraParams and e.ID_Judge = f.ID_Judge and e.Role = 'Referee'
 and a.id_segment = c.id_segments and A.pen in ('<<') and a.bonus not like ('%*%') and qoe_0 <> -3
 and a.element = '2A'
  group by b.name, b.societa, element , c.name, case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END
  Union
SELECT  b.name , b.Societa, substr(element, 1, 2) , c.name as programme, 

    case when d.Num_Licence IS NULL THEN 0
         else d.Num_Licence
    END as num_licence_athlete, f.num_licence, a.bonus,   
iif(substr(element, 3, 1) = 'B' , '0', iif(substr(element, 1 , 2) = 'NL' , '-1', substr(element, 3, 1))) as niveau

  FROM  Gara a , Classifica_Intestazione  b, segments c, Athletes d, PanelJudge e, Judges f
 where a.ID_GaraParams = b.ID_GaraParams and a.ID_Segment = b.ID_Segment AND A.numpartecipante = B.numstartinglist
   and b.name = d.name and b.ID_GaraParams = e.ID_GaraParams and e.ID_Judge = f.ID_Judge and e.Role = 'Referee'
  and a.id_segment = c.id_segments 
  and (substr(a.Element, 1, 2 ) = 'St' or substr(a.Element, 1, 4 ) = 'NLSt');




DROP VIEW IF EXISTS Ext_Medaille_free;
create view Ext_Medaille_free as
select
  num_licence_athlete, name, societa,  num_licence, 
  count(distinct(element)) filter (where element = '1W') as W1,
  count(distinct(element)) filter (where element = '1A') as A1,
  count(distinct(element)) filter (where element = '2A') as A2,
  count(distinct(element)) filter (where element = '3A') as A3,  
  count(distinct(element)) filter (where substr(element, 1, 1) = '1' and element <> '1W'  ) as Ju1,
  count(distinct(element)) filter (where substr(element, 1, 1) = '2') as Ju2,
  count(distinct(element)) filter (where substr(element, 1, 1) = '3') as Ju3,
  count(element) filter (where element = 'U') as U,
  count(element) filter (where element = 'U' and bonus = '%+') as UB,
  count(element) filter (where element = 'S') as S,
  count(element) filter (where element like 'C%D%') As C, 
  count(element) filter (where element like 'H%D%') As He, 
  count(element) filter (where element = 'Br') As Br, 
  count(element) filter (where element = 'In') as Iv,
  max(niveau) filter (where substr(element, 1, 2) = 'St') as FoSq
from BDD_medaille_free
group by num_licence_athlete,name, societa, num_licence;




DROP VIEW IF EXISTS Base_medaille_free;
create view Base_medaille_free as
SELECT num_licence_athlete, name, Societa, num_licence,
        W1 as valse,
       (A1) as Axel,
       (A2+A3) as DoubleAxel,
       (Ju1) as Simple,
       (Ju2+Ju3) as Jump,
       U as Up,
       S as Sit,
       C as Camel,
       (U+S+C+He+Iv+Br+UB) as Spin,
       FoSq as Step,
       CASE
            WHEN (A1+A2+A3)>=1
                 AND (Ju2+Ju3)>=2
                 AND (S>=1 AND (S+C+He+Iv+Br)>=3)
                 AND FoSq>='1'
           THEN 'Médaille Platine'
           WHEN (A1+A2+A3)>=1
                 AND (Ju2+Ju3)>=2
                 AND (S>=1 AND C>=1)
                 AND FoSq>='0'
           THEN 'Médaille Or'
           WHEN (A1+A2+A3)>=1
                 AND (Ju2+Ju3)>=1
                 AND (S>=1 OR C>=1)
                 AND FoSq>='0'
           THEN 'Médaille Vermeil'
           WHEN (A1+A2+A3)>=1
                 AND (S>=1 OR C>=1)
                 AND FoSq>='0'
           THEN 'Médaille Argent'
           WHEN (Ju1+Ju2+Ju3)>=4
                 AND (U+S+C+He+Iv+Br+UB)>=1
                 AND FoSq>='0'
           THEN 'Médaille Bronze'
           WHEN (Ju1+Ju2+Ju3)>=2
                 AND (U+S+C+He+Iv+Br+UB)>=1
                 AND FoSq>='0'
           THEN 'Médaille Préliminaire'
           ELSE '------'
       END as médaille                             
FROM Ext_Medaille_free
Order by médaille,name;







DROP VIEW IF EXISTS BDD_MEDAILLE_DANSE;
CREATE VIEW BDD_MEDAILLE_DANSE AS
SELECT Athletes.Name, Athletes.Societa, Segments.Name as programme, Gara.element as verification, substr(Gara.Element, 1, length(Gara.element) -1) as element,
case when substr(Gara.Element, length(Gara.element), 1) = 'B' then 0 else
case when substr(Gara.Element, 1,  2) = 'NL' then '-1' ELSE
substr(Gara.Element, length(Gara.element), 1) end END  as niveau,
Elements.id_elementscat as cat_elem,
case when Athletes.Num_Licence IS NULL THEN 0 else Athletes.Num_Licence END as num_licence,
GaraParams.ID_Competition as ID_Competition FROM Gara
INNER JOIN GaraParams ON (Gara.ID_GaraParams = GaraParams.ID_GaraParams and Gara.ID_Segment = GaraParams.ID_Segment)
INNER JOIN Participants ON (Participants.ID_GaraParams= Gara.ID_GaraParams AND Participants.ID_Segment=Gara.ID_Segment AND Participants.NumStartingList=Gara.NumPartecipante)
INNER JOIN Athletes ON (Athletes.ID_Atleta = Participants.ID_Atleta)
INNER JOIN GaraFinal ON (GaraFinal.ID_GaraParams=Gara.ID_GaraParams AND GaraFinal.ID_Segment = Gara.ID_Segment AND GaraFinal.NumPartecipante=Gara.NumPartecipante)
INNER JOIN Segments ON (Segments.ID_Segments=Gara.ID_Segment)
INNER JOIN Elements ON (Elements.Code=Gara.Element)
WHERE Segments.name not like '%Program%' 
and Gara.element <> 'ChStS';

DROP VIEW IF EXISTS sequence_danse;
create view sequence_danse as
SELECT num_licence, name, societa, 'sequence', niveau
FROM BDD_MEDAILLE_DANSE where cat_elem in ('10', '12')
order by num_licence, name, niveau desc;

DROP VIEW IF EXISTS total_score;

create view total_score As
SELECT num_licence, name, societa, 'Di' as element, round(avg(niveau), '0') as niveau FROM BDD_MEDAILLE_DANSE where cat_elem in ('13') group by num_licence, name, societa
UNION
SELECT num_licence, name, societa, 'Seq' as element, sum(niveau) as niveau from (SELECT num_licence, name, niveau, ROW_NUMBER() OVER(PARTITION BY num_licence, name) AS row_number,
societa FROM sequence_danse
order by name, niveau desc) As A where row_number <= 2
group by num_licence, name, societa
UNION
SELECT num_licence, name, societa, 'Tr' as element, max(niveau) as niveau
FROM BDD_MEDAILLE_DANSE
where  programme in ('Free Dance', 'Style Dance') and element in ('Tr', 'NLT')
group by num_licence, name, societa;

DROP VIEW IF EXISTS medailles_danse;
create view medailles_danse as 
With RECURSIVE ext(num_licence, name, societa,  danse_imposée, travelling, sequence_pas, total) AS
(select  num_licence, name, societa, sum(niveau) filter (where element = 'Di'), sum(niveau) filter (where element = 'Tr'),
sum(niveau) filter (where element = 'Seq'), ((sum(niveau) filter (where element = 'Di')) + (sum(niveau) filter (where element = 'Tr')) +
(sum(niveau) filter (where element = 'Seq'))) from total_score group by num_licence, name, societa )
select num_licence, name, societa, danse_imposée, travelling, sequence_pas, total, 
IIF( total = 0 , 'Médaille Préliminaire',
IIF( total = 0.0 , 'Médaille Préliminaire',
IIF( total = 1 , 'Médaille Bronze',
IIF( total between 2 and 3 , 'Médaille Argent',
IIF( total = 4 , 'Médaille Vermeil',
IIF( total = 5 , 'Médaille Or',
IIF( total >= 6 , 'Médaille Platine','------'))))))) as médaille from ext Order by médaille, name;


--select distinct 'free' typeMédaille, num_licence_athlete "Numéro de licence", (select max(DateEnd) from GaraParams) "date d'obtention", '' "date de fin", (select DISTINCT Place from GaraParams) "lieu d'obtention", 'FFRS' "code structure" , num_licence "numéro de licence du formateur / examinateur ", médaille commentaires
--from Base_medaille_free, GaraParams where médaille <> '------'
--UNION
--select distinct 'danse' typeMédaille, a.num_licence "Numéro de licence",  (select max(DateEnd) from GaraParams) "date d'obtention", '' "date de fin",  (select DISTINCT Place from GaraParams) "lieu d'obtention",  'FFRS' "code structure", "numéro de licence du formateur / examinateur ", médaille commentaires
--from medailles_danse a, GaraParams b, PanelJudge c, Judges d where médaille <> '------' and b.ID_GaraParams = c.ID_GaraParams and c.ID_Judge = d.ID_Judge and Role = 'Referee'
--order by médaille;


select distinct 'free' typeMédaille, num_licence_athlete "Numéro de licence", (select substr(max(DateEnd), 1, 10) from GaraParams) "date d'obtention", '' "date de fin", '' "numero_diplome",(
    select DISTINCT Place from GaraParams) "lieu d'obtention", 'FFRS' "code structure" , num_licence "numéro de licence du formateur / examinateur ", médaille commentaires
from Base_medaille_free, GaraParams where médaille <> '------'
UNION
select distinct 'danse' typeMédaille, a.num_licence "Numéro de licence",  (select  substr(max(DateEnd), 1, 10) from GaraParams) "date d'obtention", '' "date de fin",  '' "numero_diplome",(
    select DISTINCT Place from GaraParams) "lieu d'obtention",  'FFRS' "code structure", d.num_licence "numéro de licence du formateur / examinateur ", médaille commentaires from
                                                                                                                                                                                  medailles_danse a, GaraParams b, PanelJudge c, Judges d where médaille <> '------' and b.ID_GaraParams = c.ID_GaraParams and c.ID_Judge = d.ID_Judge and Role = 'Referee'
group by a.num_licence
order by médaille;