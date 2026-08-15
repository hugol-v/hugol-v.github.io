---
layout: page
title: research
permalink: /research/
description: My interests span high-dimensional probability, statistics, machine learning, and random matrix theory. Below is a concise overview of several tightly interconnected areas I am interested in.
intro_panel: true
nav: true
nav_order: 2
horizontal: false
---

<blockquote class="research-quote">
  <p>A system is deterministic only in the ways that it is explicitly prevented from being random</p>
  <cite>— Principle of maximum entropy</cite>
</blockquote>

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
  <div class="project-card-grid">
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
  <div class="project-card-grid">
    {% for project in sorted_research %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>
