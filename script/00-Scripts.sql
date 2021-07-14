 update 
    rdb$triggers 
set 
    rdb$trigger_inactive = 1
where 
    rdb$trigger_source is not null 
    and ((rdb$system_flag = 0) 
    or (rdb$system_flag is null));


SELECT 'ALTER TABLE ' || C.TABELA || ' ALTER ' || C.COLUNA || '    TYPE VARCHAR(30); ' 
 FROM PCOLUNAS C
 INNER JOIN rdb$relations r
  ON  r.rdb$relation_name = C.TABELA
where rdb$view_blr is null and (rdb$system_flag is null or rdb$system_flag = 0)
and rdb$owner_name = 'VIASOFT'
and C.TIPO = 'HORA';
   
SELECT 'UPDATE ' || C.TABELA || ' SET ' || C.COLUNA || ' = COPY   ('||C.COLUNA ||', 1,8); '
    FROM PCOLUNAS C
    INNER JOIN rdb$relations r
  ON  r.rdb$relation_name = C.TABELA
where rdb$view_blr is null and (rdb$system_flag is null or rdb$system_flag = 0)
and rdb$owner_name = 'VIASOFT'
and C.TIPO = 'HORA';  


UPDATE sintlayout SET sintlayout.subtipo = '.'
WHERE (sintlayout.subtipo = '') OR (sintlayout.subtipo IS NULL);


UPDATE FIMPORTL SET FIMPORTL.coluna = '.'
WHERE (FIMPORTL.coluna = '') OR (FIMPORTL.coluna IS NULL);


UPDATE LOGSYNCPAF SET MOTIVO = '.';

UPDATE ITEMSALDOINI SET DTIMPLANTACAO='01.01.1950' WHERE DTIMPLANTACAO < '01.01.1950';

UPDATE NFCANCELAMENTO SET CHAVEACESSO='.' WHERE CHAVEACESSO = '';

UPDATE WMUSUARIO SET RASTRINICIOMANHA=NULL WHERE RASTRINICIOMANHA = '';
UPDATE WMUSUARIO SET RASTRFIMMANHA=NULL WHERE RASTRFIMMANHA = '';
UPDATE WMUSUARIO SET RASTRINCIOTARDE=NULL WHERE RASTRINCIOTARDE = '';
UPDATE WMUSUARIO SET RASTRFIMTARDE=NULL WHERE RASTRFIMTARDE = '';
