-- Product Ranking
Select Item_Type, total_sales,
RANK() OVER(ORDER BY total_sales DESC) As Sales_Rank
FROM (
select item_type,
SUM(Item_Outlet_Sales) As total_sales
from blinkit_grocery
group by item_type
) t;
/* Short Insight - 
-> Fruits and Vegetables have highest sales of ~2820K ranking on 1st position compares to other item_type.
-> This indicates high customer footfall but also high risk of perishability.
=> Actions: 
-> Fruits and Vegetables has highest sales so ensure daily fresh refills and zero stock-outs.
-> Implement 'Cross-Selling' by recommending low-ranking items like (Dairy or Baking goods bundle 
   with Fruits and veggies with title "Make a Salad Combo") to customers buying fresh produce to
   increase Basket Value.
*/
-- Outlet Wise Contribution
Select Outlet_Identifier,
SUM(Item_Outlet_Sales) As Total_Sales,
CONCAT(ROUND(SUM(Item_Outlet_Sales) * 100.0 / SUM(SUM(Item_Outlet_Sales)) OVER(), 2), '%') As Sales_Contriution
from blinkit_grocery
group by Outlet_Identifier
Order by Total_Sales DESC;
/* Short Insight - 
-> OUT027 has total_sales of ~3453K contributed highest sales of 18.58% among all outlet_identifiers.
This indicating OUT027 has highest contribution while OUT010 & OUT019 contributed literally lowest sales.
Action:
-> Perform a 'Store Type' comparison to check if low sales are due to smaller store size or poor location.
-> For OUT010 & OUT019: Introduce Offers or Promotions to increase footfall and test if demand exists.
-> Replicate OUT027 products placement strategy across all outlets to maintain their growth. 
*/
-- Running Total 
Select Outlet_Establishment_Year,
SUM(Item_Outlet_Sales) As Yearly_Sales,
SUM(SUM(Item_Outlet_Sales)) OVER(ORDER BY Outlet_Establishment_Year DESC) AS Running_Total
from blinkit_grocery
group by Outlet_Establishment_Year
order by Running_Total DESC;
/* Short Insight
-> Established outlet (1985) have nearly 2x sales compare to recent outlet(2009).
-> There is downward trend in yearly sales contribution as we look at the newer establishment.
=> Action:
-> Launch aggressive marketing compaign like discounts, welcome bonus, offers for 
   low performing outlets to bridge the revenue gap.
-> Investigate if newer established outlets have limited footprints or limited inventory
   compared to legacy outlets.
*/
-- Category-wise Performance in Locations
Select Item_Type, Outlet_Location_Type, Total_Sales,
RANK() OVER(PARTITION BY Outlet_Location_Type
				ORDER BY Total_Sales DESC) As Rank_City
From (
Select Item_type, Outlet_Location_Type,
SUM(Item_Outlet_Sales) As Total_Sales
From blinkit_grocery
group by item_type, Outlet_Location_Type
) t;
/* Short Insights
-> Fruits and Vegetables dominating in both Tier 1 & Tier 3 Location with total sales of (~663K & ~1205K).
-> Snacks Foods has highest sale of ~955K in Tier 2 Location.
-> Seafood has lowest sales in all tiers.
=> Actions:
-> Run aggressive cross sales compaigns between Snacks and cold drinks to maximize the sales in tier 2 city.
-> Priortize high speed supply chain for fresh produce to meet huge demand (~1205K sales).
-> Reduce inventory holding for Seafood item to cut down on storage costs and wastage.
*/
-- Avg vs Actual
Select Item_Type,
Item_Outlet_Sales As Sales,
AVG(Item_Outlet_Sales) OVER(PARTITION BY Item_Type) As Avg_Sales,
Item_Outlet_Sales - AVG(Item_Outlet_Sales) OVER(PARTITION BY Item_Type) As Deviation
From blinkit_grocery
order by Item_type, Deviation DESC;
/* Short Insight
-> Sales are concentrated in a few categories, while others are underperforming.
=> Action :
-> Increase focus and stock for high-performing items, and optimize or reduce lo-performing ones.
*/
