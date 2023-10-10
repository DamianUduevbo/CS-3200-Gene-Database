SET GLOBAL local_infile = ON;

DROP DATABASE IF EXISTS info;
CREATE DATABASE info;
USE info;
DROP TABLE IF EXISTS gad;

CREATE TABLE gad (
	gad_id INT,
    association TEXT,
    phenotype TEXT,
    disease_class TEXT,
    chromosome TEXT,
    chromosome_band TEXT,
    dna_start INT,
    dna_end INT,
    gene TEXT,
    gene_name TEXT,
    paper_reference TEXT,
    pubmed_id INT,
    publish_year INT,
    population TEXT
);

LOAD DATA LOCAL 
INFILE 'C:/Users/blahb/Documents/VS_Code/CS3200/HW2/gad.csv'
INTO TABLE gad
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

USE info;
select * from gad;