## Detailed Report

### 1. Introduction / Background

TravelTide aims to enhance its loyalty program by assigning personalized perks that resonate with user behavior. With a growing user base and diverse traveler profiles, one-size-fits-all incentives are no longer effective. This project supports the strategic initiative of personalization by applying machine learning to segment customers.

### 2. Objectives

The primary objective was to explore customer segmentation using behavioral and demographic data to assign perks that could drive engagement. A secondary goal was to build a foundation for scalable, data-driven personalization strategies.

### 3. Methodology

#### Data Preparation

* **Data Type Formatting**  
  We reviewed and corrected the data types for various columns. Dates were converted into `datetime` format, and numerical fields were standardized for consistency.  
* **Missing Values and Duplicates**  
  We checked for null values and duplicates. A significant portion of null values originated from joining multiple SQL tables. These were not true missing values but the result of one-to-many or left joins, where some attributes did not apply to all users. After inspection, we retained the data but excluded non-informative columns from the clustering process.  
* **Feature Engineering**  
  To enhance the model’s ability to detect behavioral patterns, we added two new features:  
  * **`age`**: Calculated by subtracting the year of birth from the current year.  
  * **`session_duration`**: Derived from the difference between session start and end times.

#### **Handling Irregularities**

* **Negative Nights**  
  These occurred due to check-out dates being recorded one day *before* the check-in date. However, the check-in time and flight departure time aligned well, and the check-out time was always at 11:00 AM. We inferred this was a recording issue and corrected it by shifting the check-out date one day forward. This change turned negative values into valid positive ones, allowing us to preserve the data.  
* **Session Durations of Exactly 120 Minutes**  
  A large number of users had session durations recorded as exactly 120 minutes. This value appeared too consistently to reflect real behavior. After investigation, we concluded it likely represented **system-imposed idle time**. To mitigate distortion in engagement analysis, we applied **capping**:  
  * Any session longer than **30 minutes** was reassigned a value of **30 minutes**.  
  * This approach retained the records for modeling while avoiding misleading engagement signals.

#### **One-Hot Encoding**

Categorical variables, such as gender, were converted into binary features using **one-hot encoding**. This allowed the clustering algorithm to interpret non-numeric attributes without imposing artificial order.

#### **Scaling**

K-means clustering is sensitive to feature scale. We applied **standard scaling** (mean \= 0, standard deviation \= 1\) to all numerical features to ensure equal contribution of each feature to the distance calculation.

#### **Dimensionality Reduction with PCA**

To aid in visualization and better understand the data structure, we applied **Principal Component Analysis (PCA)**.

* PCA helped reduce the feature space while preserving the majority of variance.  
* We retained **ten principal components**, which together captured more than 90% of the dataset’s variance.  
* These components were used for plotting, while clustering was performed on the original scaled features.

### 4. Clustering

We applied **K-means clustering** to segment users based on travel and demographic behaviors.  
To select the optimal number of clusters, we tested multiple values of **K** and evaluated performance using:

* **Elbow Method**: Observed the point where adding more clusters led to diminishing returns in within-cluster sum of squares.  
* **Silhouette Score**: Measured how similar each point was to its own cluster versus others.

Although the results did not indicate a single perfect value, a solution with **five clusters** was:

* Reasonably supported by both metrics  
* Aligned with the **five available perks**, making the outcome directly actionable.

**Note**: While the clusters did not show strong, clear boundaries, they revealed meaningful behavioral trends that supported a rather reasoned perk assignment.

### 5. Key Findings and Perk Assignments

| Cluster | Profile Summary  | Assigned Perk  | Reasoning |
| :---: | ----- | ----- | ----- |
| Cluster 0 | Older group (\~51), high % married with children. Medium engagement, good hotel spending | 🧳 Free checked bag | Family travelers often bring more luggage. |
| Cluster 1 |  Youngest group (\~31), low spending, low hotel/flight bookings.  | 💸 Exclusive discounts  | Young users are more price-sensitive. |
| Cluster 2 | Most active: highest in flight/hotel bookings, checked bags, and hotel spending.  | 🏨 One night free hotel with flight  |  Frequent travelers benefit from hotel rewards. |
| Cluster 3 | Also high activity (slightly lower than Cluster 2). Long stays, multiple rooms. | 🍽️ Free hotel meal | Long stays suggest meals would be appreciated. |
| Cluster 4 |  Mid-range engagement, moderate spending. Mostly male, avg. age \~42 | 🚫 No cancellation fee |  Flexibility is likely valued by these users. |

