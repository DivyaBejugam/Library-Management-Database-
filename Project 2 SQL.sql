create database library; 
use library; 

create table tbl_publisher(
publisher_publisherName varchar(255)  primary key ,
publisher_publisherAddress varchar(150) ,
publisher_publisher_phone char(100));  

select * from tbl_publisher;  

create table tbl_borrower (borrower_cardNo tinyint auto_increment  primary key ,
borrower_BorrowerName varchar(100) not null,
borrower_BorrowerAddress varchar (250) not null,
borrower_Borrowerphone varchar (50) not null); 

select * from tbl_borrower;  

create table tbl_library_branch (library_branch_BranchID  tinyint auto_increment  primary key ,
library_branch_BranchName varchar(50) not null,
library_branch_BranchAddress varchar(100) not null); 

select * from tbl_library_branch; 
 


create table tbl_book(book_BookID  int AUTO_INCREMENT  PRIMARY KEY,
                      book_Title  varchar(255)  ,
                      book_PublisherName varchar(255) ,
                      foreign key(book_PublisherName) references tbl_publisher(publisher_PublisherName) on update cascade on delete cascade
                      ); 
                      
											
select * from tbl_book;   
				
create table tbl_book_authors(book_authors_AuthorsID int AUTO_INCREMENT PRIMARY KEY ,
book_authors_BookID int NOT NULL,
book_authors_AuthorName varchar(200),
foreign key(book_authors_BookID) references tbl_book(book_BookID) on update cascade on delete cascade);   

select * from tbl_book_authors;   

create table tbl_book_copies (book_copies_copiesID TINYint AUTO_INCREMENT PRIMARY KEY ,
book_copies_BookID INT NOT NULL ,
book_copies_BranchID tinyint NOT NULL ,
book_copies_No_Of_copies INT NOT NULL ,
foreign key(book_copies_BookID) references tbl_book(book_BookID) on update cascade on delete cascade,
foreign key(book_copies_BranchID) references tbl_library_branch(library_branch_BranchID) on update cascade on delete cascade);  

select * from tbl_book_copies;  

create table tbl_book_loans(book_loans_LoanID smallint auto_increment unique  primary key ,
book_loans_BookID int NOT NULL,
book_loans_BranchID tinyint NOT NULL,
book_loans_cardNo tinyint not null ,
book_loans_Dateout VARCHAR(100) ,
book_loans_DueDate VARCHAR(100),  
foreign key (book_loans_BookID) references tbl_book(book_BookID)on update cascade on delete cascade,
foreign key (book_loans_BranchID) references tbl_library_Branch(library_Branch_BranchID)on update cascade on delete cascade,
foreign key (book_loans_cardNo) references tbl_borrower(borrower_cardNo) on update cascade on delete cascade) ; 


select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_book_copies;  
select * from tbl_book_loans; 
select* from tbl_borrower;
select * from tbl_library_branch; 
select * from tbl_publisher;
 
----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
# questions
# 1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select * from tbl_book_copies; 
select * from tbl_book ; 
select * from tbl_library_branch ;
 
select book_copies_No_Of_copies , book_title,library_branch_branchname
from  tbl_book as tb
left join tbl_book_copies as bc 
on tb. book_bookid = bc.book_copies_bookid
left join tbl_library_branch as lb
on bc.book_copies_branchid = lb.library_branch_branchid
where book_title='The lost tribe' and library_branch_branchname='Sharpstown'
group by  book_copies_No_Of_copies , book_title,library_branch_branchname;  
 -----------------------------------------------------------------------------------------------------------------------------------------
# 2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?  
select * from tbl_book_copies; 
select * from tbl_book ; 
select * from tbl_library_branch ;

select sum(book_copies_No_Of_copies),book_title,library_branch_branchname
from  tbl_book as tb
left join tbl_book_copies as bc 
on tb. book_bookid = bc.book_copies_bookid 
left join tbl_library_branch as lb
on bc.book_copies_branchid = lb.library_branch_branchid
where book_title='The lost tribe' 
group by  book_copies_No_Of_copies,book_title,library_branch_branchname;   
--------------------------------------------------------------------------------------------------------------------------------------------------
# 3 Retrieve the names of all borrowers who do not have any books checked out.
select* from tbl_borrower; 
select * from tbl_book_loans  ;  
select *
from tbl_borrower as tb
left join tbl_book_loans as bl
on tb.borrower_cardNo = bl .book_loans_cardNo 
where  book_loans_BookID is null; 
---------------------------------------------------------------------------------------------------------------------------------------------
# 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18,
#retrieve the book title, the borrower's name, and the borrower's address. 
select * from tbl_book_loans  ; 
select* from tbl_library_branch;
select * from tbl_Book;

select tb.book_bookid,tb.book_title,b.borrower_borrowername,b.borrower_borroweraddress,l.book_loans_duedate,lb.library_branch_branchname
from tbl_book as tb
left join tbl_book_loans as l
on tb.book_bookid=l.book_loans_bookid
left join tbl_borrower as b
on l.book_loans_cardno=b.borrower_cardno
left join tbl_library_branch as lb
on l.book_loans_BranchID=lb.library_branch_branchid
where l.book_loans_duedate= '2/3/18' and lb.library_branch_branchname='sharpstown' ;
-------------------------------------------------------------------------------------------------------------------------------------------------
# 5 For each library branch,retrieve the branch name and the total number of books loaned out from that branch. 
select* from tbl_library_branch;
select * from tbl_book_loans  ;  

select COUNT(book_loans_loanid),lb.library_branch_branchname
from tbl_library_branch as lb
left join tbl_book_loans as l
on lb.library_branch_branchid=l.book_loans_BranchID
group by lb.library_branch_branchname; 
--------------------------------------------------------------------------------------------------------------------------------------
# 6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select count(bl.book_loans_BookID) as checked ,tb.borrower_BorrowerName,tb.borrower_BorrowerAddress,tb.borrower_Borrowerphone
from tbl_borrower as tb
left join tbl_book_loans as bl
on tb.borrower_cardNo = bl .book_loans_cardNo 
group by tb.borrower_BorrowerName,tb.borrower_BorrowerAddress,tb.borrower_Borrowerphone
having count(bl.book_loans_BookID) >5 ;  

-----------------------------------------------------------------------------------------------------------------------------------
# 7 For each book authored by "Stephen King",retrieve the title and the number of copies owned by the library branch whose name is "Central". 
select * from tbl_library_branch;
select * from tbl_book_authors; 
select * from tbl_book; 
 
select * 
 from tbl_book_authors as a
 left join tbl_book as tb
 on a.book_authors_bookid=tb.book_bookid
 left join tbl_book_copies as c
 on tb.book_bookid=c.book_copies_bookid
 left join tbl_library_branch as lb
 on c.book_copies_BranchID=lb.library_branch_branchid
 where book_authors_authorname='stephen king' and library_branch_branchname='central';  
 
 ---------------------------- extra questions ---------------------------------
 # 8 which publisher has the most number of copies of books
 select * from tbl_publisher; 
 select * from tbl_book_copies; 
 select publisher_publisherName, count(book_copies_No_Of_copies)  as high 
 from tbl_publisher as p
 left join tbl_book as b
 on p.publisher_publisherName = b.book_publisherName
 left join tbl_book_copies as c
 on b.book_BookID = c.book_copies_BookID 
 group by publisher_publisherName 
 order by publisher_publisherName limit 4; 
  
  
 #9  which author written more no of  books
select max(b.book_bookID) as count 
from tbl_Book as b
left join tbl_book_authors as a
on b.book_BookID = a.book_authors_bookID 
order by count(b.book_bookID) desc ;

# 10 which borrowers take more loan 
select borrower_BorrowerName, min(book_loans_loanID)
from tbl_borrower as tb
left join tbl_book_loans as bl
on tb.borrower_cardNo = bl .book_loans_cardNo 
group by  borrower_BorrowerName 
order by min(book_loans_loanID) desc ;




























