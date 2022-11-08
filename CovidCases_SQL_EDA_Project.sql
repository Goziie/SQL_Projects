/*
Covid 19 cases in Nigeria Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


select *
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3, 4


--Selecting data to begin with

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1, 2

-- Total Cases Vs Total Deaths in Nigeria

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where total_deaths is not null and 
 continent is not null and
location like '%Nigeria%'
order by 1, 2


-- Total Cases Vs Population in Nigeria
Select location, date, Population, total_cases, (total_cases/population)*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where location like '%Nigeria%' and 
continent is not null and
total_cases is not null 
order by 1, 2

--Total Cases Count & Infected Population Percentage in Nigeria
Select location, Population, max(total_cases) as Total_Case_Count, max((total_cases/population)*100)  as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where total_cases is not null and
location like '%Nigeria%'
Group by location, population

--Most Infectious Countries By Population and Infected Population Percentage
Select location, Population, max(total_cases) as Total_Case_Count, max((total_cases/population)*100)  as TopInfectiousPopulationPercentage
from PortfolioProject.dbo.CovidDeaths
where total_cases is not null and
continent is not null
Group by location, population
order by TopInfectiousPopulationPercentage desc

--Death Cases Count in Nigeria
Select location, max(cast(total_deaths as int)) as Death_Count
from PortfolioProject.dbo.CovidDeaths
where total_deaths is not null and
location like '%Nigeria%'
Group by location


--Most Death Cases in Countries 
Select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
where total_deaths is not null and
continent is not null 
Group by location
order by HighestDeathCount desc

--Most Death Cases in Africa
Select continent, max(cast(total_deaths as int)) as Death_Count
from PortfolioProject.dbo.CovidDeaths
where total_deaths is not null and
continent like '%Africa%'
Group by continent


--Most Death Cases by Continent 
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
where total_deaths is not null and
continent is not null 
Group by continent
order by HighestDeathCount desc

-- Total Global Cases & Death Population Percentage
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(CAST(new_deaths as int))/ sum(new_cases) * 100 as GlobalDeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
order by 1, 2

-- Daily Total Global Cases
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(CAST(new_deaths as int))/ sum(new_cases) * 100 as GlobalDeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
group by date
order by 1, 2

-- Total Population Vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
order by 2, 3

-- Total Population Vs Vaccinations in Nigeria
-- Shows the cumulative count of people that have recieved at least one Covid Vaccine in Nigeria
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over(partition by dea.location Order by dea.location, dea.date) as CumulativeCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null and 
dea.location like '%Nigeria%'
order by 2, 3

-- Using CTE to perform Calculation on Partition By in previous query and also show the percentage population of Vaccinated people in Nigeria

With VacPop ( Continent, Location, date, Population, New_Vaccinations, RollingCountOfVaccinatedPeople)
as 
( 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over(partition by dea.location Order by dea.location, dea.date) as RollingCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null
)	
Select * , (RollingCountOfVaccinatedPeople/Population) * 100 as VacPop_Percentage
From VacPop
where location like '%Nigeria%' and
Population is not null

-- Create Views
Create View PercentVaccinatedPopulation as  
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location Order by dea.location, dea.date) as RollingCountOfVaccinatedPeople
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date 
where dea.continent is not null

Select *
from PercentVaccinatedPopulation