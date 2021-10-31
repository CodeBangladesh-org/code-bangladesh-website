---
layout: codebangladesh-default
title: তথ্যপ্রযুক্তি কোম্পানি বাংলাদেশ
permalink: /tech-companies-in-bangladesh
---

<br/><br/><br/>

## বাংলাদেশে অবস্থিত তথ্যপ্রযুক্তি কোম্পানির লিস্ট

<br/>

<table>
  {% for row in site.data.companies %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
</table>

<br/>

### তথ্যসূত্র ও কৃতজ্ঞতা স্বীকার

তথ্যপ্রযুক্তি কোম্পানির লিস্টটি https://github.com/MBSTUPC/tech-companies-in-bangladesh থেকে নেয়া হয়েছে।

