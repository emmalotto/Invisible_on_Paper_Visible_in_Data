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
├── Invisible_on_Paper.Rproj                # R project to open before starting
├── preprocessing.R                         # Data preprocessing script (sourced in all Rmd files)
├── RSA015-Final ipre data set v05.dta      # Original dataset

├── CHAPTER 3/                              # Data Exploration
│   ├── 3.2 Overview of respondents’ characteristics/
│   │   └── 3.2.Rmd
│   ├── 3.3 Health Service Interactions/
│   │   └── 3.3.Rmd
│   └── 3.4 Children and documentation/
│       └── 3.4.Rmd

├── CHAPTER 4/                              # Fertility
│   ├── 4.2 From National Trends to Sample Analysis/
│   │   └── 4.2.Rmd
│   └── 4.3 Reproductive Aspirations and Fertility Outcomes/
│       └── 4.3.Rmd

└── CHAPTER 5/                              # Statistical Models
    ├── 5.3 Linear regression analysis/
    │   └── 5.3.Rmd       
    ├── 5.4 Poisson regression analysis/
    │   └── 5.4.Rmd       
    └── 5.5 Logit analysis/
        └── 5.5.Rmd       

```

---

## 🔁 Reproducibility

All scripts are written in R Markdown (`.Rmd`) and organized by thesis chapter and section.

To reproduce the analysis:

1. Clone or download this repository
2. Open the R Project file: `Invisible on Paper, Visible in Data.Rproj`
3. Run the preprocessing script: `preprocessing.R` (this script is automatically sourced by all Rmd files)
4. Open and knit the .Rmd files following the chapter and section structure:
- CHAPTER 3 – Data Exploration: 3.2, 3.3, 3.4
- CHAPTER 4 – Fertility: 4.2, 4.3
- CHAPTER 5 – Statistical Models: 5.3, 5.4, 5.5


---

## 📦 Dependencies

The following R packages are required to run the analysis:

- `haven`  
- `here`  
- `tidyverse`  
- `dplyr`  
- `ggplot2`  
- `scales`  
- `gtsummary`  
- `polycor`  
- `ggcorrplot`  
- `modelsummary`  

You can install them using:

```r
install.packages(c(
  "haven", "here", "tidyverse", "dplyr", "ggplot2", "scales",
  "gtsummary", "polycor", "ggcorrplot", "modelsummary"
))
```

⚠️ Notes

AIC values:
   Linear models → Section 5.3
   Poisson models → Section 5.4
   Logistic regressions → Section 5.5

Each AIC is computed directly within the corresponding model file.

🔒 License
This repository is released under the MIT License.
You are free to reuse the code with proper attribution.
Please consult the Open Society Justice Initiative for restrictions regarding the use of the original dataset.
