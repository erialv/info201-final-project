# read in relevant data
data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

# vector of STEM subjects to filter with
stem.subjects <- c("BIOLOGY", "CHEMISTRY", "CALCULUS AB", "CALCULUS BC", "COMPUTER SCIENCE A", "PHYSICS C: ELECTRICITY & MAGNETISM", "PHYSICS C: MECHANICS",
                   "PHYSICS 1", "PHYSICS 2", "STATISTICS")

# Filter for STEM subjects and exclude columns on 11th and 12th grade student data
stem.data <- data %>% 
  filter(Exam.Subject %in% stem.subjects) %>%
  select(-Students..11th.Grade., -Students..12th.Grade.)

# Read in more relevant data
data.students <- read.csv("data/students.csv", stringsAsFactors = FALSE)

# Exclude rows on "all subjects" data
data.students <- data.students[-c(38, 39), ]