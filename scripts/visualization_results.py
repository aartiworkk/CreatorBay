import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt

# -------------------------------
# DATABASE CONNECTION
# -------------------------------
connection = mysql.connector.connect(
    host="localhost",
    user="dbms_user",
    password="dbms123",
    database="influencer_tracker"
)



# -------------------------------
# QUERY: TOP INFLUENCERS BY ROI
# -------------------------------
query = """
SELECT i.name, ROUND(AVG(pm.roi), 2) AS avg_roi
FROM Influencer i
JOIN Performance_Metrics pm ON i.influencer_id = pm.influencer_id
GROUP BY i.influencer_id
ORDER BY avg_roi DESC
LIMIT 5;
"""

# Fetch data into DataFrame
df = pd.read_sql(query, connection)

# -------------------------------
# VISUALIZATION (BAR CHART)
# -------------------------------
plt.figure()
plt.bar(df['name'], df['avg_roi'])
plt.title("Top Influencers by Average ROI")
plt.xlabel("Influencer Name")
plt.ylabel("Average ROI")
plt.xticks(rotation=20)

# Save the graph
plt.savefig("top_influencers_roi.png")
plt.show()


# -------------------------------
# GRAPH 2: Payment Status Distribution
# -------------------------------
payment_query = """
SELECT status, COUNT(*) AS count
FROM Payments
GROUP BY status;
"""

df_payments = pd.read_sql(payment_query, connection)

plt.figure()
plt.pie(
    df_payments['count'],
    labels=df_payments['status'],
    autopct='%1.1f%%',
    startangle=90
)
plt.title("Payment Status Distribution")
plt.savefig("payment_status_distribution.png")
plt.show()


# -------------------------------
# GRAPH 3: Campaign Completion Rate
# -------------------------------
completion_query = """
SELECT 
    c.campaign_name,
    ROUND(
        100 * SUM(CASE WHEN d.status = 'Approved' THEN 1 ELSE 0 END)
        / COUNT(d.deliverable_id), 2
    ) AS completion_rate
FROM Campaigns c
JOIN Deliverables d ON c.campaign_id = d.campaign_id
GROUP BY c.campaign_id;
"""

df_completion = pd.read_sql(completion_query, connection)

plt.figure()
plt.bar(df_completion['campaign_name'], df_completion['completion_rate'])
plt.xticks(rotation=30, ha='right')
plt.title("Campaign Completion Rate (%)")
plt.xlabel("Campaign")
plt.ylabel("Completion Rate")
plt.savefig("campaign_completion_rate.png")
plt.show()


# Close connection
connection.close()
