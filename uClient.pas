unit uClient;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, sgcBase_Classes, sgcSocket_Classes,
  sgcTCP_Classes, sgcWebSocket_Classes, sgcWebSocket_Classes_Indy,
  sgcWebSocket_Client, sgcWebSocket, FMX.ScrollBox, FMX.Memo;

type
  TFrmClient = class(TForm)
    lblName: TLabel;
    edtName: TEdit;
    sgcWsClient: TsgcWebSocketClient;
    lblMessage: TLabel;
    edtMessage: TEdit;
    btnSend: TButton;
    mmLog: TMemo;
    procedure FormShow(Sender: TObject);
    procedure sgcWsClientConnect(Connection: TsgcWSConnection);
    procedure sgcWsClientDisconnect(Connection: TsgcWSConnection;
      Code: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgcWsClientError(Connection: TsgcWSConnection;
      const Error: string);
    procedure sgcWsClientMessage(Connection: TsgcWSConnection;
      const Text: string);
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmClient: TFrmClient;

implementation

{$R *.fmx}

procedure TFrmClient.btnSendClick(Sender: TObject);
begin
    if sgcWsClient.Active then
  begin
    if edtName.Text = '' then
      raise Exception.Create('Please, set your name first!');

    if edtMessage.Text = '' then
      raise Exception.Create('Please, insert a message first!');

    sgcWsClient.WriteData(edtName.Text + ': ' + edtMessage.Text);

    edtMessage.Text := '';
  end
  else
    raise Exception.Create('Your are not Connected!');
end;

procedure TFrmClient.FormShow(Sender: TObject);
begin
  sgcWsClient.Active := True;
end;

procedure TFrmClient.sgcWsClientConnect(Connection: TsgcWSConnection);
begin
  mmLog.Lines.Add('You are connected');
end;

procedure TFrmClient.sgcWsClientDisconnect(Connection: TsgcWSConnection;
  Code: Integer);
begin
  mmLog.Lines.Add('#disconnected (' + IntToStr(Code) + ')');
end;

procedure TFrmClient.sgcWsClientError(Connection: TsgcWSConnection;
  const Error: string);
begin
  mmLog.Lines.Add('#error: ' + Error);
end;

procedure TFrmClient.sgcWsClientMessage(Connection: TsgcWSConnection;
  const Text: string);
begin
  mmLog.Lines.Add(Text);
end;

procedure TFrmClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if sgcWsClient.Active = True then begin
    edtMessage.Text := 'User ' + edtName.Text + ' is offline!';
    btnSendClick(nil);
  end;

  sgcWsClient.Active := False;
end;

end.
