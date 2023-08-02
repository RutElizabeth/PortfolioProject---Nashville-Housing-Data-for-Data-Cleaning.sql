--- Portfolio focused on cleaning data in an analysis project // Portafolio enfocado a la limpieza de datos en un proyecto de analisis ---


--- Cleaning Data in SQL Queries, Call portfolio Project // Limpieza de datos en consultas SQL, proyecto de cartera de llamadas
Select *
From PortfolioProject.dbo.NashvilleHousing


--- Standardize Date Format // Formato de fecha estandarizado
select SaleDate, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)

Alter Table PortfolioProject.dbo.NashvilleHousing
add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Select *
From PortfolioProject.dbo.NashvilleHousing


--- Populate Property Address data // Rellenar datos de dirección de propiedad
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
from PortfolioProject.dbo.NashvilleHousing as A
join PortfolioProject.dbo.NashvilleHousing as B
       on A.ParcelID = B.ParcelID
       and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress is null

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as A
join PortfolioProject.dbo.NashvilleHousing as B
       on A.ParcelID = B.ParcelID
       and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(A.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as A
join PortfolioProject.dbo.NashvilleHousing as B
       on A.ParcelID = B.ParcelID
       and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress is null

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as A
join PortfolioProject.dbo.NashvilleHousing as B
       on A.ParcelID = B.ParcelID
       and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress is null


--- Breaking out Address into Individual Columns (Address, City, State) // Dividir la dirección en columnas individuales (dirección, ciudad, estado)
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select 
substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) as Address
from PortfolioProject.dbo.NashvilleHousing

select 
substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) as Address,
substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) 

Alter Table PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

---

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3), 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)

Alter Table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)

Alter Table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitsState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitsState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)

select *
from PortfolioProject.dbo.NashvilleHousing


--- Change Y and N to Yes and No in "Sold as Vacant" field // Cambie Y y N a Sí y No en el campo "Vendido como vacante"
select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant, 
CASE when SoldAsVacant = 'Y' then 'Yes'
          when SoldAsVacant = 'N' then 'No'
          ELSE SoldAsVacant 
          END
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
          when SoldAsVacant = 'N' then 'No'
          ELSE SoldAsVacant 
          END

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


--- Remove Duplicates // Eliminar duplicados
With RowNumCTE as(
select *, 
       ROW_NUMBER() OVER(
       PARTITION BY ParcelID,
       PropertyAddress, 
       SalePrice, 
       SaleDate,
       LegalReference
       ORDER BY
            UniqueID
             ) row_num
from PortfolioProject.dbo.NashvilleHousing
)
Select * 
from RowNumCTE
Where row_num > 1
Order by PropertyAddress


With RowNumCTE as(
select *, 
       ROW_NUMBER() OVER(
       PARTITION BY ParcelID,
       PropertyAddress, 
       SalePrice, 
       SaleDate,
       LegalReference
       ORDER BY
            UniqueID
             ) row_num
from PortfolioProject.dbo.NashvilleHousing
)
DELETE 
from RowNumCTE
Where row_num > 1


With RowNumCTE AS(
select *, 
       ROW_NUMBER() OVER(
       PARTITION BY ParcelID,
       PropertyAddress, 
       SalePrice, 
       SaleDate,
       LegalReference
       ORDER BY
            UniqueID
             ) row_num
from PortfolioProject.dbo.NashvilleHousing
)
SELECT*
from RowNumCTE
Where row_num > 1
Order by PropertyAddress


--- Delete Unused Columns // Eliminar columnas no utilizadas
select *
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

select *
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

select *
from PortfolioProject.dbo.NashvilleHousing
