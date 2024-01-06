"""
https://github.com/pholme/gnd

"""
import copy
from sys import argv, stderr
import networkx as nx
from networkx.algorithms.approximation import min_weighted_vertex_cover
from scipy.sparse.linalg import eigsh
from scipy.sparse.linalg.eigen.arpack.arpack import ArpackNoConvergence
from scipy.sparse import diags
import numpy as np
from numpy.random import shuffle
import os
from src.reinsertion import reinsertion, get_gcc



def GNDR(Graph:nx, dismantling_threshold=0.01, cost_type='unit'):
    cost_sum = 0
    remove_list = []
    cost_list = []
    gcc_list = []
    G = copy.deepcopy(Graph) #确保不会修改原始图中的内容
    target_size = int(dismantling_threshold * G.number_of_nodes())
    if target_size <= 1:
        target_size = 2


    while get_gcc(G) >= target_size:
        # 步骤1. === 构造最大连通组件 (LCC) 的谱划分 ===
        LCC = G.subgraph(max(nx.connected_components(G), key=len))  # 获取最大连通组件
        ii = {v: i for i, v in enumerate(list(LCC.nodes()))}  # 存储节点索引，与LCC中的顺序相同

        # 构造矩阵，符号遵循论文中的表示方法（我们直接通过求解器计算第二小的特征对应的特征向量，
        # 而不是按照论文中所述手动移动特征值并计算第二大的特征向量）
        if cost_type == 'degree':
            W = diags([d for v, d in LCC.degree()], dtype=np.int32)
            A = nx.adjacency_matrix(LCC)
            B = A * W + W * A - A
            DB = diags(np.squeeze(np.asarray(B.sum(axis=1))), dtype=np.int32)
            L = DB - B
        else:
            L = nx.laplacian_matrix(LCC)

        # 获取特征向量
        maxiter = 1000 * L.shape[0]  # 放弃的迭代次数，比默认值大100倍
        try:
            eigenvalues, eigenvectors = eigsh(L.astype(np.float32), k=2, which='SM', maxiter=maxiter)
        except ArpackNoConvergence as err:
            print(err, file=stderr)
            exit(1)

        Fiedler = eigenvectors[:, 1]  # 实际上并非Fiedler向量，但对应于Fiedler向量

        # 步骤2. === 构造边界分区的子图 ===
        H = nx.Graph()
        for u, v in LCC.edges():
            # 添加连接具有不同符号的节点的边。（注意，只有 < （而不是 <=）会错误地将对称图中类似1-2-3中的2节点归类错误。）
            if Fiedler[ii[u]] * Fiedler[ii[v]] <= 0.0:
                H.add_edge(u, v)

        # 步骤3. === 构造相对于G中的度和H中的度的最小顶点覆盖 ===
        for v in H.nodes():  # 计算权重
            H.nodes[v]['weight'] = 1.0 / H.degree(v)
            if cost_type == 'degree':
                H.nodes[v]['weight'] *= LCC.degree(v)

        cover = list(min_weighted_vertex_cover(H, weight='weight'))  # 获取顶点覆盖
        # shuffle(cover)  # 打乱顺序以消除对输入的依赖

        # 取消注释以下行以按照原始代码而非论文中的方式排序：
        if cost_type == 'degree':
            cover.sort(key=LCC.degree())
        else:
            cover.sort(key=LCC.degree(), reverse=True)

        # 步骤4. === 删除覆盖节点 ===
        for v in cover:
            if cost_type == 'degree':
                cost_sum += G.degree(v)
            else:
                cost_sum += 1
            G.remove_node(v)
            remove_list.append(v)
            cost_list.append(cost_sum)
            gcc_list.append(get_gcc(G))

    return remove_list, gcc_list, cost_list

#  ======================================================================================================
if __name__ == "__main__":
    # 读取输入参数
    # if len(argv) != 3:
    #     print('usage: python gnd.py [adj file] [weight (degree or unit)]')
    #     exit(1)
    # print(len(argv))
    netname = 'Crime'
    dismantling_threshold = 0.01
    path = os.path.join('..', 'results', netname)
    cost_type = 'unit'
    assert cost_type in ['unit','degree'], 'cost_type should be unit or degree'
    assert dismantling_threshold < 1.0

    edges = np.loadtxt(os.path.join(path, 'edges.txt'), delimiter=' ', dtype=int)  # 边列表
    G = nx.Graph()
    G.add_edges_from(edges)

    print("Processing ", netname)
    remove_list, gcc_list, cost_list = GNDR(G, dismantling_threshold=0.01, cost_type='unit')
    print("Number of attacked nodes:", len(remove_list))

    reinsertion(G, remove_list, dismantling_threshold, metric='GNDR', rel_path=path)





