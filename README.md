# BMI Final Project

Identification and characterization of biallelic burst kinetics of Ewing sarcoma from single cell RNA-Seq.

BMI5750 Final project by Ariunaa Bayanjargal and Rachel Brown. 

## 10X Genomic single cell RNA-seq of A673 parental cells

Single cell RNA-Seq data was obtained in bcl files. 

Input: bcl files

## Processing of raw scRNA-Seq data

### Cellranger mkfastq 

Converted bcl files to fastq files. 

See 2019-04-10x.job file shell script.

Input: bcl files 

Output: fastq files

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

### System Requirements for inference and hypothesis testing scripts

_txburstML.py_, _txburstPL.py_ and _txburstTEST.py_  are all python3 scripts with dependencies:

```
pandas: 0.19.2
numpy: 1.9.0
scipy: 1.0.0
joblib: 0.11
```
No further installation is needed.
### Burst frequency and size calculated
_txburstML.py_ estimates parameters of bursting kinetics given transcript counts for an allele of a gene.

If you have estimated the allelic transcript counts from the fraction of allelic reads, it is important to consider what is missing data in this case. Genes with expression (reads) but no allelic reads are different from genes without expression (and therefore no allelic reads). We handle the first case as missing data, since it is not possible to assign the expression. In the second case, we replace the NaN with a 0 since there is genuinely no detected expression. Omitting this step may have severe effects on the quality of the inference.

#### Usage

usage: txburstML.py [-h] [--njobs NJOBS] file

Maximum likelihood inference of bursting kinetics from scRNA-seq data

**positional arguments:**
  file           .csv file with allelic-resolution UMI counts

**optional arguments:**
  -h, --help     show this help message and exit
  --njobs NJOBS  Number of jobs for the parallelization, default 50

#### Output 

_txburstML.py_ outputs a pickled pandas dataframe which for each gene contains an array with three entries [k_on, k_off, k_syn] where the burst frequency = k_on and burst size = k_syn/k_off, and a boolean indicating whether gene passed a rudimentary filtering step based on the quality of the inference procedure. For example:

|gene name | parameters |	keep |
| --- | --- | --- | 
|gene1 |	[k_on,k_off,k_syn]_gene1	| True	|
|gene2 |	[k_on,k_off,k_syn]_gene2	| False	|

Input: filtered_feature_bc_matrix.csv

Output: A673_A1_ML.csv

### Confidence intervals of parameters

_txburstPL.py_ calculates the confidence intervals parameters of bursting kinetics given transcript counts for an allele of a gene. Requires _txburstML.py_ to be run on the dataset to provide input for _txburstPL.py_.

#### Usage 

usage: txburstPL.py [-h] [--file file] [--njobs NJOBS] [--alpha ALPHA]
                    [--MLFile MLFILE]

Confidence intervals on parameters of bursting kinetics from scRNA-seq data

**optional arguments:**
  -h, --help       show this help message and exit
  --file file      .csv file file with allelic-resolution transcript counts
  --njobs NJOBS    Number of jobs for the parallelization, default 50
  --alpha ALPHA    Alpha significance level (default 0.05)
  --MLFile MLFILE  Maximum Likelihood file (required)
  
#### Output
_txburstML.py_ outputs a pickled pandas dataframe which for each gene has three arrays with the point estimate from _txburstML.py_ and the confidence intervals for burst frequency and size. For example:

|gene name | point estimates |	bf_CI | bs_CI |
| --- | --- | --- | --- |
|gene1 |	[k_on,k_off,k_syn]_gene1	| [bf_point,bf_lower,bf_upper]_gene1	| [bs_point,bs_lower,bs_upper]_gene1	 |
|gene2 |	[k_on,k_off,k_syn]_gene2	| [bf_point,bf_lower,bf_upper]_gene2	| [bs_point,bs_lower,bs_upper]_gene2	 |

Input:filtered_feature_bc_matrix_ML.pkl

Output:A673_A1_PL.csv

### Differential burst size and frequency between two alleles
_txburstTEST.py_ performs hypothesis testing for differential burst frequency and size between two experiments. Requires _txburstML.py_ to be run on the dataset to provide input for _txburstTEST.py_.

#### Usage 

usage: txburstTEST.py [-h] [--file1 file1] [--file2 file2] [--njobs NJOBS]
                      [--ML1 ML1] [--ML2 ML2]

Hypothesis testing of differences in bursting kinetics from scRNA-seq data

**optional arguments:**
  -h, --help     show this help message and exit
  --file1 file1  .csv file 1 with allelic-resolution transcript counts
  --file2 file2  .csv file 2 with allelic-resolution transcript counts
  --njobs NJOBS  Number of jobs for the parallelization, default 50
  --ML1 ML1      Maximum Likelihood file 1 (required)
  --ML2 ML2      Maximum Likelihood file 2 (required)

#### Output

_txburstTEST.py_ outputs a pickled pandas dataframe with the two point estimates from _txburstML.py_ and p-values for the significance tests for differential bursting kinetics. For example:

|gene name | point estimates 1 | point estimates 2	|bf_pvalue | bs_pvalue |
| --- | --- | --- | --- | --- |
|gene1 |	[k_on,k_off,k_syn]_gene1_sample1	| [k_on,k_off,k_syn]_gene1_sample2	| burst frequency pvalue gene1	 | burst size pvalue gene1 |
|gene2 |	[k_on,k_off,k_syn]_gene2_sample1	| [k_on,k_off,k_syn]_gene2_sample2	| burst frequency pvalue gene2	 | burst size pvalue gene2 |

Input:  filtered_feature_bc_matrix_A1.csv
        filtered_feature_bc_matrix_A2.csv
        filtered_feature_bc_matrix_ML_A1.pkl 
        filtered_feature_bc_matrix_ML_A2.pkl

Output:A673_ASE_burst.csv

## Gene-set enrichment analysis

### A list of genes - biallelic differential bursting 

A list was created containing the genes that have significantly different expression between the two alleles. 

See file Dif_exp_genelist.csv 

### Characterize the genes with DAVID Bioinformatics Resources

As per class lecture. 

