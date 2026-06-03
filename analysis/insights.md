# 📊 Business Insights

> Findings and interpretations from each SQL query.  
> Dataset: 1,000 orders | 5 tables | Oracle SQL

---

## I. Sales Metrics

### Overall KPIs

| Metric | Value |
|---|---|
| Total Revenue | $2,367,915 |
| Total Orders | 1,000 |
| Monthly Average Revenue | $197,326 |
| Overall Return Rate | 20.5% |

---

### Monthly Sales Trend

| Month | Orders | Revenue |
|---|---|---|
| January | 73 | $200,891 |
| February | 69 | $147,013 |
| March | 86 | $210,815 |
| April | 102 | $234,546 |
| May | 95 | $221,934 |
| June | 68 | $164,848 |
| **July** | **116** | **$275,568** |
| August | 91 | $194,012 |
| September | 91 | $223,575 |
| October | 108 | $254,295 |
| November | 48 | $102,161 |
| December | 53 | $138,257 |

**Key Insights:**
- **July is the peak month** at $275,568 — 40% above monthly average. June→July jump: +67%.
- **November is the weakest** at $102,161 — 63% below July. October→November drop: -$152,134 (-60%), the sharpest decline of the year.
- **November–December anomaly:** E-commerce typically peaks in this period (Black Friday, year-end). The sharp decline here warrants investigation — possible data gap or operational issue.

---

### Top 5 Products by Revenue

| Rank | Product | Revenue |
|---|---|---|
| 1 | Product 21 | $71,518 |
| 2 | Product 22 | $66,007 |
| 3 | Product 11 | $64,946 |
| 4 | Product 93 | $64,087 |
| 5 | Product 88 | $59,201 |

**Key Insights:**
- Top 5 combined: **$325,759 = 13.8%** of total revenue.
- Gap between rank 1 and rank 5: only $12,317 (20.8%) — no single dominant product.
- **Low concentration risk** — portfolio is well-distributed across products.

---

### Top 5 Customers by Revenue

| Customer | Revenue | Orders | Revenue/Order |
|---|---|---|---|
| Customer 125 | $55,845 | 22 | $2,538 |
| Customer 120 | $48,363 | 15 | $3,224 |
| Customer 194 | $43,654 | 15 | $2,910 |
| Customer 23  | $40,365 | 11 | **$3,670** |
| Customer 111 | $40,140 | 12 | $3,345 |

**Key Insights:**
- **Customer 125** leads in orders (22), quantity (97), and revenue ($55,845) — true VIP.
- **Customer 23** has the highest revenue per order ($3,670) despite only 11 orders — premium buyer segment.
- **Quantity ≠ Revenue:** Customer 116 ranked in the top 5 by quantity but dropped out when sorted by revenue — buys often but cheap items.

---

## II. Discount & Payment Analysis

### Payment Method Breakdown

| Method | Orders | Share |
|---|---|---|
| Cash | 352 | 35.2% |
| Transfer | 351 | 35.1% |
| Card | 297 | 29.7% |

**Key Insights:**
- Cash and Transfer are **practically equal** (1 order difference).
- Card lags by 5.4 percentage points — opportunity to increase through incentive campaigns.
- Digital payments (Transfer + Card) = **64.8%** majority, but half of that is bank transfer (traditional method).

---

## III. Return Analysis

### Return Rate by Category

| Category | Return Rate | vs Average |
|---|---|---|
| Home | 26% | **+5.5%** |
| Electronics | 21% | +0.5% |
| Clothing | 19% | -1.5% |
| Books | 18% | -2.5% |
| Toys | 18% | -2.5% |

**Overall average: 20.5%**

**Key Insights:**
- **Home is critical** — 1 in 4 products is returned. Likely causes: size mismatch, quality expectation gap, impulse purchases.
- **Electronics** has a low rate numerically but high financial impact per return (high unit value).
- **Books and Toys** are the most stable — customer expectations well-matched.

---

### Return Reasons

| Reason | Count | Share |
|---|---|---|
| Customer Dissatisfaction | 398 | **39%** |
| Wrong Item | 361 | 36% |
| Defective | 256 | 25% |

**Key Insights:**
- **75% of returns are NOT product quality issues** — they are process and communication failures.
- **Wrong Item (36%)** is 100% preventable — warehouse/fulfillment error.
- **Customer Dissatisfaction (39%)** can be reduced by improving product descriptions, images, and size guides.

---

### Most Returned Product per Category

| Category | Product | Return Rate | Category Avg | Difference |
|---|---|---|---|---|
| Electronics | Product 82 | **58%** | 21% | **+37%** |
| Clothing | Product 90 | 46% | 19% | +27% |
| Books | Product 93 | 43% | 18% | +25% |
| Home | Product 47 | 44% | 26% | +18% |
| Toys | Product 9 | 39% | 18% | +21% |

**Key Insights:**
- These 5 products account for **124 out of 1,015 total returns (12.2%)**.
- **Product 82 (Electronics)** must be investigated immediately — more than half of all units sold are returned.
- All 5 products are significantly above their category average, suggesting product-specific issues (not category-wide).

---

## IV. Bonus Analysis

### Age Group Performance

| Age Group | Revenue | Profit Margin | Return Rate | Avg Order Value |
|---|---|---|---|---|
| Middle-Aged (31-50) | $928,407 | 20% | 22% | $2,418 |
| Senior (51-70) | $749,038 | **23%** | 23% | $2,432 |
| Young (18-30) | $726,807 | 16% | **16%** | $2,216 |

**Key Insights:**
- **Middle-Aged** generates the highest revenue but has a 22% return rate — reducing returns would directly increase net revenue.
- **Senior** has the highest profit margin (23%) and highest average order value — the most profitable segment per customer.
- **Young** has the lowest return rate (16%) — most loyal segment — but lowest profit margin and order value.
- **Critical finding:** Average discount is identical across all groups (~$23.97). No age-based pricing strategy exists. Reducing discounts for the Senior segment would directly increase margin since they are price-insensitive.

**The paradox:**
```
Young   → low returns, low margin
Senior  → high returns, high margin
Middle  → highest volume, middle everything
```

---

## 🎯 Recommendations

| Priority | Recommendation | Expected Impact | Difficulty |
|---|---|---|---|
| 1 | Investigate & fix Home return rate (26% → 20%) | High | Medium |
| 2 | Reduce discount for Senior segment ($23.97 → $18) | High | Low |
| 3 | Launch VIP program for C125, C120, C194 | High | Medium |
| 4 | Upsell Young segment (avg order $2,215 → $2,350) | Medium | Medium |
| 5 | Card payment cashback campaign (5-10%) | Medium | Low |
| 6 | Remove or rework Product 82 (Electronics, 58% return) | High | Low |
