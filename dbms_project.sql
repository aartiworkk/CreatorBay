-- Create Database
CREATE DATABASE IF NOT EXISTS influencer_tracker;
USE influencer_tracker;

-- 1. INFLUENCER TABLE
CREATE TABLE Influencer (
    influencer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    platforms VARCHAR(200),
    follower_count INT CHECK (follower_count >= 0),
    bio TEXT,
    niche VARCHAR(50),
    engagement_rate DECIMAL(5,2),
    bank_account VARCHAR(50),
    bank_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_followers (follower_count)
);

-- 2. BRANDS TABLE
CREATE TABLE Brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL UNIQUE,
    industry VARCHAR(50) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    website VARCHAR(100),
    budget_allocated DECIMAL(12,2) DEFAULT 0,
    budget_spent DECIMAL(12,2) DEFAULT 0,
    rating DECIMAL(3,2) CHECK (rating >= 0 AND rating <= 5),
    total_collaborations INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_industry (industry),
    INDEX idx_brand_name (brand_name)
);

-- 3. CAMPAIGNS TABLE
CREATE TABLE Campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    influencer_id INT NOT NULL,
    campaign_name VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget DECIMAL(10,2) NOT NULL CHECK (budget > 0),
    status ENUM('Pending', 'Active', 'Completed', 'Cancelled') DEFAULT 'Pending',
    deliverable_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (influencer_id) REFERENCES Influencer(influencer_id) ON DELETE CASCADE,
    INDEX idx_brand (brand_id),
    INDEX idx_influencer (influencer_id),
    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date),
    CONSTRAINT check_dates CHECK (end_date >= start_date)
);

-- 4. DELIVERABLES TABLE
CREATE TABLE Deliverables (
    deliverable_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    deliverable_type VARCHAR(50) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    description TEXT,
    deadline DATE NOT NULL,
    submission_date DATE,
    approval_date DATE,
    status ENUM('Pending', 'Submitted', 'Approved', 'Rejected', 'Overdue', 'Late') DEFAULT 'Pending',
    content_link VARCHAR(255),
    requirements TEXT,
    revision_count INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id) ON DELETE CASCADE,
    INDEX idx_campaign (campaign_id),
    INDEX idx_status (status),
    INDEX idx_deadline (deadline),
    INDEX idx_platform (platform)
);

-- 5. PAYMENTS TABLE
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE,
    due_date DATE NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed', 'Cancelled') DEFAULT 'Pending',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100) UNIQUE,
    invoice_number VARCHAR(50) UNIQUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id) ON DELETE CASCADE,
    INDEX idx_campaign (campaign_id),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date),
    INDEX idx_payment_date (payment_date)
);

-- 6. AUDIT LOG TABLE (Track all changes)
CREATE TABLE Audit_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    record_id INT,
    action VARCHAR(20),
    old_values TEXT,
    new_values TEXT,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_table (table_name),
    INDEX idx_time (changed_at)
);

-- 7. PERFORMANCE_METRICS TABLE (Store analytics)
CREATE TABLE Performance_Metrics (
    metric_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    influencer_id INT NOT NULL,
    reach INT DEFAULT 0,
    impressions INT DEFAULT 0,
    clicks INT DEFAULT 0,
    conversions INT DEFAULT 0,
    engagement INT DEFAULT 0,
    roi DECIMAL(5,2),
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id) ON DELETE CASCADE,
    FOREIGN KEY (influencer_id) REFERENCES Influencer(influencer_id) ON DELETE CASCADE,
    INDEX idx_campaign (campaign_id),
    INDEX idx_influencer (influencer_id)
);




-- SAMPLE DATA: INFLUENCERS
INSERT INTO Influencer (name, username, email, phone, platforms, follower_count, bio, niche, engagement_rate)
VALUES
('Sarah Johnson', '@sarahjohn', 'sarah@email.com', '9876543210', 'Instagram, TikTok, YouTube', 250000, 'Fashion & Lifestyle Blogger', 'Fashion', 5.2),
('Mike Chen', '@mikechen_', 'mike@email.com', '9876543211', 'YouTube, Instagram', 500000, 'Tech & Gadget Reviewer', 'Technology', 4.8),
('Emma Davis', '@emmadavis_', 'emma@email.com', '9876543212', 'Instagram, Pinterest', 180000, 'Home & Lifestyle Expert', 'Lifestyle', 6.1),
('Alex Kumar', '@alexkumar', 'alex@email.com', '9876543213', 'TikTok, Instagram, YouTube', 320000, 'Fitness & Nutrition Coach', 'Fitness', 5.9),
('Priya Patel', '@priyapatel', 'priya@email.com', '9876543214', 'Instagram, Blog', 150000, 'Beauty & Skincare Specialist', 'Beauty', 4.5),
('James Wilson', '@jameswilson', 'james@email.com', '9876543215', 'YouTube, Twitch', 420000, 'Gaming & Entertainment', 'Gaming', 5.5);

-- SAMPLE DATA: BRANDS
INSERT INTO Brands (brand_name, industry, contact_person, email, phone, website, budget_allocated, rating, total_collaborations)
VALUES
('TechBrand Co', 'Technology', 'John Smith', 'john@techbrand.com', '8765432100', 'www.techbrand.com', 100000, 4.5, 5),
('Fashion Hub', 'Fashion', 'Emma White', 'emma@fashionhub.com', '8765432101', 'www.fashionhub.com', 80000, 4.2, 3),
('FitLife Ltd', 'Health & Fitness', 'David Brown', 'david@fitlife.com', '8765432102', 'www.fitlife.com', 60000, 4.7, 4),
('Beauty Plus', 'Beauty', 'Lisa Grace', 'lisa@beautyplus.com', '8765432103', 'www.beautyplus.com', 50000, 4.3, 2),
('Gaming Studios', 'Gaming', 'Mark Johnson', 'mark@gamingstudios.com', '8765432104', 'www.gamingstudios.com', 75000, 4.8, 6);

-- SAMPLE DATA: CAMPAIGNS
INSERT INTO Campaigns (brand_id, influencer_id, campaign_name, description, category, start_date, end_date, budget, status, deliverable_count)
VALUES
(1, 1, 'Summer Tech Launch 2024', 'Product launch campaign for new gadgets', 'Product Launch', '2024-06-01', '2024-08-31', 15000, 'Active', 3),
(2, 2, 'Fashion Collaboration Series', 'Fashion week promotional campaign', 'Brand Awareness', '2024-07-15', '2024-09-15', 12000, 'Active', 4),
(3, 4, 'Fitness Challenge 2024', 'Fitness transformation campaign', 'Engagement', '2024-05-01', '2024-07-31', 10000, 'Completed', 5),
(4, 5, 'Beauty Summer Collection', 'New beauty product promotion', 'Product Launch', '2024-06-15', '2024-08-15', 8000, 'Active', 2),
(5, 6, 'Gaming Tournament Sponsorship', 'E-Sports tournament sponsorship', 'Event Sponsorship', '2024-08-01', '2024-09-30', 20000, 'Pending', 3),
(1, 3, 'Lifestyle Integration', 'Long-term brand integration', 'Brand Integration', '2024-07-01', '2024-12-31', 25000, 'Active', 6);

-- SAMPLE DATA: DELIVERABLES
INSERT INTO Deliverables (campaign_id, deliverable_type, platform, deadline, submission_date, approval_date, status, content_link, requirements)
VALUES
(1, 'Instagram Post', 'Instagram', '2024-06-15', '2024-06-14', '2024-06-14', 'Approved', 'https://instagram.com/post/1', 'High-quality product showcase'),
(1, 'TikTok Video', 'TikTok', '2024-06-22', '2024-06-20', '2024-06-20', 'Approved', 'https://tiktok.com/video/1', 'Trending sound, 60 seconds'),
(1, 'YouTube Review', 'YouTube', '2024-07-10', NULL, NULL, 'Pending', NULL, 'Detailed product review, 10 mins'),
(2, 'Instagram Reels', 'Instagram', '2024-07-31', '2024-07-30', '2024-07-30', 'Approved', 'https://instagram.com/reel/1', 'Fashion styling, trending audio'),
(2, 'Blog Post', 'Blog', '2024-08-15', '2024-08-20', NULL, 'Late', 'https://blog.com/fashion', 'SEO optimized, 2000 words'),
(3, 'Instagram Story Series', 'Instagram', '2024-06-30', '2024-06-28', '2024-06-29', 'Approved', 'https://instagram.com/story/1', '10 story frames minimum'),
(4, 'Product Review Video', 'YouTube', '2024-07-30', '2024-07-28', '2024-07-29', 'Approved', 'https://youtube.com/watch?v=1', 'Authentic review, 5-8 mins'),
(5, 'Twitch Stream', 'Twitch', '2024-08-20', NULL, NULL, 'Pending', NULL, 'Live gameplay, 4 hours minimum'),
(6, 'Carousel Post', 'Instagram', '2024-07-20', '2024-07-19', '2024-07-19', 'Approved', 'https://instagram.com/carousel/1', '5-10 slides, educational content');

-- SAMPLE DATA: PAYMENTS
INSERT INTO Payments (campaign_id, amount, payment_date, due_date, status, payment_method, transaction_id, invoice_number)
VALUES
(1, 15000, '2024-06-05', '2024-06-10', 'Completed', 'Bank Transfer', 'TXN001', 'INV-2024-001'),
(2, 12000, NULL, '2024-07-20', 'Pending', 'Bank Transfer', NULL, 'INV-2024-002'),
(3, 10000, '2024-05-03', '2024-05-10', 'Completed', 'PayPal', 'TXN003', 'INV-2024-003'),
(4, 8000, '2024-07-10', '2024-07-10', 'Completed', 'Bank Transfer', 'TXN004', 'INV-2024-004'),
(5, 20000, NULL, '2024-08-05', 'Pending', 'Bank Transfer', NULL, 'INV-2024-005'),
(6, 25000, '2024-07-05', '2024-07-15', 'Completed', 'Bank Transfer', 'TXN006', 'INV-2024-006');

-- SAMPLE DATA: PERFORMANCE METRICS
INSERT INTO Performance_Metrics (campaign_id, influencer_id, reach, impressions, clicks, conversions, engagement, roi)
VALUES
(1, 1, 500000, 1200000, 45000, 2250, 5.2, 18.5),
(2, 2, 750000, 1800000, 72000, 3600, 4.8, 22.3),
(3, 4, 400000, 950000, 38000, 1900, 5.9, 25.1),
(4, 5, 300000, 720000, 28800, 1440, 4.5, 15.2),
(5, 6, 600000, 1400000, 56000, 2800, 5.5, 19.8),
(6, 3, 550000, 1300000, 52000, 2600, 6.1, 24.5);



-- QUERIES:

-- 1. Get All Influencers with Campaign Count
-- Experience & earnings analysis (LEFT JOIN, GROUP BY, aggregate functions (COUNT, SUM), handling NULL values)
-- Insight: Influencers with higher campaign counts tend to have greater earning potential, indicating that experience and reliability strongly influence brand collaboration frequency.

SELECT 
    i.influencer_id,
    i.name,
    i.username,
    i.follower_count,
    i.engagement_rate,
    COUNT(c.campaign_id) as total_campaigns,
    SUM(c.budget) as total_budget_earned
FROM Influencer i
LEFT JOIN Campaigns c ON i.influencer_id = c.influencer_id
GROUP BY i.influencer_id
ORDER BY total_campaigns DESC;


-- 2. Overdue Deliverables Alert
-- Time based exception handling (Multi-table JOINs, DATE functions (CURDATE, DATEDIFF), conditional filtering using WHERE clause)
-- Insight: This query highlights campaigns at risk due to missed deadlines, enabling proactive intervention to maintain brand reputation and influencer accountability.

SELECT 
    d.deliverable_id,
    c.campaign_name,
    i.name as influencer_name,
    d.deliverable_type,
    d.deadline,
    DATEDIFF(CURDATE(), d.deadline) as days_overdue,
    d.status,
    b.brand_name
FROM Deliverables d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
JOIN Influencer i ON c.influencer_id = i.influencer_id
JOIN Brands b ON c.brand_id = b.brand_id
WHERE d.status IN ('Pending', 'Late', 'Overdue')
AND d.deadline < CURDATE()
ORDER BY days_overdue DESC;



-- 3. Pending Payments Report
-- Financial delay detection (Complex JOINs across multiple tables, date comparison, financial data filtering)
-- Insight: The results identify delayed payments across campaigns, improving financial transparency and helping influencers track outstanding dues efficiently.

SELECT 
    p.payment_id,
    b.brand_name,
    i.name as influencer_name,
    c.campaign_name,
    p.amount,
    p.due_date,
    DATEDIFF(CURDATE(), p.due_date) as days_pending,
    p.invoice_number,
    p.status
FROM Payments p
JOIN Campaigns c ON p.campaign_id = c.campaign_id
JOIN Brands b ON c.brand_id = b.brand_id
JOIN Influencer i ON c.influencer_id = i.influencer_id
WHERE p.status = 'Pending'
AND p.due_date < CURDATE()
ORDER BY p.due_date ASC;



-- 4. Campaign Performance Analysis
-- Conditional aggregation using (CASE, GROUP BY, LEFT JOINs, business metric calculation)
-- Insight: Campaigns with higher deliverable approval rates generally achieve better reach and ROI, showing a direct relationship between execution quality and performance.

SELECT 
    c.campaign_id,
    c.campaign_name,
    b.brand_name,
    i.name AS influencer_name,
    c.budget,

    COUNT(d.deliverable_id) AS total_deliverables,

    SUM(CASE 
        WHEN d.status = 'Approved' THEN 1 
        ELSE 0 
    END) AS approved_deliverables,

    SUM(CASE 
        WHEN d.status IN ('Pending', 'Late', 'Overdue') THEN 1 
        ELSE 0 
    END) AS pending_deliverables,

    ROUND(
        100 * SUM(CASE WHEN d.status = 'Approved' THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(d.deliverable_id), 0), 
        2
    ) AS completion_rate,

    MAX(pm.reach) AS reach,
    MAX(pm.impressions) AS impressions,
    MAX(pm.roi) AS roi

FROM Campaigns c
JOIN Brands b ON c.brand_id = b.brand_id
JOIN Influencer i ON c.influencer_id = i.influencer_id
LEFT JOIN Deliverables d ON c.campaign_id = d.campaign_id
LEFT JOIN Performance_Metrics pm ON c.campaign_id = pm.campaign_id

GROUP BY 
    c.campaign_id,
    c.campaign_name,
    b.brand_name,
    i.name,
    c.budget

ORDER BY c.created_at DESC;



-- 5. Influencer Earnings Report
-- Income breakdown (DISTINCT aggregation, CASE expressions, financial summarization, GROUP BY analysis)
-- Insight: Influencers receiving timely payments and maintaining strong brand ratings demonstrate higher average ROI, reinforcing the importance of financial reliability in long-term partnerships.

SELECT 
    i.influencer_id,
    i.name,
    i.username,
    i.follower_count,
    COUNT(DISTINCT c.campaign_id) as total_campaigns,
    SUM(c.budget) as total_earnings_potential,
    SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END) as amount_received,
    SUM(CASE WHEN p.status = 'Pending' THEN p.amount ELSE 0 END) as amount_pending,
    ROUND(AVG(b.rating), 2) as avg_brand_rating,
    ROUND(SUM(pm.roi) / COUNT(DISTINCT pm.campaign_id), 2) as avg_roi
FROM Influencer i
LEFT JOIN Campaigns c ON i.influencer_id = c.influencer_id
LEFT JOIN Payments p ON c.campaign_id = p.campaign_id
LEFT JOIN Brands b ON c.brand_id = b.brand_id
LEFT JOIN Performance_Metrics pm ON c.campaign_id = pm.campaign_id
GROUP BY i.influencer_id
ORDER BY total_earnings_potential DESC;


-- 6. Brand Performance Analysis
-- Budget optimization (Budget arithmetic calculations, aggregate functions, multi-table JOINs, performance analysis)
-- Insight: Brands with balanced budget utilization and consistent influencer engagement achieve higher ROI, indicating efficient allocation of marketing resources.

SELECT 
    b.brand_id,
    b.brand_name,
    b.industry,
    b.budget_allocated,
    b.budget_spent,
    b.budget_allocated - b.budget_spent as budget_remaining,
    COUNT(DISTINCT c.campaign_id) as total_campaigns,
    AVG(b.rating) as brand_rating,
    ROUND(SUM(pm.reach) / COUNT(DISTINCT c.campaign_id), 0) as avg_reach,
    ROUND(AVG(pm.roi), 2) as avg_roi,
    COUNT(DISTINCT i.influencer_id) as total_influencers_worked_with
FROM Brands b
LEFT JOIN Campaigns c ON b.brand_id = c.brand_id
LEFT JOIN Influencer i ON c.influencer_id = i.influencer_id
LEFT JOIN Performance_Metrics pm ON c.campaign_id = pm.campaign_id
GROUP BY b.brand_id
ORDER BY b.budget_spent DESC;


-- 7. Deliverable Status Summary
-- Completion matrix (Subqueries, GROUP BY on derived data, percentage calculations, status-based aggregation)
-- Insight: A higher percentage of approved deliverables reflects smoother campaign execution, while increased pending or late statuses signal potential operational bottlenecks.

SELECT 
    c.campaign_name,
    b.brand_name,
    i.name as influencer_name,
    d.status,
    COUNT(d.deliverable_id) as count,
    ROUND(100 * COUNT(d.deliverable_id) / (SELECT COUNT(*) FROM Deliverables WHERE campaign_id = c.campaign_id), 2) as percentage
FROM Deliverables d
JOIN Campaigns c ON d.campaign_id = c.campaign_id
JOIN Brands b ON c.brand_id = b.brand_id
JOIN Influencer i ON c.influencer_id = i.influencer_id
GROUP BY c.campaign_id, d.status
ORDER BY c.campaign_name, d.status;


-- 8. Top Performing Influencers
-- Advance analytics (Window functions (DENSE_RANK), aggregation, ranking logic, performance comparison)
-- Insight: Influencers ranked higher by ROI consistently convert engagement into measurable outcomes, making them ideal candidates for future high-impact campaigns.

SELECT 
    i.influencer_id,
    i.name,
    i.username,
    i.follower_count,
    i.engagement_rate,
    COUNT(DISTINCT c.campaign_id) as campaigns,
    SUM(pm.reach) as total_reach,
    SUM(pm.conversions) as total_conversions,
    ROUND(AVG(pm.roi), 2) as avg_roi,
    DENSE_RANK() OVER (ORDER BY AVG(pm.roi) DESC) as roi_rank
FROM Influencer i
LEFT JOIN Campaigns c ON i.influencer_id = c.influencer_id
LEFT JOIN Performance_Metrics pm ON c.campaign_id = pm.campaign_id
WHERE pm.campaign_id IS NOT NULL
GROUP BY i.influencer_id
ORDER BY avg_roi DESC
LIMIT 10;


-- 9. Payment Status Dashboard
-- Summary dashboard (GROUP BY aggregation, statistical analysis (SUM, AVG, MIN, MAX), dashboard-style reporting)
-- Insight: The payment distribution reveals overall financial health of collaborations, helping stakeholders quickly assess payment efficiency and risk exposure.

SELECT 
    p.status,
    COUNT(p.payment_id) as total_payments,
    SUM(p.amount) as total_amount,
    AVG(p.amount) as avg_payment,
    MIN(p.amount) as min_payment,
    MAX(p.amount) as max_payment
FROM Payments p
GROUP BY p.status;


-- 10. Campaign Timeline Analysis
-- Schedule analytics (Date arithmetic (DATEDIFF), conditional counting, timeline and schedule analysis)
-- Insight: Longer campaign durations do not always ensure better completion rates, emphasizing the need for effective timeline planning and milestone monitoring.

SELECT 
    c.campaign_id,
    c.campaign_name,
    b.brand_name,
    i.name as influencer,
    c.start_date,
    c.end_date,
    DATEDIFF(c.end_date, c.start_date) as duration_days,
    c.status,
    COUNT(d.deliverable_id) as deliverables,
    COUNT(CASE WHEN d.deadline <= CURDATE() AND d.status != 'Approved' THEN 1 END) as overdue_deliverables
FROM Campaigns c
JOIN Brands b ON c.brand_id = b.brand_id
JOIN Influencer i ON c.influencer_id = i.influencer_id
LEFT JOIN Deliverables d ON c.campaign_id = d.campaign_id
GROUP BY c.campaign_id
ORDER BY c.start_date ASC;



-- 11. Brand finds best influencers for a niche
-- Top performing brands (Multi-table JOINs, GROUP BY aggregation, AVG function, filtering using WHERE clause, ORDER BY with multiple criteria, decision-support query)
-- Insight: Within a specific niche, influencers with higher average ROI and engagement rates deliver better value, enabling brands to make data-driven influencer selection decisions.

SELECT 
    i.influencer_id,
    i.name,
    i.niche,
    i.follower_count,
    i.engagement_rate,
    ROUND(AVG(pm.roi), 2) AS avg_roi
FROM Influencer i
JOIN Performance_Metrics pm ON i.influencer_id = pm.influencer_id
JOIN Campaigns c ON pm.campaign_id = c.campaign_id
WHERE i.niche = 'Technology'
GROUP BY i.influencer_id
ORDER BY avg_roi DESC, engagement_rate DESC
LIMIT 5;





-- VIEW: Precomputed Influencer Performance Summary
-- Purpose: Abstracts complex joins and aggregations to provide a reusable,
--          simplified view of influencer campaign performance and ROI.

CREATE VIEW Influencer_Performance_View AS
SELECT 
    i.name,
    COUNT(c.campaign_id) AS campaigns,
    AVG(pm.roi) AS avg_roi
FROM Influencer i
JOIN Campaigns c ON i.influencer_id = c.influencer_id
JOIN Performance_Metrics pm ON c.campaign_id = pm.campaign_id
GROUP BY i.influencer_id;

-- To show
SELECT * FROM Influencer_Performance_View;






-- STORED PROCEDURE: Retrieve Top Influencers by Niche
-- Purpose: Encapsulates influencer discovery logic into a reusable database
--          routine that returns top-performing influencers based on ROI.

DELIMITER //

CREATE PROCEDURE GetTopInfluencersByNiche(IN niche_name VARCHAR(50))
BEGIN
    SELECT i.name, AVG(pm.roi) AS avg_roi
    FROM Influencer i
    JOIN Performance_Metrics pm ON i.influencer_id = pm.influencer_id
    WHERE i.niche = niche_name
    GROUP BY i.influencer_id
    ORDER BY avg_roi DESC
    LIMIT 5;
END //

DELIMITER ;

-- call the stored procedure
CALL GetTopInfluencersByNiche('Fitness');

