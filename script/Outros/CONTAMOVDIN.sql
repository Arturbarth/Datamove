SELECT 'UPDATE CONTAMOVDIN SET DTLANCA = ''' || LPAD(EXTRACT(DAY FROM DTLANCA), 2, '0') || '.' || LPAD(EXTRACT(month FROM DTLANCA),2, '0') || '.' || EXTRACT(YEAR FROM DTLANCA)  || ''' WHERE NUMEROCM = ' || NUMEROCM || ' AND ESTAB = ' || ESTAB ||' AND SEQCM = ' || SEQCM || ' AND SEQDIN = ' || SEQDIN || ';' FROM CONTAMOVDIN



