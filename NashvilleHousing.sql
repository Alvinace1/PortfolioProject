--Standardize date formart

Select *
From Portfolio.dbo.NashvilleHousing

Select SaleDate, CONVERT(date,SaleDate)
From Portfolio.dbo.NashvilleHousing

UPDATE Portfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD DateSold date

UPDATE Portfolio.dbo.NashvilleHousing
SET DateSold = CONVERT(date,SaleDate)



--Populate property address data

Select PropertyAddress
From Portfolio.dbo.NashvilleHousing
Where PropertyAddress is null

Select *
From Portfolio.dbo.NashvilleHousing
order by parcelID

Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL (b.PropertyAddress, a.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE b.PropertyAddress is null

UPDATE b
SET PropertyAddress = ISNULL (b.PropertyAddress, a.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE b.PropertyAddress is null



--Breaking out address into individual columns (city, state)

--PropertyAddress
Select PropertyAddress
From Portfolio.dbo.NashvilleHousing

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as PropertySplitAddress
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as PropertySplitState
From Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE Portfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PropertySplitState nvarchar(255)

UPDATE Portfolio.dbo.NashvilleHousing
SET PropertySplitState = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--OwnerAddress

Select OwnerAddress
From Portfolio.dbo.NashvilleHousing

Select 
PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3) OwnerSplitAddress
, PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2) OwnerSplitCity
, PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1) OwnerSplitState
From Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1)



--Replacing (Y/N) with (Yes/No)

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant

Select SoldAsVacant
, CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From Portfolio.dbo.NashvilleHousing

UPDATE Portfolio.dbo.NashvilleHousing
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From Portfolio.dbo.NashvilleHousing



--Removing duplicates

WITH CTE_RowNumber AS
(Select *, ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY ParcelID) RowNumber
From Portfolio.dbo.NashvilleHousing)

SELECT *
From CTE_RowNumber
Where RowNumber > 1



--Removing duplicates

SELECT *
FROM Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate