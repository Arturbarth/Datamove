-- SELECT * FROM RDB$GENERATORS

execute block
returns (
--    out_name char(31),
--    out_value bigint,
    out_sql varchar(500))
as
declare variable out_name char(31);
declare variable out_value bigint;

begin
    for select rdb$generator_name from rdb$generators where rdb$system_flag is distinct from 1
       order by rdb$generator_name into out_name do
    begin
        execute statement 'select gen_id(' || out_name || ', 0) from rdb$database ' into out_value;
        out_sql = 'SELECT '''||trim(out_name)||''' SEQ_NAME, '||out_value||' VALOR_FB, last_number from user_sequences where sequence_name ='''||trim(out_name)||''' union all';
        if (out_value > 1) then
           suspend;
    end
end