FROM ubcdsci/jupyterlab:v0.9.0

# Install Jupyter, JupterLab, R & the IRkernel
# Packages and versions specificed in environment.yml
ADD environment.yml environment.yml
RUN conda env create -f environment.yml
# Activate conda environment on startup
RUN conda env create --force -f environment.yml
RUN echo "conda activate group8" >> ~/.profile
RUN Rscript -e 'install.packages("devtools");devtools::install_github("DSCI-310/DSCI-310-Group-8-package", force = TRUE)'
