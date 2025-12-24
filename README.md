# CreatorBay – Influencer & Brand Collaboration Platform (DBMS Project)

## Overview
CreatorBay is a database-driven project that models an influencer–brand collaboration ecosystem. The system is designed to store, manage, and analyze data related to influencers, brands, campaigns, and collaboration performance using core Database Management System (DBMS) concepts.  
The project also integrates Python-based data visualization to convert database records into meaningful analytical insights.

---

## Project Objectives
- Design a structured relational database for influencer marketing
- Implement SQL queries for data retrieval and analysis
- Demonstrate relationships using primary and foreign keys
- Generate analytical visualizations from database data
- Apply DBMS concepts to a real-world business use case

---

## Database Design
The database is implemented using MySQL and includes tables representing:
- Influencers
- Brands
- Campaigns
- Collaborations
- Performance Metrics

The design uses primary keys, foreign keys, and constraints to ensure data integrity.  
All schema definitions, sample data, and SQL queries are included in `dbms_project.sql`.

---

## Technologies Used
- MySQL
- Python
- MySQL Connector for Python
- Pandas
- Matplotlib
- VS Code

---

## Functionalities Implemented
- Creation of relational tables using SQL
- Insertion of structured sample data
- Use of JOINs, aggregate functions, and GROUP BY clauses
- Analytical SQL queries for business insights
- Python-based database connectivity
- Visualization of query results using graphs

---

## Data Visualization
The Python script `visualization_results.py` generates analytical visualizations such as:
- Influencer engagement comparison
- Platform-wise influencer distribution
- Campaign performance analysis

Sample visualization outputs are provided as PNG files in the repository.

---

## How to Run the Project

### 1. Setup the Database
- Import `dbms_project.sql` into MySQL
- Ensure the database and tables are created successfully

### 2. Install Dependencies
```bash
pip install -r requirements.txt

```
### 3. Run the Visualization Script
```bash
python visualization_results.py
```
This script connects to the database, executes analytical SQL queries, and generates visual insights in the form of graphs.

---

## Learning Outcomes
- Clear understanding of relational database design
- Practical experience with SQL queries, joins, and aggregations
- Hands-on integration of MySQL with Python
- Ability to convert database results into visual insights
- Exposure to real-world DBMS application scenarios

---

## Future Enhancements
- Development of a web-based frontend for influencers and brands
- Implementation of user authentication and role-based access control
- Recommendation system for influencer–brand matching
- Real-time analytics dashboard
- Integration with live social media APIs

---

## Conclusion
CreatorBay demonstrates the practical application of Database Management System concepts in a real-world use case. The project combines structured data storage, relational modeling, SQL-based analytics, and Python-powered visualization to build a scalable influencer–brand collaboration platform
