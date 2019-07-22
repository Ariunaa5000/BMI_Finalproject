# BMI_Finalproject
Identification and characterization of biallelic burst kinetics of Ewing sarcoma from single cell RNA-Seq.

BMI5750 Final project by Ariunaa Bayanjargal and Rachel Brown. 

## 10X Genomic single cell RNA-seq of A673 parental cells
Single cell RNA-Seq data was obtained in bcl files. 
Input: bcl files

## Processing of raw scRNA-Seq data
### Cellranger mkfastq 
Converted bcl files to fastq files. 
See 2019-04-10x.job file shell script. 
Input:bcl
Output:fastq

### FASTQC
Created QC report for each fastq files. 
See fastqc_all.sh file fr script. 
Input: Fastq files
Output: HTML report 

### MultiQC
Compiled QC reports into one convinient report to see. 
Input: FASTQC reports
Output: MultiQC HTML report

### Cellranger count 
Cellranger count was used trim and align the reads to custom biallelic A673 genome. 
See cellranger_count_A1 and cellranger_count_A2 files for script. 
Input: Fastq files 
Output: csv file


## Calculation of transcriptional burst kinetics
Python codes from https://github.com/sandberg-lab/txburst was utilized to calculate burst kinetics. 

### Burst frequency and size calculated

### Confidence intervals of parameters
### Differential burst size and frequency between two alleles
### A list of genes - biallelic differential bursting 
## Gene-set enrichment analysis
Genes with significant differences in two alleles in terms of bursting pattern
Characterize the genes with DAVID Bioinformatics Resources

