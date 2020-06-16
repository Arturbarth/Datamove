unit uConexoes;

interface

uses
  FireDAC.Comp.Client, FireDAC.Phys, FireDAC.Phys.Intf,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Def,
  System.Classes, uEnum, FireDAC.Comp.UI, uParametrosConexao

  , FireDAC.Phys.Oracle
  , FireDAC.Phys.OracleDef

  ;

type
  IModelConexao = interface
    ['{14819F40-456A-4003-AB12-2A14CB87BA4E}']
    function GetConexao: TFDConnection;
    function AbrirConexao: iModelConexao;
    function FecharConexao: iModelConexao;
  end;

  TModelConexao = class(TInterfacedObject, iModelConexao)
  private
    oConexao: TFDConnection;
    oWaitCursor: TFDGUIxWaitCursor;
    oDriverFirebird: TFDPhysFBDriverLink;
    oDriverOracle: TFDPhysOracleDriverLink;
    procedure CarregarParametros(AParametros: IParametrosConexao);

  protected

  public
    constructor Create(AParametros: IParametrosConexao); overload;
    destructor Destroy; override;

    function GetConexao: TFDConnection;
    function AbrirConexao: iModelConexao;
    function FecharConexao: iModelConexao;
    class function New(AParametros: IParametrosConexao): iModelConexao;

  published
  end;

implementation

uses
  System.SysUtils;

const
  _DRIVERORACLE = 'Ora';

{ TModelConexao }

constructor TModelConexao.Create(AParametros: IParametrosConexao);
begin
  oWaitCursor := TFDGUIxWaitCursor.Create(Nil);
  oConexao := TFDConnection.Create(Nil);
  if (AParametros.GetDriverID = _DRIVERORACLE) then
    oDriverOracle := TFDPhysOracleDriverLink.Create(Nil)
  else
    oDriverFirebird := TFDPhysFBDriverLink.Create(Nil);
  CarregarParametros(AParametros);
  AbrirConexao;
end;

destructor TModelConexao.Destroy;
begin
  oConexao.Free;
  inherited;
end;

function TModelConexao.FecharConexao: iModelConexao;
begin
  oConexao.Connected := False;
end;

function TModelConexao.GetConexao: TFDConnection;
begin
  Result := oConexao;
end;

class function TModelConexao.New(AParametros: IParametrosConexao): iModelConexao;
begin
  Result := Self.Create(AParametros);
end;

function TModelConexao.AbrirConexao: iModelConexao;
begin
  oConexao.Connected := True;
end;

procedure TModelConexao.CarregarParametros(AParametros: IParametrosConexao);
begin
  oConexao.Params.Database := AParametros.GetBanco;
  oConexao.Params.UserName := AParametros.GetUsuario;
  oConexao.Params.Password := AParametros.GetSenha;
  oConexao.Params.DriverID := AParametros.GetDriverID;
  oConexao.Params.Add('Server=' + AParametros.GetServer);
  oConexao.Params.Add('Port=' + AParametros.GetPorta);
end;

end.
