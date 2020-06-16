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
    ExplicitTop = -6
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 42
      Height = 13
      Caption = 'Consulta'
    end
    object btnMoverTabelas: TButton
      Left = 832
      Top = 114
      Width = 257
      Height = 36
      Caption = 'Mover Tabelas'
      TabOrder = 0
      OnClick = btnMoverTabelasClick
    end
    object btnTestarOrigem: TButton
      Left = 832
      Top = 152
      Width = 121
      Height = 36
      Caption = 'Testar Origem'
      TabOrder = 2
      OnClick = btnTestarOrigemClick
    end
    object btnTestarDestino: TButton
      Left = 968
      Top = 152
      Width = 121
      Height = 36
      Caption = 'Testar Destino'
      TabOrder = 3
      OnClick = btnTestarDestinoClick
    end
    object meConsulta: TMemo
      Left = 2
      Top = 35
      Width = 795
      Height = 160
      Hint = 
        'Informe a consulta que vai carregar as tabelas que v'#227'o ser migra' +
        'das, essa consulta precisa obrigat'#243'riamente os campos TABELA, LI' +
        'NHAS, MIGRAR e MIGRADA'
      Lines.Strings = (
        'SELECT TABELA, LINHAS, MIGRADA, MIGRAR  FROM MIGRATABELAS')
      TabOrder = 4
    end
    object btnCarregarTabelas: TButton
      Left = 832
      Top = 35
      Width = 257
      Height = 36
      Caption = 'Carregar Tabelas'
      TabOrder = 5
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
      Left = 832
      Top = 75
      Width = 257
      Height = 36
      Caption = 'Comparar Tabelas'
      TabOrder = 6
      OnClick = btnCompararTabelasClick
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 1208
    Top = 32
  end
end
