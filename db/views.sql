create or replace view ib_assignments as
select
    b.title_id ,
    NVL(a.book_branch_id,b.respondent_id) book_branch_id,
    NVL(a.category,'UnKnown') category,
    NVL(a.rack,'R0') rack,
    NVL(a.shelf,'S0') shelf,
    b.respondent_id respondent_id,
    --b.branch_id  req_branch_id,
    --b.created_at created_at,
    b.id ibtr_id,
    count(1) book_count
    from stock_racks_shelves a, ibtrs b
    where  b.title_id = a.title_id(+)
    and a.book_branch_id(+) = b.respondent_id
    and b.state ='Assigned'
    -- and (b.respondent_id, b.title_id) not in (select respondent_id, title_id from ibt_hidden_reqs)
    and b.created_at >= (select time_basis from ibt_search_criterias e where e.respondent_id = b.respondent_id)
    and (((a.category, a.rack, a.shelf, b.title_id) = (
    select c.category, c.rack, c.shelf, c.title_id from stock_racks_shelves c
    where c.title_id = b.title_id
    and b.respondent_id = c.book_branch_id and rownum < 2))
    OR (a.category is null AND a.rack is null and a.shelf is null))
    group by
    b.title_id,
    NVL(a.book_branch_id, b.respondent_id),
    b.respondent_id ,
    --b.branch_id ,
    --b.created_at ,
    b.id,
    NVL(a.category,'UnKnown'),
    NVL(a.rack,'R0'),
    NVL(a.shelf,'S0')
    with read only

 ;

create or replace view stock_racks_shelves as
select
    --a.bookid book_id,
    --a.booknumber book_number,
    a.titleid title_id,
    a.location book_branch_id,
    --a.shelflocation shelf_location,
    --a.status book_status,
    replace(substr(shelflocation, 1, length(shelflocation)- regexp_instr(shelflocation,'R\d')),'-','') Category,
    replace(substr(shelflocation, regexp_instr(shelflocation,'R\d'), regexp_instr(shelflocation,'S\d')-regexp_instr(shelflocation,'R\d')),'-','') Rack,
    substr(shelflocation, regexp_instr(shelflocation,'S\d'),25) Shelf,
    count(1) count_per_shelf
    from jbprod.books a
    --where a.status != 'D'
    group by
    a.titleid ,
    a.location ,
    --a.shelflocation  ,
    replace(substr(shelflocation, 1, length(shelflocation)- regexp_instr(shelflocation,'R\d')),'-',''),
    replace(substr(shelflocation, regexp_instr(shelflocation,'R\d'), regexp_instr(shelflocation,'S\d')-regexp_instr(shelflocation,'R\d')),'-',''),
    substr(shelflocation, regexp_instr(shelflocation,'S\d'),25)

    with read only

 ;