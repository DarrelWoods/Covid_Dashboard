/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
	--[iso_code]
      [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      --,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      --,[new_deaths_smoothed]
      --,[total_cases_per_million]
      --,[new_cases_per_million]
      --,[new_cases_smoothed_per_million]
      --,[total_deaths_per_million]
      --,[new_deaths_per_million]
      --,[new_deaths_smoothed_per_million]
      --,[reproduction_rate]
      ,[icu_patients]
      --,[icu_patients_per_million]
      ,[hosp_patients]
      --,[hosp_patients_per_million]
      --,[weekly_icu_admissions]
      --,[weekly_icu_admissions_per_million]
      --,[weekly_hosp_admissions]
      --,[weekly_hosp_admissions_per_million]
  FROM [CovidProject].[dbo].[covid_deaths]

-- Total covid deaths by continent
  SELECT continent, SUM(CAST(new_deaths AS INT)) AS total_deaths_continent, SUM(new_deaths/population)*100 AS death_percent_continent	
  FROM CovidProject.dbo.covid_deaths
  WHERE continent IS NOT NULL
  GROUP BY continent
  ORDER BY total_deaths_continent DESC

  -- Total covid deaths and death percentage by country
  SELECT location, SUM(CAST(new_deaths AS INT)) AS total_deaths_country, population, SUM(new_deaths/population)*100 AS death_percent_country
  FROM CovidProject.dbo.covid_deaths
  WHERE continent IS NOT NULL
  GROUP BY location, population
  ORDER BY total_deaths_country DESC

  --Total covid cases by continent
  SELECT continent, MAX(CAST(total_cases AS INT)) AS total_cases_continent	
  FROM CovidProject.dbo.covid_deaths
  WHERE continent IS NOT NULL
  GROUP BY continent
  ORDER BY total_cases_continent DESC

  --Total covid cases by country
  SELECT location, SUM(CAST(new_cases AS INT)) AS total_cases_country
  FROM CovidProject.dbo.covid_deaths
  WHERE continent IS NOT NULL
  GROUP BY location
  ORDER BY total_cases_country DESC

  --Total vaccinations and percent of population vaccinated per country and date.
  SELECT d.location, d.date, MAX(CAST(v.people_fully_vaccinated AS INT)) AS total_vaccinations, MAX(v.people_fully_vaccinated/d.population)*100 AS percent_population_vaccinated
  FROM CovidProject.dbo.covid_deaths AS d JOIN CovidProject.dbo.covid_vaccinations AS v
	ON d.location = v.location 
	AND d.date = v.date --Joined the death and vaccination tables based on location and date
  WHERE d.continent IS NOT NULL
  GROUP BY d.location, d.date
  ORDER BY percent_population_vaccinated DESC
 
 --Creating a view based on the previous calculation
 CREATE VIEW percent_population_vaccinated AS
  SELECT d.location, MAX(CAST(v.people_fully_vaccinated AS INT)) AS total_vaccinations, MAX(v.people_fully_vaccinated/d.population)*100 AS percent_population_vaccinated
  FROM CovidProject.dbo.covid_deaths AS d JOIN CovidProject.dbo.covid_vaccinations AS v
	ON d.location = v.location 
	AND d.date = v.date
  WHERE d.continent IS NOT NULL
  GROUP BY d.location
  --ORDER BY percent_population_vaccinated DESC