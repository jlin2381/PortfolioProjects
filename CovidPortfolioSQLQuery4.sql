
SELECT *
FROM Covid_Portfolio..CovidDeaths
WHERE continent is not null
Order By 3,4



--SELECT *
--FROM Covid_Portfolio..CovidVaccinations
--Order By 3,4



-- SELECT Data that we will be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Portfolio..CovidDeaths
WHERE continent is not null
ORDER BY 1,2



-- Looking at the Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Covid_Portfolio..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2



-- Looking at the Total Cases vs Population
-- Shows what population has contracted Covid

SELECT Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2



-- Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Covid_Portfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc



-- Showing the Countries with the Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Covid_Portfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc



-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing Continents w/ Highest Death Count per Population
-- At this point, for real world, change FROM & GROUP BY continent to location and where is null. CONTINENT shows skewed numbers due to Continent & Location columns

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Covid_Portfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



-- Global Numbers


SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Covid_Portfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2



-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM Covid_Portfolio..CovidDeaths dea
JOIN Covid_Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3




-- USE CTE 

With PopvsVac (Continent, Location, Date, Population, new_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Covid_Portfolio..CovidDeaths dea
JOIN Covid_Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac
--WHERE location like '%states%'




-- USE TEMP TABLE
-- Had to use BIGINT instead of INT in line 146

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Covid_Portfolio..CovidDeaths dea
JOIN Covid_Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated
--WHERE location like '%states%'


-- Creating view to store data for later

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM Covid_Portfolio..CovidDeaths dea
JOIN Covid_Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated