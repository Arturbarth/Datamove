{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}


unit uThreadMoveDados;

interface

uses
  System.Classes, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.FB, uConexoes, uParametrosConexao, uEnum, Vcl.StdCtrls,
  uThreadMoveTabela, System.Generics.Collections;

type
  TThreadMoveDados = class
  private
    FcMsg: String;
    FeTpLog: tpLog;
    FnTotalTabelas: Integer;
    FnTabelaAtual: Integer;
    FModelFirebird: TModelConexao;
    FModelOracle: TModelConexao;
    qryTabelas: TFDQuery;

    procedure Logar(eTpLog: tpLog; cMsg: String);
    procedure SyncLogar;

  protected
    //procedure Execute; override;

  public
    FmeLog: TMemo;
    FmeErros: TMemo;
    FConsulta: String;
    ThreadCount: Integer;
    oListaThreads : TList;
    FpbStatus: TProgressBar;

    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;
    FParOracle, FParmFirebird: IParametrosConexao;

    procedure CarregarTabelasSistema;
    procedure ConfigurarConexoes;
    procedure MoverTabela(cTabela: String; nLinhas: Integer);
    procedure MoverTabelasSistema;


    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, uLog, uMoveDados;
{ TThreadMoveDados }

{procedure TThreadMoveDados.Execute;
begin
  ThreadCount := 0;
  oListaThreads := TList.Create;
  ConfigurarConexoes;
  MoverTabelasSistema;
end;}

procedure TThreadMoveDados.MoverTabelasSistema;
var
  cTabela: String;
begin
  Logar(tplLog,' iniciar tabelas ');

  qryTabelas.Connection := FDConFirebird;
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
  i: Integer;
  {dtini, dtfim, total: TDateTime;
  oMove: TMoveDados;}
begin

  Inc(ThreadCount);

  oThreadMoveTabelas := TThreadMoveTabelas.Create;

  oThreadMoveTabelas.FmeLog         := FmeLog;
  oThreadMoveTabelas.FmeErros       := FmeErros;

  oThreadMoveTabelas.FpbStatus      := FpbStatus;
  oThreadMoveTabelas.FTabela        := cTabela;
  oThreadMoveTabelas.FLinhas        := nLinhas;
  oThreadMoveTabelas.FParmFirebird  := FParmFirebird;
  oThreadMoveTabelas.FParOracle     := FParOracle;


  oThreadMoveTabelas.FDConOracle    := FDConOracle;
  oThreadMoveTabelas.FDConFireBird  := FDConFireBird;

  oThreadMoveTabelas.FnTotalTabelas := FnTotalTabelas;
  oThreadMoveTabelas.FnTabelaAtual  := FnTabelaAtual;
  oThreadMoveTabelas.MoverTabela(cTabela, nLinhas);;

  {oListaThreads.Add(oThreadMoveTabelas);

  if ThreadCount >= 8 then
    begin
    while oListaThreads.Count > 8 do begin
      for I := 0 to oListaThreads.Count-1 do
      begin
        if TThreadMoveTabelas(oListaThreads[i]).Finalizou then
          begin
          Dec(ThreadCount);
          oListaThreads.Remove(oListaThreads[i]);
          Break;
        end;
      end;
    end;
    {while not oThreadMoveTabelas.Finalizou do
      Sleep(5);
  end;?



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
  try
    Logar(tplLog, ' : Conectando Origem ::');
    FModelFirebird := TModelConexao.Create(FParmFirebird);
    FDConFirebird := FModelFirebird.GetConexao;
    Logar(tplLog, ' : Conectado Origem ::');
  except
    on e:Exception do begin
      Logar(tplLog, ' : Conectando Origem ::' + e.Message);
    end;
  end;

  try
    Logar(tplLog, ' : Conectando Destino ::');
  //  oParOracle := TParametrosConexao.New('127.0.0.1', '1521', 'LOCAL_ORCL', 'VIASOFT', 'VIASOFT', 'Ora');
    FModelOracle := TModelConexao.Create(FParOracle);
    FDConOracle := FModelOracle.GetConexao;
    Logar(tplLog, ' : Conectado Destino ::');
 except
    on e:Exception do begin
      Logar(tplLog, ' : Conectando Destino ::' + e.Message);
    end;
  end;

  qryTabelas.Connection := FDConFirebird;
end;


constructor TThreadMoveDados.Create;
begin
  inherited Create;
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
    Logar(tplLog,' Carregando tabelas ');
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
  SyncLogar;
  //Synchronize(SyncLogar);
end;


procedure TThreadMoveDados.SyncLogar;
begin
  TLog.New.Logar(FcMsg);
  if (FeTpLog = tplLog) then
    FmeLog.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg)
  else if (FeTpLog = tplErro) then
    FmeErros.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:sssss', now)  + ' : ' + FcMsg);
  //FpbStatus.Position := Round((FnTabelaAtual/FnTotalTabelas)*100);
end;

end.

{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}

