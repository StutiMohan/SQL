
-- * 1a. Display the first and last names of all actors from the table `actor`.

SELECT 
	first_name
    ,Last_Name 
    FROM sakila.actor
    ;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT 
    CONCAT(upper(first_name)
    ,+ ' '
    ,upper(Last_Name)) AS Actor_Name
	FROM sakila.actor
    ;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id
	,first_name
    ,last_name
	from sakila.actor 
    where first_name = "Joe"
    ;
    
-- * 2b. Find all actors whose last name contain the letters `GEN`:

select actor_id
	,first_name
    ,last_name
	from sakila.actor 
    where last_name like "%GEN%"
    ;
    
-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

SELECT 
    actor_id
    ,first_name
    ,last_name
	FROM sakila.actor
	WHERE last_name LIKE '%LI%'
	ORDER BY last_name 
		,first_name
        ;

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id
	,country
	from sakila.country 
	where country in('Afghanistan','Bangladesh','China');
        
-- * 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

ALTER TABLE  sakila.actor
ADD COLUMN middle_name VARCHAR(30) AFTER first_name
;

-- * 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE  sakila.actor
MODIFY COLUMN middle_name blob ;

-- * 3c. Now delete the `middle_name` column.

ALTER TABLE  sakila.actor
DROP COLUMN middle_name;

-- * 4a. List the last names of actors, as well as how many actors have that last name.

select last_name
	,count(last_name) 
    from sakila.actor 
    group by last_name
    ;

-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name
	,count(last_name) 
    from sakila.actor  
    group by last_name 
    having count(last_name) >= 2;

-- * 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husbands yoga teacher. Write a query to fix the record.

/* select first_name
	,last_name 
    from sakila.actor 
    where first_name = "GROUCHO" and last_name = "WILLIAMS"; */

UPDATE sakila.actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO"
and last_name = "WILLIAMS";

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

/* select first_name, last_name from sakila.actor where first_name = "HARPO" and last_name = "WILLIAMS";
select first_name, last_name from sakila.actor where last_name = "WILLIAMS"; */

UPDATE sakila.actor 
SET first_name=(
	CASE WHEN first_name="HARPO" THEN "GROUCHO"
    ELSE "MUCHO GROUCHO"
    END)
	WHERE first_name in("HARPO","GROUCHO") 
    AND last_name="WILLIAMS";

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
-- * Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>

SELECT  *
	FROM INFORMATION_SCHEMA.TABLES
	where TABLES.TABLE_NAME = "address";

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select s.first_name
	,s.last_name
    ,a.address
    ,a.address2
    ,a.district
    ,C.city
    ,a.postal_code
    from sakila.staff S inner join sakila.ADDRESS A ON S.address_id = A.address_id
    JOIN sakila.CITY C ON A.city_id = C.city_id
    ;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

SELECT 
	 S.FIRST_NAME
	,S.LAST_NAME
	,P.AMOUNT 
    ,P.STAFF_ID
    ,S.STAFF_ID 
	FROM SAKILA.STAFF S 
    RIGHT JOIN SAKILA.PAYMENT P ON S.STAFF_ID = P.STAFF_ID
    WHERE P.PAYMENT_DATE BETWEEN "2005-08-01" AND "2005-08-31"

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT F.TITLE 
    ,COUNT(A.ACTOR_ID) AS Number_of_Actors
	from SAKILA.ACTOR A
    INNER JOIN SAKILA.FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
    INNER JOIN SAKILA.FILM F ON FA.FILM_ID = F.FILM_ID
    GROUP BY F.TITLE 
    ORDER BY F.TITLE 
    ;

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT F.TITLE
		,COUNT(I.INVENTORY_ID) AS "Number of Copies"
	FROM SAKILA.FILM F
	INNER JOIN SAKILA.INVENTORY I ON F.FILM_ID = I.FILM_ID
    WHERE TITLE = "Hunchback Impossible"
    GROUP BY F.TITLE;
     ; 

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT   C.FIRST_NAME
		,C.LAST_NAME
        ,SUM(P.AMOUNT) AS "Total Paid by Each Customer"
        FROM  STORE S
        INNER JOIN CUSTOMER C ON S.STORE_ID = C.STORE_ID
        INNER JOIN PAYMENT P ON C.CUSTOMER_ID = P.CUSTOMER_ID
        GROUP BY C.FIRST_NAME
				,C.LAST_NAME
        ORDER BY C.LAST_NAME
        ;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT F.TITLE 
		FROM SAKILA.FILM f
        inner JOIN LANGUAGE L
        WHERE TITLE LIKE "Q%" OR TITLE LIKE "k%"
        AND L.NAME = "ENGLISH"
        ;
-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT   A.FIRST_NAME
		,A.LAST_NAME
        FROM SAKILA.FILM f
        INNER JOIN SAKILA.ACTOR A
		WHERE F.TITLE = "Alone Trip";

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT  CU.FIRST_NAME
		,CU.LAST_NAME
		,CU.EMAIL 
FROM 
SAKILA.COUNTRY C 
INNER JOIN SAKILA.CITY CT ON C.COUNTRY_ID = CT.COUNTRY_ID
INNER JOIN SAKILA.ADDRESS A ON A.CITY_ID = CT.CITY_ID
INNER JOIN SAKILA.CUSTOMER CU ON A.ADDRESS_ID = CU.ADDRESS_ID
WHERE C.COUNTRY = "CANADA"
;

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT F.TITLE FROM SAKILA.FILM F
JOIN SAKILA.FILM_LIST L ON L.FID = F.FILM_ID
WHERE L.CATEGORY = "FAMILY"
;

-- * 7e. Display the most frequently rented movies in descending order.

SELECT F.TITLE
, COUNT(I.INVENTORY_ID) AS 'Frequently_Rented'
FROM SAKILA.FILM F 
INNER JOIN SAKILA.INVENTORY I ON F.FILM_ID = I.FILM_ID
INNER JOIN SAKILA.RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY F.TITLE
ORDER BY COUNT(I.INVENTORY_ID) DESC;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.

-- * 7g. Write a query to display for each store its store ID, city, and country.

-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you havent solved 7h, you can substitute another query to create a view.

-- * 8b. How would you display the view that you created in 8a?

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

## Appendix: List of Tables in the Sakila DB

* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
	'actor'
	'actor_info'
	'address'
	'category'
	'city'
	'country'
	'customer'
	'customer_list'
	'film'
	'film_actor'
	'film_category'
	'film_list'
	'film_text'
	'inventory'
	'language'
	'nicer_but_slower_film_list'
	'payment'
	'rental'
	'sales_by_film_category'
	'sales_by_store'
	'staff'
	'staff_list'
	'store'
```

## Uploading Homework

* To submit this homework using BootCampSpot:

  * Create a GitHub repository.
  * Upload your .sql file with the completed queries.
  * Submit a link to your GitHub repo through BootCampSpot.
