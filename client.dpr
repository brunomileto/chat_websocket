program client;

uses
  System.StartUpCopy,
  FMX.Forms,
  uClient in 'uClient.pas' {FrmClient};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmClient, FrmClient);
  Application.Run;
end.
