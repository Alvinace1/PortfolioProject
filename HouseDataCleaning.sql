SELECT *
FROM CovidDeaths
WHERE Continent is not NUll
ORDER BY location



--Data of major concern

SELECT date, Location, population,  total_cases, new_cases, total_deaths
FROM CovidDeaths
ORDER BY location, date



--Looking at the Total Cases vs The Total Deaths in Nigeria
--This shows the percentage of people who died from Covid in Nigeria

SELECT date, Location, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
FROM CovidDeaths
where location like '%nigeria%'
ORDER BY date



--Looking at the Total Cases vs The Population in Nigeria
--This shows the percentage of people who got Covid in Nigeria

SELECT date, Location, population, total_cases, (total_cases/population)*100 as InfectionRate
FROM CovidDeaths
where location like '%nigeria%'
ORDER BY date



-- Countries with the Highest infection per population
 
SELECT Location, Population, MAX(total_cases) as InfectionCount, MAX((total_cases/population))*100 as InfectionRate
FROM CovidDeaths
WHERE Continent is not NUll
GROUP BY Location, Population
ORDER BY InfectionRate DESC



--Showing the country with the higest death count per population

SELECT Location, MAX(total_deaths) as DeathCount
FROM CovidDeaths
WHERE Continent is not NUll
GROUP BY Location
ORDER BY DeathCount DESC



--Showing the continent with the higest death count per population

SELECT Location, population, MAX(total_deaths) as DeathCount, MAX((total_deaths/population))*100 as DeathRate
FROM CovidDeaths
WHERE Continent is NUll
GROUP BY Location, population
ORDER BY DeathCount DESC



-- continent with the Highest infection per population
 
SELECT Location, Population, MAX(total_cases) as InfectionCount, MAX((total_cases/population))*100 as InfectionRate
FROM CovidDeaths
WHERE Continent is NUll 
GROUP BY Location, Population
ORDER BY InfectionCount DESC



---Looking at the number of total cases and the death count daily

SELECT date, SUM(new_cases) as TotalCases, SUM(new_deaths)  as TotalDeaths
FROM CovidDeaths
WHERE Continent is not NUll
GROUP BY date
ORDER BY date



--Loking at countries with new cases and new deaths count daily

SELECT location, date, SUM(new_cases) as TotalCases, SUM(new_deaths)  as TotalDeaths --(total_cases/population)*100 as InfectionRate
FROM CovidDeaths
Where Continent is not NUll and new_cases+new_deaths <> 0
GROUP BY date, location
ORDER BY  Location, date



---Looking at the number of total cases and the death count

SELECT  SUM(new_cases) as TotalCases, SUM(new_deaths)  as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathRateOfInfected
FROM CovidDeaths
WHERE Continent is not NUll 



---Looking at the total death rate of the world population

SELECT (SELECT  MAX(population) FROM CovidDeaths WHERE Continent is NUll) as WorldPopulation 
, SUM(new_cases) as TotalCases, SUM(new_deaths)  as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathRateOfInfected
, SUM(new_deaths)/(SELECT  MAX(population) FROM CovidDeaths WHERE Continent is NUll)*100 as DeathRateOfWorld
FROM CovidDeaths
WHERE Continent is not NUll 



--Total number of people that has been vaccinated in all countries

SELECT Deaths.Continent, Deaths.Location, Population, SUM(new_vaccinations) as TotalVaccinations
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll 
GROUP BY Deaths.location, Deaths.Continent, Population
ORDER BY location



----When vaccinations started in all countries

--SELECT Deaths.Location, Vaccinated.date, SUM(new_vaccinations)
--FROM CovidDeaths as Deaths
--JOIN CovidVaccinations as Vaccinated
--	ON Deaths.Location = Vaccinated.Location 
--	and Deaths.date = Vaccinated.date
--WHERE Deaths.Continent is not NUll and new_vaccinations is not NUll
--GROUP BY Deaths.location, Vaccinated.date
--ORDER BY location, date




--Vaccination daily count

SELECT Deaths.Continent, Deaths.Location, Deaths.Date, Population, new_vaccinations
, SUM(new_vaccinations) over (partition by Vaccinated.location order by Vaccinated.Location, Vaccinated.date) as TotalVaccinationCount
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll and new_vaccinations is not null
ORDER BY location, date, Deaths.Continent



--Percentage of the total population vaccinated in a each country

SELECT Deaths.Continent, Deaths.Location, Population
, SUM(new_vaccinations) as TotalVaccinated, SUM(new_vaccinations)/Population as PercentageVaccinated
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll and new_vaccinations is not null
GROUP BY Deaths.Continent, Deaths.Location, Population
ORDER BY location, Deaths.Continent



--Creating a Temp Table for TotalVaccinated

DROP Tabel if Exists #TotalVaccination
CREATE TABLE #TotalVaccination
(Continent nvarchar (255),
Location nvarchar (255),  
Popuation numeric, 
TotalVaccinated numeric, 
PercentageVaccinated numeric)

INSERT INTO #TotalVaccination
SELECT Deaths.Continent, Deaths.Location, Population
, SUM(new_vaccinations) as TotalVaccinated, SUM(new_vaccinations)/Population as PercentageVaccinated
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll and new_vaccinations is not null
GROUP BY Deaths.Continent, Deaths.Location, Population
ORDER BY location, Deaths.Continent



--CREATING VIEWS TO STORE DATA FOR LATER VISUALIZATION
CREATE view TotalVaccinationCount AS
SELECT Deaths.Continent, Deaths.Location, Deaths.Date, Population, new_vaccinations
, SUM(new_vaccinations) over (partition by Vaccinated.location order by Vaccinated.Location, Vaccinated.date) as TotalVaccinationCount
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll and new_vaccinations is not null
----ORDER BY location, date, Deaths.Continent

CREATE view TotalNumberOfVaccinations AS
SELECT Deaths.Continent, Deaths.Location, Population, SUM(new_vaccinations) as TotalVaccinations
FROM CovidDeaths as Deaths
JOIN CovidVaccinations as Vaccinated
	ON Deaths.Location = Vaccinated.Location 
	and Deaths.date = Vaccinated.date
WHERE Deaths.Continent is not NUll 
GROUP BY Deaths.location, Deaths.Continent, Population


