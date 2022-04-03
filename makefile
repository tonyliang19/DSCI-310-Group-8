
   
# author: Anam Hira, Tony Liang
# date: 2022-04-01

all: results/stats/peg_stg.png results/stats/maximum.csv results/stats/minumum.csv results/stats/observations.csv results/model/lm_rmse.csv results/model/lm_rmspe.csv results/model/kmin.csv results/model/knn_rmspe.csv results/model/lm_predictions.png results/model/knn_regressions_plot.png doc/student_performance_analysis_report.html doc/student_performance_analysis_report.pdf


# generate figures and objects for report

# download data
data/raw/student_performance.xls: src/download_data.r
	Rscript src/download_data.r --url=https://archive.ics.uci.edu/ml/machine-learning-databases/00257/Data_User_Modeling_Dataset_Hamdi%20Tolga%20KAHRAMAN.xls --file_path=data/raw/student_performance.xls

data/processed/data_training.csv data/processed/data_testing.csv : src/prepare_data.r 
	Rscript src/prepare_data.r --file_path=data/raw/student_performance.xls --target_value=5 --dest_path=data/processed

results/stats/peg_stg.png results/stats/maximum.csv results/stats/minumum.csv results/stats/observations.csv: src/data_visualisation.R
	Rscript src/data_visualisation.r --df=data/processed/train_data.csv --out_dir=results/stats

results/model/lm_rmse.csv results/model/lm_rmspe.csv results/model/kmin.csv results/model/knn_rmspe.csv results/model/lm_predictions.png results/model/knn_regressions_plot.png: src/summary_script.R
	Rscript src/summary_script.R --user_training=data/processed/train_data.csv --user_testing=data/processed/test_data.csv --results=results/model


# render R Markdown report in HTML and PDF
doc/student_performance_analysis_report.html doc/student_performance_analysis_report.pdf: doc/student_performance_analysis_report.Rmd doc/references.bib
	Rscript -e "rmarkdown::render('doc/student_performance_analysis_report.Rmd', c('bookdown::html_document2', 'bookdown::pdf_document2'))"

# render Jupyter Book report in HTML and PDF
#doc/jbook_example/_build/html/index.html: doc/jbook_example/_config.yml doc/jbook_example/_toc.yml doc/jbook_example/jbook_example.ipynb doc/jbook_example/references.bib
#	jb build doc/jbook_example/
#doc/jbook_example/_build/latex/python.pdf: doc/jbook_example/_config.yml doc/jbook_example/_toc.yml doc/jbook_example/jbook_example.ipynb doc/jbook_example/references.bib
#	jb build doc/jbook_example/ --builder pdflatex

# clean
clean:
	rm -rf results
	rm -rf doc/analysis/report.html doc/analysis/report.pdf
