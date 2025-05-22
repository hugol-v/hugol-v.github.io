---
layout: page
title: "Note to self: Upper Half-Plane Fixed Point Theorems"
description: Small set of notes on versions of the Schwarz–Pick Lemma, Denjoy–Wolff Theorem and Complex Implicit Function Theorem in the upper half-plane, with a focus on their relevance to deterministic equivalents in random matrix theory.
importance: 1
img: assets/img/det_equiv_conv.png
related_publications: false
---

### Motivation

---

If you've spent any time with random matrix theory like I have recently you will almost certainly run into something called a *deterministic equivalent*. These often show up as functions mapping the upper half of the complex plane $$\mathbb{H} = \{ z \in \mathbb{C} : \mathrm{Im}(z) > 0 \}$$ into itself that (uniquely) solve some fixed-point equation.

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

Before we state the Schwarz–Pick lemma for the Poincaré metric, we'll need a couple of definitions. I will present a slightly more general metric called the *Carathéodory–Riffen–Finsler (CRF) pseudometric*. We refer to the original papers by Harris [^harris1] [^harris2] for a more detailed discussion of this metric and its properties. What follows is adapted from my master's thesis.

#### Definition

Let $$D$$ be a domain in a normed linear space over the complex numbers $$X$$. We define the *infinitesimal Carathéodory–Riffen–Finsler (CRF) pseudometric* as

$$
\alpha(x,v) = \sup \left\{ \|\mathrm{D}f(x)v\| \,\middle|\, f \in \mathrm{Hol}(D, \mathbb{D}) \right\}, \quad (x,v)\in D \times X,
$$

where $$\mathbb{D}$$ denotes the open complex unit disk of radius 1 and $$\mathrm{Hol}(D, \mathbb{D})$$ is the set of holomorphic functions from $$D$$ to $$\mathbb{D}$$. The pseudometric $$\alpha$$ is an *infinitesimal Finsler pseudometric* on $$D$$, meaning that it is non-negative, lower semicontinuous, locally bounded, and satisfies

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

As the name suggests, $$\rho$$ is generally a pseudometric. For instance, if we let $$X=D=\mathbb{C}$$, then any holomorphic function $$f : \mathbb{C} \to \mathbb{D}$$ is a constant function by Liouville's theorem. This means that the CRF pseudometric is identically zero on the whole complex plane. On the other hand, a sufficient condition for the CRF pseudometric to be a metric is that the domain $$D$$ is bounded, in which case it is possible to show that

$$
\rho(x, y) \geq \frac{1}{d} \|x - y\|_X
$$

where $$d$$ is the diameter of $$D$$. By extension, if there exists a biholomorphic map $$f : D_1 \to D_2$$ between two a domain $$D_1$$ and a bounded domain $$D_2$$, then the CRF pseudometric on $$D_1$$ is also a metric by biholomorphic invariance (which we discuss below). This will ensure that the CRF pseudometric is a metric in the cases of the unit disk and the upper half-plane for instance.

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

There is also an infinitesimal version of the Schwarz–Pick lemma, which is just the derivative form of Proposition 1. We state it here for completeness, but before we do so let us first highlight the relationship between the infinitesimal CRF pseudometric and the CRF pseudometric.

Fix a point $$x \in D$$ and consider a the smooth curve $$\gamma(t) = x+tv$$ with tangent vector $$v$$ at $$t=0$$. We suppose that $$t$$ is small enough so that $$\gamma(s) \in D$$ for all $$s \in [0, t]$$. By definition of the CRF pseudometric,

  $$
    \rho(x, \gamma(t)) \leq  \int_0^{t}\alpha(\omega(s), \omega^\prime(s))\,\mathrm{d}s = \frac{1}{t}\int_0^{t}\alpha(\gamma(s), t\gamma^\prime(s))\,\mathrm{d}s = \int_0^{t}\alpha(\gamma(s), \gamma^\prime(s))\,\mathrm{d}s.
  $$

  Taking the limit as $$t \to 0^{+}$$,

  $$
    \lim_{t \to 0^{+}} \frac{\rho(x, \gamma(t))}{t} \leq \lim_{t \to 0^{+}}\int_0^{t}\alpha(\gamma(s), \gamma^\prime(s))\,\mathrm{d}s = \alpha(x, v).
  $$

  This gives us one direction of the inequality. For the other direction, let $$\epsilon > 0 $$ and choose $$f_0\in \mathrm{Hol}(D, \mathbb{D})$$ such that

  $$
  \|Df_0(x)v\| \geq \alpha(x, v) -\epsilon.
  $$

  Choose $$\delta > 0 $$ small enough sucht that $$\|f_0(x+tv) - f_0(x) - tDf_0(x)v\| < \epsilon t$$ whenever $$t\|v\| = \|x+tv - x\| < \delta$$. Then,

  $$
  |f_0(x+tv) - f_0(x)| \geq (\alpha(x, v) - 2\epsilon)t.
  $$

  By the integrated form of the Schwarz–Pick lemma (Proposition 1),

  $$
  \rho(x, x+tv) \geq \rho_{\mathbb{D}}(f_0(x), f_0(x+tv)) = (\alpha(x, v) - 2\epsilon)t + o(t)
  $$

  where we have used the explicit form of the Poincaré metric on the unit disk (see below). Dividing both sides by $$t$$ and taking the limit as $$t \to 0^{+}$$ gives us

  $$
  \lim_{t \to 0^{+}} \frac{\rho(x, x+tv)}{t} \geq \alpha(x, v) - 2\epsilon.
  $$

  Since $$\epsilon$$ is arbitrary, we conclude that the integrated form of the CRF pseudometric is related to the infinitesimal CRF pseudometric through the Schwarz–Pick lemma as

  $$
  \lim_{t \to 0^{+}} \frac{\rho(x, x+tv)}{t} = \alpha(x, v).
  $$

  We can now state the infinitesimal version of the Schwarz–Pick lemma.

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

  Although Proposition 2 is usually proved first and implies Proposition 1, we sketch how Proposition 2 follows from Proposition 1. Applying Proposition 1 to \(x\) and \(\gamma(t)=x+tv\) gives us

  $$
  \rho_2(f(x), f(\gamma(t))) \leq \rho_1(x, \gamma(t)).
  $$

  The infinitesimal CRF pseudometric is related to the CRF pseudometric through the limit
  
  $$
    \alpha(x, v) = \lim_{t \to 0^{+}} \frac{\rho(x, x+tv)}{t}.
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

For our use case, we are working with holomorphic functions on the upper half-plane. In order to transfer the results from the unit disk to the upper half-plane, consider the *Cayley transform*

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

DO SKETCH OF PROOF FOR DENJOY WOLFF THEOREM

In our random matrix example, for a fixed spectral parameter $$z \in \mathbb{H}$$, the solution is defined in terms of $$m(z) \in \mathbb{H}$$ which in turn is defined as the unique solution of a fixed-point equation

$$F(m;z) \equiv m\left(1+\frac{1}{p} \mathrm{tr}\left(C (C m + zI)^{-1}\right)\right) = -1.$$

For a fixed $$z \in \mathbb{H}$$, one may check that the function $$F(m;z)$$ is a holomorphic map from the upper half-plane $$\mathbb{H}$$ into itself. There exists multiple fixed point theorems that could be used to show the existence of a unique solution $$m(z) \in \mathbb{H}$$ for the fixed-point equation $$F(m;z)=1$$ under various conditions. For instance, I like the Earle-Harris fixed point theorem[^earle], which states that strict holomorphic maps on domains of a Banach space are strict contractions with respect to the CRF pseudometric, and hence admits a unique fixed point. The fixed-point theorem by Khatskevich-Reich-Shoikhe is also noteworthy [^khatskevich]. It states that we do not necessarily need the map to be a strict, and that uniformly continuous extensions on the boundary of the domain and strict contraction on the boundary are sufficient to guarantee the existence of a unique fixed point.

Here, I will instead present the *Denjoy–Wolff theorem*, a classical result in complex analysis that helps us understand the behavior of iterates of such maps. This theorem provides the basis for why $$m(z)$$ is well-defined and unique within $$\mathbb{H}$$.

First, we state the theorem for the unit disk $$\mathbb{D}$$, for which a standard reference are Milnor [^milnor] and Carleson & Gamelin [^carleson_gamelin].

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Proposition 4 (Denjoy–Wolff Theorem on the Disk)</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \( g : \mathbb{D} \to \mathbb{D} \) be a holomorphic function and suppose that \(g(\mathbb{D})\) is a proper subset of \(\mathbb{D}\). Then, the sequence of iterates \(\{g^{\circ n}(w)\}\) converges for every \(w \in \mathbb{D}\) to a unique point \(w_0 \in \bar{\mathbb{D}}\). Furthermore, if \(w_0 \in \mathbb{D}\), then \(w_0\) is the unique fixed point of \(g\) in \(\mathbb{D}\).
</div>
<div style="height:1em"></div>

The limit point $$w_0$$ is called the *Denjoy–Wolff point* of $$g$$. We stated the proposition in a slightly different form than the standard one, basically using the fact that $$g$$ cannot be an automorphism of the disk since $$g(\mathbb{D})$$ is a proper subset of $$\mathbb{D}$$.

Using the Cayley transform, we can state the corresponding result for the upper half-plane.

<div style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <strong>Corollary 5 (Denjoy–Wolff Theorem on the Upper Half-Plane)</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \( f : \mathbb{H} \to \mathbb{H} \) be a holomorphic function and suppose that \(f(\mathbb{H})\) is a proper subset of \(\mathbb{H}\). Then, the sequence of iterates \(\{f^{\circ n}(z)\}\) converges for every \(z \in \mathbb{H}\) to a unique point \(\alpha \in \overline{\mathbb{H}}\). Furthermore, if \(\alpha \in \mathbb{H}\), then \(\alpha\) is the unique fixed point of \(f\) in \(\mathbb{H}\).
</div>
<div style="height:1em"></div>

<details style="border: 1px solid #4695b8; padding: 1em; border-radius: 5px;">
  <summary><strong>Proof sketch</strong></summary>
  <br>
  The result for the upper half-plane \(\mathbb{H}\) is derived from the unit disk \(\mathbb{D}\) version using a conformal map (the Cayley transform \(\phi\)). Let \(g : z \in \mathbb{D} \mapsto \phi(f(\phi^{-1}(z)))\) be a holomorphic conjugate map. Since \(f\) is not an automorphism of \(\mathbb{H}\), \(g\) is not an automorphism of \(\mathbb{D}\) either. 
  
  Hence, by Proposition 4, the iterates \(g^n(w)\) converge to a Denjoy–Wolff point \(w_0 \in \overline{\mathbb{D}}\) for all \(w \in \mathbb{D}\). The iterates are related by \(\phi(f^{\circ n}(z)) = g^{\circ n}(\phi(z))\) for \(z \in \mathbb{H}\). Using the fact that \(\phi^{-1}\) is continuous, it follows that \(f^{\circ n}(z) = \phi^{-1}(g^{\circ n}(\phi(z)))\) converges to \(\phi^{-1}(w_0) \). The point \(\alpha\) is in \(\overline{\mathbb{H}}\) since \(w_0\) is in \(\overline{\mathbb{D}}\).
</details>
<div style="height:1em"></div>

In the context of our fixed-point map $$G(m;z)$$ with $$G(m;z) = (1+\frac{1}{p} \mathrm{tr}(C (C m + zI)^{-1}))^{-1}$$, we can usually show that $$G(m;z)$$ is not an automorphism of the upper half-plane since $$G(m;z)$$ is a proper subset of $$\mathbb{H}$$. Hence, Corollary 5 applies, and we get that there exists a unique fixed point $$m(z) \in \mathbb{H}$$ for each fixed $$z \in \mathbb{H}$$ as long as we can show that the iterates $$G^{\circ n}(m)$$ does no converge to the boundary $$\partial\mathbb{H}$$.

### Complex Implicit Function Theorem

---

The previous results give tools to show that the fixed-point equation $$F(m;z)=1$$ has a unique solution in the upper half-plane for each fixed $$z \in \mathbb{H}$$. However, we also need to show that this solution is analytic in the upper half-plane. To do so, we can use the *complex implicit function theorem*.

<div style="border:1px solid #4695b8;padding:1em;border-radius:5px;">
  <strong>Proposition 6 (Complex Implicit Function Theorem)</strong>
  <span style="display:inline-block; width:0.5em;"></span>
  Let \(\displaystyle U \subset \mathbb{C}^\alpha \times \mathbb{C}^\beta\) be open and \(G : U \to \mathbb{C}^\beta\) holomorphic in all variables. Assume \((x_0, y_0) \in U\) satisfies \(G(x_0, y_0) = 0\) and the Jacobian \(\partial_y G(x_0, y_0) \in \mathbb{C}^{\beta \times \beta}\) is invertible. Then there exist neighbourhoods \(V\) and \(W\) containing \(x_0\) and \(y_0\) respectively, and a unique holomorphic map \(h : V \to W\) such that

  $$
  \left\{(x, h(x)) \in V \times W : G(x, h(x)) = 0\right\} = \{(x, y) \in V \times W : G(x, y) = 0\}.
  $$

</div>
<div style="height:1em"></div>

The proof follows from the holomorphic inverse-function theorem.

In our case, we want to apply the analytic implicit function theorem to the fixed-point equation $$F(m;z)=1$$. Taking the derivative with respect to $$m$$, we have

$$
\partial_m F(m;z) = \partial_m \frac{m}{G(m)} = \frac{G(m) - m \partial_m G(m)}{G(m)^2}. 
$$

By the differential form of the Schwarz–Pick lemma on the upper half-plane, 

$$|\partial_m G(m;z)| \leq \frac{\Im[G(m)]}{\mathrm{Im}(m)}.$$

Hence, for $$z \in \mathbb{H}$$ fixed, if $$m(z)$$ is a solution of the fixed-point equation $$G(m(z);z)=m(z)$$, then 

$$|\partial_m G(m;z)|<1$$ 

and consequently $$\partial_m F(m(z);z)\neq 0$$ in a sufficiently small neighbourhood of $$m(z)$$. This means, by the complex implicit function theorem, that there exists a unique holomorphic branch $$m(z)$$ in a neighbourhood of $$z$$ such that $$F(m(z);z)=0$$. The argument we just presented is adapted from a paper by Elliot Paquette, Courtney Paquette, Lechao Xiao and Jeffrey Pennington [^paquette].

Since the upper half-plane is simply connected and there is a unique solution for every $$z \in \mathbb{H}$$, we can glue the local branches together to obtain a global holomorphic function $$m : \mathbb{H} \to \mathbb{H}$$ such that $$F(m(z);z)=0$$ for all $$z \in \mathbb{H}$$.

### Schwarz Reflection Principle

---

The above gives us an analytic solution in the upper half-plane. However, in some cases, we may want to extend the solution to the lower half-plane and on part of the real line. This is important, for example, when we want to take contour integrals around some of the eigenvalues of the random matrix. This is where the *Schwarz reflection principle* comes into play.

The Schwarz reflection principle states that if $$f$$ is a holomorphic function on the upper half-plane $$\mathbb{H}$$, and if $$f$$ extends continuously to an open interval $$I \subseteq \mathbb{R}$$ with $$f(I) \subseteq \mathbb{R}$$, then we can extend $$f$$ to the lower half-plane by reflection. In other words, the function

$$
\tilde{f}(z) = \begin{cases}
f(z) & \text{if } z \in \mathbb{H} \cup I \\
\overline{f(\overline{z})} & \text{if } z \in -\mathbb{H}
\end{cases}
$$

is a holomorphic function on $$\mathbb{H} \cup I \cup -\mathbb{H}$$, where we defined by $f(z)=\lim_{t \to 0^+} f(z+it)$ for $$z \in I$$. This follows from the Schwarz reflection principle.

For *Herglotz functions*, which are ubiquitous in random matrix theory, the non-tangential limits $$\lim_{t \to 0^+} f(x+it)$$ exist for almost every $$x \in \mathbb{R}$$.

### References

---

[^silverstein]: J.W. Silverstein and Z.D. Bai. *On the Empirical Distribution of Eigenvalues of a Class of Large Dimensional Random Matrices*. Journal of Multivariate Analysis 54(2), 1995. [doi:10.1006/jmva.1995.1051](https://doi.org/10.1006/jmva.1995.1051)

[^harris1]: L. A. Harris. *Fixed points of holomorphic mappings for domains in Banach spaces*. Journal of Functional Analysis, 1979.

[^harris2]: J.W. Harris. *Bounded Symmetric Homogeneous Domains in Infinite Dimensional Spaces*. Advances in Mathematics, 1979.

[^helton]: J.W. Helton, S.A. McCullough, and V. Vinnikov. *Operator-valued Nevanlinna–Pick kernels and realization theory*. 2007.

[^stein]: E. M. Stein and R. Shakarchi. *Complex Analysis*. Princeton Lectures in Analysis II, Princeton University Press, 2003.

[^milnor]: J. Milnor. Dynamics in One Complex Variable. Annals of Mathematics Studies, Princeton University Press, 3rd edition, 2006. (See Appendix A: The Denjoy-Wolff Theorem)

[^carleson_gamelin]: L. Carleson and T. W. Gamelin. Complex Dynamics. Universitext, Springer-Verlag, 1993. (The Denjoy-Wolff theorem is typically discussed in chapters on iteration of analytic functions, e.g., Chapter II or III).

[^paquette]: Paquette, E., Paquette, C., Xiao, L., & Pennington, J. (2025). 4+3 Phases of Compute-Optimal Neural Scaling Laws. arXiv. https://arxiv.org/abs/2405.15074

[^earle]: C. J. Earle and R. S. Hamilton, A fixed point theorem for holomorphic mappings, Global Analysis (Proc. Sympos. Pure Math., Vol. XVI, Berkeley, Calif., (1968)), American Mathematical Society, Rhode Island, 1970, pp. 61–65.

[^khatskevich]: A. Khatskevich, S. Reich, and D. Shoikhet, Fixed point theorems for holomorphic mappings and operator theory in indefinite metric spaces, Integral Equations Operator Theory 22 (1995), no. 3, 305–316.