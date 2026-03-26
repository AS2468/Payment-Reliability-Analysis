# Payment-Reliability-Analysis
An organization was facing unidentified revenue leakage and customer frustration due to a fluctuating transaction success rate. Without analysis, one cannot identify whether the failures were due to technical bugs, user error, or specific payment gateways.

# Analysis
Created Amount Buckets (Micro to Medium) and Day Phases (Morning to Night) using DAX to categorize raw timestamps and values.
Built high-level KPIs, including Success Rate %, Total Transactions, and Value of Failed Transactions.
Connected the Customer Table to the Transaction Table to move from "Transaction counts" to "Human impact."

# Key Insights
The Revenue Drain: Identified ₹2.1M in failed transaction value. Notably, Card payments (₹615K) and UPI (₹592K) are the largest contributors to financial loss.

The Nighttime Paradox: While the Night phase has the highest volume of attempts, it has the lowest success rate (70%). This indicates a massive scalability issue during peak hours or scheduled bank downtime.

Value-Based Friction: Medium-value transactions (5k–20k) fail significantly more often than Micro payments, suggesting stricter bank-side security triggers or timeout issues for larger amounts.

Individual Frustration: Pinpointed 2 specific customers who experienced 9+ consecutive failures. One user is a "Gateway Victim" (only UPI fails), while the other is a "Systemic Failure" (everything fails), suggesting a mix of technical bugs and account-level issues.

# Findings
High Card Failure Value
Nighttime Success Drop
High-Volume low-value trasnactions Failures
Top 10 Failed Users for preventing churn
