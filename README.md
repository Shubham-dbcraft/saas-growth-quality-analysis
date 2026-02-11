# saas-growth-quality-analysis
SaaS revenue quality analysis using SQL and Power BI to model MRR, churn, expansion, and Net Revenue Retention (NRR).



# SaaS Growth Quality Analysis  
### Revenue Modeling using SQL + Power BI

## 📌 Project Overview

This project analyzes SaaS revenue quality by separating acquisition, churn, and expansion layers to understand how growth truly compounds over time.

While Monthly Recurring Revenue (MRR) appeared to be increasing, a deeper analysis revealed weakening Net Revenue Retention (NRR), signaling that growth was becoming acquisition-dependent rather than retention-driven.

The goal of this project was not just to report metrics, but to model how revenue behaves inside a SaaS business.

---

## 🎯 Business Question

Can a SaaS company show rising MRR while its underlying revenue engine is deteriorating?

If so:
- How can we detect the inflection point?
- What metrics reveal revenue leakage?
- When does growth stop compounding?

---

## 🏗 Data Modeling Approach (SQL Layer)

The raw subscription dataset was structured into clean monthly revenue layers using SQL.

The modeling process included:

1. Creating a clean analytics table from raw subscription data  
2. Calculating Monthly New MRR (acquisition layer)  
3. Calculating Monthly Churned MRR (revenue leakage)  
4. Identifying Expansion Revenue from upgrades  
5. Computing Net MRR Change  
6. Building a running Starting MRR base  
7. Calculating Net Revenue Retention (NRR)

Key Output Tables:
- `v_monthly_mrr`
- `v_monthly_nrr`

This structure mimics how real RevOps / SaaS analytics teams model revenue intelligence.

---

## 📊 Metrics Modeled

- **MRR (Monthly Recurring Revenue)**
- **New MRR**
- **Churned MRR**
- **Expansion MRR**
- **Net MRR Change**
- **Starting MRR**
- **NRR (Net Revenue Retention)**

NRR Formula Used:

NRR = (Starting MRR + Expansion − Churn) / Starting MRR

Interpretation:
- NRR > 100% → Revenue Compounding  
- NRR = 100% → Stagnation  
- NRR < 100% → Revenue Base Shrinking  

---

## 🔎 Key Insight

Although MRR continued to grow, NRR fell below 100% in late 2024.

This indicated:

- Expansion was no longer offsetting churn  
- Existing customer revenue stopped compounding  
- Growth became acquisition-dependent  
- Long-term predictability weakened  

This shift represents a critical inflection point in SaaS revenue quality.

---

## 📈 Dashboard Layer (Power BI)

The SQL outputs were connected to Power BI to create a 3-page analytical narrative:

1️⃣ MRR Growth vs Durability  
2️⃣ Breakdown of Retention and Compounding (NRR View)  
3️⃣ Business Implication & Leadership Action Points  

The dashboard emphasizes decision-making over visual complexity.

---

## 🚀 What This Project Demonstrates

- Revenue modeling using SQL  
- Metric engineering for SaaS businesses  
- Understanding of growth quality vs growth volume  
- Ability to translate data into business implications  
- End-to-end analytics pipeline: Raw Data → SQL → BI Storytelling  

---

## 📁 Repository Structure

