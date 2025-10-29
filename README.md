# mistelilab-centromeres CRISPR Screens Analysis

### General Information

This is a repo containing the R code used to generate the CRISPR/Cas9 knock-out (KO) screen results included in the [eLife manuscript](https://doi.org/10.7554/eLife.108410.1) from the Misteli Lab at the National Cancer Institute/NIH. The R code heavily uses the [cellHTS2 package](https://bioconductor.riken.jp/packages/3.13/bioc/html/cellHTS2.html).

**Title:** Orderly mitosis shapes interphase genome architecture

**Authors:** Krishnendu Guin, Adib Keikhosravi, Raj Chari, Gianluca Pegoraro, Tom Misteli.

**DOI:** doi.org/10.7554/eLife.108410.1

The code for the analysis of the primary sgRNA screens with the Synthego human Epigenetics Library in HCT116-Cas9 and hTERT-RPE1-Cas9 cells, respectively,s is contained in two self-contained subfolders: `Epiplus_sgrna_screen_HCT116` and `Epiplus_sgrna_screen_RPE1`.

### Epigenetics Plus / Centromeres Screens

The `Epiplus_sgrna_screen_HCT116` and `Epiplus_sgrna_screen_RPE1` folders contain:

- An `01_hts2_dataprep.qmd` script that includes the R and `cellHTS2` code used to prepare the data for the actual `cellHTS2` analysis. This script needs to be run before the `02_hts2_analysis.qmd` script.
- An `02_hts2_analysis.qmd` script that runs the `cellHTS2` analysis separately on each cellular feature calculated by the [HiTIPS](https://hitips.readthedocs.io/en/latest/instructions.html) image analysis software.
- The well level results obtained from HiTIPS, which is contained in the `hitips_input` subfolder.
- The `reformat_metadata` subfolder contains library reformatting metadata output by the liquid handler and is used by the `01_hts2_dataprep.qmd` script to generate the sgRNA oligos layouts for the imaging plates used in the screen.
- A `Description.txt` file that contains details about the screen according to `cellHTS2`
- A series of subfolders whose name starts with `hts2_output` containing the results of the `cellHTS2` analysis. Each of these subfolder contains data relative to one of the cellular features analyzed and output by HiTIPS.

The subfolders containing primary screen results relevant for this manuscript are:

- `spots_number_mean`: These are data relative to the mean number of CENPC spots per cell.

- `k_corr_perc_mean`: These are data relative to the mean CENPC spots clustering score calculated using the Ripley-K clustering metric.

For information about this repo, please contact [Tom Misteli](mailto:mistelit@nih.gov) or [Gianluca Pegoraro](mailto:gianluca.pegoraro@nih.gov).
