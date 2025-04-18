# Executive Summary

## Introduction / Background

This project addresses the need to tailor customer perks for TravelTide's loyalty program by analyzing customer behavior and characteristics. The goal is to enhance personalization in perk assignment, improving customer satisfaction and retention.

## Objectives

The aim was to segment customers into distinct groups based on their travel behavior and demographic attributes, and assign the most relevant perks to each segment.

## Methodology

We used K-means clustering to group customers into five segments. Prior to clustering, data was cleaned, scaled, and transformed (e.g., one-hot encoding for categorical features). We evaluated each segment's average behavior across key metrics such as booking activity, discounts used, age, family status, and session information. However, the clusters did not show strong, clear-cut distinctions, and there was no sharp boundary between groups. Despite this, the clusters revealed enough behavioral patterns to guide a reasoned perk assignment.

## Irregularities

We observed some data irregularities, such as users with a negative number of nights and session durations of exactly 120 minutes which were carefully handled.

## Key findings

- Cluster 0 - Older group (avg age ~51), high percentage married and with children. Medium engagement, good hotel spending.
- Cluster 1 - Youngest group (~31), low spending, fewer hotel/flight bookings.
- Cluster 2 - Highest in: flight_booked, hotel_booked, checked_bags, money_spent_hotel, nights, rooms. Very active travelers, book many flights/hotels, high spending.
- Cluster 3 - Also high in flight_booked, hotel_booked, and money_spent_hotel, though slightly less than cluster 2. Long stays, many rooms.
- Cluster 4 - Mid-range travelers: medium hotel/flight bookings, moderate nights and spending.
Mostly male, average age ~42.

## Recommendations / Next Steps

d1. A/B test perk effectiveness within each segment to validate assignments.
2. Monitor perk redemptions to further refine segmentation and improve targeting.




