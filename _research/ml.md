---
layout: page
title: Theory of machine learning
description:
img: assets/img/random_features.gif
importance: 1
related_publications: false
---

*Why do highly over-parametrized deep neural networks exhibit exceptional generalization capabilities? Are neural networks sensitive to the distribution of their inputs?*

Machine learning and data science provide a rich source of questions that can be studied with tools from random matrix theory, high-dimensional probability, and statistics. Simplified or "toy" models (such as kernel methods, random features, and other tractable surrogates of neural networks) offer a way to isolate key mechanisms behind generalization, optimization, and representation learning. These perspectives have clarified both the strengths and limitations of kernel-like models, highlighted the central role of feature learning, and revealed many surprising (and not so surprising) high-dimensional phenomena. At the same time, much remains poorly understood, making this an active area for developing new mathematical ideas.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/random_features.gif" title="Empirical test error of random features ridge regression" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">We predict the empirical test error of random feature ridge regression as a function of the size of the hidden layer for different ridge parameter &delta;.</div>