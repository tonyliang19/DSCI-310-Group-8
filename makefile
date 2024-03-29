# author: Anam Hira, Tony Liang, Isabela Lucas Bruxellas
# date: 2022-04-01

all: data/raw/student_performance.xls data/processed/train_data.csv data/processed/test_data.csv results/stats/peg_stg.png results/stats/mean.csv results/stats/maximum.csv results/stats/minumum.csv results/stats/observations.csv results/model/lm_rmse.csv results/model/lm_rmspe.csv results/model/kmin.csv results/model/knn_rmspe.csv results/model/lm_predictions.png results/model/knn_regressions_plot.png doc/student_performance_analysis_report.html doc/student_performance_analysis_report.pdf

# generate figures and objects for report

# download data
data/raw/student_performance.xls: src/download_data.R
	Rscript src/download_data.R --url=https://archive.ics.uci.edu/ml/machine-learning-databases/00257/Data_User_Modeling_Dataset_Hamdi%20Tolga%20KAHRAMAN.xls --out_dir=data/raw/student_performance.xls

data/processed/train_data.csv data/processed/test_data.csv: src/prepare_data.R 
	Rscript src/prepare_data.R --file_path=data/raw/student_performance.xls --target_value =5 --dest_path=data/processed/

# visualization of statistics
results/stats/peg_stg.png results/stats/mean.csv results/stats/maximum.csv results/stats/minumum.csv results/stats/observations.csv: src/data_visualisation.R
	Rscript src/data_visualisation.R --df=data/processed/train_data.csv --out_dir=results/stats

# visualization of model
results/model/lm_rmse.csv results/model/lm_rmspe.csv results/model/kmin.csv results/model/knn_rmspe.csv results/model/lm_predictions.png results/model/knn_regressions_plot.png: src/summary_script.R
	Rscript src/summary_script.R --user_training=data/processed/train_data.csv --user_testing=data/processed/test_data.csv --results=results/model


# render R Markdown report in HTML and PDF
doc/student_performance_analysis_report.html doc/student_performance_analysis_report.pdf: doc/student_performance_analysis_report.Rmd doc/references.bib
	Rscript -e "rmarkdown::render('doc/student_performance_analysis_report.Rmd', c('bookdown::html_document2', 'bookdown::pdf_document2'))"

# clean
clean:
	rm -rf results/stats results/model
	rm -rf data/raw data/processed
	rm -rf doc/student_performance_analysis_report.html doc/student_performance_analysis_report.pdf

