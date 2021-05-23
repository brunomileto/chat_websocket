program client;

uses
  System.StartUpCopy,
  FMX.Forms,
  uClient in 'uClient.pas' {FrmClient},
  uc in 'uc.pas' {frmWSClient_FMX},
  usv in 'usv.pas' {frmServer_FMX};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmClient, FrmClient);
  Application.CreateForm(TfrmWSClient_FMX, frmWSClient_FMX);
  Application.CreateForm(TfrmServer_FMX, frmServer_FMX);
  Application.Run;
end.
