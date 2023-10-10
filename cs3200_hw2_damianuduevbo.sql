-- CS3200: Database Design
-- GAD: The Genetic Association Database


-- Write a query to answer each of the following questions
-- Save your script file as cs3200_hw2_yourname.sql (no spaces)
-- Submit this file for your homework submission

use gad;



-- 1. 
-- Explore the content of the various columns in your gad table.
-- List all genes that are "G protein-coupled" receptors in alphabetical order by gene symbol
-- Output the gene symbol, gene name, and chromosome
-- (These genes are often the target for new drugs, so are of particular interest)
select gene, gene_name, chromosome 
from gad
where (gene like 'G%') order by gene;



-- 2. 
-- How many records are there for each disease class?
-- Output your list from most frequent to least frequent
SELECT disease_class, COUNT(*) AS frequency
FROM gad
GROUP BY disease_class
ORDER BY frequency DESC;

-- 3. 
-- List all distinct phenotypes related to the disease class "IMMUNE"
-- Output your list in alphabetical order
SELECT DISTINCT phenotype
FROM gad
WHERE disease_class = 'IMMUNE'
ORDER BY phenotype;

-- 4.
-- Show the immune-related phenotypes
-- based on the number of records reporting a positive association with that phenotype.
-- Display both the phenotype and the number of records with a positive association
-- Only report phenotypes with at least 60 records reporting a positive association.
-- Your list should be sorted in descending order by number of records
-- Use a column alias: "num_records"
SELECT phenotype, count(*) as freq
FROM gad
WHERE disease_class = 'IMMUNE' AND association = 'Y'
GROUP BY phenotype
HAVING COUNT(*) >= 60
ORDER BY freq DESC;



-- 5.
-- List the gene symbol, gene name, and chromosome attributes related
-- to genes positively linked to asthma (association = Y).
-- Include in your output any phenotype containing the substring "asthma"
-- List each distinct record once
-- Sort  gene symbol
select distinct gene, gene_name, chromosome, chromosome_band, phenotype
from gad
where phenotype like '%asthma%' and association = 'Y'
ORDER BY gene;


-- 6. HELP
-- For each chromosome, over what range of nucleotides do we find
-- genes mentioned in GAD?
-- Exclude cases where the dna_start value is 0 or where the chromosome is unlisted.
-- Sort your data by chromosome. Don't be concerned that
-- the chromosome values are TEXT. (1, 10, 11, 12, ...)
select chromosome,
	min(dna_start) as min, max(dna_start) as max
from gad
where (dna_start != 0 and chromosome != ' ')
group by chromosome
order by chromosome;



-- 7 
-- For each gene, what is the earliest and latest reported year
-- involving a positive association
-- Ignore records where the year isn't valid. (Explore the year column to determine what constitutes a valid year.)
-- Output the gene, min-year, max-year, and number of GAD records
-- order from most records to least.
-- Columns with aggregation functions should be aliased
select gene, min(publish_year) as min_year, max(publish_year) as max_year, count(*) as num_records
from gad
where (association = 'Y' and publish_year > 1)
group by gene
order by num_records desc;




-- 8. 
-- Which genes have a total of at least 100 positive association records (across all phenotypes)?
-- Give the gene symbol, gene name, and the number of associations
-- Use a 'num_records' alias in your query wherever possible
-- (select phenotypes from gad where (association = 'Y'))

select gene, gene_name, count(*) as num_records
from gad
where (association = 'Y')
group by gene, gene_name
having num_records >= 100;



-- 9. 
-- How many total GAD records are there for each population group?
-- Sort in descending order by count
-- Show only the top five results based on number of records
-- Do NOT include cases where the population is blank
select population, count(*) as num_records
from gad
where (population != '')
group by population
order by num_records desc limit 5;




-- 10. 
-- In question 5, we found asthma-linked genes
-- But these genes might also be implicated in other diseases
-- Output gad records involving a positive association between ANY asthma-linked gene and ANY disease/phenotype
-- Sort your output alphabetically by phenotype
-- Output the gene, gene_name, association (should always be 'Y'), phenotype, disease_class, and population
-- Hint: Use a subselect in your WHERE class and the IN operator
select gene, gene_name, association, phenotype, disease_class, population
from gad
where gene in (
    select distinct gene
    from gad
    where association = 'Y' and phenotype like '%asthma%'
) and association = 'Y'
order by phenotype asc;


-- 11. 
-- Modify your previous query.
-- Let's count how many times each of these asthma-gene-linked phenotypes occurs
-- in our output table produced by the previous query.
-- Output just the phenotype, and a count of the number of occurrences for the top 5 phenotypes
-- with the most records involving an asthma-linked gene (EXCLUDING asthma itself).
select phenotype, count(*) as occurrences
from gad
where gad.gene in (
    select distinct gene
    from gad
    where association = 'Y' and phenotype like '%asthma%'
) and association = 'Y' and phenotype != 'asthma'
group by phenotype
order by occurrences desc limit 5;



-- 12. 
-- Interpret your analysis

-- a) Search the Internet. Does existing biomedical research support a connection between asthma and the
-- top phenotype you identified above? Cite some sources and justify your conclusion!

-- Yes, biomedical research has found connection between asthma and Rheumatoid Arthritis (RA). 
-- A study published in the journal "Division of Rheumatology, Department of Internal Medicine" titled
-- "Association of rheumatoid arthritis with bronchial asthma and asthma-related comorbidities: A population-based national surveillance study"
-- found evidence of a connection. The study states, 
-- "Among allergic diseases, asthma has been proven to be associated with RA (10). Longitudinal analysis revealed a higher likelihood of developing RA in patients with asthma (17).
-- Conversely, a higher rate of asthma development has been observed in patients with RA (9)".

-- SOURCE:
-- https://www.frontiersin.org/articles/10.3389/fmed.2023.1006290/full#:~:text=Among%20allergic%20diseases%2C%20asthma%20has,patients%20with%20RA%20(9).

-- b) Why might a drug company be interested in instances of such "overlapping" phenotypes?
-- Their drugs that can treat multiple related conditions.

-- CONGRATULATIONS!!: YOU JUST DID SOME LEGIT DRUG DISCOVERY RESEARCH! :-)





-- 13. MY OWN QUERY
-- "How does the distribution of gene-disease associations differ across diverse populations in the context of personalized medicine?"
SELECT population, disease_class, COUNT(*) AS association_count
FROM gad
WHERE association = 'Y' and population != ''
GROUP BY population, disease_class
ORDER BY population, association_count DESC;

-- This query investigates the distribution of gene-disease associations across different populations.
-- By analyzing the "population" column in the GAD dataset, we can gain insights into how genetic associations with diseases vary among different population groups.
-- The query counts the number of positive associations ('Y') for each disease class for each population, providing valuable information for personalized medicine research.
-- These results can be used to understand the genetic basis of diseases and potential population-specific differences in genetic susceptibility,
-- contributing to the discussion on tailoring medical treatments to individual patients.