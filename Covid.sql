SELECT *
FROM Covid
ORDER BY 3,4

--Converting data types to the suitable types

--ALTER TABLE Covid
--ALTER COLUMN total_deaths INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN new_cases FLOAT
--GO

--ALTER TABLE Covid
--ALTER COLUMN new_deaths FLOAT
--GO

--ALTER TABLE Covid
--ALTER COLUMN total_tests INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN new_tests INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN total_vaccinations INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN people_vaccinated INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN people_fully_vaccinated INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN total_boosters INT
--GO

--ALTER TABLE Covid
--ALTER COLUMN population INT
--GO



--Studying the Data in Africa

--Total cases and deaths in Africa

SELECT location, population, SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths
FROM Covid
WHERE continent is NULL and location = ('Africa')
GROUP BY location, population 
ORDER BY 2



--Total cases and deaths in all African Countries

SELECT location, population, SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths
FROM Covid
WHERE continent = ('Africa')
GROUP BY location, population
ORDER BY 3 DESC



--Percentage of peope who got infected 

SELECT location, population, SUM(new_cases) as totalCases, (SUM(new_cases)/population*100) as infectionRate
FROM Covid
WHERE continent = ('Africa')
GROUP BY location, population
ORDER BY 1



--Death rate over cases

SELECT location, population, SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, (SUM(new_deaths)/SUM(new_cases)*100) as deathRate
FROM Covid
WHERE continent = ('Africa')
GROUP BY location, population
ORDER BY 3 DESC
--South Africa recorded the most covid cases and deaths in Africa



--Total cases and deaths in Nigeria

SELECT continent, location, population, SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths
FROM Covid
WHERE continent is not NULL and location = ('Nigeria')
GROUP BY continent, location, population 
ORDER BY 2



--Death rate in Nigeria

SELECT continent, location, population, SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as deathRate
FROM Covid
WHERE continent is not NULL and location = ('Nigeria')
GROUP BY continent, location, population 
ORDER BY 2



--Vaccinations in Africa

--Converting the column to the appropriate data type
UPDATE Covid
SET new_vaccinations = ISNULL(new_vaccinations,'0')

ALTER TABLE Covid
ALTER COLUMN new_vaccinations FLOAT
GO

UPDATE Covid
SET people_vaccinated = ISNULL(people_vaccinated,'0')

ALTER TABLE Covid
ALTER COLUMN people_vaccinated FLOAT
GO



--Total vaccination in all African Countries

SELECT continent, location, population, MAX(people_vaccinated) as totalVaccinations
FROM Covid
WHERE continent = ('Africa')
GROUP BY continent, location, population
ORDER BY 4 DESC
--Nigeria had the highest Vaccinations



--Vaccination rate in African countries

SELECT continent, location, population, MAX(people_vaccinated) as totalVaccinations, MAX(people_vaccinated)/population*100 as vaccinationRate
FROM Covid
WHERE continent = ('Africa')
GROUP BY continent, location, population
ORDER BY 4 DESC



--Total vaccinations in Africa

DROP TABLE IF EXISTS
CREATE TABLE #TempCovid(
continent NVARCHAR(255), location NVARCHAR(255), population FLOAT, totalVaccinations FLOAT)

INSERT INTO #TempCovid
SELECT continent, location, population, MAX(people_vaccinated) as totalVaccinations
FROM Covid
WHERE continent = ('Africa')
GROUP BY continent, location, population
ORDER BY 4 DESC

SELECT continent, SUM(population) as totalPopulation, SUM(totalVaccinations) as totalVaccination
FROM #TempCovid
GROUP BY continent



--Vaccination rate in Africa
SELECT continent, SUM(population) as totalPopulation, SUM(totalVaccinations) as totalVaccination, SUM(totalVaccinations)/SUM(population)*100 as vaccinationRate
FROM #TempCovid
GROUP BY continent