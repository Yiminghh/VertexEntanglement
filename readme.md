# Identifying key players in complex networks through network entanglement

[Yiming Huang](https://yiminghh.github.io/), 
[Hao Wang](https://scholar.google.com/citations?user=Mfj5te4AAAAJ&hl=zh-CN), 
[Xiao-Long Ren](https://github.com/renxiaolong), 
[Linyuan Lü](https://linyuanlab.com/). Identifying key players in complex networks through network entanglement. Communications Physics (2024).

<p align="center">
  <img src=".\VertexEnt.png" width="700">
</p>

This paper proposed an entanglement-based metric - vertex entanglement (VE) - quantifying local perturbations on spectral entropy, with superior applications in network dismantling and brain network analysis.




# Repo Contents

1. data
   - please put your dataset in the following directory `'./data/{data_name}/edges.txt'`
2. src: source code of VE
   - **VE.py: python version implementation of our algorithm**
   - reinsertion.py:  this algorithm can reinsert nodes that 
   - GNDR.py: The original GNDR code is not in Python, and it is not adapted for non-connected graphs. We provide a Python version of the GNDR algorithm. 
3. utils: basic utils used in the src code


# Reproduce results

 Run `VE.py` directly to reproduce the dismantling results in our paper.

- The resulting list of moving nodes is given in `'./results/{data_name}/VER_nodelist.txt'`
- The resulting GCC change list corresponding to the given removing nodes list is reported in `'./results/{data_name}/VER_gcc.txt'`
- Change `netname` to conduct experiments for different datasets. Note that your dataset should put the edge list in the following directory `'./data/{data_name}/edges.txt'`


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
  title = {Identifying key players in complex networks via network entanglement},  
  author={Huang, Yiming and Wang, Hao and Ren, Xiao-Long and L{\"u}, Linyuan},
  journal = {Communications Physics},  
  year = {2024},  
  volume = {7},  
  number = {1},  
  pages = {19},  
  issn = {2399-3650},  
  url = {https://doi.org/10.1038/s42005-023-01483-8},  
  doi = {10.1038/s42005-023-01483-8},  
}
```






