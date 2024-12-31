--Start working on your Portfolio Project

--Import the excel files from ssms import and export management

-- All the columns:
-- iso_code	continent	location	date	total_cases	new_cases	new_cases_smoothed	total_deaths	new_deaths	new_deaths_smoothed	total_cases_per_million	new_cases_per_million	new_cases_smoothed_per_million	total_deaths_per_million	new_deaths_per_million	new_deaths_smoothed_per_million	reproduction_rate	icu_patients	icu_patients_per_million	hosp_patients	hosp_patients_per_million	weekly_icu_admissions	weekly_icu_admissions_per_million	weekly_hosp_admissions	weekly_hosp_admissions_per_million	total_tests	new_tests	total_tests_per_thousand	new_tests_per_thousand	new_tests_smoothed	new_tests_smoothed_per_thousand	positive_rate	tests_per_case	tests_units	total_vaccinations	people_vaccinated	people_fully_vaccinated	total_boosters	new_vaccinations	new_vaccinations_smoothed	total_vaccinations_per_hundred	people_vaccinated_per_hundred	people_fully_vaccinated_per_hundred	total_boosters_per_hundred	new_vaccinations_smoothed_per_million	new_people_vaccinated_smoothed	new_people_vaccinated_smoothed_per_hundred	stringency_index	population_density	median_age	aged_65_older	aged_70_older	gdp_per_capita	extreme_poverty	cardiovasc_death_rate	diabetes_prevalence	female_smokers	male_smokers	handwashing_facilities	hospital_beds_per_thousand	life_expectancy	human_development_index	population	excess_mortality_cumulative_absolute	excess_mortality_cumulative	excess_mortality	excess_mortality_cumulative_per_million
SELECT * 
FROM Portfolio_Project.dbo.COVID
WHERE 1=0

-- Selecting Indias Data

SELECT Location, 
		date, 
		total_cases
FROM Portfolio_Project.dbo.COVID
WHERE Location LIKE '%india%'
	AND CONTINENT IS NOT NULL
ORDER BY date


--Showing Countries with highest death count

SELECT Location,
       MAX(Total_Deaths) AS Total_Death_Count  -- Corrected column name
FROM Portfolio_Project.dbo.COVID
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY MAX(Total_Deaths) DESC;  -- Corrected ORDER BY clause


-- Showing Continents with Highest Death Counts

SELECT Continent,
       MAX(Total_Deaths) AS Total_Death_Count  -- Corrected column name
FROM Portfolio_Project.dbo.COVID
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY MAX(Total_Deaths) DESC;  -- Corrected ORDER BY clause

-- Death Percent: Total cases vs Total Deaths

SELECT Location,
		MAX(Date) AS Latest_Date,
		MAX(Total_Cases) AS Total_Cases,
        MAX(Total_Deaths) AS Total_Death_Count, 
	   	MAX(Total_Deaths)/NULLIF(MAX(Total_Cases), 0)*100 AS Death_Percentage

INTO 
	Portfolio_Project.dbo.Death_Percent

FROM 
	Portfolio_Project.dbo.COVID

WHERE Continent IS NOT NULL

GROUP BY 
		Location
ORDER BY 
		MAX(Total_Deaths) DESC;  -- Corrected ORDER BY clause


--Using OVER FUNCTION

SELECT 
    Location, 
    Continent, 
    Date, 
    Population,  -- Corrected the spelling mistake
    new_vaccinations,
    SUM(CONVERT(bigint, new_vaccinations)) OVER (PARTITION BY Location ORDER BY Date) as RollingPeopleVaccinated
FROM 
    Portfolio_Project.dbo.COVID
WHERE 
    Continent IS NOT NULL
ORDER BY
    Location,
    Date;

-- Use CTE: Common Table Expression

-- Define the CTE
WITH PopvsVac AS (
    SELECT 
        Continent,
        Location, 
        Date, 
        Population,
        SUM(CONVERT(bigint, new_vaccinations)) OVER (PARTITION BY Location ORDER BY Date) as RollingPeopleVaccinated
    FROM 
        Portfolio_Project.dbo.COVID
    WHERE 
        Continent IS NOT NULL
)

-- Select from the CTE and create a new table
SELECT * 
INTO Portfolio_Project.dbo.Rolling_People_Vaccinated
FROM PopvsVac
ORDER BY Location, Date;


