# MSc Thesis: Italian PVS Analysis – Reproducible Workflow

This repository contains the full Stata + Python workflow used for my MSc Thesis titles:

> **“Socioeconomic Inequalities in Perceived Healthcare Quality in Italy”**

My thesis investigates disparities in individuals’ perceptions of healthcare quality in Italy across socio-economic classes. The analysis reveals a strong correlation between lower socioeconomic status and negative perceptions of the quality of healthcare, and explores potential mechanisms underlying this relationship.

The present code starts from the raw **PVS** micro‑data, cleans and enriches the dataset, imputes some missing values, derives explanatory indices, builds socio‑economic status clusters, runs regression models and mediation tests.
## Methodology

#### Data

The analysis draws from the first wave of the People's Voice Survey (Italian sample). The original dataset can be downloaded for free [here]([url](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/3ARMQF))

Additional information about the dataset can be read [here]([url](https://www.questnetwork.org/our-work/peoples-voice-survey))

#### Methods for analysis

* Cluster analysis to identify socio-economic clusters
* Principal Component Analysis to construct indices
* Multivariate linear regression and logit
* Sobel mediation tests

---

## Project tree

```text
.
├── data/                # raw‑data .dta files + intermediate outputs
├── codes/               # Stata do‑files
│   ├── 1 - clean_data.do
│   ├── 2 - impute_income.do
│   ├── 3 - clusters.do
│   ├── 4 - indices.do
│   └── 5 - regressions.do
├── master.do            # one‑click driver script
└── outputs/             # tables, figures, logs
    ├── figures/
    └── tables/             
```

> **Tip:** All relative paths are built from the folder that contains `master.do`.
> Clone the repo, `cd` into it, open Stata, and just `do master.do`.

---

## Prerequisites

| Software               | Version                                                                              | Used for                           |
| ---------------------- | ------------------------------------------------------------------------------------ | ---------------------------------- |
| **Stata**              | 17 (or newer 16)                                                                     | Main data wrangling & econometrics |
| **Python**             | 3.9+ (via `python`‑end)                                                              | K‑NN income imputation             |
| **pandas**             | ≥ 2.0                                                                                | —                                  |
| **scikit‑learn**       | ≥ 1.4                                                                                | `KNNImputer`                       |
| **matplotlib / numpy** | any recent                                                                           | plotting & numerics                |
| Stata user packages    | `estout`, `pca`, `mca`, `missings`, `heatplot`, `palettes`, `tabout`, `sgmediation2` |                                    |

All Stata packages are installed automatically by `master.do`.
For Python, create a virtual‑env and `pip install -r requirements.txt` with:

```bash
pandas scikit-learn matplotlib numpy
```

---

## How the pipeline works

| Stage                      | Script                    | What it does                                                                                                                                                                                                                                                                                                                                   |
| -------------------------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **0. Prepare environment** | `master.do` (lines 1–70)  | Installs any missing SSC packages, defines global folder macros (`$data`, `$codes`, `$outputs`, …).                                                                                                                                                                                                                                            |
| **1. Clean raw data**      | `1 - clean_data.do`       | ‑ Keeps the Italian sample (`country==14`).‑ Harmonises variable names, drops uneeded IDs.‑ Recodes geography, education & insurance variables.‑ Calls `indices.do` and `regressions.do` later in the chain.                                                                                                                                   |
| **2. Impute income**       | `2 - impute_income.do`    | Runs **inside a Python block**:   1. Pulls current Stata dataset into pandas via SFI.  2. Uses `KNNImputer` twice – first on the most‑correlated variables, then on a user‑selected set – to fill missing `income`.  3. Writes the imputed columns to `data/imputed_income.dta`.  Back in Stata, `master.do` merges those columns on `respid`. |
| **3. SES clusters**        | `3 - clusters.do`         | Standardises education & (imputed) income, then applies k‑means to create **three socio‑economic status clusters** (`ses_cluster`). Includes exploratory graphs & basic validations.                                                                                                                                                           |
| **4. Outcome indices**     | `4 - indices.do`          | Builds three composite outcomes:   *System Quality*, *Primary‑Care Coverage*, *Patient Satisfaction*. Each block: z‑scores variables, checks α / inter‑item correlations, runs a PCA where justified, and labels the resulting index.                                                                                                          |
| **5. Main regressions**    | `5 - regressions.do`      | Runs a battery of OLS, Logit & Ordered‑Logit models:   *Model 0* – controls only  *Model 1* – + education  *Model 2* – + SES cluster dummies. Stores estimates with `eststo`, exports publication‑ready tables via `esttab`.                                                                                                                   |
| **6. Wrap‑up**             | `master.do` (final lines) | Collects regression tables, saves graphs (under `outputs/figures`), and writes log files.                                                                                                                                                                                                                                                      |

---

## Running the entire study

1. **Clone** the repo

   ```bash
   git clone https://github.com/<user>/italy‑pvs.git
   cd italy‑pvs
   ```
2. **Open Stata**, set your working dir to the repo root or simply run

   ```stata
   cd "~/path/to/italy-pvs"
   do master.do
   ```
3. Grab a coffee — the whole run takes ≈ 3 min on a modern laptop (Python imputation \~30 s).

All intermediate `.dta` files and final outputs appear in `/outputs`.
Logs (`.smcl`) for every script are also saved there for transparency.

---

## License & citation

The code is released under the MIT License.
If you use or adapt it, please cite:

```
Ardito, E. (2025). “Socioeconomic Inequalities in Perceived Healthcare Quality in Italy”. Unpublished MSc Thesis.
```

Any addition, correction or suggestion is welcome!
