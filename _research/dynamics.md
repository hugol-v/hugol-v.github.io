---
layout: page
title: Dynamics of training
description:
img: assets/img/halting_time.gif
importance: 4
related_publications: false
---

*What the relation between properties of the data, such as its probability distribution and the presence of low-rank signals, and the behavior of optimization algorithm? What is the average-case complexity of optimization algorithm in the large-scale setting?*

In high-dimensional learning problems, optimization algorithms exhibit rich and sometimes unexpected behaviors. The interaction between data distribution, noise, and low-rank structure can strongly shape training trajectories, and random matrix methods help reveal universality phenomena that persist across models. For large problems, worst-case complexity often fails to capture typical behavior, and average-case analyses provide more relevant insight, especially when universality makes performance largely independent of fine distributional details. Beyond finding a minimizer, training can introduce inductive biases that improve generalization in over-parameterized models, and learning may unfold in a stage-wise or "staircase" manner, with relevant directions discovered sequentially.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/halting_time.gif" title="Halting time of large-scale gradient descent" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    The halting time of gradient descent applied to a random linear regression problem becomes predictable as the dimension of the input and the number of samples increase linearly. We also observe a universality phenomenon: the halting time does not depend on the distribution of the input.
</div>