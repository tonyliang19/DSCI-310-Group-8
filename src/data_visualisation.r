# author Anam HIra
# date: 2022-03-28

"Scriptt to create exploratory data visualisations and tables that are useful
to help the consumer understand the dataset"

"Usage src/data_visualisation.r --train=<train> --out_dir=<out_dir>"

"Options:
--df=<df>     Path (including filename) to training data
--results=<results> Path to directory where the plots should be saved"
library(tidyverse)
library(digest)
library(repr)
library(tidymodels)
library(readxl)
library(cowplot)
library(GGally)
library(broom)
library(rlang)
library(testthat)
options(repr.matrix.max.rows = 6)
source("../src/R/load_data.R")
source("../src/R/wrangle_data.R")
source("../src/R/summary_fun.R")
source("../src/R/num_na.R")
source("../src/R/visualize_vars.R")
source("../src/tests/testthat/test-load_data.R")
source("../src/tests/testthat/test-num_na.R")
source("../src/tests/testthat/test-summary_fun.R")
source("../src/tests/testthat/test-wrangle_data.R")
source("../src/tests/testthat/test-visualize_vars.R")
opt <- docopt(doc)
main <- function(df,results) {
    
    if (!dir.exists(results)) {
    dir.create(results)
  }
    train_data <- read_feather(train) %>% 
    user_means <- summary_fun(user_training,mean)
    

    maximum <- summary_fun(user_training, max)
    maximum
    write_csv(maximum,
            file.path(out_dir, "maximum.csv"))
    minimum <- summary_fun(user_training, min)
    write_csv(minimum,
            file.path(out_dir, "minimum.csv"))

    observations <- user_training %>%
    summarize(n = n())
    write_csv(observations,
            file.path(out_dir, "observations.csv"))

    
    peg_stg <- visualize_vars(user_training, STG, PEG)
    peg_stg
    
   # ggsave(paste0(out_dir, "/visualise_data.png"), 
    #     peg_stg,
     #    width = 8, 
      #   height = 10)
    ggsave("peg_stg.png", device = "png", path = results, width = 5, height = 4)
}

main(opt[["--df"]], opt[["--results"]])