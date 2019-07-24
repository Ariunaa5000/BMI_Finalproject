#!/bin/bash


fastqDir=/gpfs0/home/gdlessnicklab/rsaxb003/scRNAseq/FASTQs/H3W53BBXY/2-19-04-02-143B
cd $fastqDir
out_dir=/gpfs0/home/gdlessnicklab/rsaxb003/scRNAseq/FASTQC_result
for filename in $(find -name '*.fastq.gz'); do
      fastqc $filename ${filename/fastq.gz} \
      --outdir=$out_dir;
done
