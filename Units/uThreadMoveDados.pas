unit uThreadMoveDados;

interface

uses
  System.Classes, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.FB, uConexoes, uParametrosConexao, uEnum, Vcl.StdCtrls,
  uThreadMoveTabela;

type
  TThreadMoveDados = class(TThread)
  private
    FcMsg: String;
    FeTpLog: tpLog;
    FnTotalTabelas: Integer;
    FnTabelaAtual: Integer;
    FModelFirebird: TModelConexao;
    FModelOracle: TModelConexao;
    qryTabelas: TFDQuery;
    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;
    procedure Logar(eTpLog: tpLog; cMsg: String);
    procedure SyncLogar;
    procedure CarregarTabelasSistema;
    procedure ConfigurarConexoes;
    procedure MoverTabela(cTabela: String; nLinhas: Integer);
  protected
    procedure Execute; override;
    procedure MoverTabelasSistema;
  public
    FmeLog: TMemo;
    FmeErros: TMemo;
    FConsulta: String;
    ThreadCount: Integer;
    FpbStatus: TProgressBar;
    FParOracle, FParmFirebird: IParametrosConexao;
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, uLog, uMoveDados;
{ TThreadMoveDados }

procedure TThreadMoveDados.Execute;
begin
  ThreadCount := 0;
  ConfigurarConexoes;
  MoverTabelasSistema;
end;

procedure TThreadMoveDados.MoverTabelasSistema;
var
  cTabela: String;
begin
  FmeLog.Clear;
  FmeErros.Clear;
  CarregarTabelasSistema;
  FnTotalTabelas := qryTabelas.RecordCount;

  Logar(tplLog, ' : Iniciando cópia das tabelas PADRÕES do SISTEMA ::');
  qryTabelas.First;
  while (not qryTabelas.Eof) do
    begin
    try
      FnTabelaAtual := qryTabelas.RecNo;
      cTabela := Trim(qryTabelas.FieldByName('TABELA').AsString);
      MoverTabela(cTabela, qryTabelas.FieldByName('LINHAS').AsInteger);
    except
      on e: Exception do
        begin
        Logar(tplErro,' : Erro: ' + cTabela + ' :: '  + e.message);
      end;
    end;
    qryTabelas.next;
  end;
end;

procedure TThreadMoveDados.MoverTabela(cTabela: String; nLinhas: Integer);
var
  oThreadMoveTabelas: TThreadMoveTabelas;
  {dtini, dtfim, total: TDateTime;
  oMove: TMoveDados;}
begin


  Inc(ThreadCount);

  oThreadMoveTabelas := TThreadMoveTabelas.Create(true);

  oThreadMoveTabelas.FmeLog         := FmeLog;
  oThreadMoveTabelas.FmeErros       := FmeErros;

  oThreadMoveTabelas.FpbStatus      := FpbStatus;
  oThreadMoveTabelas.FTabela        := cTabela;
  oThreadMoveTabelas.FLinhas        := nLinhas;
  oThreadMoveTabelas.FParmFirebird  := FParmFirebird;
  oThreadMoveTabelas.FParOracle     := FParOracle;
  oThreadMoveTabelas.FnTotalTabelas := FnTotalTabelas;
  oThreadMoveTabelas.FnTabelaAtual  := FnTabelaAtual;
  oThreadMoveTabelas.Start;

  if ThreadCount >= 10 then
    begin
    while not oThreadMoveTabelas.Finalizou do
      Sleep(5);

    ThreadCount := 0;
  end;





  {try
    Logar(tplLog, ' : Inciando copia da tabela ' + cTabela + '('+ IntToStr(nLinhas) +' registros) - Tabela' + IntToStr(FnTabelaAtual) + ' de ' + IntToStr(FnTotalTabelas));
    dtini := Now;
    oMove := TMoveDados.Create(FDConFirebird, FDConOracle);
    oMove.MoverDadosTabela(cTabela);
    total := Now-dtini;
    Logar(tplLog, ' : Finalizada copia da tabela ' + cTabela + ' com ' +
           IntToStr(nLinhas) + ' registros ' +
           ' em ' + FormatDateTime('hh:mm:sssss', total));
  finally
    oMove.Free;
  end;}
end;

procedure TThreadMoveDados.ConfigurarConexoes;
//var
//  oParOracle, oParmFirebird: IParametrosConexao;
begin
//  oParmFirebird := TParametrosConexao.New('127.0.0.1', '3050', 'E:\Bancos\INDIANAAGRI_MIGRA.FDB', 'VIASOFT', '153', 'FB');
  FModelFirebird := TModelConexao.Create(FParmFirebird);
  FDConFirebird := FModelFirebird.GetConexao;

//  oParOracle := TParametrosConexao.New('127.0.0.1', '1521', 'LOCAL_ORCL', 'VIASOFT', 'VIASOFT', 'Ora');
  FModelOracle := TModelConexao.Create(FParOracle);
  FDConOracle := FModelOracle.GetConexao;

  qryTabelas.Connection := FDConFirebird;
end;


constructor TThreadMoveDados.Create(CreateSuspended: Boolean);
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;
  qryTabelas := TFDQuery.Create(nil);
end;

destructor TThreadMoveDados.Destroy;
begin
  FModelFirebird.Free;
  FModelOracle.Free;
  qryTabelas.Free;
  inherited;
end;

procedure TThreadMoveDados.CarregarTabelasSistema;
begin
  try
    qryTabelas.Close;
    qryTabelas.SQL.Text := FConsulta;
//    qryTabelas.SQL.Text := 'SELECT * FROM MIGRATABELAS WHERE TABELA = ''PCLASFIS'''; //MIGRAR = '+ QuotedStr('S') +
//                           ' AND PERSONALIZADA <> ' + QuotedStr('S') + ' AND LINHAS > 0 AND MIGRADA <> ' + QuotedStr('S') +
//                           ' ORDER BY LINHAS DESC';
    qryTabelas.Open;
    qryTabelas.FetchAll;
  except
    on e: Exception do
      begin
      Logar(tplErro,' : Erro ao carregar lista de tabelas : '  + e.message);
    end;
  end;
end;

procedure TThreadMoveDados.Logar(eTpLog: tpLog; cMsg: String);
begin
  FcMsg := cMsg;
  FeTpLog := eTpLog;
  Synchronize(SyncLogar);
end;


procedure TThreadMoveDados.SyncLogar;
begin
  TLog.New.Logar(FcMsg);
  if (FeTpLog = tplLog) then
    FmeLog.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg)
  else if (FeTpLog = tplErro) then
    FmeErros.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg);
  FpbStatus.Position := Round((FnTabelaAtual/FnTotalTabelas)*100);
end;

end.
