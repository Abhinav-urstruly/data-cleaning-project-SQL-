/* cleaning data in sql*/
select * from abhinavdb.dbo.NashVilleHousing;
-- Standartixe data
select SaleDate,CONVERT(Date,SaleDate) from abhinavdb.dbo.NashVilleHousing;

Update abhinavdb.dbo.NashVilleHousing SET SaleDate=CONVERT(Date,SaleDate);

ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add SaleDateConverted Date;

Update abhinavdb.dbo.NashVilleHousing SET SaleDateConverted=CONVERT(Date,SaleDate);

select SaleDateConverted,CONVERT(Date,SaleDate) from abhinavdb.dbo.NashVilleHousing;
-------------------------------------------------------------------------------------------------------------------------------------
--Populate Property Address data
select PropertyAddress  from abhinavdb.dbo.NashVilleHousing;
select * from abhinavdb.dbo.NashVilleHousing where PropertyAddress is null;

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from abhinavdb.dbo.NashVilleHousing a
JOIN abhinavdb.dbo.NashVilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from abhinavdb.dbo.NashVilleHousing a
JOIN abhinavdb.dbo.NashVilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

Select PropertyAddress from abhinavdb.dbo.NashVilleHousing where PropertyAddress is null ;


---------------------------------------------------------------------------------------------------------
-- Breaking out address into Individual Columns(Address,City,State)
select PropertyAddress  from abhinavdb.dbo.NashVilleHousing;

select
SUBSTRING( PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN( PropertyAddress)) as Address

from abhinavdb.dbo.NashVilleHousing;

ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update abhinavdb.dbo.NashVilleHousing SET PropertySplitAddress=SUBSTRING( PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add PropertySplitCity Nvarchar(255);

Update abhinavdb.dbo.NashVilleHousing SET PropertySplitCity=SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN( PropertyAddress));

select * from abhinavdb.dbo.NashVilleHousing;

----------------------------------------OwnerAddress Populating ----------------------------------------

select OwnerAddress from abhinavdb.dbo.NashVilleHousing;

select PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from abhinavdb.dbo.NashVilleHousing;



ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add OwnerSplitState Nvarchar(255);
Update abhinavdb.dbo.NashVilleHousing SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1);

ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add OwnerCity Nvarchar(255) ;
Update abhinavdb.dbo.NashVilleHousing SET OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE abhinavdb.dbo.NashVilleHousing
Add OwnerSplitAddress Nvarchar(255);
Update abhinavdb.dbo.NashVilleHousing SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);
select * from abhinavdb.dbo.NashVilleHousing;
----------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No
select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from abhinavdb.dbo.NashVilleHousing group by SoldAsVacant order by 2;


select SoldAsVacant,CASE When SoldAsVacant='Y' THEN 'Yes'
						When SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
						END

from abhinavdb.dbo.NashVilleHousing;


Update abhinavdb.dbo.NashVilleHousing
SET SoldAsVacant=CASE When SoldAsVacant='Y' THEN 'Yes'
						When SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
						END


select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from abhinavdb.dbo.NashVilleHousing group by SoldAsVacant order by 2;

------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates
WITh RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
	ORDER BY UniqueID) AS row_num
from abhinavdb.dbo.NashVilleHousing)


--DElETE  from RowNumCTE where row_num>1;
select * from RowNumCTE where row_num>1;
--------------------------------------------------------------------------------------------------------------------------------
-- Delete unused Columns
 select * from abhinavdb.dbo.NashVilleHousing;

 ALTER TABLE abhinavdb.dbo.NashVilleHousing
 DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

 
 ALTER TABLE abhinavdb.dbo.NashVilleHousing
 DROP COLUMN OwnerSplitCity

 ALTER TABLE abhinavdb.dbo.NashVilleHousing
 DROP COLUMN SaleDate

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --
