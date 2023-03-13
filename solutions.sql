USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


select count(*) as num_rows from imdb.director_mapping;
select count(*) as num_rows from imdb.genre;
select count(*) as num_rows from imdb.movie;
select count(*) as num_rows from imdb.`names`;
select count(*) as num_rows from imdb.ratings;
select count(*) as num_rows from imdb.role_mapping;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- A primary key cannot have null values

select 
	case when  sum((case when title is null then 1 else 0 end)) > 0 then 1 else 0 end as title_null,
	case when  sum((case when year is null then 1 else 0 end)) > 0 then 1 else 0 end as year_null,
    case when  sum((case when date_published is null then 1 else 0 end)) then 1 else 0 end as date_published_null,
    case when  sum((case when duration is null then 1 else 0 end)) then 1 else 0 end  as duration_null,
    case when  sum((case when country is null then 1 else 0 end)) then 1 else 0 end as country_null,
    case when  sum((case when worlwide_gross_income is null then 1 else 0 end)) then 1 else 0 end as worlwide_gross_income_null,
    case when  sum((case when languages is null then 1 else 0 end)) then 1 else 0 end as languages_null,
    case when  sum((case when production_company is null then 1 else 0 end)) then 1 else 0 end as production_company_null
from
	movie
;	







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select
	year(date_published) as Year,
    count(*) as number_of_movies
from
	movie
group by     
    year(date_published)
;  


select
	month(date_published) as month_num,
    count(*) as number_of_movies
from
	movie
group by     
    month(date_published)
;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


select 
	count(*)
from
	movie
where
	(lower(country) like '%india%' or lower(country) like '%usa%')
	and year(date_published) = 2019
;





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


select 
	genre
from
	genre
group by genre
;        
  




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:



select 
	genre as `genre`,
    count(*) as `number_movies`
from
	movie m
inner join 
	genre g
on m.id = g.movie_id	
group by genre
order by count(*) desc
;




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(*) from
(
	select 
		movie_id,
		count(*) as genre_count
	from
		genre
	group by movie_id
	having genre_count = 1
) as t1
;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select 
	genre as `genre`,
    avg(duration) as `avg_duration`
from
	movie m
inner join 
	genre g
on m.id = g.movie_id	
group by genre
;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


select 
	genre as `genre`,
    count(*) as `movie_count`,
    rank() over (order by count(*) desc) as genre_rank
from
	movie m
inner join 
	genre g
on m.id = g.movie_id	
group by genre
order by genre_rank desc
;




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


select 
	min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from
	ratings r
;



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select
	title,
    avg_rating,
    row_number() over (order by avg_rating desc) as movie_rank
from
	movie m
inner join 
	ratings rtg
		on rtg.movie_id =  m.id 
limit 10
;		

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select
	median_rating,
    count(*) as movie_count
from   
   ratings
group by median_rating   
order by median_rating asc 	
;	
	

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select
	m.production_company,
    count(*) as movie_count,
	rank() over (order by count(*) desc) as prod_company_rank	
from
	movie m
inner join 
	ratings rtg
on rtg.movie_id = m.id
where
	m.production_company is not null
    and rtg.avg_rating > 8
group by m.production_company
;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select
	genre,
    count(*) as movie_count
from
	genre g
inner join
	ratings rtg 
on
	g.movie_id = rtg.movie_id
inner join movie m
	on m.id = rtg.movie_id
    
where
	rtg.total_votes > 1000
		and m.year = 2017
		and month(m.date_published) = 3
        and year(m.date_published) = 2017
group by genre
;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


select
	m.title,
    rtg.avg_rating,
    g.genre
from
	genre g
inner join
	ratings rtg 
on
	g.movie_id = rtg.movie_id
inner join movie m
	on m.id = rtg.movie_id
where
	rtg.avg_rating > 8
    and m.title like 'The %'
;	



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select
	count(*)
from
	ratings rtg 
inner join movie m
	on m.id = rtg.movie_id
    
where
	rtg.median_rating = 8
    and m.date_published between '2018-04-01' and '2019-04-01'
;	








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select 
	(case when german_votes > italian_votes then 1 else 0 end) as res
from
	(select
		sum(case when lower(m.country) like '%germany%' then rtg.total_votes else 0 end) as german_votes,
		sum(case when lower(m.country) like '%italy%' then rtg.total_votes else 0 end) as italian_votes
	from
		ratings rtg
	inner join movie m
		on m.id = rtg.movie_id
	) as t1
;	



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select 
	sum(case when `name` is null then 1 else 0 end) as name_nulls, 
	sum(case when height is null then 1 else 0 end) as height_nulls, 
	sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls , 
	sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls	
from
	`names`
 ;   
    

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select
	`name`,
	count(*) as movie_count
from
	director_mapping dm
inner join movie m
	on m.id = dm.movie_id
inner join `names` nm
	on nm.id = dm.name_id 
inner join genre g2
	on g2.movie_id = m.id
inner join 
(
	select
		g.genre,
        row_number() over (order by count(*) desc) as genre_rank
	from
		genre g
	inner join
		ratings rtg 
	on
		g.movie_id = rtg.movie_id
	inner join movie m
		on m.id = rtg.movie_id
	where
		rtg.avg_rating > 8
	group by genre 
) as t1

on  g2.genre = t1.genre
where
t1.genre_rank <= 3
group by dm.name_id
;	

    
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select
	`name` as actor_name,
    count(*) as movie_count 
from
	role_mapping rm
inner join
	`names` nm
on nm.id = rm.name_id
inner join 
	ratings rtg
on rtg.movie_id = rm.movie_id 
inner join movie m
	on m.id = rm.movie_id
where
	category = 'actor'
    and median_rating >= 8
 group by name_id
 order by count(*) desc
 limit 2
;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select
	m.production_company,
    sum(rtg.total_votes) as vote_count, 
    row_number() over (order by sum(rtg.total_votes) desc) as prod_comp_rank 
from
	ratings rtg
inner join movie m
	on m.id = rtg.movie_id
where
	m.production_company is not null	
group by m.production_company    
limit 3
;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
	`name` as actor_name,
    sum(rtg.total_votes) as total_votes, 
    count(*) as movie_count,
    sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) as actor_avg_rating,
    rank() over (order by sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) desc, sum(rtg.total_votes)  desc)  as actor_rank
from
	role_mapping rm
inner join
	`names` nm
on nm.id = rm.name_id
inner join 
	ratings rtg
on rtg.movie_id = rm.movie_id 
inner join movie m
	on m.id = rm.movie_id
where
	category = 'actor'
    and lower(country) like '%india%'
 group by name_id
 having count(*) >= 5
;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
	`name` as actress_name,
    sum(rtg.total_votes) as total_votes, 
    count(*) as movie_count,
    sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) as actress_avg_rating,
    rank() over (order by sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) desc, sum(rtg.total_votes)  desc)  as actress_rank
from
	role_mapping rm
inner join
	`names` nm
on nm.id = rm.name_id
inner join 
	ratings rtg
on rtg.movie_id = rm.movie_id 
inner join movie m
	on m.id = rm.movie_id
where
	category = 'actress'
    and lower(country) like '%india%'
    and lower(languages) like '%hindi%'
 group by name_id
 having count(*) >= 3
;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


select
	m.title,
    case 
		 when rtg.avg_rating > 8 then 'Superhit movies' 
		 when rtg.avg_rating > 7 and rtg.avg_rating <= 8 then 'Hit movies'
         when rtg.avg_rating >= 5 and rtg.avg_rating <= 7 then 'One-time-watch movies'
         when rtg.avg_rating < 5 then 'Flop movies'
    else
		'Flop movies'
    end as ctg
from
	genre g
inner join
	ratings rtg 
on
	g.movie_id = rtg.movie_id
inner join movie m
	on m.id = rtg.movie_id
where
	lower(g.genre) like '%thriller%'
;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select
	genre,
    avg(duration) as avg_duration,
    sum(duration) over w1 as running_total_duration,
    avg(duration) over w1 as moving_avg_duration
from
	genre g
inner join movie m
	on m.id = g.movie_id   
group by genre
window w1 as (order by genre rows unbounded preceding) 
;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

select 
	t2.*
from    
(
select
    g.genre,
    m.`year`,
    m.title,
    cast(replace(m.worlwide_gross_income , "$" , "") as unsigned) as worldwide_gross_income,
    rank() over (partition by m.year order by cast(replace(m.worlwide_gross_income , "$" , "") as unsigned) desc) as movie_rank
from
	genre g
inner join movie m
	on m.id = g.movie_id
inner join 
(
	select
		g.genre,
        row_number() over (order by count(*) desc) as genre_rank
	from
		genre g
	inner join movie m
		on m.id = g.movie_id
	group by genre 
) as t1
on t1.genre = g.genre 
where
	t1.genre_rank <= 3
    and m.worlwide_gross_income is not null
) as t2
where
	t2.movie_rank <= 3	
;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select
	m.production_company,
	count(*) as movie_count,
    rank() over (order by count(*) desc)   as prod_comp_rank
from
	movie m
inner join
	ratings rtg
on rtg.movie_id = m.id
where
	rtg.median_rating >= 8
    and m.languages like '%,%'
    and m.production_company is not null
group by  m.production_company
limit 2   
;	


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
	`name` as actress_name,
    sum(rtg.total_votes) as total_votes, 
    count(*) as movie_count,
    sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) as actress_avg_rating,
    rank() over (order by sum(rtg.avg_rating*rtg.total_votes)/sum(rtg.total_votes) desc, sum(rtg.total_votes)  desc)  as actress_rank
from
	role_mapping rm
inner join
	`names` nm
on nm.id = rm.name_id
inner join 
	ratings rtg
on rtg.movie_id = rm.movie_id 
inner join movie m
	on m.id = rm.movie_id
inner join genre g
	on m.id = g.movie_id    
where
	category = 'actress'
    and rtg.avg_rating > 8
    and lower(g.genre) like '%drama%'
 group by name_id
 limit 3
;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with avg_inter_movie_days_v2 as (
	select
		dm.name_id,
        m.date_published,
        lead(m.date_published, 1)  over (partition by dm.name_id   order by dm.name_id asc, m.date_published asc) as next_date_published,
        datediff(lead(m.date_published, 1)  over (partition by dm.name_id   order by dm.name_id), m.date_published) as date_diff
	from
		movie m
    inner join
		director_mapping dm
    on 
		dm.movie_id = m.id
),
avg_inter_movie_days_v3 as (select 
	avg(date_diff) as ddf,
    name_id
from
	avg_inter_movie_days_v2	
group by 
	name_id	
) 

select
	dm.name_id,
    nm.`name`,
    count(*) as `number_of_movies`,
    av3.ddf as `avg_inter_movie_days`,
    rtg.avg_rating as avg_rating,
    sum(rtg.total_votes) as `total_votes`,
    min(rtg.avg_rating) as `min_rating`,
    max(rtg.avg_rating) as `max_rating`,
    sum(m.duration) as total_duration
from
	director_mapping dm
inner join
    movie m
	on dm.movie_id = m.id
inner join `names` nm
	on nm.id = dm.name_id
inner join `ratings` rtg
	on rtg.movie_id = m.id 
inner join avg_inter_movie_days_v3 av3 
    on dm.name_id = av3.name_id
group by dm.name_id
order by count(*) desc
limit 9
;
	
    
	





