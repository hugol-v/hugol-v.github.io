---
layout: page
title: research
permalink: /research/
description: Summary of my research interests.
nav: true
nav_order: 2
horizontal: false
---

<blockquote>A system is deterministic only in the ways that it is explicitly prevented from being random
<cite>- Principle of maximum entropy</cite></blockquote>

I have a broad interest in various subjects within the realm of high-dimensional probability, statistics, machine learning, and random matrix theory. Below, I provide a concise overview of some tightly interconnected research areas that I am interested in.

<!-- pages/research.md -->
<div class="research">
{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized research -->
  {% for category in page.display_categories %}
  <a id="{{ category }}" href=".#{{ category }}">
    <h2 class="category">{{ category }}</h2>
  </a>
  {% assign categorized_research = site.research | where: "category", category %}
  {% assign sorted_research = categorized_research | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_research %}
      {% include research_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_research %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display research without categories -->

{% assign sorted_research = site.research | sort: "importance" %}

  <!-- Generate cards for each project -->

{% if page.horizontal %}

  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_research %}
      {% include research_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_research %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>
