-- This project's main aim is to use SQL to analyze the movie dataset and answer a few questions.

select *
from dbo.Movies

-- Questions
-- Research Question 1 : Which year has the highest release of movies?
						Select release_year, count(id) as MovieCount_PerYear
						from dbo.Movies
						group by release_year
						order by MovieCount_PerYear desc

-- Research Question 2 : Which Movie Has The Highest Or Lowest Profit?
			--	Highest Profit		
						Select Top 1 title, Profit as Highest_Profit
						from dbo.Movies
						order by Profit desc

			-- Lowest Profit			
						Select Top 1 title, Profit as Lowest_Profit
						from dbo.Movies
						order by Profit

 -- Research Question 3 : Movie with Highest And Lowest Budget?
			--	Highest Budget		
						Select Top 1 title, budget as Highest_Budget
						from dbo.Movies
						order by budget desc

			-- Lowest Budget			
						Select Top 1 title, budget as Lowest_budget
						from dbo.Movies
						where budget <> 0
						order by budget

 -- Research Question 4 : Top 10 Movies with Largest And Lowest Earned Revenue?
			--	Highest Revenue		
							Select Top 10 title, revenue 
							from dbo.Movies
							order by revenue desc

			--	Lowest Revenue	
							Select Top 10 title, revenue 
							from dbo.Movies
							order by revenue 

 -- Research Question 5 : Movie with Longest And Shortest Runtime?
			--	Highest Runtime
							Select Top 1 title, runtime 
							from dbo.Movies
							order by runtime desc

			--	Shortest Runtime
							Select Top 1 title, runtime 
							from dbo.Movies
							where runtime <> 0
							order by runtime 

 -- Research Question 6 : 5 Movies with Highest And Lowest Votes?
			--	Highest Votes
							Select Top 5 title, vote_average 
							from dbo.Movies
							order by vote_average desc
			--	Lowest Votes
							Select Top 5 title, vote_average 
							from dbo.Movies
							order by vote_average 

 -- Research Question 7 : Which Year Has The Highest Profit Rate?
						Select release_year, sum(profit) as Total_Profits
						from dbo.Movies
						group by release_year
						order by Total_Profits desc

-- Research Question 8 : Which length movies most liked by the audiences according to their popularity?
						Select runtime, AVG(popularity) as Mean_Popularity
						from dbo.Movies
						group by runtime
						order by Mean_Popularity desc

 -- Research Question 9: Average Runtime Of Movies From Year To Year?
						Select release_year, AVG(runtime) as Avg_Runtime
						from dbo.Movies
						group by release_year
						order by release_year

 -- Research Question 10: Which Month Released Highest Number Of Movies In All Of The Years? And Which Month Made The Highest Average Revenue?
			--Top Months in Release			
						SELECT DATENAME(month, release_date) as [Month], COUNT(id) as Movie_Count
						from dbo.Movies
						group by DATENAME(month, release_date)
						order by Movie_Count desc
			
			--Top Months in Revenue
						SELECT DATENAME(month, release_date) as [Month], avg(revenue) as Avg_Revenue
						from dbo.Movies
						group by DATENAME(month, release_date)
						order by Avg_Revenue desc

 -- Research Question 11: Which Genre Has The Highest Release Of Movies?
						with genre_cte as 
								(select genres, value as Genre, id
								from dbo.Movies
								cross apply 
								string_split(genres, '|' ))

								Select Genre , count(id) as Total_Release
								from genre_cte
								group by Genre 
								order by Total_Release desc
 
 -- Reasearch Question 12: Most Frequent Actor?
						with Actor_cte as 
								(select cast, value as Actors, id
								from dbo.Movies
								cross apply 
								string_split(cast, '|' ))

								Select Actors , count(id) as Total_Release
								from Actor_cte
								group by Actors 
								order by Total_Release desc

 -- Reasearch Question 13: Top 20 Production Companies With Higher Number Of Release?
						with ProdComp_cte as 
								(select production_companies, value as Production_Company, id
								from dbo.Movies
								cross apply 
								string_split(production_companies, '|' ))

								Select Top 20 Production_Company , count(id) as Total_Release
								from ProdComp_cte
								group by Production_Company 
								order by Total_Release desc

 -- Reasearch Question 14: Life Time Profit Earn By Each Production Company
						with ProdComp_cte as 
								(select production_companies, value as Production_Company, Profit
								from dbo.Movies
								cross apply 
								string_split(production_companies, '|' ))

								Select Top 20 Production_Company , Sum(Profit) as Total_Profits
								from ProdComp_cte
								group by Production_Company 
								order by Total_Profits desc

 -- Research Question 15 : Top 20 Director Who Directs Maximum Movies?
							Select director, count(id) as Total_Release
							from dbo.Movies
							where director is not null
							group by director 
							order by Total_Release desc


	


