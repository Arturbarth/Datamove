EXECUTE BLOCK 
   RETURNS (tabela VARCHAR(100), linhas INTEGER)
AS
declare variable CTABELA varchar(200);
declare variable CSQL varchar(32500);

BEGIN
   FOR select rdb$relation_name  from rdb$relations r
        where rdb$view_blr is null and (rdb$system_flag is null or rdb$system_flag = 0)
        and rdb$owner_name = 'VIASOFT'
        and rdb$relation_name not  in('VSCONSULTA', 'PAUDITA', 'UPGBANCOCLI', 'UPGCOMANDO', 'UPGCOMANDOEX')
        INTO :CTABELA DO
     BEGIN
     CSQL =  'SELECT '''||CTABELA||''' AS TABELA, COUNT(*) LINHAS FROM '||CTABELA;
     FOR EXECUTE STATEMENT CSQL
         INTO :tabela, :linhas DO
     BEGIN
          INSERT INTO MIGRATABELAS(TABELA, LINHAS, MIGRAR, MIGRADA) VALUES(TRIM(:TABELA), :LINHAS, 'S', 'N');
          if (LINHAS > 0) then
             SUSPEND;
     END
  END
END
