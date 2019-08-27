#!/bin/bash
#SBATCH --account=rpp-kenclark
#SBATCH --time=4:00:00
#SBATCH --mem=1200M
module load matlab/2018a
srun matlab -nodisplay -singleCompThread -r "doublepeak"

