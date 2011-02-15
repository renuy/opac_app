create or replace view ib_assignments as
select
    a.title_id ,
    a.book_branch_id,
    a.category,
    a.rack,
    a.shelf,
    b.respondent_id respondent_id,
    --b.branch_id  req_branch_id,
    --b.created_at created_at,
    b.id ibtr_id,
    count(1) book_count
    from stock_racks_shelves a, ibtrs b
    where  b.title_id = a.title_id
    and a.book_branch_id = b.respondent_id
    and b.state ='Assigned'
    -- and (b.respondent_id, b.title_id) not in (select respondent_id, title_id from ibt_hidden_reqs)
    and b.created_at >= (select time_basis from ibt_search_criterias e where e.respondent_id = b.respondent_id)
    and (a.category, a.rack, a.shelf, b.title_id) = (
    select c.category, c.rack, c.shelf, c.title_id from stock_racks_shelves c
    where c.title_id = b.title_id
    and b.respondent_id = c.book_branch_id and rownum < 2)
    group by
    a.title_id,
    a.book_branch_id,
    b.respondent_id ,
    --b.branch_id ,
    --b.created_at ,
    b.id,
    a.category,
    a.rack,
    a.shelf
    with read only

 ;
