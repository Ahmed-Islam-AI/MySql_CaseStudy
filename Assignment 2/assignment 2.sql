create database assignment_2;

select * from petowners;
select * from pets;
select * from proceduresdetails;
select * from procedureshistory;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 1. List the names of all pet owners along with the names of their pets.
select  p.Name as PetName, 
		concat(p_o.Name, " ",p_o.Surname) As "Owner"
from pets p inner join petowners p_o
on p.OwnerID = p_o.OwnerID;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Qustion 2. List all pets and their owner names, including pets that don't have recorded owners.
select * from petowners;
select * from pets;

select  p.petid, 
		p.name, 
        p.kind, p.age,
	    concat(p_o.Name, " ",p_o.Surname) As "Owner_Name",
        p.OwnerID
from pets p left join petowners p_o
on  p.OwnerID = p_o.OwnerID;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 3. Combine the information of pets and their owners, including those pets without owners 
-- and owners without pets.  
select * from petowners;
select * from pets;

select  p.*, 
		concat(p_o.Name, " ",p_o.Surname) "Owner_Name", 
		p_o.StreetAddress "Owner_StreetAddress", 
        p_o.City "Owner_City", 
        p_o.State "Owner_State", 
        p_o.StateFull "Owner_StateFull", 
        p_o.ZipCode "Owner_ZipCode"
from pets p join petowners p_o
on p.OwnerID = p_o.OwnerID;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 4. List all pet owners and the number of dogs they own. 
select * from pets;
select * from petowners;

SELECT  po.Name as Owner_Name,
		COUNT(p.PetID) as Number_of_Dogs_Owned
FROM petowners po LEFT JOIN pets p 
ON po.OwnerID = p.OwnerID
WHERE p.kind = 'Dog'
GROUP BY po.OwnerID, po.Name;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 5. Identify pets that have not had any procedures.  
select * from pets;
select * from procedureshistory;

SELECT p.*, ph.ProcedureType
FROM pets p left JOIN procedureshistory ph 
ON p.PetID = ph.PetID
WHERE ph.PetID IS NULL;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 6. Find the name of the oldest pet.
select max(age) from pets;

select name, age from pets
where age=(select max(age) from pets);

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 7. Find the details of procedures performed on 'Cuddles'. 
select * from proceduresdetails;
select * from pets;
select * from procedureshistory;

SELECT p.*, ph.*
FROM pets p
INNER JOIN procedureshistory ph ON p.PetID = ph.PetID
WHERE p.Name = 'Cuddles';

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 8. List the pets who have undergone a procedure called 'VACCINATIONS'.
select * from proceduresdetails;
select * from pets;
select * from procedureshistory;
 
SELECT  p.Name, ph.ProcedureType
FROM pets p JOIN procedureshistory ph 
ON p.PetID = ph.PetID
JOIN proceduresdetails pd 
ON ph.ProcedureSubCode = pd.ProcedureSubCode
WHERE pd.ProcedureType = 'VACCINATIONS';

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 9. Count the number of pets of each kind. 
select * from pets;
select kind, count(kind) "No_of_pets" from pets group by kind;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 10. Group pets by their kind and gender and count the number of pets in each group.
select * from pets;
select kind, gender, count(name) as "No_of_pets"
from pets
group by kind, gender;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 11. Show the average age of pets for each kind, but only for kinds that have more than 5 pets. 
select  kind,  
		avg(age), 
        count(kind) "kind_counts" 
from pets 
group by kind 
having kind_counts > 5;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 12. Find the types of procedures that have an average cost greater than $50.  
select * from proceduresdetails;

select  ProcedureType, 
		avg(Price) "Avg_Price" 
from proceduresdetails 
group by ProcedureType 
having Avg_Price > 50;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 13. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. 
-- Age less then 3 Young, 
-- Age between 3 and 8 Adult, 
-- else Senior. 
select * from pets;

select *,
case
	when age < 3 then "Young"
    when age between 3 and 8 then "Adult"
    else "Senior"
end as "Pet_status"
from pets;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 14. Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female). 
select * from pets;
select *, 
case
	when gender = "male" then "Boy"
    else "girl"
end as "Gender_label"
from pets ;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->

-- Question 15. For each pet, display the pet's name, the number of procedures they've had, and a 
-- status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 
-- procedures, and 'Super User' for more than 7 procedures. 
select * from pets;
select * from proceduresdetails;
select * from procedureshistory;

select 	p.Name, 
        count(*) as 'NumProcedures',
		case
			when count(*) between 1 and 3 then 'Regular'
            when count(*) between 4 and 7 then 'Frequent'
            else 'Super User'
        end as 'procedure_status'
from pets p left join procedureshistory ph
on p.PetID = ph.PetID
GROUP BY p.Name;

-- <*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>--<*>/<*>-->