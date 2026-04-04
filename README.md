# Digital Payments Reliability & Revenue Leakage Analysis
This project analyzes 4,714 digital transactions to identify systemic failures within a payment ecosystem. By correlating transaction volumes, success rates, and financial values, the analysis uncovers ₹2.1M in revenue leakage and provides data-driven recommendations for infrastructure scaling and gateway optimization.

# Key Business Insights (The Dashboard Results)
1. The Nighttime Reliability Gap

A clear inverse correlation exists between transaction volume and success.

The Night phase handles the highest traffic (32.77% of all transactions), yet suffers the lowest success rate at ~70%.

Business Impact: This indicates server congestion or bank-side maintenance during peak Indian retail hours.

2. High-Value Transaction Friction

Success rates drop as transaction values increase from Micro (<500) to Medium (5k-20k).

UPI and Wallet success rates dip by ~5% when moving into the Medium-value bucket.

Business Impact: Suggests authentication timeouts or stricter security triggers on higher-value mobile payments.

3. Financial Prioritization

While UPI is the most frequent method, it is not the costliest failure point.

Card payments represent the highest financial loss, totaling ₹615.59K in failed value.

Business Impact: Prioritizing the Card gateway API fix offers the highest immediate ROI for the business.

# Technical Implementation

Created a calculated column "Day_Phase" to bucket timestamps into Morning, Afternoon, Evening, and Night.

Developed "Amount_Bucket" calculated column to categorize transactions by size.

Established a One-to-Many relationship between the Customer and Transaction tables to track unique user impact (identifying 732 affected customers).

# Primary Measures Used
Success Rate % = DIVIDE([Successful_Txns], [Total_Txns])

Value of Failed Txns = CALCULATE(SUM(Transactions[Amount]), Transactions[Status] <> "Success")

Unique Customers Failing = DISTINCTCOUNT(Transactions[Customer_ID]) filtered by failure status.

# Business Recommendations
Scale API/Server resources specifically for the Night phase to handle the 32%+ volume peak.

Prioritize a technical audit of the Card Payment Gateway to recover the ₹615K+ currently being lost.

Use the Unique Customers Failing list to proactively reach out to users of failed transactions to prevent churn.
