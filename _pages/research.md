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

I have a broad interest in various subjects within the realm of high-dimensional probability, statistics, optimization, and random matrix theory. I thrive on exploring new problems and generating innovative ideas. Below, I provide a concise overview of some tightly interconnected research areas that I have delved into.

## Random matrix theory
*How, and when, can we describe the asymptotic spectral information of random matrices? To what extent do random matrices depend on the distribution of their entries?* These fundamental questions form the core of my research interests in random matrix theory.
In my pursuit of answers, I have explored a multitude of techniques within the field. From leveraging free operator-valued theory to utilizing concentration inequalities, I have employed various tools to address these inquiries.
Currently, my focus lies in extending the framework of the matrix Dyson equation to account for linearizations, also known as pencils, of random matrices.

 | <img src="/images/evol_spectrum.gif" width="100%"> | 
 |:-------------:|
 | The empirical spectral distribution of a covariance matrix converges as the dimension of the matrix increases. We observe two distinct bulk in the high-dimensional limit, hinting at the structure of the underlying covariance matrix. |

## Machine learning
*Why do highly over-parametrized deep neural networks exhibit exceptional generalization capabilities?* This intriguing phenomenon has piqued my interest, and I have found that random matrix theory offers valuable insights into studying the behavior of machine learning models.
One avenue of exploration involves delving into the random feature model, which serves as a useful framework for explaining empirically observed phenomena, such as the intriguing double descent phenomenon. By analyzing this simplified model, we aim to uncover the distinctive characteristics that make deep neural networks excel in their performance.
In particular, the study of the neural tangent kernel and the conjugate kernel presents fascinating opportunities for investigation.

## Dynamics of training
*How do the algorithms used to train large neural networks converge to good solutions, even when dealing with non-convex and occasionally non-smooth loss functions? Additionally, what is the typical convergence rate of stochastic gradient descent on such problem?* Given the high-dimensional nature of machine learning problems, it becomes essential to analyze the average case complexity of the algorithms employed in training neural networks.
In my research, I sought to uncover how the presence of spikes impacts the training dynamics and the resulting performance of the trained model by studying a simplified spiked linear regression model trained using gradient descent. I derived an asymptotic characterization of the loss function and demonstrated that the halting time can be predicted as the dimension of the input and the number of samples grow linearly. This type of analysis holds practical significance, as it assists in selecting appropriate hyperparameters and provides insights into the computational time required for real-life applications. Indeed, many real datasets have been observed to have a spiked spectrum.

I also delved into a related problem involving logistic regression, where the presence of non-linearity introduces more intriguing dynamics while simultaneously adding complexity to the analysis.

| <img src="/images/halting_time.gif" width="100%"> |
|:-------------:|
| The halting time of gradient descent applied to a random linear regression problem becomes predictable as the dimension of the input and the number of samples increases linearly. We also observe a universality phenomenon: the halting time does not depend on the distribution of the input. |



