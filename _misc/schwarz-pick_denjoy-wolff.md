---
layout: page
title: "Note to self: Upper Half-Plane Fixed Point Theorems"
description: Notes on versions of the Schwarz–Pick Lemma, Denjoy–Wolff Theorem and Complex Implicit Function Theorem in the upper half-plane, with a focus on their relevance to deterministic equivalents in random matrix theory.
importance: 1
related_publications: false
---

- Add image of equation in header
- Add description of file
- Add section numbers
- Add plot

### Motivation

---

If you've spent any time with random matrix theory like I have recently you will almost certainly run into something called a *deterministic equivalent*. These often show up as functions mapping the upper half of the complex plane $$\mathbb{H}$$ into itself that solve some fixed-point equation.

To give a concrete example, suppose we take a random matrix of the form $$X = C^{1/2} Z$$, where:

- $$C \in \mathbb{R}^{p \times p}$$ is a deterministic positive semidefinite matrix with bounded operator norm,
- $$Z \in \mathbb{R}^{p \times n}$$ has independent, zero-mean, unit-variance entries, and satisfies some mild moment conditions (typically something like bounded fourth moment or sub-Gaussian tails).

We can define the *Stieltje transform* of the empirical spectral distribution of the eigenvalues of $$\frac{1}{n} XX^\top$$ as

$$
s_n(z) = \frac{1}{p} \mathrm{tr}\left(\left(\frac{1}{n}XX^\top - zI\right)^{-1}\right) = \frac{1}{p} \sum_{i=1}^p \frac{1}{\lambda_i - z},
$$

where $$z \in \mathbb{H}$$ is a *spectral parameter*, and $$\lambda_i$$ are the eigenvalues of $$\frac{1}{n}XX^\top$$.

It is a well known results that in the so-called *thermodynamic limit* (when both $$p, n \to \infty$$ and $$p/n \to c$$ for some constant $$c > 0$$) that $$s_n(z)$$ is asymptotically well approximated by a deterministic function $$s(z)$$ which takes the form (see Silverstein and Bai[^silverstein] for a classical reference)

$$
s(z) = -\frac{1}{p} \mathrm{tr}\left((C m(z) + zI)^{-1}\right),
$$

where $$m(z):\mathbb{H}\mapsto \mathbb{H}$$ uniquely solves the fixed-point equation

$$
m(z) = -\frac{1}{1 + \frac{1}{p} \mathrm{tr}\left(C (C m(z) + zI)^{-1}\right)}.
$$

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/det_equiv_conv.png" title="Empirical test error of random features ridge regression" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">The Stieltje transform \(s_n(z)\), with \(X\) a matrix with i.i.d. standard Gaussian entries, concentrates around the deterministic equivalent \(s(z)\) as \(n \to \infty\) with \(n/p = 1/2\).</div>

This deterministic function $$m(z)$$ is a key object since it lets us describe the limiting behavior of the spectrum and other spectral quantities of interest. However, $$m(z)$$ generally cannot be written in a closed-form.

Nonetheless, we can still say some things about it. For example, we can show that it is analytic on $$\mathbb{H}$$, and we can approximate it numerically by iterating a fixed-point map. These properties (and more) follow from classical results in complex analysis but adapted from the unit disk to the upper half-plane. In this post I just want to highlight a few of these results, and how they apply in this setting.

### Carathéodory–Riffen–Finsler Pseudometric

---

Before we state the Schwarz–Pick lemma for the Poincaré metric, we'll need a couple of definitions. Since I used it in my master's thesis, I will present a slightly more general metric called the *Carathéodory–Riffen–Finsler (CRF) pseudometric*. We refer to the original papers by Harris [^harris1] [^harris2] for a more detailed discussion of this metric and its properties.

#### Definition

Let $$D$$ be a domain in a normed linear space over the complex numbers $$X$$. We define the *infinitesimal Carathéodory–Riffen–Finsler (CRF) pseudometric* as

$$
\alpha(x,v) = \sup \left\{ \|\mathrm{D}f(x)v\| \,\middle|\, f \in \mathrm{Hol}(D, \mathbb{D}) \right\}, \quad (x,v)\in D \times X,
$$

where $$\mathbb{D}$$ denotes the open complex unit disk of radius 1. The pseudometric $$\alpha$$ is an *infinitesimal Finsler pseudometric* on $$D$$, meaning that it is non-negative, lower semicontinuous, locally bounded, and satisfies

$$
\alpha(x, tv) = |t|\,\alpha(x, v)
$$

for all $$(x, v) \in D \times X$$ and $$t \in \mathbb{R}$$.

Let $$\Gamma$$ be the set of all curves in $$D$$ with piecewise continuous derivatives (called *admissible* curves), and define

$$
\mathcal{L}(\gamma) = \int_0^1 \alpha(\gamma(t), \gamma'(t))\,\mathrm{d}t, \quad \gamma \in \Gamma.
$$

The pseudometric $$\alpha$$ is a seminorm at each point in $$D$$, and $$\mathcal{L}(\gamma)$$ is interpreted as the length of the curve $$\gamma$$ with respect to $$\alpha$$. Then, the *CRF pseudometric* $$\rho$$ on $$D$$ is then defined by

$$
\rho(x, y) = \inf \left\{ \mathcal{L}(\gamma) \,\middle|\, \gamma \in \Gamma,\, \gamma(0) = x,\, \gamma(1) = y \right\}, \quad (x,y) \in D^2.
$$

As the name suggests, $$\rho$$ is a pseudometric.

#### Schwarz–Pick Lemma for the CRF Pseudometric

We can state a version of the Schwarz–Pick lemma that holds for the CRF pseudometric.

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Proposition 1</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \(\displaystyle D_1 \) and \(\displaystyle D_2 \) be domains in complex normed vector spaces, and let \(\displaystyle \rho_1 \) and \(\displaystyle \rho_2 \) be the associated CRF pseudometrics. If \(\displaystyle f : D_1 \to D_2 \) is holomorphic, then
  <div>$$ \rho_2(f(x), f(y)) \leq \rho_1(x, y) $$</div>
  for all \(\displaystyle x, y \in D_1 \).
</div>
<div style="height:1em"></div>

Proposition 1 tells us that the CRF pseudometric is non-expansive for holomorphic maps. In particular, if we apply it to a biholomorphic map $$f : D_1 \to D_2$$, we get

$$
\rho_2(f(x), f(y)) \leq \rho_1(x, y) = \rho_1(f^{-1}(f(x)), f^{-1}(f(y))) \leq \rho_2(f(x), f(y)),
$$

which means the inequalities must be equalities and

$$
\rho_2(f(x), f(y)) = \rho_1(x, y)
$$

for all $$x, y \in D_1$$. In other words, the CRF pseudometric is *biholomorphically invariant* [^helton].

There is also an infinitesimal version of the Schwarz–Pick lemma, which is just the derivative form of Proposition 1. We state it here for completeness.

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Proposition 2</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \(\displaystyle D_1 \) and \(\displaystyle D_2 \) be domains in complex normed vector spaces, and let \(\displaystyle \alpha_1 \) and \(\displaystyle \alpha_2 \) be the associated infinitesimal CRF pseudometrics. If \(\displaystyle f : D_1 \to D_2 \) is holomorphic, then
  <div>$$ \alpha_2(f(x), Df(x)v) \leq \alpha_1(x, v) $$</div>
  for all \(\displaystyle x \in D_1 \) and all tangent vectors \(\displaystyle v \in T_x D_1 \).
</div>
<div style="height:1em"></div>

<details style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <summary><strong>Proof sketch</strong></summary>

  <br>

  We sketch how Proposition 2 follows from Proposition 1. Fix a point \(x \in D_1\) and consider a smooth curve \(\gamma(t)\) through \(x\) with tangent vector \(v = \gamma^\prime(0)\). Applying Proposition 1 to \(x\) and \(\gamma(t)\) leads to

  $$
  \rho_2(f(x), f(\gamma(t))) \leq \rho_1(x, \gamma(t)).
  $$

  The infinitesimal CRF pseudometric is sometimes equivalently defined as
  
  $$
    \alpha(x, v) = \lim_{t \to 0^{+}} \frac{\rho(x, \gamma(t))}{t}.
  $$

  Since \(f\circ \gamma\) is a curve in \(D_2\) through \(f(x)\) with tangent vector \(Df(x)v\) by the chain rule, we can apply the definition of the infinitesimal CRF pseudometric to get

  $$
  \alpha_2(f(x), Df(x)v) = \lim_{t \to 0^{+}} \frac{\rho_2(f(x), f(\gamma(t)))}{t} \leq \lim_{t \to 0^{+}} \frac{\rho_1(x, \gamma(t))}{t} = \alpha_1(x, v).
  $$

</details>

<br>

### The Poincaré Metric

---

We can now specialize the CRF pseudometric to the unit disk and the upper half-plane.

#### On the Unit Disk

As hinted above, the CRF pseudometric is a generalization of the *Poincaré metric* on the open unit disk $$\mathbb{D}$$, which plays a central role in complex analysis. If we denote by $$\rho_{\mathbb{D}}$$ the CRF pseudometric on the open unit disk, then we have the explicit formula

$$
\rho_{\mathbb{D}}(z_1, z_2) = \mathrm{arctanh} \left| \frac{z_1 - z_2}{1 - \overline{z_1} z_2} \right|.
$$

The Schwarz–Pick lemma for the CRF pseudometric (Proposition 1) and the infinitesimal version (Proposition 2) can be specialized to the Poincaré metric. In this case, let $$f : \mathbb{D} \to \mathbb{D}$$ be a holomorphic function. Then for all $$z_1, z_2 \in \mathbb{D}$$,

$$
  \rho_{\mathbb{D}}(f(z_1), f(z_2)) \leq \rho_{\mathbb{D}}(z_1, z_2).
$$

In particular, since $$x\mapsto \tanh(x)$$ is an increasing function, we can also write this equivalently as

$$
  \left| \frac{f(z_1) - f(z_2)}{1 - \overline{f(z_1)} f(z_2)} \right| \leq \left| \frac{z_1 - z_2}{1 - \overline{z_1} z_2} \right|.
$$

For $$z_1=z$$ and $$z_2=z+h$$, the above implies

$$
    \left|\frac{f(z+h)-f(z)}{h}\right|\left| \frac{1}{1 - \overline{f(z)} f(z+h)} \right| \leq \left| \frac{1}{1 - \overline{z} (z+h)} \right|.
$$

Taking the limit as $$h \to 0$$ using the fact that $$f$$ is holomorphic and rearranging,

$$
    \frac{|f^\prime(z)|}{1 - |f(z)|^2} \leq \frac{1}{1 - |z|^2}
$$

for all $$z \in \mathbb{D}$$. This is the differential form of the Schwarz–Pick lemma for the Poincaré metric.

In the case of the Poincaré metric on the unit disk, the Schwarz–Pick lemma tells us more than just non-expansiveness. It also comes with a *rigidity statement*: if equality holds in either the distance form or the differential form of the inequality, then the function must be a *Möbius automorphism* of the disk. That is, if

$$
\rho_{\mathbb{D}}(f(z_1), f(z_2)) = \rho_{\mathbb{D}}(z_1, z_2)
$$

for some distinct $$z_1, z_2 \in \mathbb{D}$$, or if

$$
\frac{|f'(z)|}{1 - |f(z)|^2} = \frac{1}{1 - |z|^2}
$$

for some $$z \in \mathbb{D}$$, then $$f$$ must be of the form

$$
f(z) = e^{i\theta} \cdot \frac{z - a}{1 - \overline{a} z}, \quad \text{for some } a \in \mathbb{D},\; \theta \in \mathbb{R}.
$$

Let us collect these results in a single proposition. We refer to standard references for details of the proof [^stein].

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Proposition 3 (Schwarz–Pick Lemma on the Disk)</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \(\displaystyle f : \mathbb{D} \to \mathbb{D} \) be a holomorphic function. Then:
  <ol>
    <li>For all \(\displaystyle z_1, z_2 \in \mathbb{D} \),
      <div>$$ \rho_{\mathbb{D}}(f(z_1), f(z_2)) \leq \rho_{\mathbb{D}}(z_1, z_2) $$</div>
      or equivalently,
      <div>$$ \left| \frac{f(z_1) - f(z_2)}{1 - \overline{f(z_1)} f(z_2)} \right| \leq \left| \frac{z_1 - z_2}{1 - \overline{z_1} z_2} \right|. $$</div>
    </li>
    <li>For all \(\displaystyle z \in \mathbb{D} \),
      <div>$$ \frac{|f'(z)|}{1 - |f(z)|^2} \leq \frac{1}{1 - |z|^2}. $$</div>
    </li>
    <li>If equality holds in either inequality at any point \(\displaystyle z \in \mathbb{D} \) or for some distinct \(\displaystyle z_1, z_2 \), then \( f \) must be a Möbius automorphism of the disk, i.e.,
      <div>$$ f(z) = e^{i\theta} \cdot \frac{z - a}{1 - \overline{a} z} $$</div>
      for some \( a \in \mathbb{D} \) and \( \theta \in \mathbb{R} \).
    </li>
  </ol>
</div>
<div style="height:1em"></div>


#### On the Upper Half-Plane

For our use case, we are working with holomorphic functions on the *upper half-plane* $$\mathbb{H} = \{ z \in \mathbb{C} : \mathrm{Im}(z) > 0 \}$$. In order to transfer the results from the unit disk to the upper half-plane, consider the *Cayley transform*

$$
\phi : z\in\mathbb{H} \to \frac{z - i}{z + i} \in \mathbb{D}.
$$

The Cayley transform is a biholomorphic map with inverse given by

$$
\phi^{-1}(w) = i \frac{1 + w}{1 - w}.
$$

By pulling back the Poincaré metric from the disk via $$\phi^{-1}$$, we obtain the Poincaré metric on the upper half-plane. For $$z_1, z_2 \in \mathbb{H}$$, we have

$$
\rho_{\mathbb{H}}(z_1, z_2) = \rho_{\mathbb{D}}(\phi(z_1), \phi(z_2)) = \mathrm{arctanh} \left| \frac{\phi(z_1) - \phi(z_2)}{1 - \overline{\phi(z_1)} \phi(z_2)} \right|.
$$

After some algebraic manipulation, we can show that

$$
\rho_{\mathbb{H}}(z_1, z_2) = \mathrm{arccosh} \left( 1 + \frac{|z_1 - z_2|^2}{2 \mathrm{Im}(z_1) \mathrm{Im}(z_2)} \right).
$$ 

Using the relationship between the Poincaré metric on the disk and the upper half-plane, we can transfer the results from the unit disk to the upper half-plane. We collect these results here.

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Corollary 4 (Schwarz–Pick Lemma on the Upper Half-Plane)</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \(\displaystyle f : \mathbb{H} \to \mathbb{H} \) be a holomorphic function. Then:
  <ol>
    <li>For all \(\displaystyle z_1, z_2 \in \mathbb{H} \),
      <div>$$ \rho_{\mathbb{H}}(f(z_1), f(z_2)) \leq \rho_{\mathbb{H}}(z_1, z_2) $$</div>
      or equivalently,
      <div>$$ \left| \frac{f(z_1) - f(z_2)}{f(z_1) - \overline{f(z_2)}} \right| \leq \left| \frac{z_1 - z_2}{z_1 - \overline{z_2}} \right|. $$</div>
    </li>
    <li>For all \(\displaystyle z \in \mathbb{H} \),
      <div>$$ \frac{|f'(z)|}{\mathrm{Im}(f(z))} \leq \frac{1}{\mathrm{Im}(z)}. $$</div>
    </li>
    <li>If equality holds in either inequality at any point \(\displaystyle z \in \mathbb{H} \) or for some distinct \(\displaystyle z_1, z_2 \), then \( f \) must be a Möbius automorphism of the upper half-plane, i.e.,
      <div>$$ f(z) = \frac{a z + b}{c z + d} $$</div>
      for some real coefficients \( a, b, c, d \in \mathbb{R} \) satisfying \( ad - bc > 0 \).
    </li>
  </ol>
</div>
<div style="height:1em"></div>
Note that if $$g$$ is a Möbius automorphism of the unit disk, then the composition $$f(z) = \phi(g(\phi^{-1}(z)))$$ is a Möbius automorphism of the upper half-plane and takes exactly the same form as above. Furthermore, we may obtain the differential form of the Schwarz–Pick lemma for a holomorphic function $$f$$ on the upper half-plane by defining $$\phi\circ f\circ \phi^{-1}$$ and using the chain rule as well as the infinitesimal version of the Schwarz–Pick lemma on the disk.

### Denjoy–Wolff Theorem

---

Get a unique fixed point in the upper half-plane for fixed z

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

### Complex Implicit Function Theorem

The previous results help us show that for z fixed, the fixed-point equation has a unique solution in the upper half-plane. To show that the solution is analytic in the upper half-plane, we can use the complex implicit function theorem. 

Talk about local branches and how we can glue them together to get a global solution.

### Schwarz Reflection Principle

This gives us an analytic solutution in the upper half-plane. However, to take countour integral around eigenvalues or instance, we need to have a solution on the real line (where there are no eigenvalues) and in the lower half-plane.

### References

---

[^silverstein]: J.W. Silverstein and Z.D. Bai. *On the Empirical Distribution of Eigenvalues of a Class of Large Dimensional Random Matrices*. Journal of Multivariate Analysis 54(2), 1995. [doi:10.1006/jmva.1995.1051](https://doi.org/10.1006/jmva.1995.1051)

[^harris1]: L. A. Harris. *Fixed points of holomorphic mappings for domains in Banach spaces*. Journal of Functional Analysis, 1979.

[^harris2]: J.W. Harris. *Bounded Symmetric Homogeneous Domains in Infinite Dimensional Spaces*. Advances in Mathematics, 1979.

[^helton]: J.W. Helton, S.A. McCullough, and V. Vinnikov. *Operator-valued Nevanlinna–Pick kernels and realization theory*. 2007.

[^stein]: E. M. Stein and R. Shakarchi. *Complex Analysis*. Princeton Lectures in Analysis II, Princeton University Press, 2003.
