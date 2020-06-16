unit uThreadCompararTabelas;

interface

uses
  System.Classes, uParametrosConexao, Vcl.ComCtrls, Vcl.StdCtrls,
  FireDAC.Comp.Client, uEnum, uConexoes, IBX.IBDatabase, IBX.IBExtract;

type
  TThreadCompararTabelas = class(TThread)
  private
    FcMsg: String;
    FeTpLog: tpLog;


    IBExtract: TIBExtract;
    IBConection : TIBDatabase;
    IBTransaction : TIBTransaction;

    FnTotalTabelas: Integer;
    FnTabelaAtual: Integer;

    qryTabelasOrigem: TFDQuery;
    qryTabelasDestino: TFDQuery;
    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;

    FModelFirebird: TModelConexao;
    FModelOracle: TModelConexao;

    procedure ConfigurarConexoes;
    procedure Logar(eTpLog: tpLog; cMsg: String);
    procedure SyncLogar;

    procedure CompararTabelasOrigemXDestino;
    procedure AbrirTabelasOrigem;
    procedure AbrirTabelasDestino;
    procedure CompararTabelas;

  protected
    procedure Execute; override;
  public
    FmeLog: TMemo;
    FmeErros: TMemo;
    FpbStatus: TProgressBar;
    FParOracle, FParmFirebird: IParametrosConexao;
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;

  end;

implementation

uses
  uLog, System.SysUtils;

{ TThreadCompararTabelas }

procedure TThreadCompararTabelas.AbrirTabelasOrigem;
begin
  qryTabelasOrigem.Close;
  qryTabelasOrigem.SQL.Clear;
  qryTabelasOrigem.SQL.Add('SELECT RDB$RELATION_NAME AS TABELA FROM RDB$RELATIONS');
  qryTabelasOrigem.SQL.Add('WHERE RDB$SYSTEM_FLAG = 0');
  qryTabelasOrigem.SQL.Add('AND RDB$VIEW_SOURCE IS NULL');
  qryTabelasOrigem.Open;
  qryTabelasOrigem.FetchAll;
end;

procedure TThreadCompararTabelas.AbrirTabelasDestino;
begin
  qryTabelasDestino.Close;
  qryTabelasDestino.SQL.Clear;
  qryTabelasDestino.SQL.Add('SELECT TABLE_NAME AS TABELA FROM DBA_TABLES');
  qryTabelasDestino.SQL.Add('where owner = ''VIASOFT''');
  qryTabelasDestino.Open;
  qryTabelasDestino.FetchAll;
end;

procedure TThreadCompararTabelas.CompararTabelasOrigemXDestino;
begin
  AbrirTabelasOrigem;
  AbrirTabelasDestino;
  CompararTabelas;
end;

procedure TThreadCompararTabelas.CompararTabelas;
begin
  FnTotalTabelas := qryTabelasOrigem.RecordCount;
  Logar(tplLog, ' : Comparação de tabelas ::');
  qryTabelasOrigem.First;
  while not qryTabelasOrigem.Eof do
    begin
    if not qryTabelasDestino.Locate('TABELA', qryTabelasOrigem.FieldByName('TABELA').AsString, []) then
      begin
      Logar(tplLog,': Tabela: ' + qryTabelasOrigem.FieldByName('TABELA').AsString + ' :: Não existe no destino');
      //IBExtract.ExtractObject(eoTable, qryTabelasOrigem.FieldByName('TABELA').AsString, [etTable, etTrigger, etForeign, etIndex] );
      //Logar(tplLog, 'SQL Da tabela: ' + IBExtract.Items.Text);
    end;
    qryTabelasOrigem.Next;
  end;
  Logar(tplLog, ' : FIM comparação de tabelas ::');
end;

procedure TThreadCompararTabelas.ConfigurarConexoes;
var
   cIbCon: String;
//var
//  oParOracle, oParmFirebird: IParametrosConexao;
begin
//  oParmFirebird := TParametrosConexao.New('127.0.0.1', '3050', 'E:\Bancos\INDIANAAGRI_MIGRA.FDB', 'VIASOFT', '153', 'FB');
  FModelFirebird := TModelConexao.Create(FParmFirebird);
  FDConFirebird := FModelFirebird.GetConexao;

//  oParOracle := TParametrosConexao.New('127.0.0.1', '1521', 'LOCAL_ORCL', 'VIASOFT', 'VIASOFT', 'Ora');
  FModelOracle := TModelConexao.Create(FParOracle);
  FDConOracle := FModelOracle.GetConexao;

  qryTabelasOrigem.Connection := FDConFirebird;
  qryTabelasDestino.Connection := FDConOracle;


  //teste para extrair o metadata das tabelas
  cIbCon := FParmFirebird.GetServer + '/' + FParmFirebird.GetPorta + ':' + FParmFirebird.GetBanco;

  IBConection := TIBDatabase.Create(Nil);
  IBConection.DatabaseName := cIbCon;
  IBConection.Params.Add('user_name='+FParmFirebird.GetUsuario);
  IBConection.Params.Add('password='+FParmFirebird.GetSenha);
  IBConection.Params.Add('lc_ctype=ISO8859_1');
  IBConection.LoginPrompt := False;
  IBConection.Connected := True;

  IBTransaction := TIBTransaction.Create(Nil);
  IBTransaction.DefaultDatabase := IBConection;


  IBExtract := TIBExtract.Create(Nil);
  IBExtract.Database    := IBConection;
  IBExtract.Transaction := IBTransaction;

end;

constructor TThreadCompararTabelas.Create(CreateSuspended: Boolean);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;
  qryTabelasOrigem  := TFDQuery.Create(nil);
  qryTabelasDestino := TFDQuery.Create(nil);
end;

destructor TThreadCompararTabelas.Destroy;
begin
  FModelFirebird.Free;
  FModelOracle.Free;
  qryTabelasOrigem.Free;
  qryTabelasDestino.Free;
  inherited;
end;

procedure TThreadCompararTabelas.Execute;
begin
  ConfigurarConexoes;
  CompararTabelasOrigemXDestino;
end;

procedure TThreadCompararTabelas.Logar(eTpLog: tpLog; cMsg: String);
begin
  FcMsg := cMsg;
  FeTpLog := eTpLog;
  Synchronize(SyncLogar);
end;

procedure TThreadCompararTabelas.SyncLogar;
begin
  TLog.New.Logar(FcMsg);
  if (FeTpLog = tplLog) then
    FmeLog.Lines.Add('--' + FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg)
  else if (FeTpLog = tplErro) then
    FmeErros.Lines.Add('--' + FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg);
  FpbStatus.Position := Round((FnTabelaAtual/FnTotalTabelas)*100);
end;

end.
