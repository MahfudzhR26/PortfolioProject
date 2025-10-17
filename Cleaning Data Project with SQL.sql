#In this project, I downloaded the data from Github
#Performed the data cleaning as per the queries below.


#1
-- Cleaning data in SQL Queries

Select * 
From SQLTutorial..Nashville_HousingData


#2
-- Standardize Date Format

Select SaleDate 
From SQLTutorial..Nashville_HousingData

ALTER TABLE SQLTutorial..Nashville_HousingData
ALTER COLUMN SaleDate date;



#3
-- Populate Property Adress Data

Select *
From SQLTutorial..Nashville_HousingData
--Where PropertyAddress is NULL
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQLTutorial..Nashville_HousingData a
JOIN SQLTutorial..Nashville_HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL


UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQLTutorial..Nashville_HousingData a
JOIN SQLTutorial..Nashville_HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL


#4
-- Breaking out address into Individual Columns (Address, City, State)

Select *
From SQLTutorial..Nashville_HousingData
--Where PropertyAddress is NULL
--Order by ParcelID

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From SQLTutorial..Nashville_HousingData


--add a new column for splitadresss

ALTER TABLE SQLTutorial..Nashville_HousingData
ADD PropertySplitAddress Nvarchar(225);

Update SQLTutorial..Nashville_HousingData
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


ALTER TABLE SQLTutorial..Nashville_HousingData
ADD PropertySplitCity Nvarchar(225);

Update SQLTutorial..Nashville_HousingData
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

Select *
From SQLTutorial..Nashville_HousingData


#5
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From SQLTutorial..Nashville_HousingData
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From SQLTutorial..Nashville_HousingData

UPDATE SQLTutorial..Nashville_HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select *
From SQLTutorial..Nashville_HousingData


#6
-- Remove duplicates
-- Through creating CTE

WITH RowNUMCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From SQLTutorial..Nashville_HousingData
--Order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--order by PropertyAddress


#7
-- Delete Unused Columns

Select *
From SQLTutorial..Nashville_HousingData


ALTER TABLE SQLTutorial..Nashville_HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
