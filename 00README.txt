EPN, Thu May 21 2015

Goal: Carry out tests on the specificity of Rfam 12.0 RNA models to
determine if GPIPE can safely expand the number of Rfam models it
uses to annotate prokaryotic genomes.

Related JIRA ticket: GP-10960.
GitHub URL: https://github.com/nawrockie/infernal_gpipe_tests_specificity.git

To reproduce the tests discussed here, see 00TOREPRODUCE.txt in this
directory. 

Sections of this file:
- Background on Rfam 12.0
- What I did to carry out the tests
- Bacterial results
- Archaeal results 
- Conclusions
- Recommendations
- Further investigation of 18 hits to 'bacteria-no' models

------------------------------------------------------------------------

Background on Rfam 12.0: 

Rfam 12.0 includes 2450 CM files and accompanying SEED alignments.
Each CM file was built from it's associated SEED alignment using
Infernal 1.1's cmbuild program. Rfam curators use each model to search
against the RFAMSEQ database, a 270Gb database of archaeal, bacterial,
eukaryotic and viral sequences derived from the ENA
database. Specifically RFAMSEQ is composed of the standard and whole
genome shotgun data classes of ENA.

Based on the results of those searches, an Rfam curator defines a
model-specific 'GA' bit score cutoff which separates all presumed true
homologs from the highest scoring false positive for that model. (No
hits believed to be a false positive have a score better than (above)
the GA cutoff.) The set of all hits for a model above GA is defined as
the 'FULL' set of sequences for that model.

------------------------------------------------------------------------

What I did to carry out the tests:

1. Created a list of Rfam 12.0 models that have >=1 bacterial
   sequences in both their 'SEED' and 'FULL' sets in the Rfam 12.0
   annotations (list file called bacteria.yes.list), and a list of
   models that do not (list file called bacteria.no.list).

   bacteria.yes.list:  616 models 
   bacteria.no.list:  1834 models

2. Searched all Rfam 12.0 models against 96 randomly chosen bacterial
   genomes using Infernal 1.1.1's 'cmsearch program. 

   The idea is that only hits to models in the bacterial.yes set
   should occur in bacterial genomes. Any hits to models in the
   bacteria.no set are likely to be false positives. By looking at how
   many hits there are to the 'yes' and 'no' sets we can get an idea
   of how specific Infernal and Rfam CMs are.

   The 96 bacterial genomes are the same ones used for my other test
   related to upgrading from Infernal 1.0 to Infernal 1.1. 'cmsearch'
   was run the same way that Rfam annotators run it ('cmsearch --noali
   --rfam --cpu 0 --nohmmonly --cut_ga").

3. Counted how many hits were found for each set of models. Again,
   models in 'bacteria.yes.list' are hits that are expected to have
   hits in at least some bacteria. Models in 'bacteria.no.list' are
   hits that are not expected in bacteria (with some exceptions as
   decribed in the 'Further investigation' section below.)  These
   counts are included below in the results sections.

4. Repeated steps 1-3 for 4 randomly chosen archaeal genomes, again
   the same 4 that were used for my earlier tests related to upgrading
   GPIPE to Infernal 1.1.

   archaea.yes.list:   96 models
   archaea.no.list:  2354 models

-------------------------------------------------------------------------

Bacterial results:

The Rfam searches against the 96 bacterial genomes returned 11,190
hits to 408 total Rfam 12.0 models. Of these, 11,172 (99.8%) are to
one of the 616 models that are in the 'bacteria-yes' group, and 18
(0.2%) are to one of the 1834 models that are in the 'bacteria-no'
group.  The 'bacteria-yes' group are those models for which at least 1
bacterial sequence exists in the Rfam 12.0 SEED and FULL set for that
model (see 'Background' above).

Of the 11,172 bacteria-yes hits, 1699 (15%) are to one of the 30 Rfam
families currently annotated by GPIPE, so expanding to annotate all
other Rfam families (or alternatively only the 616 bac.yes models)
would increase the number of Rfam-based RNA annotations in a typical
bacterial genome roughly 6 or 7-fold.

Here is a list of the 18 hits to the 'bacteria-no' models:
accn    name              tot-number-of-hits-in-96-genomes
RF00028 Intron_gpI        7
RF00032 Histone3          3
RF00262 sar               2
RF02540 LSU_rRNA_archaea  1
RF02253 IRE_II            1
RF01960 SSU_rRNA_eukarya  1
RF01761 wcaG              1
RF01717 PhotoRC-II        1
RF00002 5_8S_rRNA         1

I investigated each of these 18 (see 'Further investigation of 18
hits' section below) and believe that only 5 are actual false positive
hits, and that the other 13 are either true homologs (9),
non-bacterial sequence contamination (3) or due to misassembly (1)
(see 'Further investigation' section below for explanations).

For a full list of number of bacterial hits to each model,
see the bacteria.counts file. For a list of those to the 30 current
GPIPE Rfam models, see bacteria.GPIPE30.counts.

-----------------------------------------------------------------------

Archaeal results: 

The Rfam searches against the 4 archaeal genomes returned 220 hits
to 17 total Rfam 12.0 models. All 220 of these were to hits to 
one of the 96 models that are in the 'archaea-yes' group, and 0 were
to one of the 2354 models in the 'archaea-no' group. The 'archaea-yes'
and 'archaea-no' groups were constructed in an analogous manner to the
bacterial groups as explained above.

Of these 220 hits, 6 (3%) are to one of the 30 Rfam families
currently annotated by GPIPE, so expanding to annotate all other Rfam
families (or alternatively, the 96 arc.yes models) would increase
the number of Rfam-based RNA annotations in a typical archaeal genome
roughly 40-fold.

For a full list of number of archaeal hits to each model,
see the archaea.counts file. For a list of those to the 30 current
GPIPE Rfam models, see archaea.GPIPE30.counts.

-----------------------------------------------------------------------

Conclusions: 

I think these results indicate that the Rfam models are fairly
specific, at least when used with cmsearch and the specific
command-line options and score thresholds used by Rfam annotators. 

One important caveat is that while the performance shown in these
tests demonstrates that non-bacterial (or non-archaeal) Rfam models
tend to yield small numbers of false annotations, it has not shown
that the bacterial (or archaeal) models are making correct annotations
in bacterial an archaeal genomes. For that I can refer you to one
independent benchmark (Freyhult and Gardner 2007), and one internal
benchmark (which was developed and carried out by Infernal developers,
Nawrocki, 2013).

References:
- Freyhult,E.K. et al. (2007) Exploring genomic dark matter: a critical
  assessment of the performance of homology search methods on noncoding
  RNA. Genome Res., 17, 117

- Nawrocki,E.P and Eddy, S.R. (2013) Infernal 1.1: 100-fold faster RNA
  homology searches. Bioinformatics, 29 (22): 2933-2935.

--------------------------------------------------------------------

Recommendations:

Due to the high specificity demonstrated here, GPIPE could expand the
number of Rfam models it uses to annotate RNAs in genomes. There are
at least 2 reasonable approaches I can think of:

Approach A: Search each new genome with all 2450 Rfam 12.0 models and
  cmsearch using the Rfam default options/thresholds I've used here 
  and remove overlaps using the simple rule used here (for any two
  overlapping hits, keep only the one with the better E-value).  

  For any remaining hit to an unexpected model (in the 'bacteria-no'
  set for bacteria, or 'archaea-no' set for archaea), throw an
  exception and manually investigate it. This may be an indication of
  contamination or misassembly. If the results here are
  representative, you should get about 1 of these for every 4 genomes
  annotated. 

Approach B: Only search each new genome with the set of expected
  models for its domain (bacteria-yes set or archaea-yes set), and
  remove overlaps as in approach A.

A few important exceptions you might consider:

- You probably don't want to use Rfam to annotate tRNAs (RF00005
  model) if you are already using tRNAscan-SE. tRNAscan-SE is
  preferred because it uses the same type of scoring system as
  Infernal (covariance models), but it also does a good job of
  determining if tRNAs are likely pseudo-genes or not, which
  Infernal/Rfam do not.

- If you go with proposal B above, you may want to manually add a few
  models to the bacterial-yes set, such as RF00028 (Group I introns)
  which do occur in bacteria, even though no bacterial seed sequences
  exist in the Rfam SEED alignment.

-----------------------------------------------------

Further investigation of 18 hits to 'bacteria-no' models:

--
RF00028 Intron_gpI: 7 hits

Conclusion: true homologs (probably)

These are actually expected, and are probably real group I intron
homologs. The RF00028 model is in the bacteria-no group because no
Rfam 12.0 RF00028 SEED sequences are bacterial. However, it is known
that group I introns do exist in bacteria, and there are more than
1100 bacterial group I Intron sequences in the Rfam 12.0 FULL set for
RF00028. All 7 of these hits have an E-value better than 1E-12, which
further supports the assertion that they are group I introns.

--
RF00032 Histone3: 3 hits

Conclusion: false positive cmsearch hits

This family is a stem loop in the 3'UTR of histone mRNAs, which only
exist in eukaryotes. These three hits are probably false positives.

--
RF00262 sar: 2 hits

Conclusion: true homologs (probably)

This is the same situation as RF00028, there are 0 bacterial SEED
sequences for RF00262, but many bacterial FULL sequences (102), so
these are likely real homologs (both have E-values < 1E-13).

--
RF02540 LSU_rRNA_archaea: 1 hit

Conclusion: false positive cmsearch hit

This hit overlaps with three bacterial LSU rRNA hits (RF02541) which
collectively score better than this RF02540 hit (if you sum their bit
scores). However, using our simple de-overlapping strategy, we will
misannotate this sequence as an archaeal LSU instead of a bacterial
LSU.

-- 
RF02253 IRE_II: 1 hit

Conclusion: false positive cmsearch hit

This is a iron-response-element stem loop structure that occurs in the
UTR of mRNAs related to iron metabolism, and only exists in
eukaryotes. The E-value is marginal (.0014) which also makes this hit
suspect. 

--
RF01960 SSU_rRNA_eukarya: 1 hit

Conclusion: contamination, not a bacterial sequence.

The sequence this hit occurs in: ANNT01001371.1 is a eukaryotic
sequence, not a bacterial one. The support for this is that BLASTing
it against NR returns many significant hits of E-value of 0, all of
which are eukaryotic.

--
RF01761 wcaG RNA: 1 hit 

Conclusion: contamination, viral sequence (bacteriophage)

The sequence this hit occurs in: KB910798.1 is not a bacterial
sequence, not a bacterial one. The support for this is that BLASTing
it against NR returns a top hit of E-value 6E-130 to a phage
sequence. 

--
RF01717 PhotoRC-II: 1 hit 

Conclusion: contamination: viral sequence (bacteriophage)

This hit occurs in the same sequence as RF01761, and is thought to be
contamination for the same reason listed for RF01761 above.

--
RF00002 5_8S_rRNA

Conclusion: misassembly (probably)

I BLASTed the sequence of this hit (DS179593.1 115586..115435) against
NR and found the top hit (E=1E-117) matches 99% identity and 100%
coverage with an annotated LSU rRNA in CP000789.1. This is to be
expected since eukaryotic 5.8S rRNA is homologous to the 5' end of
bacterial/archaeal LSU rRNA, however the lack of a full length LSU
rRNA in DS179593.1 suggests a misassembly. 

-------------------------------------------------------------------------
