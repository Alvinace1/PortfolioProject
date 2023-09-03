SELECT *
FROM nashvilleHousing

--Cleaning this data to make it more useful


--Propery formating the SaleDate data type from DateTime to Date

SELECT SaleDate
FROM nashvilleHousing

ALTER TABLE nashvilleHousing
ALTER COLUMN SaleDate DATE



--Auto Populating the property address based on ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (b.PropertyAddress, a.PropertyAddress)
FROM nashvilleHousing as a
JOIN nashvilleHousing as b
	ON a.ParcelId = b.ParcelId
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL (b.PropertyAddress, a.PropertyAddress)
FROM nashvilleHousing as a
JOIN nashvilleHousing as b
	ON a.ParcelId = b.ParcelId
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null



--Splitting the Property Address into different columns, (Address and City)

SELECT PropertyAddress, PARSENAME (REPLACE (PropertyAddress, ',', '.'), 2) as propertySplitAddress
, PARSENAME (REPLACE (PropertyAddress, ',', '.'), 1) as propertyCity
FROM nashvilleHousing


ALTER TABLE nashvilleHousing
ADD PropertySplitAddress NVARCHAR (255)

UPDATE nashvilleHousing
SET PropertySplitAddress = PARSENAME (REPLACE (PropertyAddress, ',', '.'), 2)

ALTER TABLE nashvilleHousing
ADD PropertyCity NVARCHAR (255)

UPDATE nashvilleHousing
SET PropertyCity = PARSENAME (REPLACE (PropertyAddress, ',', '.'), 1)

ALTER TABLE nashvilleHousing
DROP COLUMN PropertyAddress



--Splitting the OwnerAddress into different columns, (Address, City and State)

SELECT OwnerAddress, PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3) as OwnerSplitAddress
, PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2) as OwnerCity
,PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1) as OwnerState
FROM nashvilleHousing


ALTER TABLE nashvilleHousing
ADD OwnerSplitAddress NVARCHAR (255)

UPDATE nashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3)


ALTER TABLE nashvilleHousing
ADD OwnerCity NVARCHAR (255)

UPDATE nashvilleHousing
SET OwnerCity = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2)

ALTER TABLE nashvilleHousing
ADD OwnerState NVARCHAR (255)

UPDATE nashvilleHousing
SET OwnerState = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1)

ALTER TABLE nashvilleHousing
DROP COLUMN OwnerAddress



-- Replacing the Y/N with Yes/No in the SoldAsVacant Column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvilleHousing
GROUP BY SoldAsVacant

Select SoldAsVacant
, CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From nashvilleHousing

UPDATE nashvilleHousing
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From nashvilleHousing



SELECT *
FROM nashvilleHousing
