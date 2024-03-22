-- Visualization

-- Total Cases reported through the time frame
select sum(cast(Total_Cases as BIGINT)) as Total_Cases
from (select max(total_cases) as Total_Cases from covid_deaths
group by location) as subqueryalias;

-- Total Deaths reported through the time frame
select sum(cast(Max_Deaths as BIGINT)) as Total_Deaths
from(
select max(total_deaths) as Max_Deaths from 
covid_deaths group by location) as subqueryalias;

-- Total Deaths by Continent and Location
select continent,location,max(total_deaths) as Total_Deaths
from covid_deaths
where location not like '%income%'
and location not in ('World','European Union')
and location not in (select distinct continent from covid_deaths)
group by continent,location
order by 3 desc;

-- Death count per continent
select continent,max(population) as Population,max(total_deaths) as TotalDeaths
from covid_deaths
where continent is not null and trim(continent) != ''
group by continent
order by 2 desc;

-- Death Rate by Location
select location, max(total_cases) as Total_Cases, max(total_deaths) as Total_Deaths, 
round((max(total_deaths)/cast(max(total_cases) as float))*100,4) as DeathPercentage
from covid_deaths
where location not like '%income%'
and location not in ('World','European Union')
and location not in (select distinct continent from covid_deaths)
group by location
having round((max(total_deaths)/cast(max(total_cases) as float))*100,4) is not null
order by 3 desc;






