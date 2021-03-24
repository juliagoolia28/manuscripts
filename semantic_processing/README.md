# Neural underpinnings of preschooler’s semantic processing: evidence from the N400 and theta frequency of the EEG
## Sonali Poudel, Julie M. Schneider, Anna E. Middleton, Asha Pavuluri & Mandy J. Maguire

## Abstract. 

Semantic mastery requires knowing not only a word’s meaning but also how the word relates to other words in one’s lexicon. To better understand the neural correlates of young children’s semantic networks, we used EEG to examine the neural activity of pre-school aged children (3-5-year olds) as they listened to noun pairs that were either semantically related (e.g., horse - sheep) or unrelated (e.g., garage - sheep). Like adults and children in previous studies, children in the current study exhibited a significantly larger N400 amplitude to semantically incongruent word pairs compared to semantically congruent word pairs. Surprisingly, children’s theta response was opposite of that previously reported in adults. Children exhibited greater theta power in response to semantically congruent word pairs as opposed to incongruent words pairs. Further, there was a significant positive correlation between N400 and theta effects in children. These results provide novel insights into the neural underpinnings of semantic processing in children and emphasize the importance of investigating both theta and the N400 with respect to semantic development. 

## Data:

- All raw EEG files (unedited) for this project are located at:
```
Maguire Server\Workspace\N400-theme category\Theme Category\Children
```

- All Epoched data for this project (both ERP & ERSP), and the study used for stats, are located at:
```
Maguire Server\For RA use\Studies\Theme Category\Studies\JMS_N400_theta
```

1. Create a STUDY design using the EEGLab Toolbox within Matlab
    - Create two conditions: Related and Unrelated
    - Codes for Related: 211 & 212 & 221 & 222 & 231 & 232 & 241 & 242
    - Codes for Unrelated: 213 & 223 & 233 & 243

2. Precompute the STUDY to analyze ERPs and ERSPs (removing baseline)
3. Once the STUDY is done precomputing, save as
4. pop_chanplot for computation of statistics
    - To compute channel clusters:
    - select all electrodes
    - STATS: ![Set Stats based on this image](https://github.com/juliagoolia28/manuscripts/blob/master/semantic_processing/stats.png)
   
