# Numpy is the numerical library dadi is built upon

import numpy
from numpy import array

import matplotlib
matplotlib.use("AGG")

import sys
sys.path.append('/proj/b2012209/private/tools/dadi/RyanGutenkunst-dadi-e741dc81ff1e')

import dadi
# In demographic_models.py, we've defined a custom model for this problem
import demographics1pop



#from a frequency spectrum file
fs = dadi.Spectrum.from_file(sys.argv[1])
print fs
fs = fs.fold()
print fs
# Define sample size (list)
ns = fs.sample_sizes
print ns

# Define grid size
pts_l = [50,60,70]

func = demographics1pop.growth 
params = array([1, 1])
upper_bound = [100, 20]
lower_bound = [0.0001,0.0001]

func_ex = dadi.Numerics.make_extrap_log_func(func)
model = func_ex(params, ns, pts_l)
ll_model = dadi.Inference.ll_multinom(model, fs)
print 'Model log-likelihood:', ll_model
theta = dadi.Inference.optimal_sfs_scaling(model, fs)
p0 = dadi.Misc.perturb_params(params, fold=1, upper_bound=upper_bound)
popt = dadi.Inference.optimize_log(p0, fs, func_ex, pts_l, 
                                   lower_bound=lower_bound,
                                   upper_bound=upper_bound,
                                   verbose=len(params),
                                   maxiter=None)
print 'Optimized parameters', repr(popt)
model = func_ex(popt, ns, pts_l)
ll_opt = dadi.Inference.ll_multinom(model, fs)
print 'Optimized log-likelihood:', ll_opt


bootstraps = []
for ii in range(100):
    print ii
    bootstrap_data = fs.sample()
    popt = dadi.Inference.optimize_log(p0, bootstrap_data, func_ex, pts_l, 
                                   lower_bound=lower_bound,
                                   upper_bound=upper_bound,
                                   verbose=len(params),
                                   maxiter=None)
    print 'Optimized parameters', repr(popt)
    model = func_ex(popt, ns, pts_l)
    ll = dadi.Inference.ll_multinom(model, bootstrap_data)
    print 'Optimized log-likelihood:', ll
    theta = dadi.Inference.optimal_sfs_scaling(model, bootstrap_data)
    model *= theta
    bootstraps.append([ll, theta, popt[0], popt[1]])
bootstraps = numpy.array(bootstraps)
numpy.savetxt('1Dboots.npy', bootstraps)
bootstraps = numpy.loadtxt('1Dboots.npy')

sigma_boot = numpy.std(bootstraps, axis=0)[1:]

print 'Bootstrap uncertainties:', sigma_boot



