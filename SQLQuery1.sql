--Cleaning Data In Sql Queries

select*
from Housing

-- Standerize Data Format

select SaleDate,Convert(Date,SaleDate)
from Housing

Update Housing
set SaleDate=Convert(Date,SaleDate)

alter table Housing
add Sale_Date_Converted Date;

Update Housing
set Sale_Date_Converted=Convert(Date,SaleDate)

select Sale_Date_Converted,Convert(Date,SaleDate)
from Housing
-----------------------------------------------------------------------
--Populate Property Address

select*
from Housing
--where PropertyAddress is Null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------

--Breaking out Address into individual Columns (Address,City,State)

select PropertyAddress
from [Project 3].dbo.Housing


select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address 
,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City 
from Housing

alter table Housing
add Property_Split_Address Nvarchar(255);

Update Housing
set Property_Split_Address=SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

alter table Housing
add Property_Split_City nvarchar(255);

Update Housing
set Property_Split_City=SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select*
from Housing

	
-- the easy way to make a split

select OwnerAddress
from Housing

select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)as Adress,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2)as City,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)as State
from Housing

alter table Housing
add Owner_Split_Adress Nvarchar(255);

Update Housing
set Owner_Split_Adress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

alter table Housing
add Owner_Split_City nvarchar(255);

Update Housing
set Owner_Split_City=PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

alter table Housing
add Owner_Split_State nvarchar(255);

Update Housing
set Owner_Split_State=PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

select*
From Housing

---------------------------------------------------------------------------------------------------


-- Chancing Y and N to Yes And No in "Sold as Vacant"Field

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from Housing
group by SoldAsVacant
order by 2




select SoldAsVacant
,Case when SoldAsVacant = 'Y'then 'Yes'
 when SoldAsVacant= 'N'then 'No'
 else SoldAsVacant
 End
from Housing

update Housing 
Set SoldAsVacant=Case when SoldAsVacant = 'Y'then 'Yes'
 when SoldAsVacant= 'N'then 'No'
 else SoldAsVacant
 End

 ---------------------------------------------------------------------------------------
--Remove Duplicate

with RowNumCTE as(
select*,
ROW_NUMBER() over (
Partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by uniqueID
) as Row_Num
From Housing
--order by ParcelID
)
Delete
from RowNumCTE
where Row_Num>1
--order by 4



------------------------------------------------------------------------------------------------------------
--Delete unused column

select*
From Housing

alter table Housing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

alter table Housing
Drop Column SaleDate


