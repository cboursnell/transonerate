Transonerate
============

A Ruby gem to generate a per contig score using exonerate and a genome

## Usage

```
transonerate --assembly <your_assembly> --genome <genome> --annotation <
existing_annotation> --left <fastq_files> --right <fastq_files>
```

## Musings

Idea for getting a per contig score using exonerate: We want to show that the
transrate score, which is achieved used reads only, is highly correlated with
this exonerate score which requires a genome and gtf.

Align the reads to the genome using tophat/cufflinks and create a new gtf file
that contains all the previously annotated regions and also any new ones that
it thinks exists based on the read evidence.

From exonerate we can set ryo to

    --ryo "%qi\t%ti\t%pi\t%qab\t%qae\t%tab\t%tae\t%ql\n"

that will output a sort of blast6-like format. Eg:

    query               target  seqid  qs  qe    target_s   target_e     qlen
    comp111716_c0_seq1    Chr1  95.24  0   253   33596559   33596305     253

Then we can find the length of alignment by doing (qe-qs/qlen) and multiply it
by the %seqid. Then look up this region in the gtf. Sum the length of all exons
that are wholly or partially covered by the `target_s` and `target_e` exonerate
hit. Find the percentage coverage to the transcript. So the score has to take
into account the %seqid, the percentage of the contig that aligned to the
genome, and the percentage of the aligned contig that aligned to a transcript
in the gtf.