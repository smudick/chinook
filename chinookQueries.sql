--customers not from usa
select c.FirstName, c.LastName, c.CustomerId, c.Country
from Customer c
where c.Country != 'usa'

--customers from Brazil
select c.FirstName, c.LastName, c.CustomerId, c.Country
from Customer c
where c.Country = 'brazil'

--brazil customer invoices
select c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
from Customer c
	join invoice i
		on i.CustomerId = c.CustomerId
		where i.BillingCountry ='brazil'

--sales agents
select * 
	from Employee e
	where e.Title like '%agent'

--unique invoice countries
select distinct i.BillingCountry
from Invoice i

--sales agent invoices
select i.*, e.FirstName, e.LastName 
from Invoice i 
join Customer c
	on c.customerId = i.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
	order by e.EmployeeId

--invoice totals
select i.total, c.FirstName as CustomerFirstName, c.LastName as CustomerLastName, c.Country, e.FirstName as AgentFirstName, e.LastName as AgentLastName
from Invoice i 
join Customer c
	on c.customerId = i.CustomerId
	join Employee e
	on e.EmployeeId = c.SupportRepId
	order by c.CustomerId

--total invoices per year
select year(i.invoiceDate) as 'Year', count(*)
from invoice i
where year(i.invoiceDate) = '2009' or year(i.invoiceDate) = '2011'
group by year(i.invoiceDate)

--total sales year
select year(i.invoiceDate) as 'Year', sum(i.total) as TotalSales
from invoice i
where year(i.invoiceDate) = '2009' or year(i.invoiceDate) = '2011'
group by year(i.invoiceDate)

--invoice 37 line item count
select il.InvoiceId, count(*) as LineItems
from InvoiceLine il
where il.InvoiceId = '37'
group by il.InvoiceId

--line items per invoice
select il.InvoiceId, count(*) as LineItems
from InvoiceLine il
group by il.InvoiceId

--line items track
select il.*, t.Name
from InvoiceLine il
join Track t
	on il.TrackId = t.TrackId
	order by il.InvoiceId

--line items track artist
select il.*, t.Name, ar.Name
from InvoiceLine il
join Track t
	on il.TrackId = t.TrackId
	join Album al
	on al.AlbumId = t.AlbumId
	join Artist ar
	on ar.ArtistId = al.ArtistId
	order by il.InvoiceId

--country invoices
select i.BillingCountry, count(*) as TotalInvoices
from Invoice i
group by i.BillingCountry

--playlists track count
select p.Name, count(*) as Tracks
from PlaylistTrack pt
join Playlist p 
on pt.PlaylistId = p.PlaylistId
group by p.Name

--tracks no ID
select t.Name as Track, al.Title as Album, mt.Name as MediaType, g.Name as Genre
from Track t
join album al
	on al.AlbumId = t.AlbumId
	join MediaType mt
	on mt.MediaTypeId = t.MediaTypeId
	join Genre g
	on g.GenreId = t.GenreId
	order by al.Title

--invoices line item count
select i.*, count(*) as LineItems
from InvoiceLine il
	join invoice i
	on il.InvoiceId = i.InvoiceId
	group by i.InvoiceId, i.CustomerId, i.InvoiceDate, i.BillingAddress, i.BillingAddress,
	i.BillingCountry, i.BillingState, i.BillingPostalCode, i.Total, i.BillingCity

--non correlated subquery method
select * 
from Invoice i
	join (select invoiceId, count(*) as numberOfLineItems
	from InvoiceLine
	group by invoiceId) lineCount
	on lineCount.InvoiceId = i.InvoiceId

--sales agent total sales
select e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.LastName, e.FirstName
	order by TotalSales desc

--top 2009 sales agent
select top 1 e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	where year(i.InvoiceDate) = '2009'
	group by e.LastName, e.FirstName
	order by TotalSales desc

--top agent overall
select top 1 e.FirstName,e.LastName, sum(i.Total) as TotalSales
from invoice i
	join Customer c
	on c.CustomerId = i.CustomerId
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.LastName, e.FirstName
	order by TotalSales desc

--sales agent customer count
select e.FirstName, e.LastName, count(*) as TotalCustomers
from Customer c
	join Employee e 
	on c.SupportRepId = e.EmployeeId
	group by e.FirstName, e.LastName
	order by TotalCustomers desc

--total sales per country
select i.BillingCountry, sum(i.total) as TotalSales
from Invoice i
group by i.BillingCountry

--top country
select top 1 i.BillingCountry, sum(i.total) as TotalSales
from Invoice i
group by i.BillingCountry
order by TotalSales desc