#!/bin/bash
#SBATCH --job-name=cellVTpp_test       # Job name
#SBATCH --ntasks=1                    # Number of tasks
#SBATCH --gpus=2                      # Number of GPUs
#SBATCH --cpus-per-task=24            # CPUs per task
#SBATCH --partition=GPUampere         # Partition to use

# Define paths for clarity and reuse
MODEL_DIR="/homes/psgudla/PARA/AREAS/Models/CellViT-plus-plus"
SLIDES_DIR="/projects/conco/gundla/root/Glioma_CLAM/rawdata/slides_40x"
SIF_PATH="/homes/psgudla/PARA/AREAS/Models/CellViT-plus-plus/cellvitpp.sif"
WSI_PATH="TCGA-02-0003-01Z-00-DX3.svs"
OUTPUT_DIR="/mnt/scripts/output_preprocess/"
LOG_DIR="/homes/psgudla/PARA/AREAS/Models/CellViT-plus-plus/logs_local/"
OUTPUT_FILE="${LOG_DIR}/example3_testrun_out.log"
ERROR_FILE="${LOG_DIR}/example3_testrun_err.log"
# Run the command using Apptainer
apptainer exec \
    --nv \
    --bind "${MODEL_DIR}":/mnt/scripts/ \
    --bind "${SLIDES_DIR}":/mnt/slides/ \
    "${SIF_PATH}" python /mnt/scripts/cellvit/detect_cells.py \
        --model '/mnt/scripts/checkpoints/classifier/SAM/CellViT-SAM-H-x40-AMP.pth' \
        --outdir '${OUTPUT_DIR}' \
        --geojson \
        --compression \
        --graph process_wsi \
        --wsi_path '/mnt/slides/${WSI_PATH}'
    " >> "${OUTPUT_FILE}" 2>> "${ERROR_FILE}"