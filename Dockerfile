FROM quay.io/jupyter/minimal-notebook:latest

USER root

# Update the base container and install required packages
RUN apt-get update && apt-get install -y wget

# Check if Miniconda is already installed; if not, install it
RUN if [ ! -d "/opt/conda" ]; then \
      wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh && \
      bash /opt/miniconda.sh -b -p /opt/conda && \
      rm /opt/miniconda.sh; \
    fi

# Update Conda and install additional JupyterLab packages
RUN /opt/conda/bin/conda update -n base -c defaults conda && \
    /opt/conda/bin/conda install -c conda-forge jupyterlab ipywidgets

# Add conda to the PATH environment variable
ENV PATH /opt/conda/bin:$PATH

# Copy and set permissions for the startup script
COPY start-notebook.sh /usr/local/bin/start-notebook.sh
RUN chmod +x /usr/local/bin/start-notebook.sh

# Expose Jupyter port
EXPOSE 8888

# Set the startup command to launch JupyterLab
CMD ["/bin/bash", "-c", "source /opt/conda/bin/activate && nohup jupyter notebook --ip=0.0.0.0 --allow-root"]
