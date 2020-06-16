object dmCon: TdmCon
  OldCreateOrder = False
  Height = 415
  Width = 962
  object FDBatchMove1: TFDBatchMove
    Reader = FDBatchMoveDataSetReader1
    Writer = FDBatchMoveDataSetWriter1
    Mappings = <>
    LogFileName = 'Data.log'
    CommitCount = 2000
    OnProgress = FDBatchMove1Progress
    Left = 504
    Top = 80
  end
  object FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader
    DataSet = qryOrigem
    Left = 374
    Top = 24
  end
  object FDBatchMoveDataSetWriter1: TFDBatchMoveDataSetWriter
    DataSet = qryDestino
    Left = 372
    Top = 104
  end
  object FDCommand1: TFDCommand
    Connection = FDConOracle
    Left = 160
    Top = 176
  end
  object qryOrigem: TFDQuery
    Connection = FDConOracle
    FetchOptions.AssignedValues = [evMode, evItems, evRowsetSize, evCache, evUnidirectional]
    FetchOptions.Unidirectional = True
    FetchOptions.RowsetSize = 2000
    FetchOptions.Items = [fiBlobs, fiDetails]
    FetchOptions.Cache = []
    Left = 140
    Top = 22
  end
  object qryDestino: TFDQuery
    Connection = FDConFireBird
    Left = 144
    Top = 92
  end
  object FDConOracle: TFDConnection
    Params.Strings = (
      'Database=ORCL19C1'
      'User_Name=VIASOFT'
      'Password=VIASOFT'
      'DriverID=Ora')
    Left = 32
    Top = 94
  end
  object FDConFireBird: TFDConnection
    Params.Strings = (
      'Database=C:\FIREBIRD\SOLASOL\AGRO.FDB'
      'User_Name=VIASOFT'
      'Password=153'
      'Server=DW259'
      'Port=3050'
      'DriverID=FB')
    Left = 32
    Top = 20
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    VendorHome = 'E:\DataMove_new\instantclient12c'
    VendorLib = 'E:\DataMove_new\instantclient12c\oci.dll'
    NLSLang = 'BRAZILIAN PORTUGUESE_BRAZIL.WE8MSWIN1252'
    TNSAdmin = 'E:\DataMove_new\instantclient12c'
    Left = 54
    Top = 172
  end
  object qryTabelas: TFDQuery
    Connection = FDConFireBird
    Left = 160
    Top = 264
  end
  object dsTabelas: TDataSource
    Left = 238
    Top = 270
  end
  object qryGridTabelas: TFDQuery
    Connection = FDConFireBird
    Left = 328
    Top = 280
  end
  object dsGridTabelas: TDataSource
    DataSet = qryGridTabelas
    Left = 406
    Top = 286
  end
  object FDBatchMoveSQLReader1: TFDBatchMoveSQLReader
    Left = 480
    Top = 200
  end
  object IBExtract1: TIBExtract
    Database = IBDatabase1
    Transaction = IBTransaction1
    OverrideSQLDialect = 0
    Left = 720
    Top = 208
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'DW259/3050:C:\FIREBIRD\SOLASOL\AGRO.FDB'
    Params.Strings = (
      'user_name=VIASOFT'
      'password=153'
      'lc_ctype=ISO8859_1')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 720
    Top = 160
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Left = 728
    Top = 304
  end
end
