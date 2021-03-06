SELECT 
  'DROP SEQUENCE '||SEQUENCE_NAME||'; ' ||
  'CALL CREATE_SEQUENCE('''|| SUBSTR(SEQUENCE_NAME, INSTR(SEQUENCE_NAME, '_')+1, INSTR(SEQUENCE_NAME, '_', 1,2)-5 )||''', '''||
  SUBSTR(SEQUENCE_NAME, INSTR(SEQUENCE_NAME, '_', 1,2)+1, STRLEN(SEQUENCE_NAME))||''');'  
FROM USER_SEQUENCES 
WHERE SEQUENCE_NAME LIKE 'GEN\_%' ESCAPE '\' 
AND EXISTS(SELECT 1 FROM USER_TAB_COLUMNS 
          WHERE TABLE_NAME=SUBSTR(SEQUENCE_NAME, INSTR(SEQUENCE_NAME, '_')+1, INSTR(SEQUENCE_NAME, '_', 1,2)-5 )
            AND COLUMN_NAME =  SUBSTR(SEQUENCE_NAME, INSTR(SEQUENCE_NAME, '_', 1,2)+1, STRLEN(SEQUENCE_NAME))
            );

