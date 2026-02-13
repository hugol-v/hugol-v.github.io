---
layout: page
title: Complexity of learning
description:
img: assets/img/multi_index_harmonic.gif
importance: 1
related_publications: false
---

*When, and why, can we efficiently learn in high dimensions? What structural properties of data make learning computationally feasible?*

Modern data is often high-dimensional: language models work over massive vocabularies, and biological systems involve thousands of interacting components. Yet learning in these settings can be surprisingly effective. A possible explanation is the presence of latent low-dimensional structure. Although the ambient dimension is large, the true complexity of the data is often governed by hidden structure that lives in an essentially much smaller space. Exploiting this structure is key to efficient learning.

I am interested in understanding when such models can be learned efficiently. A recurring theme is the statistical–computational tradeoff: some problems are learnable in principle, but no efficient algorithm achieves the optimal rates. Frameworks such as statistical query (SQ) and low-degree polynomial (LDP) methods help formalize these limitations, while algorithmic work aims to match (or nearly match) these bounds.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/multi_index_harmonic.gif" title="Halting time of large-scale gradient descent" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
Heat map illustrating subspace recovery in a parity multi-index model. The first two rows correspond to the hidden orthonormal directions generating the signal. The last two rows show the basis recovered by harmonic tensor unfolding as the number of samples increases. As more data becomes available, the recovered subspace progressively aligns with the true latent structure.
</div>
