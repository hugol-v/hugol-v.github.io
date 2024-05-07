---
layout: page
title: Dynamics of training
description:
img: assets/img/halting_time.gif
importance: 1
related_publications: false
---

*What the relation between properties of the data, such as its probability distribution and the presence of low-rank signals, and the behavior of optimization algorithm? What is the average-case complexity of optimization algorithm in the large-scale setting?*

Given the high-dimensional nature of machine learning problems, it becomes essential to analyze the average case complexity of the algorithms employed in training neural networks. This is because the worst-case complexity is not necessarily representative of the expected behavior of certain large-scale algorithms. Additionally, using random matrix theory, we can study the effect of the distribution of the input on the training dynamics and establish universality phenomena. Furthermore, we can analyze how well an algorithm can use hidden signals in the data to improve training. This type of analysis holds practical significance, as it assists in selecting appropriate hyperparameters and provides insights into the computational time required for real-life applications. I have explored these topics in the context of gradient descent applied to random linear and logistic regression problems.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/halting_time.gif" title="Halting time of large-scale gradient descent" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    The halting time of gradient descent applied to a random linear regression problem becomes predictable as the dimension of the input and the number of samples increase linearly. We also observe a universality phenomenon: the halting time does not depend on the distribution of the input.
</div>