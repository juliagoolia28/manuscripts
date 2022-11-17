from surfer import Brain, io, utils
import numpy as np
from scipy.stats import scoreatpercentile
import os
import math
import nipype.interfaces.fsl as fsl
import nipype.interfaces.freesurfer as fs

os.environ["SUBJECTS_DIR"] = "/freesurfer/kids"
datadir = "/MRIdata/subjects/"

save_view_names = ["lat"]

for surfsubj in ["BILDC3098", "BILDC3099", "BILDC3117", "BILDC3129", "BILDC3135", "BILDC3137", "BILDC3149", "BILDC3153", "BILDC3163", "BILDC3164", "BILDC3169", "BILDC3170", "BILDC3173"]:
	for hemi in ["lh","rh"]:
		for contrast in ["Parametric"]:#,"Parametric"]:
			brain = Brain(surfsubj,hemi,"inflated",config_opts={'cortex':'low_contrast','background':'white'})

			if contrast == "Task_Rest":
				peakval = 25
			else:
				peakval = 20

			# Read in the effect size and variance data
			eff = io.project_volume_data("%s/%s/fixedfx/fwhm_6.0/cope_%s.nii.gz"%(datadir,surfsubj,contrast),
				hemi,subject_id=surfsubj,smooth_fwhm=4.0,
				projmeth="dist",projsum="max",projarg=[-1.0,1.5,0.25],surf="white")

			brain.add_data(eff,min=peakval*-1,max=peakval,thresh=-1000,colormap="blue-red")

			brain.show_view("lat")
			brain.save_image("/gablab/p/BILD/data_kids/phono/MRIdata/subjects/figures/ASD/lat/%s_%s_%s.tiff"%(surfsubj,contrast,hemi))
			brain.close()
