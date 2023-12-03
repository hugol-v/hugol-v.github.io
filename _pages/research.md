---
#layout: archive
title: "Research"
permalink: /research/
author_profile: true
redirect_from:
  - /research.html
---

{% include base_path %}

> A system is deterministic only in the ways that it is explicitly prevented from being random -- Principle of maximum entropy

I have a broad interest in various subjects within the realm of high-dimensional probability, statistics, optimization, and random matrix theory. Below, I provide a concise overview of some tightly interconnected research areas that I have delved into.

## Random matrix theory

*How, and when, can we describe the asymptotic spectral information of random matrices? To what extent do random matrices depend on the distribution of their entries?*

Random matrix theory is one of my main research interests. I am interested in a wide range of topics within the field, including the study of spiked models and phase transitions, universality phenomena and the application of random matrix theory to data science. I have explored a multitude of techniques within the field, such as leave-one-out approaches, leveraging free operator-valued theory, utilizing concentration inequalities, and using Stein’s method.

Currently, my focus lies in extending the framework of the matrix Dyson equation to account for correlated linearizations, also known as pencils, of random matrices. The objective is to derive anisotropic global laws for the pseudo-resolvent of linearizations with general correlation structure.

 | <img src="/images/evol_spectrum.gif" width="100%"> |
 |:-------------:|
 | The empirical spectral distribution of a covariance matrix converges as the dimension of the matrix increases. We observe two distinct bulk in the high-dimensional limit, hinting at the structure of the underlying covariance matrix. |

## Machine learning

*Why do highly over-parametrized deep neural networks exhibit exceptional generalization capabilities? Are neural networks sensitive to the distribution of their inputs?*

I have found that random matrix theory offers valuable insights into studying the behavior of machine learning models and data science more generally. One avenue of exploration involves delving into the random features model. The random features model serves as a simplified model of two-layer neural networks, where we initialize the weights randomly and only train the second layer weights. Using the matrix Dyson equation, we can derive an explicit expression for the empirical test error of random feature ridge regression. This allows us to study phenomena such as the multiple descent phenomenon and implicit regularization. We can also establish a Gaussian equivalence theorem, which states that a random features model can be replaced by an equivalent Gaussian model with matching covariance.

| <img src="/images/random_features.gif" width="100%"> |
|:-------------:|
| We predict the empirical test error of random feature ridge regression as a function of the size of the hidden layer for different ridge parameter $\delta$. |

## Dynamics of training

*What the relation between properties of the data, such as its probability distribution and the presence of low-rank signals, and the behavior of optimization algorithm? What is the average-case complexity of optimization algorithm in the large-scale setting?*

Given the high-dimensional nature of machine learning problems, it becomes essential to analyze the average case complexity of the algorithms employed in training neural networks. This is because the worst-case complexity is not necessarily representative of the expected behavior of certain large-scale algorithms. Additionally, using random matrix theory, we can study the effect of the distribution of the input on the training dynamics and establish universality phenomena. Furthermore, we can analyze how well an algorithm can use hidden signals in the data to improve training. This type of analysis holds practical significance, as it assists in selecting appropriate hyperparameters and provides insights into the computational time required for real-life applications. I have explored these topics in the context of gradient descent applied to random linear and logistic regression problems.

| <img src="/images/halting_time.gif" width="100%"> |
|:-------------:|
| The halting time of gradient descent applied to a random linear regression problem becomes predictable as the dimension of the input and the number of samples increase linearly. We also observe a universality phenomenon: the halting time does not depend on the distribution of the input. |
