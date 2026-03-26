# Payment-Reliability-Analysis
An organization was facing unidentified revenue leakage and customer frustration due to a fluctuating transaction success rate. Without analysis, one cannot identify whether the failures were due to technical bugs, user error, or specific payment gateways.

# Analysis
Created Amount Buckets (Micro to Medium) and Day Phases (Morning to Night) using DAX to categorize raw timestamps and values.
Built high-level KPIs, including Success Rate %, Total Transactions, and Value of Failed Transactions.
Connected the Customer Table to the Transaction Table to move from "Transaction counts" to "Human impact."

# Key Insights
Identified ₹2.1M in failed transaction value. Card payments (₹615K) and UPI (₹592K) are the largest contributors to financial loss.

While the Night phase has the highest volume of attempts, it has the lowest success rate (70%). This indicates a massive scalability issue during peak hours or scheduled bank downtime.

Success rates drop to a low of **70% at Night**, despite having the highest volume, indicating server capacity issues.

While UPI is the most popular, **Card payments** represent the highest financial risk, with **₹615K in lost value**.

Medium-value transactions (5k–20k) fail significantly more often than Micro payments, suggesting stricter bank-side security triggers or timeout issues for larger amounts.

# Findings
High Card Failure Value
Nighttime Success Drop
High-Volume low-value trasnactions Failures
Top 10 Failed Users for preventing churn
