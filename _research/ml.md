---
layout: page
title: Theory of machine learning
description:
img: assets/img/random_features.gif
importance: 1
related_publications: false
---

_Why do highly over-parametrized deep neural networks exhibit exceptional generalization capabilities? Are neural networks sensitive to the distribution of their inputs?_

I have found that random matrix theory offers valuable insights into studying the behavior of machine learning models and data science more generally. One avenue of exploration involves delving into the random features model. The random features model serves as a simplified model of two-layer neural networks, where we initialize the weights randomly and only train the second layer weights. Using the matrix Dyson equation, we can derive an explicit expression for the empirical test error of random feature ridge regression. This allows us to study phenomena such as the multiple descent phenomenon and implicit regularization. We can also establish a Gaussian equivalence theorem, which states that a random features model can be replaced by an equivalent Gaussian model with matching covariance. $$\delta$$

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/random_features.gif" title="Empirical test error of random features ridge regression" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">We predict the empirical test error of random feature ridge regression as a function of the size of the hidden layer for different ridge parameter &delta;.</div>
