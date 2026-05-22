/*
Cleaning Data in SQL Queries
*/


select *
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select CONVERT(Date,SaleDate) as SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing

--Update NashvilleHousing
--SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
from PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as SplitAddress
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as SplitCity
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing Add
PropertySplitAddress Nvarchar(255),
PropertySplitCity Nvarchar(255);

Update NashvilleHousing SET 
PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ),
PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




select *
from PortfolioProject.dbo.NashvilleHousing



select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing ADD 
OwnerSplitAddress Nvarchar(255),
OwnerSplitCity Nvarchar(255),
OwnerSplitState Nvarchar(255);



update NashvilleHousing SET 
OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



select *
from PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




select SoldAsVacant, 
       CASE when SoldAsVacant = 'Y' THEN 'Yes'
            when SoldAsVacant = 'N' THEN 'No'
            ELSE SoldAsVacant
       END
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	                    When SoldAsVacant = 'N' THEN 'No'
	                    ELSE SoldAsVacant
	               END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
select *, ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
		       PropertyAddress,
		       SalePrice,
		       SaleDate,
		       LegalReference
         ORDER BY  UniqueID ) row_num

from PortfolioProject.dbo.NashvilleHousing
)
select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



select *
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



