unit uIParametrosConexoes;

interface

uses
  uEnum;

type
  IParametrosConexoes = interface
    ['{63587B88-E13E-4DB7-A93D-12D6D4B3D6F8}']
    function GetServer: string;
    function GetPorta: string;
    function GetBanco: string;
    function GetUsuario: string;
    function GetSenha: string;
    function GetDriverID: string;
    function GetoTipoBanco: TenBancoConectar;
  end;

implementation

end.
