unit uMoveDados;

interface

uses
  FireDAC.Comp.BatchMove, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Comp.BatchMove.SQL,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.BatchMove.DataSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  System.Classes, FireDAC.Comp.UI,
  uConexoes, Vcl.StdCtrls;

type
  IMoveDados = interface
  ['{5EFE6439-77A9-4A96-A0EF-4FFC1E1ED476}']
    procedure MoverDadosTabela(cTabela: String);
  end;

  TMoveDados = class(TInterfacedObject, IMoveDados)
  private
    FModelFirebird: TModelConexao;
    FModelOracle: TModelConexao;
    FDBatchMove1: TFDBatchMove;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDBatchMoveDataSetWriter1: TFDBatchMoveDataSetWriter;
    FDBatchMoveSQLReader1: TFDBatchMoveSQLReader;
    FDBatchMoveSQLWriter1: TFDBatchMoveSQLWriter;
    FDMetaInfoQuery1: TFDMetaInfoQuery;
    FDCommand1: TFDCommand;
    qryOrigem: TFDQuery;
    qryDestino: TFDQuery;
    qryTabelas: TFDQuery;
    dsTabelas: TDataSource;
  public
    FmeLog: TMemo;
    FmeErros: TMemo;
    FDConOracle: TFDConnection;
    FDConFireBird: TFDConnection;
    class function New(oConOrigem, oConDestino: TFDConnection): IMoveDados;
    constructor Create(oConOrigem, oConDestino: TFDConnection); overload;
    destructor Destroy; override;
    procedure MoverDadosTabela(cTabela: String);
    procedure ExecuteCommandDestino(cComando: String);
    procedure AtualizarMigradas(cTabela: String);
  end;

implementation

uses uParametrosConexao, uEnum;


{ TMoveDados }

class function TMoveDados.New(oConOrigem, oConDestino: TFDConnection): IMoveDados;
begin
  Result := TMoveDados.Create(oConOrigem, oConDestino);
end;

constructor TMoveDados.Create(oConOrigem, oConDestino: TFDConnection);
begin
  FDConFirebird := oConOrigem;
  FDConOracle := oConDestino;
//  qryOrigem := TFDQuery.Create(nil);
//  qryDestino := TFDQuery.Create(nil);
//  qryOrigem.Connection := FDConFirebird;
//  qryDestino.Connection := FDConOracle;

//  FDBatchMoveDataSetReader1 := TFDBatchMoveDataSetReader.Create(nil);
//  FDBatchMoveDataSetWriter1 := TFDBatchMoveDataSetWriter.Create(nil);
//  FDBatchMoveDataSetReader1.DataSet := qryOrigem;
//  FDBatchMoveDataSetWriter1.DataSet := qryDestino;

  FDBatchMove1 := TFDBatchMove.Create(nil);
  FDBatchMoveSQLReader1 := TFDBatchMoveSQLReader.Create(FDBatchMove1);
  FDBatchMoveSQLReader1.Connection := FDConFirebird;

  FDBatchMoveSQLWriter1 := TFDBatchMoveSQLWriter.Create(FDBatchMove1);
  FDBatchMoveSQLWriter1.Connection := FDConOracle;



//  FDBatchMove1.CommitCount := 500;
//  FDBatchMove1.Reader := FDBatchMoveDataSetReader1;
  FDBatchMove1.Reader := FDBatchMoveSQLReader1;
  FDBatchMove1.Writer := FDBatchMoveSQLWriter1;
end;

destructor TMoveDados.Destroy;
begin
//  qryOrigem.Free;
//  qryDestino.Free;
//  FDBatchMoveDataSetReader1.Free;
//  FDBatchMoveDataSetWriter1.Free;
  FDBatchMoveSQLReader1.Free;
  FDBatchMove1.Free;
  inherited;
end;

procedure TMoveDados.MoverDadosTabela(cTabela: String);
begin
  ExecuteCommandDestino('TRUNCATE TABLE ' + cTabela);
//  qryOrigem.SQL.Text := 'SELECT * FROM ' + cTabela;
//  qryOrigem.Open;
  FDBatchMoveSQLReader1.TableName := cTabela;
  FDBatchMoveSQLWriter1.TableName := cTabela;

//  qryDestino.SQL.Text := 'SELECT * FROM ' + cTabela;
//  qryDestino.Open;

  FDBatchMove1.Execute;

  //FDBatchMove1.OnProgress;

  AtualizarMigradas(cTabela);
end;

procedure TMoveDados.AtualizarMigradas(cTabela: String);
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FDConFireBird;
    qry.SQL.Text := 'SELECT * FROM MIGRATABELAS WHERE TABELA = :TABELA';
    qry.ParamByName('TABELA').Value := cTabela;
    qry.Open();
    qry.Edit;
    qry.FieldByName('MIGRADA').Value := 'S';
    qry.Post;
  finally
    qry.Free;
  end;
end;


procedure TMoveDados.ExecuteCommandDestino(cComando: String);
begin
  FDConOracle.ExecSQL(cComando);
end;



end.
