
-- Data Cleaning Project--

Select *
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

-- Delete Duplicate Data--

With ROWNUMCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY Title, 
				Star_rating,
				Review,
				Customer_date
				Order by
					F1 ) row_num

From Data_cleaning.dbo.Etsy_Reveiw_Data_2
)

Delete
From ROWNUMCTE
where row_num>1


-- Split Customer and date to separate column with changing date to date data type--


Select PARSENAME(REPLACE(Customer_date, ',','.'),4),
       PARSENAME(REPLACE(Customer_date, ',','.'),2)+PARSENAME(REPLACE(Customer_date, ',','.'),1)
  
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Select Customer_date, REPLACE(Customer_date, ',                     ,', ',')
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Alter Table Etsy_Reveiw_Data_2
ADD Customer_Date_Updated nvarchar(255)

Update Etsy_Reveiw_Data_2
SET Customer_Date_Updated=REPLACE(Customer_date, ',                     ,', ',')

Alter Table Etsy_Reveiw_Data_2
ADD Customer_name nvarchar(255)

Alter Table Etsy_Reveiw_Data_2
Add Review_Date Date
 

Update Etsy_Reveiw_Data_2
Set Customer_name=PARSENAME(REPLACE(Customer_Date_Updated, ',','.'),3)

Update Etsy_Reveiw_Data_2
Set Review_Date=CONVERT(Date, PARSENAME(REPLACE(Customer_date, ',','.'),2)+PARSENAME(REPLACE(Customer_date, ',','.'),1))

Select Customer_date, SUBSTRING(Customer_date, 1, CHARINDEX(',',Customer_date,-1)) as Customer, Customer_name
From Data_cleaning.dbo.Etsy_Reveiw_Data_2
Where Customer_name is Null

Select Customer_Date_Updated, SUBSTRING(Customer_Date_Updated, 1, CHARINDEX(',',Customer_Date_Updated,-1)) as Customer, Customer_name
From Data_cleaning.dbo.Etsy_Reveiw_Data_2
Where Customer_name is Null


UPDATE Etsy_Reveiw_Data_2
Set Customer_name=SUBSTRING(Customer_Date_Updated, 1, CHARINDEX(',',Customer_Date_Updated,-1))
Where Customer_name is Null

Update Etsy_Reveiw_Data_2
Set Customer_name= TRIM(Customer_name)

Select Customer_Date_Updated, Customer_name
From Data_cleaning.dbo.Etsy_Reveiw_Data_2
Where Customer_name= '  '

Update Etsy_Reveiw_Data_2
Set Customer_name= Customer_Date_Updated
Where Customer_name= '  '

Select Customer_Date_Updated, CONVERT(Date, PARSENAME(REPLACE(Customer_Date_Updated, ',','.'),2)+','+PARSENAME(REPLACE(Customer_Date_Updated, ',','.'),1))as R_Date, Review_Date
From Data_cleaning.dbo.Etsy_Reveiw_Data_2
Where Review_Date is Null

Update Etsy_Reveiw_Data_2
Set Review_Date=CONVERT(Date, PARSENAME(REPLACE(Customer_Date_Updated, ',','.'),2)+','+PARSENAME(REPLACE(Customer_Date_Updated, ',','.'),1))
Where Review_Date is Null


-- Update Price and converting it to Float Data Type--

Select PARSENAME(REPLACE(Price, ',','.'),2)+'.'+PARSENAME(REPLACE(Price, ',','.'),1) as Price_updated
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Alter Table Etsy_Reveiw_Data_2
ADD Price_updated nvarchar(255)

Update Etsy_Reveiw_Data_2
Set Price_updated=TRIM(PARSENAME(REPLACE(Price, ',','.'),2)+'.'+PARSENAME(REPLACE(Price, ',','.'),1))


Select Price_updated, Convert(float, Trim('USD'+'+' from Price_updated))
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Update Etsy_Reveiw_Data_2
SET Price_updated=Convert(float, Trim('USD'+'+' from Price_updated))

--Convert star rating to floating number--

Select Overall_star, SUBSTRING(Overall_star, 1, CHARINDEX(' ',Overall_star,-1)) as Overall_star_updated, 
		Trim('out of'+ 'stars' from SUBSTRING(Overall_star, CHARINDEX(' ',Overall_star,+1), len(Overall_star))) as Out_of
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Alter Table Etsy_Reveiw_Data_2
ADD Overall_star_updated nvarchar(255)

Alter Table Etsy_Reveiw_Data_2
ADD Out_of nvarchar(255)

Update Etsy_Reveiw_Data_2
SET Overall_star_updated=Convert(float, SUBSTRING(Overall_star, 1, CHARINDEX(' ',Overall_star,-1)))

Update Etsy_Reveiw_Data_2
Set Out_of=Convert(float, Trim('out of'+ 'stars' from SUBSTRING(Overall_star, CHARINDEX(' ',Overall_star,+1), len(Overall_star))))

Select Star_rating, SUBSTRING(Star_rating, 1, CHARINDEX(' ',Star_rating,-1)) as Individual_Star_rating 
From Data_cleaning.dbo.Etsy_Reveiw_Data_2

Alter Table Etsy_Reveiw_Data_2
ADD Individual_Star_rating nvarchar(255)


Update Etsy_Reveiw_Data_2
SET Individual_Star_rating=Convert(float, SUBSTRING(Star_rating, 1, CHARINDEX(' ',Star_rating,-1)))


--Delete Unnecessary Column--

Alter Table Etsy_Reveiw_Data_2
Drop Column Price, Overall_star, Star_rating,Customer_date, Customer_Date_Updated

Select *
From Data_cleaning.dbo.Etsy_Reveiw_Data_2