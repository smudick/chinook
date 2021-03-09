--1 customers not from usa
select c.FirstName, c.LastName, c.CustomerId, c.Country
from Customer c
where c.Country != 'usa'

--2 customers from Brazil
select c.FirstName, c.LastName, c.CustomerId, c.Country
from Customer c
where c.Country = 'brazil'

--3 brazil customer invoices
select c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
from Customer c
	join invoice i
		on i.CustomerId = c.CustomerId
		where i.BillingCountry ='brazil'

--4 sales agents
select * 
	from Employee e
	where e.Title like '%agent'

--5 unique invoice countries
select distinct i.BillingCountry
from Invoice i

--6 sales agent invoices
select i.*, e.FirstName, e.LastName 
from Invoice i 
join Customer c
	on c.customerId = i.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
	order by e.EmployeeId

--7 invoice totals
select i.total, c.FirstName as CustomerFirstName, c.LastName as CustomerLastName, c.Country, e.FirstName as AgentFirstName, e.LastName as AgentLastName
from Invoice i 
join Customer c
	on c.customerId = i.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
	order by c.CustomerId

--8 total invoices per year
select year(i.invoiceDate) as 'Year', count(*)
from invoice i
where year(i.invoiceDate) = '2009' or year(i.invoiceDate) = '2011'
group by year(i.invoiceDate)

--9 total sales year
select year(i.invoiceDate) as 'Year', sum(i.total) as TotalSales
from invoice i
where year(i.invoiceDate) = '2009' or year(i.invoiceDate) = '2011'
group by year(i.invoiceDate)

--10 invoice 37 line item count
select il.InvoiceId, count(*) as LineItems
from InvoiceLine il
where il.InvoiceId = '37'
group by il.InvoiceId

--11 line items per invoice
select il.InvoiceId, count(*) as LineItems
from InvoiceLine il
group by il.InvoiceId

--12 line items track
select il.*, t.Name
from InvoiceLine il
join Track t
	on il.TrackId = t.TrackId
	order by il.InvoiceId

--13 line items track artist
select il.*, t.Name, ar.Name
from InvoiceLine il
join Track t
	on il.TrackId = t.TrackId
	join Album al
	on al.AlbumId = t.AlbumId
	join Artist ar
	on ar.ArtistId = al.ArtistId
	order by il.InvoiceId

--14 country invoices
select i.BillingCountry, count(*) as TotalInvoices
from Invoice i
group by i.BillingCountry

--15 playlists track count
select p.Name, count(*) as Tracks
from PlaylistTrack pt
join Playlist p 
on pt.PlaylistId = p.PlaylistId
group by p.Name

--16 tracks no ID
select t.Name as Track, al.Title as Album, mt.Name as MediaType, g.Name as Genre
from Track t
join album al
	on al.AlbumId = t.AlbumId
	join MediaType mt
	on mt.MediaTypeId = t.MediaTypeId
	join Genre g
	on g.GenreId = t.GenreId
	order by al.Title

--17 invoices line item count
select i.*, count(*) as LineItems
from InvoiceLine il
	join invoice i
	on il.InvoiceId = i.InvoiceId
	group by i.InvoiceId, i.CustomerId, i.InvoiceDate, i.BillingAddress, i.BillingAddress,
	i.BillingCountry, i.BillingState, i.BillingPostalCode, i.Total, i.BillingCity

-- non correlated subquery method
select * 
from Invoice i
	join (select invoiceId, count(*) as numberOfLineItems
	from InvoiceLine
	group by invoiceId) lineCount
	on lineCount.InvoiceId = i.InvoiceId

--18 sales agent total sales
select e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.LastName, e.FirstName
	order by TotalSales desc

--19 top 2009 sales agent
select top 1 e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	where year(i.InvoiceDate) = '2009'
	group by e.LastName, e.FirstName
	order by TotalSales desc

--20 top agent overall
select top 1 e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.LastName, e.FirstName
	order by TotalSales desc

--21 sales agent customer count
select e.FirstName, e.LastName, count(*) as TotalCustomers
from Customer c
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.FirstName, e.LastName
	order by TotalCustomers desc

--22 total sales per country
select i.BillingCountry, sum(i.total) as TotalSales
from Invoice i
group by i.BillingCountry

--23 top country
select top 1 i.BillingCountry, sum(i.total) as TotalSales
from Invoice i
group by i.BillingCountry
order by TotalSales desc

--24 top track 2013
select top 1 t.name, count(il.quantity) as TotalSold
from InvoiceLine il
	join invoice i
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
	where i.InvoiceDate like '%2013%'
	group by t.name
	order by totalsold desc 


--25 top 5 most purchased tracks
select top 5 t.name, count(il.quantity) as TotalSold
from InvoiceLine il
	join invoice i
	on i.InvoiceId = il.InvoiceId
	join Track t
	on il.TrackId = t.TrackId
	group by t.name
	order by totalsold desc 

--26 top 3 best selling artists
select top 3 a.Name, count(il.quantity) as TotalSold
from Artist a
	join Album al
	on al.ArtistId = a.ArtistId
	join track t
	on t.AlbumId = al.AlbumId
	join InvoiceLine il
	on t.TrackId = il.TrackId
	join invoice i
	on i.InvoiceId = il.InvoiceId
	group by a.Name
	order by TotalSold desc

--27 top media type
select top 1 m.Name, count(il.quantity) as TotalSold
from track t
	join InvoiceLine il
	on il.TrackId = t.TrackId
	join MediaType m
	on t.MediaTypeId = m.MediaTypeId
	group by m.Name
	order by TotalSold desc