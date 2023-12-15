---
layout: archive
title: "CV"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

Here is an *abridged* version of my CV.

## Education

* **M.Sc. Mathematics and Statistics**, *McGill University*, 2024 (expected)
  * Thesis topic: Matrix Dyson Equation for Correlated Linearizations and Test Error of Random Features Regression
  * Co-supervised by Professor Courtney Paquette and Professor Elliot Paquette
* **B.Sc. Joint Honours Mathematics and Computer Science**, *McGill University*, 2022
  * Graduated with First Class Joint Honours.
* **DEC in Computer Science and Mathematics**, *Champlain Regional College*, 2018

## Publications

  <ul>{% for post in site.publications reversed %}
    {% include archive-single-cv.html %}
  {% endfor %}</ul>

## Presentations

### Research Presentations

  <ul>{% for post in site.talks reversed %}
    {% if post.researchorreview != "review" %}
      {% include archive-single-talk-cv.html %}
    {% endif %}
  {% endfor %}</ul>

### Litterature Reviews

  <ul>{% for post in site.talks reversed %}
    {% if post.researchorreview == "review" %}
      {% include archive-single-talk-cv.html %}
    {% endif %}
  {% endfor %}</ul>

## Teaching/Marking

  <ul>{% for post in site.teaching reversed %}
    {% include archive-single-teaching-cv.html %}
  {% endfor %}</ul>

## Awards and Scholarships

* **First-class honours in Mathematics and Computer Science**, *McGill University*, 2022
* **Undergraduate student research award**, *NSERC*, 2021
* **Major entrance scholarship in science**, *Hydro-Québec*, 2018

## Services and Extra Curricular Activities

* *Organizer*
  * Co-organizer for the Montreal RMT-ML-OPT seminar at McGill University (Fall 2023)
* *Review*
  * OPT Workshop on Optimization for Machine Learning (NeurIPS 2023)
  * High-dimensional Learning Dynamics Workshop (ICML 2023)
  * OPT Workshop on Optimization for Machine Learning (NeurIPS 2022)
* *Volunteer*
  * OPT Workshop on Optimization for Machine Learning (NeurIPS 2021)
