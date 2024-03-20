-- We'll perform data cleaning for the specific fields we work with given we'll not utilise all the columns

select * from covid_deaths;

select column_name, data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'covid_deaths';

-- data cleaning
alter table covid_deaths
alter column total_cases float;
alter table covid_deaths
alter column total_deaths float;
alter table covid_deaths
alter column total_cases_per_million float;
alter table covid_deaths
alter column total_cases integer;
alter table covid_deaths
alter column total_deaths_per_million float;
alter table covid_deaths
alter column total_cases integer;


-- Total Cases reported through the time frame
select sum(cast(Total_Cases as BIGINT)) as Total_Cases
from (select max(total_cases) as Total_Cases from covid_deaths
group by location) as MaxCases;

-- Total Deaths reported through the time frame
select sum(cast(Max_Deaths as BIGINT)) as Total_Deaths
from(
select max(total_deaths) as Max_Deaths from 
covid_deaths group by location) as subqueryalias;

-- Calculating the death percentage from cases
select (max(total_deaths)/max(total_cases))*100 AS Death_Percentage
FROM covid_deaths;

-- Total Deaths by Location
select location,max(total_deaths) as Total_Deaths
from covid_deaths
where location not like '%income%'
and location not in ('World','European Union')
and location not in (select distinct continent from covid_deaths)
group by location
order by 2 desc;

-- Death count per continent
select continent,max(population) as Population,max(total_deaths) as TotalDeaths
from covid_deaths
where continent is not null and trim(continent) != ''
group by continent
order by 2 desc;

-- Death Rate per location
select location, max(total_cases) as Total_Cases, max(total_deaths) as Total_Deaths, 
round((max(total_deaths)/cast(max(total_cases) as float))*100,4) as DeathPercentage
from covid_deaths
where location not like '%income%'
and location not in ('World','European Union')
and location not in (select distinct continent from covid_deaths)
group by location
having round((max(total_deaths)/cast(max(total_cases) as float))*100,4) is not null
order by 3 desc;


-- total cases vs population(positivity rate)
select location, max(total_cases) as Total_Cases,max(population) as Population,
round(max(total_cases)/max(population),4) as Infection_Rate 
from covid_deaths
where location not like '%income%'
and location not in ('World','European Union')
and location not in (select distinct continent from covid_deaths)
and total_cases is not null
group by location
order by 4 desc;

-- The Population and highest numbers of icu patients,hospital patients and Patients
select location,max(population) as Population,max(icu_patients_per_million) as Max_ICU_Patients,
max(hosp_patients_per_million) as Highest_Patients_Per_Million,max(hosp_patients) as Highest_Patients
from covid_deaths
group by location;


-- Vaccinations

-- Total Tests Conducted
select round(max(total_tests),0) as TotalTests from covid_vaccinations;

-- Total Vaccinations reported
select round(max(total_vaccinations),0) as TotalVaccinations from covid_vaccinations;

-- Total Boosters Administered
select round(max(total_boosters),0) as TotalBoosters from covid_vaccinations;

-- Locations and their corresponding Tests and Vaccinations
select location,max(total_tests) as TotalTests,max(total_vaccinations) as TotalVaccinations
from covid_vaccinations
--where total_tests is not null and trim(total_tests) != ''
group by location;


-- Total population vs vaccinations

with PopVsVacc(continent,location,population,total_vaccinations)
as(
select cd.continent,cd.location,max(cd.population) as Population,max(cv.total_vaccinations) as Total_Vaccinations from
covid_deaths cd
join covid_vaccinations cv
on cd.location = cv.location
group by cd.continent,cd.location
)
select *,(total_vaccinations/population)*100 from PopVsVacc;






