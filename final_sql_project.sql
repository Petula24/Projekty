
#Počet provedených testù                  
create or replace table provedene_testy as
select tests_performed, country, `date`   
from covid19_tests as ct;      


# Binární promìnná pro víkend/vední den (1_0) 
create or replace table binarni_promenna as         
select date,                                            
	country,                                            
	confirmed,                                          
	case when weekday(`date`) in (5, 6) then 1          
	else 0 end as weekend,                              
	# roční období daného dne                
	case when month(`date`) between 1 and 3 then 0      
		when month(`date`) between 4 and 6 then 1       
		when month(`date`) between 7 and 9 then 2       
		when month(`date`) between 10 and 12 then 3     
	end as season                                       
from covid19_basic_differences as base


# Hustota zalidnění
create or replace table hustota_zalidneni as
select country, population         
from lookup_table as lt      
where province is null; 


#HDP, GINI koeficient, dìtská úmrtnost
create or replace table z_economies as
select distinct                                           
 	e.country,                                       
 	e.GDP/e.population as HDP,                     
 	e.mortaliy_under5 as detska_umrtnost,            
 	e.gini as Gini                              
from economies as e                                  
where `year` = 2020
  

# Medián věku obyvatel 2018
create or replace table median as
select country,                                           
	round(median_age_2018,2) as median_vek           
from countries as c
)  


#Podil naboženstvi
create or replace table v_podil_nabozenstvi as                                                                              
with krestanstvi as (                                                                                           
	select country, population                                                                                  
	from religions as re                                                                                         
	where religion = 'Christianity' and `year` = 2020                                                           
	order by country                                                                                            
),                                                                                                              
islam as (                                                                                                      
	select country, population                                                                                  
	from religions as re                                                                                        
	where religion = 'Islam' and `year` = 2020                                                                  
	order by country                                                                                            
),                                                                                                              
hinduismus as (                                                                                                 
	select country, population                                                                                  
	from religions as re                                                                                         
	where religion = 'Hinduism' and `year` = 2020                                                               
	order by country                                                                                            
),                                                                                                              
budhismus as (                                                                                                  
	select country, population                                                                                  
	from religions as re                                                                                            
	where religion = 'Buddhism' and `year` = 2020                                                               
	order by country                                                                                            
),                                                                                                              
judaismus as (                                                                                                  
	select country, population                                                                                  
	from religions as re                                                                                            
	where religion = 'Judaism' and `year` = 2020                                                                
	order by country                                                                                            
),                                                                                                              
lidova_nab as (                                                                                                 
	select country, population                                                                                  
	from religions as re                                                                                            
	where religion = 'Folk Religions' and `year` = 2020                                                         
	order by country                                                                                            
),                                                                                                              
ostatni as (                                                                                                    
	select country, population                                                                                  
	from religions as re                                                                                            
	where religion = 'Other Religions' and `year` = 2020                                                        
	order by country                                                                                            
),                                                                                                              
nepridr_nab as (                                                                                                
	select country, population                                                                                  
	from religions as re                                                                                             
	where religion = 'Unaffiliated Religions' and `year` = 2020                                                 
	order by country                                                                                            
)                                                                                                               
select                                                                                                          
	rel_2020.country,                                                                                           
	round((k.population / total_population_2020) * 100, 2) as krestan_proc,                                     
	round((i.population / total_population_2020) * 100, 2) as islam_proc,                                       
	round((h.population / total_population_2020) * 100, 2) as hinduism_proc,                                    
	round((b.population / total_population_2020) * 100, 2) as buddhism_proc,                                    
	round((j.population / total_population_2020) * 100, 2) as judaism_proc,                                     
	round((l.population / total_population_2020) * 100, 2) as lidova_nab_proc,                                 
	round((o.population / total_population_2020) * 100, 2) as ostatni_proc,                                     
	round((n.population / total_population_2020) * 100, 2) as nepridr_nab_proc                                  
from                                                                                                            
	(                                                                                                           
	select re.country, re.year, sum(r.population) as total_population_2020                                        
	from religions as re                                                                                         
	where r.year = 2020                                                                                         
	group by re.country                                                                                          
) rel_2020                                                                                                      
left join krestanstvi as k                                                                                         
	on k.country = rel_2020.country                                                                             
left join islam i                                                                                               
	on i.country = rel_2020.country                                                                             
left join hinduismus h                                                                                          
	on h.country = rel_2020.country                                                                             
left join budhismus b                                                                                           
	on b.country = rel_2020.country                                                                             
left join judaismus j                                                                                           
	on j.country = rel_2020.country                                                                             
left join lidova_nab l                                                                                          
	on l.country = rel_2020.country                                                                             
left join ostatni o                                                                                             
	on o.country = rel_2020.country                                                                             
left join nepridr_nab n                                                                                         
	on n.country = rel_2020.country;   


# Rozdil mezi očekávanou dobou dožití v r. 1965 a v roce 2015
create or replace table rozdil_doziti as                                                                                             
select                                                            
	country, `year`,                                              
	life_expectancy as le_2015                                    
from life_expectancy as le                                        
where `year` = 2015                                               
)                                                                     
select                                                                
	base.country,                                                     
	le.life_expectancy - rozdil.le_1965 as rozdil         
from rozdil                                                           
join life_expectancy as le                                            
	on rozdil.country = le.country                                        
where le.`year` = 1965;


#Průměrná denní teplota
create or replace table prum_den_tepl as
select                                                                           
		`date`                                                   
		city,                                                                    
		avg(regexp_substr((temp,'[0-9]+')) as prumer             
from weather as w                                                               
where time between '06:00' and '19:00' and city is not null          
group by date, city  
)


# Nulové srážky:
create or replace table nulove_srazky as
select date, city,                                               
		sum(poc_hodin) AS pocet                                  
from (                                                           
	select `date`, city, `time`, rain ,                          
		case when rain = '0.0 mm' then 0                         
			else 3 end as poc_hodin                              
	from weather as w                                               
	where city is not null                                       
)  trn                                                           
group by `date`, city 
)


# Maximální síla větru:
create or replace table as
select                                                                   
	date,                                               
	city,                                                                
	max(gust) as sila_vetru                                              
from weather as w                                                           
where time between '00:00' and '21:00' and city is not null              
group by date(`date`), city;

# Hodnoty tabulky
create or replace table t_mesta (           
	mesta text(255),                        
	mesta_as text(255)                      
);                                          
insert into t_mesta (mesta, mesta_as)                                             
	values ('Amsterdam', 'Amsterdam'),                                            
	('Athens', 'Athenai'),                                                        
	('Belgrade', 'Belgrade'),                                                     
	('Berlin', 'Berlin'),                                                         
	('Bern', 'Bern'),                                                             
	('Bratislava', 'Bratislava'),                                                 
	('Brussels', 'Bruxelles [Brussel]'),                                          
	('Bucharest', 'Bucuresti'),                                                   
	('Budapest', 'Budapest'),                                                     
	('Chisinau', 'Chisinau'),                                                     
	('Copenhagen', 'Copenhagen'),                                                 
	('Dublin', 'Dublin'),                                                         
	('Helsinki', 'Helsinki [Helsingfors]'),                                       
	('Kiev', 'Kyiv'),                                                             
	('Lisbon', 'Lisboa'),                                                         
	('Ljubljana', 'Ljubljana'),                                                   
	('London', 'London'),                                                         
	('Luxembourg', 'Luxembourg [Luxemburg/L'),                                    
	('Madrid', 'Madrid'),                                                         
	('Minsk', 'Minsk'),                                                           
	('Moscow', 'Moscow'),                                                         
	('Oslo', 'Oslo'),                                                             
	('Paris', 'Paris'),                                                           
	('Prague', 'Praha'),                                                          
	('Riga', 'Riga'),                                                             
	('Rome', 'Roma'),                                                             
	('Skopje', 'Skopje'),                                                         
	('Sofia', 'Sofia'),                                                           
	('Stockholm', 'Stockholm'),                                                   
	('Tallinn', 'Tallinn'),                                                       
	('Tirana', 'Tirana'),                                                         
	('Vienna', 'Wien'),                                                           
	('Vilnius', 'Vilnius'),                                                       
	('Warsaw', 'Warszawa');                                                       
                                                                                  
alter table t_mesta convert to character set utf8mb4 collate 'utf8mb4_general_ci';

                                                                                 
# Tabulka zeme                                                                   
create or replace table t_zeme(                                                  
	zeme text(255),                                                              
	zeme_as text(255)                                                            
);                                                                               
insert into t_zeme(zeme, zeme_as)                                                
	values ('Albania', 'Albania'),                                               
	('Austria', 'Austria'),                                                      
	('Belarus', 'Belarus'),                                                      
	('Belgium', 'Belgium'),                                                      
	('Bulgaria', 'Bulgaria'),                                                    
	('Czech republic', 'Czechia'),                                               
	('Denmark', 'Denmark'),                                                      
	('Estonia', 'Estonia'),                                                      
	('Finland', 'Finland'),                                                      
	('France', 'France'),                                                        
	('Germany', 'Germany'),                                                      
	('Greece', 'Greece'),                                                        
	('Hungary', 'Hungary'),                                                      
	('Ireland', 'Ireland'),                                                      
	('Italy', 'Italy'),                                                          
	('Latvia', 'Latvia'),                                                        
	('Lithuania', 'Lithuania'),                                                  
	('Luxembourg', 'Luxembourg'),                                                
	('Moldova', 'Moldova'),                                                      
	('Netherlands', 'Netherlands'),                                              
	('North Macedonia', 'North Macedonia'),                                      
	('Norway', 'Norway'),                                                        
	('Poland', 'Poland'),                                                        
	('Portugal', 'Portugal'),                                                    
	('Romania', 'Romania'),                                                      
	('Russian Federation', 'Russia'),                                            
	('Serbia', 'Serbia'),                                                        
	('Slovakia', 'Slovakia'),                                                    
	('Slovenia', 'Slovenia'),                                                    
	('Spain', 'Spain'),                                                          
	('Sweden', 'Sweden'),                                                        
	('Switzerland', 'Switzerland'),                                              
	('Ukraine', 'Ukraine'),                                                      
    ('United Kingdom', 'United Kingdom');                                        
alter table t_zeme convert to character set utf8mb4 collate 'utf8mb4_general_ci';


# 1. část
create or replace table t_cast_1         
select distinct                          
	pt.tests_performed,                  
	pt.country,                          
	pt.`date`,                           
	bp.rocni_obdobi,                     
	bp.weekend                           
from provedene_testy as pt               
join binarni_promenna as bp              
	on pt.country = bp.country           
	and pt.`date` = bp.`date`; 


# 2. část	
create or replace table t_cast_2 
select 
	hz.population,
	ze.HDP,
	ze.detska_umrtnost, 
	ze.Gini,
	m.median_vek,
	pn.krestan_proc,
	pn.islam_proc,
	pn.hinduism_proc,
	pn.buddhism_proc,
	pn.judaism_proc,
	pn.lidova_nab_proc,
	pn.ostatni_proc,
	pn.nepridr_nab_proc,
	dz.rozdil 
from hustota_zalidneni as hz 
join z_economies as ze 
	on hz.country = ze.country 
join median as m 
	on hz.country = m.country
join podil_nabozenstvi as pn 
	on hz.country = m.country 
join delka_zivota as dz 
	on hz.country = dz.country; 


# 3. část
create or replace table t_cast_3               
select                                         
	pdt.prumer,                                
	pdt.city 
	ns.pocet,                                  
	msv.sila_vetru                             
from prum_den_tepl as pdt                      
join nulove_srazky as ns                       
	on pdt.`date` = ns.`date`                  
	and pdt.city = ns.city                     
join max_sila_vetru as msv                     
	on pdt.`date` = msv.`date`                 
	and pdt.city = msv.city;                   	
	
    
# Spojení tabulek
create or replace table spoje_tab         
select                                    
	tc2.*,                                
	tc3.pocet,                            
	tc3.prumer,                           
	tc3.sila_vetru,                       
	tm.mesta_as,                          
	tz.zeme_as                            
from t_cast_2 as tc2                      
join t_zeme as tz                         
	on tc2.country = tz.zeme_as           
join t_cast_3 as tc3                      
	on tc3.city = tc2.country             
join t_mesta as tm                        
	on tm.mesta = tc3.city;


# Finální tabulka
create or replace table t_Zikmundova_final_sql_project
select distinct                                       
	tc1.country,                                      
	tc1.tests_performed,                              
	tc1.rocni_obdobi,                                 
	tc1.weekend,                                      
	tst.population,                                   
	tst.HDP,                                          
	tst.detska_umrtnost,                              
	tst.Gini,                                         
	tst.median_vek,                                   
	tst.krestan_proc,                                 
	tst.islam_proc,                                   
	tst.hinduism_proc,                                
	tst.buddhism_proc,                                
	tst.judaism_proc,                                 
	tst.lidova_nab_proc,                              
	tst.ostatni_proc,                                 
	tst.nepridr_nab_proc,                             
	tst.rozdil,                                       
	tst.pocet,                                        
	tst.prumer,                                       
	tst.sila_vetru,                                   
	tst.mesta_as,                                     
	tst.zeme_as                                       
from t_cast_1 as tc1                                  
join t_spoje_tab as tst                               
	on tc1.country = tst.zeme_as;                     