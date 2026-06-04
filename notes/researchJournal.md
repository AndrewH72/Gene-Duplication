# May 25, 2026
I found 4 additional datasets that we can use:
- Human Protein Atlas (HPA)
- E-MTAB-1733 (Human)
- Tabula Muris (Mouse)
- E-MTAB-6081 (Mouse)

# May 26, 2026
Previously we had 10 shared tissues for the human and mouse datasets.\
In addition to the datasets that we originally had, GTEx and MGI, I added in HPA and E-MTAB-1733 for humans and Tabula Muris and E-MTAB-6081 for mice. Now there are 22 shared tissues.\
This combination of datasets now include:
- cerebellum
- cerebral cortex
- duodenum
- esophagus
- hypothalamus
- kidney
- midbrain
- pancreas
- retina
- spinal cord
- stomach
- thymus

# May 27th, 2026
The two datasets that maximized the total number of tissues are: GTEx and E-MTAB-6081 with a total of 8 tissues.\
These tissues are: brain, colon, esophagus, heart, kidney, liver, pancreas, and stomach.\
There aren't any NAs in either datasets. There were, however, many zeros in the datasets. I don't remember if that is problematic, so I have two sets of each dataset. One where rows/columns containing more than 50% 0's were removed. The other didn't have this filter applied.\
For the human datasets: the non-filtered dataset contains 52,970 genes and the filtered dataset had 38,238 genes. For the mice datasets: the non-filtered dataset contains 47,531 genes and the filtered dataset had 13,8948 genes.\
I've only taken a look at all possible combinations from six datasets: GTEx, HPA, E-MTAB-1733, MGI, Tabula Muris, and E-MTAB-6081.\
I also have a document containing the information you wanted me to collect for each dataset.

## Notes
- Try to understand why the number of genes in the datasets are so high. Might be because these datasets have genes that are non-protein encoding
- Try to understand the gene name format in GTEx. It is the ENSMBL version.
- Transcripts: different RNAs
- Try to understand why there are repeats in the tissues for E-MTAB-6081. It might correspond to different developmental stages or if they are replicates.

## To Do
- Make sure we don't have repeating information for the same gene. Like the same gene, but from different version doesn't appear.
- Determine if there are non-protein encoding genes.
- Come up with a table for both species that only focuses on the shared tissues. Columns should be tissues. Rows should be genes. Average whatever is necessary. Add one more column that categorizes what type of gene the gene is. Use BioMart/Type.

# May 28th, 2026
For the GTEx data, we saw that it was formatted as "ENSG00000290825.2", where ".2" indicates the ENSMBL version. I determined that there were no duplicated genes in the dataset.\
The number of genes in both datasets is so high because some genes are non-protein encoding.\
The repeats in tissues for E-MTAB-6081 are because they correspond to different mice. I'm not entirely sure what "199" might mean, but the numbers 1-13 correspond to tissues for the first mice, 14-26 for the second mice, and 27-39 for the third mice.

## To Do
- Identify which samples were kept and discarded from the filtering.
- Try to calcualte the tissue expression divergence scores.

# May 29, 2026
I identified the number of genes that were dropped (43) and the genes that were dropped for GTEx. Those can be found in the droppedGenes.txt file. I ran all of these genes on BioMart, and nothing came up. I looked up one of the genes, ENSG00000287139, and Ensembl says "this identifier is not in the current EnsEMBL database" and the ID is retired. The same thing is true for the genes that were dropped for E-MTAB-6081. There were 4,143 genes that were dropped. This was before I filtered for protein-coding genes.

I put the genes that were dropped back by changing the merge from an inner to outer.

Mice used in E-MTAB-6081 were 7-8 weeks olds. Mice begin their adulthood at just 6-weeks, so these mice were adults. The GTEx data came from the Adult GTEx portal, so all samples are also adults.

## Notes
- Keep as many genes as possible. Don't drop genes.
- Samples = Tissues
- Double-check that all tissues are adult tissues.

# May 31, 2026
I spent the entire day studying for the GRE. Geometry has always been a weakness of mind, so I went through Magoosh's entire geometry module today. Also, I completed the first GRE practice test. I was surprised by my writing score (5), but that is graded by a computer and I think I just hit the type of words that it was looking for. My verbal reasoning score (157) is decent, but my quantitative reasoning score (153) is abysmal for the field that I want to get into. Studying up on that should be my main priority.

# June 1, 2026
I created my own functions to calculate the Euclidean and Pearson distance, and the TEC score. For the Euclidean and Pearson distance, I compared those values to functions provided by Python libraries such as Numpy. The Python functions were more precise than mine, but there were also some values after a certain amount of decimal points that didn't match. I would like to discuss this further with Dr. Alvarez-Ponce to see what he thinks.

When I appended these values onto the expression profiles for both humans and mice, I used my own functions.

There were some IDs that were in the ortholog table, but not in the dataframe and those IDs have NaNs for the distance columns.

# June 2, 2026
I emailed Dr. Alvarez-Ponce about my progress with the distance functions, and appending those columns onto the expression profiles. He emailed back saying that it makes more sense to append those columns onto the ortholog table file, and I agree, that does make more sense. By doing this, I also save memory and computational time by not having to rewrite the same data to both species' expression profile.

Another thing that Dr. Alvarez-Ponce pointed out was that the TEC column was completely filled by 0's. After looking back at the function I create for it, I realized that the logic was incorrect. Before, I only made use of the binary AND operation on the binary NOT of the secondary species dataframe. This just doesn't make sense. The new logic makes use of binary XOR to extract only the tissues in either of the dataframes, and then using binary AND on the species we want to find their unique tissues for. The output of this function matches the outputs of my own manual calculations.

Dr. Alvarez-Ponce discovered that E-MTAB-6081 was not in TPM, it was actually in TP100K, even though the file said it was TPM. So, all I had to do was multiply the dataset by 10 to get it to TPM, and then all files dependent on E-MTAB-6081 were updated to reflect this change.

## Notes
- Test out Euclidean distance with normalization.
- Re-read Pearson paper (Pereira et al., 2009) to see range of Pearson distance.
- GOC correlates with being a parental or daughter copy.
- The copy with the highest GOC score is the parental, and the one with the lower GOC score is the daughter copy.
- E-MTAB-6081 is in RPKM, while GTEx is in TPM. 

## To Do
- Start doing basic statistical analysis of data (mean, median, mode, etc) of each ortholog type. A preliminary analysis.
- Go to orthologTableDist and try to identify which species experienced a duplication in the one-to-many. Duplicated species ID will appear more than once. 
- Convert E-MTAB-6081 to TPM and recalculate the distance values.

# June 3, 2026
I created a column in the orthologTableDist.csv/parquet file that describes which organism was duplicated for one-to-many orthologs. "Human", "Mouse", and "NA" are the only values in the column. I took a deeper look into the "NA" values and it are genes that are labeled as one-to-many orthologs, but do not contain duplicated genes. These "NA" one-to-many orthologs are actually one-to-one orthologs. This could be because of a mislabel or the duplicated genes weren't included in the BioMart table.

Also added in Euclidean and Pearson distance with Euclidean normalization columns to the orthologTableDist files. This is to see if normalization of the data will have any affect on our results.
