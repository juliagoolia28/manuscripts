from surfer import Brain, io, utils
import numpy as np
import scipy
from scipy import misc
from scipy.stats import scoreatpercentile
import os
import math
import nipype.interfaces.fsl as fsl
import nipype.interfaces.freesurfer as fs

os.environ["SUBJECTS_DIR"] = "/mindhive/xnat/surfaces/CASL"
# try fslaverage brain as the background
datadir = "/gablab/p/CASL/Results/Imaging/tone/groups"

save_view_names = ["lat"]

#for surfsubj in ["SLI3039","SLI3046","SLI3063","SLI3065","SLI3071","SLI3072", "SLI3075","SLI3081","SLI3084","BILDC3130"]:
# change the inflation options
for hemi in ["lh","rh"]:
	for contrast in ["Spe-v-Wav"]:
		brain = Brain("MNI_152_T1_1mm",hemi,"inflated",config_opts={'cortex':'classic','background':'white'})
		peakval = .01 #1.959 1.645,2.326
		#if contrast == "Task_Rest":
		#	peakval = 2.57
		#else:
		#	peakval = 2.57

		# Read in the effect size and variance data
        #sig1 = io.read_scalar_data("%s/preprespe/%s/corrected_voxp1.959_fdr0.05/zstat1_threshold-%s.mgz"%(datadir,contrast,hemi))
        #sig2 = io.read_scalar_data("%s/prefinalhsk/%s/corrected_voxp1.959_fdr0.05/zstat1_threshold-%s.mgz"%(datadir,contrast,hemi))

        sig1 = io.project_volume_data("%s/preprespe/%s/corrected_voxp1.959_fdr0.05/zstat1_cluster_corrected.nii.gz"%(datadir,contrast),
			hemi,subject_id="MNI_152_T1_1mm",smooth_fwhm=3.0,
			projmeth="frac",projsum="max",projarg=[-1.0,1.5,0.25],surf="pial")
        sig2 = io.project_volume_data("%s/pre3mohsk/%s/corrected_voxp1.959_fdr0.05/zstat1_cluster_corrected.nii.gz"%(datadir,contrast),
			hemi,subject_id="MNI_152_T1_1mm",smooth_fwhm=3.0,
			projmeth="frac",projsum="max",projarg=[-1.0,1.5,0.25],surf="pial")
        conjunct = np.min(np.vstack((sig1, sig2)), axis=0)
        brain.add_overlay(sig1,min=peakval,max=7,name="sig1")
        brain.overlays["sig1"].pos_bar.lut_mode = "autumn"
        brain.overlays["sig1"].pos_bar.visible = False

        brain.add_overlay(sig2,min=peakval,max=7,name="sig2")
        brain.overlays["sig2"].pos_bar.lut_mode = "Reds"
        brain.overlays["sig2"].pos_bar.visible = False
        #brain.show_view({'azimuth':135, 'elevation': 75})
        brain.add_overlay(conjunct,min=peakval,max=7,name="conjunct")
        brain.overlays["conjunct"].pos_bar.lut_mode = "Greens"
        brain.overlays["conjunct"].pos_bar.visible = False
        brain.show_view("lat")

        brain.save_image("/gablab/p/CASL/Results/Imaging/tone/groups/conjunction/%s_%s_%s_pial_test.tiff"%(contrast,hemi,peakval))
        brain.close()
