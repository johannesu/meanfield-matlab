A MATLAB wrapper for solving DenseCRF problems [1,2]. 
The code uses the c++ library provided with [2].

How to use?
---

* For solving a general problem see examples/example.m.

* For segmentation on the MSRC-21 database using the unary potentials from [http://graphics.stanford.edu/projects/densecrf/unary/](http://graphics.stanford.edu/projects/densecrf/unary/) see examples/example_MSRC.m

![Image and result](screenshot/screenshot.png)
Included solvers
--
* Meanfield [2].
* TRWS-S [3].
* MATLAB implementation of meanfield (very slow).


References
-----
1. __Efficient Inference in Fully Connected CRFs with Gaussian Edge Potentials__.
NIPS 2011.
_Philipp Krähenbühl and Vladlen Koltun_.

2. __Parameter Learning and Convergent Inference for Dense Random Fields__.
ICML 2013.
_Philipp Krähenbühl and Vladlen Koltun_.

3. __Convergent Tree-reweighted Message Passing for Energy Minimization__.
IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI) 2006.  
_Vladimir Kolmogorov_.