Select *
FROM SQLTutorial..Covid_Deaths
Where continent <> ' '
order by 3,4


-- Selecting Data that is going to be use

Select location, date, total_cases, new_cases, total_deaths, population
FROM SQLTutorial..Covid_Deaths
order by 1,2


-- Looking at a Total Cases vs Total Death
-- shows the likelihood of dying if contract covid in the country

Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
FROM SQLTutorial..Covid_Deaths
Where location like '%Malaysia%'
AND continent <> ' '
order by 1,2


-- Looking at Total Cases vs Population
-- Shows the likelihood of dying if contract covid in the country

Select location, date, population, total_cases,  (cast(total_cases as float)/cast(population as float))*100 as positvecasesPercentage
FROM SQLTutorial..Covid_Deaths
--Where location like '%Malaysia%'
Where population != '0'
AND continent <> ' '
order by 1,2


-- Looking at countrie with Highest Infection Rate compared to Population
-- Excluded location = Northern Cyprus, International due to its population=0, causing a MSG8134 

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPercentage
FROM SQLTutorial..Covid_Deaths
--Where location like '%cyprus%'
Where population != '0'
AND continent <> ' '
Group by location, population
order by InfectedPercentage DESC 


-- Showing countries with highest death count perpopulation

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLTutorial..Covid_Deaths
--Where location like '%cyprus%'
--Where population != '0'
Where continent <> ' '
Group by location
order by TotalDeathCount DESC 


-- Break things down by continent
-- Showing the continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLTutorial..Covid_Deaths
--Where location like '%cyprus%'
--Where population != '0'
Where continent <> ' '
Group by continent
order by TotalDeathCount DESC 


-- Global Numbers

Select  SUM(new_cases) as total_newcases, SUM(cast(new_deaths as int)) as total_newdeath, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM SQLTutorial..Covid_Deaths
--Where location like '%Malaysia%'
Where new_cases != '0'
And continent <> ' '
--group by date
order by 1,2


-- Looking at covid_vacinnations table

Select *
FROM SQLTutorial..Covid_Vaccinations
order by 3,4


-- Joining both tables

Select *
FROM SQLTutorial..Covid_Deaths dea
Join SQLTutorial..Covid_Vacinnations vac
	on dea.location = vac.location
	and dea.date = vac.date


-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM SQLTutorial..Covid_Deaths dea
Join SQLTutorial..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent <> ' '
order by 2,3


-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM SQLTutorial..Covid_Deaths dea
Join SQLTutorial..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent <> ' '
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PopulationVaccinatedPercentage
From PopvsVac
Where Population != '0'


-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM SQLTutorial..Covid_Deaths dea
Join SQLTutorial..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent <> ' '
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as PopulationVaccinatedPercentage
From #PercentPopulationVaccinated
Where Population != '0'



-- Creating view to store data for later

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM SQLTutorial..Covid_Deaths dea
Join SQLTutorial..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent <> ' '
--order by 2,3

Select *
from PercentPopulationVaccinated