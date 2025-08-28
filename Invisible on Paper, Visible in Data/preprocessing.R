# LOAD LIBRARIES
library(haven)   # to read .dta files
library(here)    # to search for the file
library(tidyverse)  #for the plotting (ggplot2) and data manipulation (dplyr)

# The dataset must be in the same folder as this file
data <- read_dta(here("RSA015-Final ipre data set v05.dta"))


#SUBSET
data_subset <- data%>%
  dplyr::select(
    #socio-demographic factors
    Complete,        # indicates whether the questionnaire was completed
    B1,              # respondent's gender
    Q1,              # respondent's age
    Q2,              # marital status
    Q4,              # highest level of education attained
    
    #documents
    Q11,             # whether the respondent has a birth certificate
    Q11a,            # reason for not having a birth certificate
    Q17,             # whether the respondent has applied for a national ID
    Q17a,            # reason for not applying for a national ID
    Q18,             # whether the respondent currently has a national ID
    Q18a,            # reason for not having a national ID
    Q18b,            # how long the national ID application has been pending
    Q28,             # whether the respondent has applied for a passport
    Q29,             # whether the respondent has a passport
    
    #vetting
    Q26,             # whether the respondent was ask to appear before a vetting committee
    Q26a,            # how many times the respondent appeared before a vetting committee
    Q26b,             # security services present
    starts_with("Q26c"),  # things asked for by the vetting committee
    starts_with("Q26d"),  # which document was vetted 
    
    #health facility (hospital or clinic)
    Q38,           # walking minutes to nearest clinic/hospital
    Q39,           # ability to pay for medical treatment
    Q40, Q40a,     # avoided care due to cost? how many times?
    Q41,           # type of facility usually visited
    Q42, Q43,      # satisfaction: waiting time / overall quality
    Q44, Q45,      # turned away or avoided care due to ID
    
    #fertility
    Q46,             # Total number of children ever born
    Q46a,            # number of children respondent believes a family should have
    Q46b,            # whether the respondent would personally like to have children
    Q46c,            # number of children the respondent would like to have
    Q46d,            # when the respondent would like to have a child (if any)
    starts_with("Q46e"),  # Age of each child (Q46e1 to Q46e12)
    starts_with("Q46h"),  # Place of birth of each child (home, hospital, other)
    starts_with("Q46i"),  # Whether each child has a birth certificate
    starts_with("Q46j"),  # Reason each child does not have a birth certificate
    starts_with("Q46k"),  # Age at which certificate was received
    starts_with("Q46m"),  # Whether they paid to help to get the certificate
    starts_with("Q46n"),  # Whether any child could not enroll in school due to lack of birth certificate
    starts_with("Q46p"),  # Whether any child could not sit for exams due to lack of birth certificate
    Q47,             # ideal number of children a family should have
    Q47a,            # whether the respondent would like to have more children
    Q47b,            # how many more children the respondent would like to have
    Q47c,            # when the respondent would like to have more children 
    Q48,             # whether the respondent sought antenatal care for the youngest child (only to women)
    Q48a,            # how many ante-natal visits (only to women)
    Q48b,            # at what month of pregnancy first ante-natal care visit (only to women)
    
    #ethnic group
    Q104,             # respondent's ethnic group, cultural group, or tribe if == 0 -> nubians
    QE10              # NFR
  )


#BINARY INDICATORS
# undocumented = 1 if no national ID (Q18 == 0), otherwise 0
data_subset$undocumented <- ifelse(data_subset$Q18 == 0, 1, 0)
data_subset <- data_subset %>%
  # Step 1: create id_eff and pass_eff
  mutate(
    id_eff = case_when(
      Q17 == 0        ~ 0,
      Q18 == 1        ~ 1,
      Q18 == 0        ~ 0,
      TRUE            ~ NA_real_
    ),
    pass_eff = case_when(
      Q28 == 0        ~ 0,
      Q29 == 1        ~ 1,
      Q29 == 0        ~ 0,
      TRUE            ~ NA_real_
    )
  ) %>%
  
  # Step 2: define documentation status
  mutate(
    undocumented_def = case_when(
      Q11 == 1 & id_eff == 1 & pass_eff == 1 ~ "fully documented",
      Q11 == 0 & id_eff == 1 & pass_eff == 0 ~ "only ID",
      TRUE                                   ~ "no documentation"
    ),
    undocumented_def = factor(
      undocumented_def,
      levels = c("no documentation", "only ID", "fully documented")
    )
  )


# nubian = 1 if nubian  (Q104 == 0), otherwise 0
data_subset$nubian <- ifelse(data_subset$Q104 == 0, 1, 0)

#RECODING AND COLLAPSING
data_subset <- data_subset %>%
  mutate(
    # Original factors
    marital_status = factor(Q2,
                            levels = c(0, 1, 2, 3, 4, 5, 98, 99),
                            labels = c("Single", "Partner, unmarried", "Married", "Widowed",
                                       "Divorced", "Separated", "Don't know", "Refuse to answer")
    )
    ,
    education = factor(Q4, levels = 0:9,
                       labels = c("No education","Some primary","Completed primary",
                                  "Some secondary","Completed secondary",
                                  "Some college/technical","Completed college/technical",
                                  "Some university","Completed university","Other"))
  ) %>%
  # New, collapsed groups:
  mutate(
    marital_group = case_when(
      marital_status %in% c("Married","Partner, unmarried") ~ "Coupled",
      marital_status == "Single"                          ~ "Single",
      TRUE                                                 ~ "Other"
    ) %>% factor(levels = c("Single","Coupled","Other")),
    
    educ_group = case_when(
      education %in% c("No education","Some primary","Completed primary")        ~ "Primary or less",
      education %in% c("Some secondary","Completed secondary")                   ~ "Secondary",
      education %in% c("Some college/technical","Completed college/technical",
                       "Some university","Completed university")                ~ "Tertiary",
      TRUE                                                                       ~ "Other"
    ) %>% factor(levels = c("Primary or less","Secondary","Tertiary","Other"))
  )

#gender
data_subset <- data_subset %>%
  mutate(gender = factor(B1, labels = c("Male", "Female")))

# recoding “Don’t know” and “Refuse to answer” (codes 98/99) to NA
data_subset <- data_subset %>%
  mutate(across(
    .cols = everything(),
    .fns  = ~ replace(.x, .x %in% c(98, 99), NA)
  ))



#FERTILITY GAP
# Initialize fertility_gap with NA
data_subset$fertility_gap <- NA

# Step 1: Save actual number of children from Q46
data_subset$actual_children <- NA
data_subset$actual_children[!is.na(data_subset$Q46) & data_subset$Q46 < 98] <- data_subset$Q46[!is.na(data_subset$Q46) & data_subset$Q46 < 98]

# Step 2: Create a variable for desired number of children
data_subset$desired_children <- NA

# Case 1: Respondents with NO children who DO want children (Q46b == 1), valid Q46c
no_children_want_index <- !is.na(data_subset$Q46) & data_subset$Q46 == 0 &
  !is.na(data_subset$Q46b) & data_subset$Q46b == 1 &
  !is.na(data_subset$Q46c) & data_subset$Q46c < 98

data_subset$desired_children[no_children_want_index] <- data_subset$Q46c[no_children_want_index]

# Case 2: Respondents with NO children who DO NOT want children (Q46b == 0)
no_children_dont_want_index <- !is.na(data_subset$Q46) & data_subset$Q46 == 0 &
  !is.na(data_subset$Q46b) & data_subset$Q46b == 0

data_subset$desired_children[no_children_dont_want_index] <- 0

# Case 3: Respondents WITH children who DO want more children (Q47a == 1), valid Q47b
has_children_want_more_index <- !is.na(data_subset$Q46) & data_subset$Q46 > 0 &
  !is.na(data_subset$Q47a) & data_subset$Q47a == 1 &
  !is.na(data_subset$Q47b) & data_subset$Q47b < 98

data_subset$desired_children[has_children_want_more_index] <- 
  data_subset$Q46[has_children_want_more_index] + data_subset$Q47b[has_children_want_more_index]

# Case 4: Respondents WITH children who DO NOT want more children (Q47a == 0)
has_children_dont_want_more_index <- !is.na(data_subset$Q46) & data_subset$Q46 > 0 &
  !is.na(data_subset$Q47a) & data_subset$Q47a == 0

data_subset$desired_children[has_children_dont_want_more_index] <- data_subset$Q46[has_children_dont_want_more_index]

# Finally, compute the fertility gap
data_subset$fertility_gap <- data_subset$desired_children - data_subset$actual_children



#AGE CLASSES
data_subset <- data_subset %>%
  mutate(
    age_group = cut(
      Q1,
      breaks = c(18, 24, 34, 44, Inf),
      labels = c("18-24", "25-34", "35-44", "45+"),
      right = TRUE
    )
  )


nrow(data_subset)

#data for modeling
model_data <- data_subset %>%
  filter(
    !is.na(desired_children),
    !is.na(marital_group),
    !is.na(educ_group),
    !is.na(undocumented_def),
    !is.na(nubian),
    !is.na(B1),
    !is.na(education),
    !is.na(Q1),
    !is.na(marital_status),
  )

#for logit model
model_data <- model_data %>%
  mutate(
    desired_any = ifelse(desired_children > 0, 1, 0)  
    #desired_any = 1 when at least one child desired, otherwise 0
  )

