---
title: 'A Brief Introduction to Random Matrix Theory for Machine Learning -- Part 1: The Curse of Dimensionality'
date: 2022-08-26
permalink: /posts/2022/08/a-brief-introduction-to-random-matrix-theory-for-machine-learning-part-1/
tags:
  - Random Matrix Theory
  - Probability
  - High-dimensional
---

Modern machine learning models are now commonly trained on huge datasets where the number of samples is proportional to the dimension of the feature space. However,
traditional statistical tools such as the central limit theorem fail to capture the subtleties of such a high dimensional framework. This creates a disparity between theory in practice in machine learning.
We illustrate some of the traps caused by the so-called *curse of dimensionality*.

> *This blog series is inspired from the book “Random Matrix Methods for Machine Learning: When Theory Meets Applications” by Zhenyu Liao and Romain Couillet [[1]](#ref1).*

## Motivation
Modern machine learning (ML) models are often trained using a large set of samples in a high-dimensional feature space. 
In many applications, the dimension $d$ of the observations can be as large as the number $n$ of samples. 
While this “big-data boom” introduces unprecedented opportunities for ML applications, it comes with a price: traditional intuition which motivated standard ML algorithms 
can collapse when applied to high-dimensional problems.
This leaves an alarming gap between theory and practice in ML, which we illustrate by giving some examples below.

#### Overparametrization
Generally, data fitting methods heavily rely on some kind of bias-variance tradeoff. In this context, a model must be complex enough have the capacity of modeleling
the underlying *true* function, but *simple enough* to retain good generalization properties. While the precise meaning of simple/complex enough can be somewhat vague, 
one thing is certain: a model with as many parameter as we have observations is guaranteed to overfit. At least, that is what happens with, 
say, basic polynomial fitting (see [Figure 2](#fig2)) and it seems to coroborated by traditional statistics analysis...

| ![Illustration of Overparametrization](/images/intro-rmt-4-ml-part-1/overparametrization.gif) |
|:--:|
| *Figure 2: <a id="fig2"></a>* Least square polynomial fit with increasing degree. The base function (in <span style="color:blue">blue</span>) is $$p(x):= (x-0.75)^{3}-2\cdot (x-0.75)+ 1$$. The data points $$\{y_{i}\}_{i=1}^{20}$$ are noisy observations of the base functions, i.e. $$y_{i}=p(x_{i})+\epsilon_{i}$$ for white noise $$\epsilon_{i}\sim N(0,0.16)$$.|

Surprinsingly, it is common in deep learning to overparametrize neural networks [[2]](#ref2). This tendency can be attributed to a puzzling *double-descent* phenomenon, 
meaning that the performance of a model gets worse than gets better as we increase the number of parameters [[3]](#ref3). Empirically, multiple models 
have exhibited strong generalization properties while being vastly overparametrized [[4]](#ref4). The scaling behaviour of such models goes against 
traditional statistical analysis which indicates that this practice leads to overfitting.

#### Pre-training
It is now common to pre-train entire natural language processing (NLP) models [[5]](#ref5). 
The common intuition for pre-training is that it embeds the model with an underlying structure that reduces the effective dimension. 
Perhaps unintuitively, some study suggests that pre-trained models can have higher effective dimension but still generalize well due to 
an improved eigenalignment [[6]](#ref6).

#### Worst case complexity
Machine learning models are often trained my minimizing some objective function using an optimization algorithm. The standard algorithmic complexities obtained 
from worst-case scenarios can be uninformative, or even misleading, when considered in high-dimensional settings. A more informative concept is the average-case 
complexity that dictates the expected complexity. See [[7]](#ref7) for more information.

Those conundrums are due to the so-called *curse of dimensionality*.

## The Curse of Dimensionality
We place ourselves in the regime where $n \propto d$ are large and proportional. Asymptotically, we assume that
$n,d\rightarrow \infty$ with $\frac{d}{n}\rightarrow r\in\mathbb{R}_{>0}$. Under this framework, some aspects of fixed $d$
analysis fall victim to the traps caused by the curse of dimensionality. We give a couple examples.

### Example 1 : A die with many (many) sides
Let $$X_{i}\sim \mathcal{U}\{1,d\}$$ for all $$i\in \{1,...,n\}$$ represent $$n\in\mathbb{N}$$ rolling of a $$d$$ sided die. In most introductory to statistics course, we learn that the
empirical mean $$\overline{X}$$ of $$\{X_{i}\}_{i=1}^{n}$$ converges (in distribution) to a normally distributed random variable. In particular, by Lindeberg–Lévy CLT, we have that

$$
\overline{X} -\mathbb{E}X \xrightarrow[n\rightarrow \infty]{d} \mathcal{N}(0,n^{-1}\sqrt{\mathbb{V}X}).
$$

It is temping to say that, for large $n$, the empirical mean is concentrated around its mean. However, it is important to recall that $$\mathbb{V}X=\frac{d^{2}-1}{12}$$ actually 
depends on $$d$$ in such a was that $$\mathbb{V}X = \mathcal{O}(d)$$ is of competing order in our regime with $$d\propto n$$. This prevents the concentration of the empirical mean.

### Example 2 : Norm equivalence
It is well known that all norms defined on a finite-dimensional vector space are equivalent. In particular, for any tuple of norms $$\|\cdot\|_{a}$$ and $$\|\cdot\|_{b}$$
defined on $$\mathbb{C}^{d}$$, there exists two constants $$0<\underline{c}<\overline{c}<\infty$$ such that $$\underline{c}\|x\|_{a}\leq \|x\|_{b} \leq \overline{c}\|x\|_{a}$$ on 
$$\mathbb{C}^{d}$$. Consequently, convergence in any norm is equivalent.

Consider a collection of normally distributed random vector 
$$\{\mathbf{x}_{i}\}_{i=1}^{N} \subset \mathbb{R}^{d}$$ such that $$\mathbf{x}_{i}\stackrel{i.i.d.}{\sim}\mathcal{N}(\mathbf{0},\mathbf{I}_{d})$$ for all
$$i\in\{1,2,...,n\}$$. If the underlying distribution is hidden, we can form the *sample covariance matrix*

$$
\mathbf{C} = \frac{1}{n}\sum_{i=1}^{n}\mathbf{x}_{i} \mathbf{x}_{i}^{T}
$$

to estimate the true covariance matrix. 

By the strong law of large number and a simple concentration of measure
argument, it is clear that $$\|\mathbf{C}-\mathbf{I}_{d}\|_{\infty}\xrightarrow[n,d\rightarrow \infty]{a.s.} 0 $$ as long as $d$ is at most a polynomial function of $n$. 
However, $\mathbf{C}$ is the sum of $n$ rank-one matrices and therefore
has rank at most $n$. We must have $$\|\mathbf{C}-\mathbf{I}_{d}\|_{2} \not\xrightarrow[]{} 0 $$ as $n,d\rightarrow \infty$ with $r\in\mathbb{R}_{>1}$. 

How is that possible? Well, the constants $$\underline{c}$$ and $$\overline{c}$$ actually depend on $$d$$. In our case, the relation is $$\|\cdot\|_{2}\leq \sqrt{d}\|\cdot\|_{\infty}$$
(and in many cases $$\|\cdot\|_{2}\approx \sqrt{d}\|\cdot\|_{\infty}$$).

### Example 3 : Binary classification
Let's consider a toy binary classification setup: We are given 
- a set of samples $$\{\mathbf{x}_{i}\}_{i=1}^{n}\subset \mathbb{R}^{d}$$ with normally distributed $$\mathbf{x}_{i} \stackrel{i.i.d.}{\sim} \mathcal{N}(\frac{s_{i}\mu}{\sqrt{d}},\mathbf{I}_{d})$$;
- centered Bernoulli signals $$s_{i} \stackrel{i.i.d.}{\sim} 2 \cdot \mathrm{Bernoulli}\left(\frac{1}{2}\right)-1$$ and
- signal strength $$\mu$$. 

A visual representation of the resulting dataset for $$d=2$$ is given in [Figure 1](#fig1).
<a id="fig1"></a>


| ![Representation of clusters for $$d=2$$](/images/intro-rmt-4-ml-part-1/curse_dimensionality.png) |
|:--:|
| *Figure 1: Comparison of properties of the dateset $$\{x_{i}\}_{i=1}^{500}$$ where $$\mu=3$$ for $$d=2$$ (first row) and $$d=500$$ (second row). (Left): $$\left([x_{i}]_{1},[x_{i}]_{2}\right)_{i=1}^{n}$$; (Middle): $$\left(i,\frac{1}{d}x_{i}^{T} x_{i}\right)_{i=2}^{n}$$; (Right): $$\left(i,\frac{1}{d}\|x_{i}-x_{1}\|^{2}\right)_{i=2}^{n}$$. The color attributed to $$x_{i}$$ depends on the canonical class given by the signal $$s_{i}$$.* |

When $$d=2$$, the samples cluster around two distinct centroids. Therefore, samples belonging to the same class are
closer in the Euclidean sense and more align than samples from distinct classes. This can easily be verified, at least
in expectation, as

$$
\mathbb{E}\mathbf{x}_{i}^{T}\mathbf{x}_{j} = \mu^{2}s_{i}s_{j}
$$

and

$$
\mathbb{E}||\mathbf{x}_{i} -\mathbf{x}_{j}||^{2} = 2\left(d+\frac{\mu^{2}}{2}(s_{i}-s_{j})^{2}\right).
$$

for any $$i\neq j$$. Letting $$d$$ increase, the normalized inner product $$d^{-1}\mathbf{x}_{i}^{T}\mathbf{x}_{j}$$ and the normalized
difference $$d^{-1}\|\mathbf{x}_{i} -\mathbf{x}_{j}\|^{2}$$ both converges, in expectation, to constants that are surprinsingly *class
independent*. Can we still use classification algorithms such as logistic regression and $$k$$-means clustering? Yes,
but not because of traditional intuitive motivations based on sample-sample difference between functions of Euclidean
distance or inner products. Instead, we rely on small contributions throughout a large number of data to have an
accumulated effect.

## A Blessing in Disguise
To summarize, modern machine learning models can have as many, if not more, parameters than training samples. In these settings, the curse of dimensionality forces us to rethink some
concepts that we sometimes take for granted.

Fortnuately, we can use powerful tools from *random matrix theory* to analyze complex high-dimensional problem and maybe even bridge the aforementione gap between theory and practice in machine learning.

## References

<a id="ref6"></a>[[1]] Liao, Zhenyu, and Romain Couillet. “Random Matrix Methods for Machine Learning: When Theory Meets Applications,” August 20, 2021. https://zhenyu-liao.github.io/book/.

<a id="ref1"></a>[[2]] Chou, Hung-Hsu, Johannes Maly, and Holger Rauhut. “More Is Less: Inducing Sparsity via Overparameterization.” ArXiv:2112.11027, April 1, 2022. http://arxiv.org/abs/2112.11027.

<a id="ref2"></a>[[3]] Nakkiran, Preetum, Gal Kaplun, Yamini Bansal, Tristan Yang, Boaz Barak, and Ilya Sutskever. “Deep Double Descent: Where Bigger Models and More Data Hurt.” ArXiv:1912.02292 [Cs, Stat], December 4, 2019. http://arxiv.org/abs/1912.02292.

<a id="ref3"></a>[[4]] Zhang, Chiyuan, Samy Bengio, Moritz Hardt, Benjamin Recht, and Oriol Vinyals. “Understanding Deep Learning Requires Rethinking Generalization.” ArXiv:1611.03530 [Cs], February 26, 2017. http://arxiv.org/abs/1611.03530.

<a id="ref4"></a>[[5]] Wang, Sinong, Madian Khabsa, and Hao Ma. “To Pretrain or Not to Pretrain: Examining the Benefits of Pretraining on Resource Rich Tasks.” ArXiv:2006.08671 [Cs, Stat], June 15, 2020. http://arxiv.org/abs/2006.08671.

<a id="ref5"></a>[[6]] Wei, Alexander, Wei Hu, and Jacob Steinhardt. “More Than a Toy: Random Matrix Models Predict How Real-World Neural Representations Generalize.” ArXiv:2203.06176 [Cs, Stat], March 11, 2022. http://arxiv.org/abs/2203.06176.

<a id="ref6"></a>[[7]] Paquette, Courtney, Bart van Merriënboer, Elliot Paquette, and Fabian Pedregosa. “Halting Time Is Predictable for Large Models: A Universality Property and Average-Case Analysis.” ArXiv:2006.04299 [Math, Stat], October 2, 2021. http://arxiv.org/abs/2006.04299.


[1]: Chou, Hung-Hsu, Johannes Maly, and Holger Rauhut. “More Is Less: Inducing Sparsity via Overparameterization.” ArXiv:2112.11027, April 1, 2022. http://arxiv.org/abs/2112.11027.

[2]: Craven, Peter, and Grace Wahba. “Smoothing Noisy Data with Spline Functions.” Numerische Mathematik 31, no. 4 (December 1, 1978): 377–403. https://doi.org/10.1007/BF01404567.

[3]: Golub, Gene H., Michael Heath, and Grace Wahba. “Generalized Cross-Validation as a Method for Choosing a Good Ridge Parameter.” Technometrics 21, no. 2 (1979): 215–23. https://doi.org/10.2307/1268518.

[4]: Liao, Zhenyu, and Romain Couillet. “Random Matrix Methods for Machine Learning: When Theory Meets Applications,” August 20, 2021. https://zhenyu-liao.github.io/book/.

[5]: ———. “The Dynamics of Learning: A Random Matrix Approach.” ArXiv:1805.11917 [Cs, Stat], July 20, 2018. http://arxiv.org/abs/1805.11917.

[6]: Liao, Zhenyu, and Michael W. Mahoney. “Hessian Eigenspectra of More Realistic Nonlinear Models.” ArXiv:2103.01519 [Cs, Math, Stat], March 16, 2021. http://arxiv.org/abs/2103.01519.

[7]: Louart, Cosme, Zhenyu Liao, and Romain Couillet. “A Random Matrix Approach to Neural Networks.” ArXiv:1702.05419 [Cs, Math], June 29, 2017. http://arxiv.org/abs/1702.05419.

[8]: Marčenko, V.A., and Leonid Pastur. “Distribution of Eigenvalues for Some Sets of Random Matrices.” Math USSR Sb 1 (January 1, 1967): 457–83.

[9]: Mei, Song, Theodor Misiakiewicz, and Andrea Montanari. “Generalization Error of Random Features and Kernel Methods: Hypercontractivity and Kernel Matrix Concentration.” ArXiv:2101.10588 [Math, Stat], January 26, 2021. http://arxiv.org/abs/2101.10588.

[10]: Nakkiran, Preetum, Gal Kaplun, Yamini Bansal, Tristan Yang, Boaz Barak, and Ilya Sutskever. “Deep Double Descent: Where Bigger Models and More Data Hurt.” ArXiv:1912.02292 [Cs, Stat], December 4, 2019. http://arxiv.org/abs/1912.02292.

[11]: Paquette, Courtney, Kiwon Lee, Fabian Pedregosa, and Elliot Paquette. “SGD in the Large: Average-Case Analysis, Asymptotics, and Stepsize Criticality.” ArXiv:2102.04396 [Cs, Math, Stat], February 8, 2021. http://arxiv.org/abs/2102.04396.

[12]: Paquette, Courtney, Bart van Merriënboer, Elliot Paquette, and Fabian Pedregosa. “Halting Time Is Predictable for Large Models: A Universality Property and Average-Case Analysis.” ArXiv:2006.04299 [Math, Stat], October 2, 2021. http://arxiv.org/abs/2006.04299.

[13]: Raffel, Colin, Noam Shazeer, Adam Roberts, Katherine Lee, Sharan Narang, Michael Matena, Yanqi Zhou, Wei Li, and Peter J. Liu. “Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer.” ArXiv:1910.10683 [Cs, Stat], July 28, 2020. http://arxiv.org/abs/1910.10683.

[14]: Wang, Sinong, Madian Khabsa, and Hao Ma. “To Pretrain or Not to Pretrain: Examining the Benefits of Pretraining on Resource Rich Tasks.” ArXiv:2006.08671 [Cs, Stat], June 15, 2020. http://arxiv.org/abs/2006.08671.

[15]: Wei, Alexander, Wei Hu, and Jacob Steinhardt. “More Than a Toy: Random Matrix Models Predict How Real-World Neural Representations Generalize.” ArXiv:2203.06176 [Cs, Stat], March 11, 2022. http://arxiv.org/abs/2203.06176.

[16]: Wigner, Eugene P. “On the Distribution of the Roots of Certain Symmetric Matrices.” Annals of Mathematics 67, no. 2 (1958): 325–27. https://doi.org/10.2307/1970008.

[17]: Zhang, Chiyuan, Samy Bengio, Moritz Hardt, Benjamin Recht, and Oriol Vinyals. “Understanding Deep Learning Requires Rethinking Generalization.” ArXiv:1611.03530 [Cs], February 26, 2017. http://arxiv.org/abs/1611.03530.
