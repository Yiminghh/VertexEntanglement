# Identifying key players in complex networks through network entanglement

Yiming Huang, Hao Wang, Xiao-Long Ren, Linyuan Lü. Identifying key players in complex networks through network entanglement. Communications Physics (2024).

<p align="center">
  <img src=".\VertexEnt.png" width="700">
</p>

This paper proposed an entanglement-based metric - vertex entanglement (VE) - quantifying local perturbations on spectral entropy, with superior applications in network dismantling and brain network analysis.




# Repo Contents

1. data
2. src: source code of VE
   - **VE.py**: python version implementation
   - VE.m: matlab version implementation
   - reinsertion.py 
   - GNDR.py: The original GNDR code is not in Python, and it is not adapted for non-connected graphs. We provide a Python version of the GNDR algorithm. 
3. utils: basic utils used in the src code


# Basebline methods implementation
We used the source codes released online, and adopted the best parameter settings provided by authors (if available) for each method.
```
https://github.com/zhfkt/ComplexCi (CI)
https://github.com/abraunst/decycler (MinSum)
http://power.itp.ac.cn/~zhouhj/codes.html (BPD)
https://github.com/hcmidt/corehd (CoreHD)
https://github.com/renxiaolong/Generalized-Network-Dismantling (GNDR)
```

# Reference

Please cite our work if you find our code/paper is useful to your work:
```latex
@article{VE2024Huang,
  title={Identifying key players in complex networks through network entanglement},
  author={Huang, Yiming and Wang, Hao and Ren, Xiao-Long and L{\"u}, Linyuan},
  journal={Communications Physics},
  doi={10.1038/s42005-023-01483-8},
  year={2024}
}
```






