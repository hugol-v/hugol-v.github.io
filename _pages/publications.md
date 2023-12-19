---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

{% if site.author.googlescholar and site.author.arxiv %}
  You can also find my articles on <a href="{{site.author.googlescholar}}">my Google Scholar profile</a> and <a href="{{site.author.arxiv}}">my arXiv profile</a>.
{% elsif site.author.googlescholar %}
  You can also find my articles on <a href="{{site.author.googlescholar}}">my Google Scholar profile</a>.
{% elsif site.author.arxiv %}
  You can also find my articles on <a href="{{site.author.arxiv}}">my ArXiv profile</a>.
{% endif %}

{% include base_path %}

## Preprints

{% for post in site.publications reversed %}
  {% if post.type == "preprint" %}
    {% include archive-single.html %}
  {% endif %}
{% endfor %}