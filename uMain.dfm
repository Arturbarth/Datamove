object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Data Move'
  ClientHeight = 705
  ClientWidth = 1452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 249
    Width = 1452
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnl3: TPanel
      Left = 0
      Top = 248
      Width = 1452
      Height = 208
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object pgLog: TPageControl
        Left = 0
        Top = 0
        Width = 800
        Height = 208
        ActivePage = bsLog
        Align = alClient
        TabOrder = 0
        object bsLog: TTabSheet
          Caption = 'Log'
          object meLog: TMemo
            Left = 0
            Top = 0
            Width = 792
            Height = 180
            Align = alClient
            TabOrder = 0
          end
        end
      end
      object PageControl1: TPageControl
        Left = 800
        Top = 0
        Width = 652
        Height = 208
        ActivePage = TabSheet1
        Align = alRight
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = 'Erros'
          object meErros: TMemo
            Left = 0
            Top = 0
            Width = 644
            Height = 180
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 1452
      Height = 248
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 1452
        Height = 248
        ActivePage = TabSheet2
        Align = alClient
        TabOrder = 0
        object TabSheet2: TTabSheet
          Caption = 'Tabelas'
          object gridTabelas: TDBGrid
            Left = 0
            Top = 0
            Width = 790
            Height = 220
            Align = alLeft
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'TABELA'
                Width = 420
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'LINHAS'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MIGRADA'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MIGRAR'
                Visible = True
              end>
          end
        end
      end
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 1452
    Height = 249
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 42
      Height = 13
      Caption = 'Consulta'
    end
    object btnMoverTabelas: TButton
      Left = 886
      Top = 119
      Width = 257
      Height = 36
      Caption = 'Mover Tabelas'
      TabOrder = 0
      OnClick = btnMoverTabelasClick
    end
    object meConsulta: TMemo
      Left = 2
      Top = 35
      Width = 591
      Height = 160
      Hint = 
        'Informe a consulta que vai carregar as tabelas que v'#227'o ser migra' +
        'das, essa consulta precisa obrigat'#243'riamente os campos TABELA, LI' +
        'NHAS, MIGRAR e MIGRADA'
      Lines.Strings = (
        'SELECT TABELA, LINHAS, MIGRADA, MIGRAR  FROM MIGRATABELAS'
        'WHERE MIGRADA = '#39'N'#39)
      TabOrder = 2
    end
    object btnCarregarTabelas: TButton
      Left = 599
      Top = 117
      Width = 257
      Height = 36
      Caption = '2 Carregar Tabelas'
      TabOrder = 3
      OnClick = btnCarregarTabelasClick
    end
    object cxGroupBox1: TGroupBox
      Left = 0
      Top = 201
      Width = 1452
      Height = 48
      Align = alBottom
      Caption = 'Progresso'
      TabOrder = 1
      object pbStatus: TProgressBar
        Left = 2
        Top = 15
        Width = 1448
        Height = 17
        Align = alTop
        TabOrder = 0
      end
    end
    object btnCompararTabelas: TButton
      Left = 886
      Top = 77
      Width = 257
      Height = 36
      Caption = '4 Comparar Tabelas'
      TabOrder = 4
      OnClick = btnCompararTabelasClick
    end
    object Button1: TButton
      Left = 599
      Top = 35
      Width = 121
      Height = 36
      Caption = 'Testar Origem'
      TabOrder = 5
      OnClick = btnTestarOrigemClick
    end
    object Button2: TButton
      Left = 735
      Top = 35
      Width = 121
      Height = 36
      Caption = 'Testar Destino'
      TabOrder = 6
      OnClick = btnTestarDestinoClick
    end
    object btnInserirTabelas: TButton
      Left = 599
      Top = 77
      Width = 257
      Height = 36
      Caption = '1 Inserir Tabelas'
      TabOrder = 7
      OnClick = btnInserirTabelasClick
    end
    object Button4: TButton
      Left = 599
      Top = 159
      Width = 257
      Height = 36
      Caption = '3 Desablitar Trigger e FK'
      TabOrder = 8
      OnClick = btnCarregarTabelasClick
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 1344
    Top = 40
  end
  object OracleDriver: TFDPhysOracleDriverLink
    VendorLib = 'C:\OCI\oci.dll'
    Left = 1296
    Top = 177
  end
  object FDConnection2: TFDConnection
    Params.Strings = (
      'Database=127.0.0.1:1533/COTRIBATEST'
      'User_Name=VIASOFT'
      'Password=VIASOFT'
      'OSAuthent=No'
      'CharacterSet=UTF8'
      'DriverID=Ora')
    LoginPrompt = False
    Left = 816
    Top = 241
  end
  object FDScript1: TFDScript
    SQLScripts = <
      item
        SQL.Strings = (
          'CREATE TABLE MIGRATABELAS ('
          '    TABELA         VARCHAR(200),'
          '    LINHAS         INTEGER,'
          '    PERSONALIZADA  CHAR(1),'
          '    MIGRAR         CHAR(1),'
          '    MIGRADA        CHAR(1)'
          ');')
      end
      item
        SQL.Strings = (
          'CREATE INDEX MIGRATABELAS_IDX1 ON MIGRATABELAS (TABELA);')
      end>
    Params = <>
    Macros = <>
    Left = 788
    Top = 313
  end
  object FDScript2: TFDScript
    SQLScripts = <
      item
        SQL.Strings = (
          'EXECUTE BLOCK '
          '   RETURNS (tabela VARCHAR(100), linhas INTEGER)'
          'AS'
          'declare variable CTABELA varchar(200);'
          'declare variable CSQL varchar(32500);'
          ''
          'BEGIN'
          '   FOR select rdb$relation_name  from rdb$relations r'
          
            '        where rdb$view_blr is null and (rdb$system_flag is null ' +
            'or rdb$system_flag = 0)'
          '        and rdb$owner_name = '#39'VIASOFT'#39
          
            '        and rdb$relation_name not  in('#39'VSCONSULTA'#39', '#39'PAUDITA'#39', '#39 +
            'UPGBANCOCLI'#39', '#39'UPGCOMANDO'#39', '#39'UPGCOMANDOEX'#39')'
          '        INTO :CTABELA DO'
          '     BEGIN'
          
            '     CSQL =  '#39'SELECT '#39#39#39'||CTABELA||'#39#39#39' AS TABELA, COUNT(*) LINHA' +
            'S FROM '#39'||CTABELA;'
          '     FOR EXECUTE STATEMENT CSQL'
          '         INTO :tabela, :linhas DO'
          '     BEGIN'
          
            '          INSERT INTO MIGRATABELAS(TABELA, LINHAS, MIGRAR, MIGRA' +
            'DA) VALUES(TRIM(:TABELA), :LINHAS, '#39'S'#39', '#39'N'#39');'
          '          if (LINHAS > 0) then'
          '             SUSPEND;'
          '     END'
          '  END'
          'END')
      end>
    Params = <>
    Macros = <>
    Left = 1140
    Top = 329
  end
  object FDQuery1: TFDQuery
    SQL.Strings = (
      'EXECUTE BLOCK '
      '   RETURNS (tabela VARCHAR(100), linhas INTEGER)'
      'AS'
      'declare variable CTABELA varchar(200);'
      'declare variable CSQL varchar(32500);'
      ''
      'BEGIN'
      '   FOR select rdb$relation_name  from rdb$relations r'
      
        '        where rdb$view_blr is null and (rdb$system_flag is null ' +
        'or rdb$system_flag = 0)'
      '        and rdb$owner_name = '#39'VIASOFT'#39
      
        '        and rdb$relation_name not  in('#39'VSCONSULTA'#39', '#39'PAUDITA'#39', '#39 +
        'UPGBANCOCLI'#39', '#39'UPGCOMANDO'#39', '#39'UPGCOMANDOEX'#39')'
      '        INTO :CTABELA DO'
      '     BEGIN'
      
        '     CSQL =  '#39'SELECT '#39#39#39'||CTABELA||'#39#39#39' AS TABELA, COUNT(*) LINHA' +
        'S FROM '#39'||CTABELA;'
      '     FOR EXECUTE STATEMENT CSQL'
      '         INTO :tabela, :linhas DO'
      '     BEGIN'
      
        '          INSERT INTO MIGRATABELAS(TABELA, LINHAS, MIGRAR, MIGRA' +
        'DA) VALUES(TRIM(:TABELA), :LINHAS, '#39'S'#39', '#39'N'#39');'
      '          if (LINHAS > 0) then'
      '             SUSPEND;'
      '     END'
      '  END'
      'END')
    Left = 572
    Top = 353
    ParamData = <
      item
        Name = 'CTABELA'
        ParamType = ptInput
      end
      item
        Name = 'TABELA'
        ParamType = ptInput
      end
      item
        Name = 'LINHAS'
        ParamType = ptInput
      end>
  end
  object FDConnection1_1: TFDConnection
    Params.Strings = (
      'Database=E:\Firebird\ALTONORTE\AGRO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1/3050'
      'CharacterSet=ISO8859_1'
      'DriverID=FB')
    LoginPrompt = False
    Left = 712
    Top = 385
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=127.0.0.1:1533/COTRIBACLI'
      'User_Name=VIASOFT'
      'Password=VIASOFT'
      'OSAuthent=No'
      'CharacterSet=UTF8'
      'DriverID=Ora')
    LoginPrompt = False
    Left = 704
    Top = 249
  end
end
