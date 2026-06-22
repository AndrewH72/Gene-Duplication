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
I created a column in the orthologTableDist.csv/parquet file that describes which organism was duplicated for one-to-many orthologs. "Human", "Mouse", and "NA" are the only values in the column. I took a deeper look into the "NA" values and it are genes that are labeled as one-to-many orthologs, but do not contain duplicated genes. These "NA" one-to-many orthologs are actually one-to-one orthologs. This could be because of a mislabel or the duplicated genes weren't included in the BioMart table. The number of the duplicated species' genes was also noted. For example if there was a human one-to-many ortholog, then the column for the number of human duplicated genes would be x and the number of mouse duplicated genes would 1.

Also added in Euclidean and Pearson distance with Euclidean normalization columns to the orthologTableDist files. This is to see if normalization of the data will have any affect on our results.

# June 4, 2026
I had a meeting with Dr. Alvarez-Ponce, and we found out that I incorrectly performed the Euclidean normalization. We also found out that I switched the species name for which species was duplicated for one-to-many orthologs. For the Euclidean normalization, I incorrectly believed dividing by 1,000 would be enough because the sum of all the columns would be 1,000,000 and the square root of 1,000,000 is 1,000. However, what I didn't realize is that I needed to first square each individual element in a column before summing it and then rooting the sum. I have since corrected the mistake. The switching of the species name was also an easy fix. I also fixed the order of the columns to be consistent.

From there, I performed a log2(x+1) transformation on both expression profiles since AI said this was a common method of normalization. I then calculated the Euclidean distance on this log-transformed data.


## Notes for Meeting:
- In the last paragraph of the conclusion section, Piasecka et al stated that Euclidean distance paired with Euclidean normalization is a superior metric to compare expression conservation.
- Pearson distance is unaffected by the type of normalization applied.
- Euclidean distance with Euclidean normalization values are significantly lower for broadly-expressed genes than for organ-specific genes.
- Euclidean distance with Z-Normalization was not affecte by organ specificity. But it does have higher scores for random pairs.
- If a dataset has more broadly-expressed genes than it is more likely to be underestimated.

## Notes:
- Can ask AI for help interpreting a paper.
- Tau describes tissue-specificity
- We should try doing Euclidean distance on log2-transformed expression values
- Fix Euclidean normalization. I should be squaring all the individual elements before summing them.
- Fix my labels for the duplicated species. It looks like I swapped the labels, so "Human" should be "Mouse" and "Mouse" should be "Human."
- Make the order Human and then Mouse.
- For the statistical analysis, fill in a table where I have different category of genes (one-to-one, one-to-many in human GOC=0, one-to-many in human GOC=25, etc.., one-to-many in mouse GOC=0, etc.., many-to-many)and put the number, mean, median for each of our columns
- Perform a statistical test with each pair of categories.
- Find new papers if I ever have eany free time.

# June 5, 2026
I filled out a table provided to me by Dr. Alvarez-Pone (data/distances.xlsx). In the provided document, I was asked to find the number, median, and mean of category of genes (one2one, one2many, many2many, one2many GOC = 0, etc.). I also performed a Mann-Whitney U Test on pairs of gene categories (one2one vs one2many in humans, one2many in humans with GOC = 0 vs one2many in humans with GOC = 25, etc). During these Mann-Whitney U Tests, I saw that the p-value for the Pearson Distance values all came out as NaN. With some digging, I discovered that this happens because either one of or both of the groups has zero variance (identical values for all tissues) or one of or both of the groups contains a NaN itself. The problem was the former. I thought I could either replace these NaNs with a 1 (indicating no correlation), a 2 (indicated a strong negative correlation), or drop these rows entirely. Dr. Alvarez-Ponce said it is standard to drop them, so I did. The analysis ran smoothly afterwards.

Three categories for the Mann-Whitney U Tests were corrected. I fixed the Pearson distance values for those categories, and then I filled in the same data for the other four distance metrics (Euclidean distance, Euclidean distance w/ Euclidean normalization, Euclidean distance w/ log2 transformation, Euclidean distance, TEC).

## To Do:
- double check the distances to make sure they are calculated correctly
- randomly pick two genes and calculate their distances. do this 10K times.

# June 6, 2026
I am going through all of my distance functions, and making sure that they are correctly calculating those values. They are not. For TEC, I misread one of the variables and that threw off the entire calculation. It turns out the formula is more nuanced than I thought, and there are actual edge-cases that I need to consider. One of these edge cases is when the total number of tissues that gene I and/or gene J are expressed in equal 0. With the formula for TEC, if this happens, we end up dividing by 0 and that's a problem. So now I need to consider what the TEC value should be for those cases. **I am going to ask Dr. Alvarez-Ponce about this.**

There is a TEC formula that considers the level of expression of a gene. We are still going to run into the same problem when gene I and/or gene J's total number of expressed tissues is 0, but we are going to capture more information than the previous TEC formula that we are using. **I am going to ask Dr. Alvarez-Ponce about this.**

# June 8, 2026
There were a lot of changes that I made for the distance calculations:
- Euclid Dist: I changed my own implementation of Euclidean distance to Numpy's implementation (np.linalg.norm). The reason I did this was because Numpy's implementation was faster and more precise.
- Euclid Dist w/ Euclid Norm: Turns out that I was normalizing by the column and not by the row. I'm not sure why, but I have since changed that. 
- Pearson Dist: I also changed my own implementation of Pearson distance to SciPy's implementation (scipy.spatial.distance.correlation). My own implementation was precise up to a certain degree, so using SciPy's would be much better.
- TEC: Confirmed from Dr. Alvarez-Ponce that I should return NaN anytime a divide by zero occurs.

For the data itself, I also changed the way that merged files. Before, I merged on only one column and did an outer merge. This blew up the resulting dataframe (~3 million rows!). I changed it to merge on both ID columns and to perform a left merge. This made sure that only IDs that were contained in the ortholog table were kept.

I redid the code that generates the Excel file. Previously, I would copy-and-paste the corresponding values, but that is not optimal at all. Now, everything is semi-automatic. I don't really understand why the Excel file won't overwrite itself, but everytime I want to make a change I need to delete the old Excel file and then run the code to generate a new one. But it works!

Now I have to double-check everything to make sure it's all actually correct.

# June 9, 2026
While looking over the Euclidean normalization technique that I performed on the data, I had doubts on whether I should've normalized by the columns or the rows. I read online that row-normalization may result in information lose, and that would definitely affect the results of our analysis, but reading over the paper for Euclidean normalization, performing it by rows is what they did.

The one-to-one genes have fewer NAs than every other group. Since these genes have not experienced a duplication event, the gene must be fully working to ensure that nothing goes wrong. We see very few of these genes having low expression profiles. With the duplicated genes, the workload can be split between them all, so expression doesn't need to be as high.

EuclidDist and EuclidDistLog have the same number of rows. This is because these metrics aren't dividing by anything, so expression profiles that are all 0 don't cause issues for these columns. EuclidDistNorm and PearDist have the same number of rows. Since these columns are dividing the expression profile by some value, they run into trouble with expression profiles that are all 0. TEC doesn't have the same number of rows as any other metric. Similarly, TEC runs into trouble for all 0 expression profiles, but it also runs into trouble when expression profiles are below 1, resulting in essentially an all 0 expression profile.

# June 10, 2026
Moved onto the next step of the process: picking random human-mouse gene pairs and calculating the distance metrics on them. We picked 10,000 samples, and this group will act as one of our control groups. Since most of these genes probably won't be orthologs, we expect them to have higher distance metrics. Of the 10,000 samples only 3 are orthologs.

# June 11, 2026
Double-checked that the calculations for the 10,000 randomly picked genes are correct.

Did the first to do. Super easy to add in the code.

There are mismatches. This could be because we are looking at different versions of the same data.

Changed the version, and there are no mismatches.

## Notes
- GOC: looks at two genes upstream and downstream our gene of interest.
- Potential problem: Since the score is given with a human gene as reference, when we look at one-to-many duplicated in mouse genes, then the GOC score might not be correctly reflecting the GOC score for humans, with mouse as reference.

## To Do:
- Add another line to each page "random pairs". Just identify the median and mean. We would expect them to have the biggest distance.
- DAP will let me know what pvalue tests to add to the table.
- From the orthologTable.csv only focus on one-to-many, and derive a table for genes that duplicated in mouse and one in human. Look for trios and identify parental/daughter copies using the GOC score. Each line should be a trio (reference species, duplicated species parent, duplicated species daughter, GOC parent, GOC daughter, distance-parent, distance-daughter (the distance metrics come from the orthologTable)). if there aren't one-to-two copies then the daughter copy is the gene with the lowest, the parental is the one with the lowest, but make sure they have metrics. if there are duplicates pick one at random. skip if the GOC scores are the same.
- count how many cases the distance is larger in the parental or the daughter
- To address the problem, I should add another column with the human GOC score to the orthologTable.
- Generate the reciprical table from an Ensembl version closest to our normal table (Jan 28, 2026).
- Use the Ensembl 115 version.

# June 12, 2026
I identified the parental and daughter copies for orthologs, following the rules above.
I identified the number of genes where the parental copy had higher distances for all metrics, where the daughter copy had higher distances for all metrics, and when they were both equal for all metrics.

## Notes
- Count how many times daughter has a higher distance than the parental, vice versa, and for the same. Do this for each of the metrics and separately for human and mouse.
- Binomial test for all columns in the newly made stats file. Ignore equal row.
- Add in distances between parental and daughter copies.
- For each column in human/mouseParentDaughter, calculate the mean and average. Add these values to automatedDistancesWithRandom.xlsx (new rows for trios, duplicated in [species], [copy])
- trios, duplicated in human, parental; trios, duplicated in human, daughter; trios, duplicated in mouse, parental; trios, duplicated in mouse, daughter.
- Gene Ontology (a way of classifying genes by biological process, molecular function, and cellular component). Perform an enrichment analysis for the top 25% one-to-one genes (round up) and all one-to-many genes in each distance. Once I have identified these terms, use BioMart to downloads tables that connect with GO terms (GO term accession and GO term name). Only focus on enriched analysis (more than the average percent found in genome).

# June 15, 2026
## McNair
### Vanderbilt Presentation
- 5:1 faculty-to-PhD ratio
- Look at LinkedIn profiles to see their journey.
- TA/RA position for the first two years. Followed by a preliminary/comprehensive exam (oral or written).
- Early deadline: 12/15
- Final deadline: 1/8
- Application fee waiver until 12/1. Available starting 8/1.
- SoP, 3 LoR, resume/CV, transcripts, online application.
- Ignore the title of the department, degree, etc. Focus on the type of research that faculty are doing.
- Ask recruiters for information about graduate school.

### Fellowships Presentationa
- Appointments can be made even in the summer (M - F).
- Non-Competitive Eligibility (NCE): bypass application process for time spent in service.
- **Schedule appointment with OUF to draft NSF-GRFP application.**
- Paul & Daisy Soros Fellowships for New Americans.
- Weekly open workshopping (Tues/Wed at 1st Floor Honors College).
- ASU has a good repository of fellowships, grants, etc.
- **Ask Dr. Han to see if she'd be willing to work on a NSF-GRFP application together. Dr. Alvarez-Ponce would also be good, but he doesn't have the AI aspect, which I think would be a benefit.**
- Show don't tell.

### Notes
- Vanderbilt sounds like a good school, but I don't think the programs it is offering fits my specific needs.
- Very informative, got me into the mindset on how best to structure my statements, not just for fellowships, but also for graduate school applications.

## Research
1. I used Gene Ontology Enrichment Analysis on all human one-to-many genes and the top 25% (5,176) one-to-one genes for Pearson distance. This analysis output which biological processes are under/overrepresented in our dataset, and by how much. I will use this information to see if there are any shared biological processes, and if there are, then we can identify these genes and remove them from our analysis.
2. I added in the pvalues of the binomial test comparing parental vs daughter copies.


### Notes
- Identify genes corresponding with the shared biological processes, but don't remove them yet. Continue working with the entire dataset. We will remove these genes later down the road when we have a better understanding of the project and analysis.
- !!! I still need to do the binomial test on the parental-daughter copies to see if daughter copies experiencing higher levels of tissue expression divergence is statistically significant.
- GO Enrichment Analysis: reference list (all protein-encoding genes in human genome); FDR
- DeDupeList.com: removes duplicates in a list
- False Discovery Rate (corrected p-value): decreases the threshold for significane because it adjusts the pvalue for the number of tests conducted or some other variable. For example, if 100 tests were corrected then all p-values would be multiplied by 100, so now to have a FDR value of 0.05, your pvalue would be 0.0005.
- Focus on super categories for GO Enrichment. Make a list of all of the GO accession codes for each category. Do this for all groups. See what groups appears in both analyses with the same sign. Place in another list and these are the genes that we would want to remove. Add a column to the orthologTable that flags whether a gene should or shouldn't be removed. This column should be populated by "under/overrepresented" if the signs from both GO analyses match.
- Add the extra lines to the distances table. These lines can be found in Outlook. Add another column in the same file that looks at the correlation (rho) of the number of genes belonging to a specific group and its distance and the pvalue associated with the test. Skip for one-to-one genes. The purpose of this is to see if genes that experienced more duplication evenets experience more evolution than those who havent. Compare the distance of each gene with the number of duplicated copies. Use the spearman metric. Spearman is non-parametric, which means the test doesn't assume any distribution or normality of the data. It cares more about the ranking of the values. Check it out.

## Next Steps
1. Add parental-daughter copies to distancesTable.
2. GO Enrichment Analysis.
3. Correlation of distances and number of duplicated copies.

### Notes about Graduate School
- EvolDir - a listserv that I can subscribe to. Contains announcements about graduate positions, conferences, etc.
- Contact a faculty in the graduate program of interest, see if they encourage you to apply (it means that the professor is interested). No gurantees. Dependent on funding.
- Show interest that you are working with the professor. Shouldn't be generic, should be tailored to them. Looked at the website of the lab and there is a reason why you are interest in that specific lab. Attach CV. Ask if they are accepting students in the Fall. Highlight skills that make you look like a good candidate.
- The bigger a name and the more people in a lab, the less time that they will have to meet with you.
- Create a list of labs that I am interest in and show it to Dr. Alvarez-Ponce.
- Famous Labs: Stanford (Dimitri Petrov), UMich (Jianzhi Zhang), USCS (Beth Shapiro).
- ISMB Conference. McNair could pay for it or a part of it. We also have the 1K from INBRE.
- Look at authors of papers I've been reading. Easy initial email. 
- Just need a good reason for showing interest. Attending talks. Subscribe to EECB and CMB list.

# June 16, 2026
## McNair
### Counseling Presentation
- Reflect on if what you're doing is self-care.
- Determine if the time that I am allocating throughout the week aligns my core values.
- Belly breathing. Before bed is good.

### Research Presentation
**Pros:**
- Didn't read off of slides.
- Hand movements.
- Consistent pace.
- No filler words.
- Setting up background.

**Cons:**
- Emphasize things more.
- Simplifying explanations with analogies (creating a connection), pictures, etc.
- Potential analogy: parents and kids (Kardashians).
- Conference audience will be quite difference. Make it very generalizable and simple. Use pictures analogies.
- Sell importance of work immediately.
- Potential change color scheme (Green -> Blue).
- Blow up subfunctionalization and neofunctionalization image.
- Parental and Daughter Copies image should be bigger.
- Emotional aspect.

### Notes
- I really enjoyed the core values activity. It made me realize some of the things I thought I valued weren't really as important, and things that I never thought about were actually really valuable to me. My core values are: intimacy, monogamy, and friendship.
- Appreciation page and contact information page. Results page too.

## INBRE
### Mentoring Presentation
- Keep mental notes of your instincts during the day.
- Ask other people about your potential boss and the projects/work area.
- Quality of life is hugely enhanced by a good working environment.
- Listen to your peers.
- Do what interests you.
- Emulate before you innovate.
- Critical-thinking skills.
- Keep your boss updated. Not bragging.
- Graduate school pick somewhere supportive, and then pick the big labs for postdoc.

# June 17, 2026
## Research
1. I found the number of genes, the median for every distance metric, and the mean for every distance metric of the parental-daughter genes. This was done for both genes that were duplicated in humans and in mice.
2. I identified the shared GO Accession Terms between the top 25% one-to-one genes for Pearson Distance and all the one-to-many genes. There was one shared GO Accession Term: "GO:0050911" that detects chemical stimulus involved in sensory perception of smell. However, there was an overrepresentation of this gene in the one-to-many genes, and an underrepresentation in the one-to-one genes. So, there aren't any genes that we would need to remove. I do want to double-check this.

# June 18, 2026
1. Continued double-checking from the previous day.

# June 22, 2026
1. Added correlation (spearman rho) and pvalue columns to each distance metric in the distanceTable.
2. Added GO information to the orthologTable. Now includes the GO Accession Term, label, and whether the gene is under/overrepresented in the dataset.
3. Added Mann-Whitney U Test p-values for the parental-daughter copies to the distanceTable.