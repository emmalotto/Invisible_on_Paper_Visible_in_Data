## ⚠️ This GitHub repository is currently a work in progress and will be finalized in the coming days.


# Invisible on Paper, Visible in Data

This repository contains all R scripts, codebooks, and supplementary materials used in the Bachelor's thesis:

📘 **Invisible on Paper, Visible in Data: Exploring the Demography of the Nubian Community in Kenya**  
👩🏻‍🎓 *Emma Lotto – Università degli Studi di Padova (2025)*  
📊 *Bachelor's Degree in Statistics for Economics and Business*

---

## 🧭 Overview

This thesis investigates the demographic consequences of legal invisibility by analyzing fertility intentions, child registration, and access to healthcare within the Nubian community in Kibera (Nairobi, Kenya).  
The analysis draws on an original dataset collected in 2015 by the Open Society Justice Initiative (OSJI), in collaboration with the Nubian Rights Forum (NRF).

All analyses were conducted in **R** and organized to ensure full **transparency**, **reproducibility**, and **modularity**.

---

## 📁 Repository Structure

```bash
Invisible_on_Paper_Visible_in_Data/
├── 0_data/               # Raw and cleaned data files (e.g. .dta, .RDS)
├── 1_intro/              # Introduction and thesis structure
├── 2_data_methods/       # Sampling, variables, and modeling description
├── 3_exploration/        # Descriptive analysis and data exploration
├── 4_fertility/          # Fertility gap, desired vs. actual children
├── 5_models/             # Linear, Poisson and Logistic regressions
├── 6_appendix/           # Codebook, questionnaire, extra tables
└── README.md             # This file
```

---

## 🔁 Reproducibility

All scripts are written in R Markdown (`.Rmd`) and organized by thesis chapter and section.

To reproduce the analysis:

1. Clone or download this repository
2. Open each `.Rmd` file following the chapter order
3. Make sure the original dataset  
   `RSA015-Final ipre data set v05.dta`  
   is placed inside the folder `0_data/`
4. Knit or run the chunks in RStudio

All variable transformations are documented in a separate codebook.

---

## 📦 Dependencies

The following R packages were used throughout the project:

- `tidyverse`
- `haven`
- `dplyr`
- `ggplot2`
- `broom`
- `survey`
- `psych`
- `patchwork`
- `readxl`
- `car`

You can install them using:

```r
install.packages(c("tidyverse", "haven", "broom", "survey", "psych", "patchwork", "readxl", "car"))
```

🔒 License
This repository is released under the MIT License.
You are free to reuse the code with proper attribution.
Please consult the Open Society Justice Initiative for restrictions regarding the use of the original dataset.
