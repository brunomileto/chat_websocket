unit uc;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Layouts, FMX.Memo,
  sgcWebSocket_Classes, sgcWebSocket_Client, sgcWebSocket, FMX.Edit,
  sgcBase_Classes, sgcTCP_Classes, sgcWebSocket_Classes_Indy, FMX.ScrollBox,
  FMX.StdCtrls, FMX.Controls.Presentation, sgcSocket_Classes;

type
  TfrmWSClient_FMX = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    txtName: TEdit;
    txtMessage: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    WSClient: TsgcWebSocketClient;
    memoLog: TMemo;
    btnSend: TButton;
    procedure WSClientConnect(Connection: TsgcWSConnection);
    procedure WSClientDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure WSClientError(Connection: TsgcWSConnection; const Error: string);
    procedure WSClientMessage(Connection: TsgcWSConnection; const Text: string);
    procedure btnSendClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWSClient_FMX: TfrmWSClient_FMX;

implementation

{$R *.fmx}

procedure TfrmWSClient_FMX.btnSendClick(Sender: TObject);
begin
  if WSClient.Active then
  begin
    if txtName.Text = '' then
      raise Exception.Create('Type a Name before send a message');

    if txtMessage.Text = '' then
      raise Exception.Create('Type a Message before send a message');

    WSClient.WriteData(txtName.Text + ': ' + txtMessage.Text);

    txtMessage.Text := '';
  end
  else
    raise Exception.Create('Not connected');
end;

procedure TfrmWSClient_FMX.btnStartClick(Sender: TObject);
begin
  WSClient.Active := True;
end;

procedure TfrmWSClient_FMX.btnStopClick(Sender: TObject);
begin
  WSClient.Active := False;
end;

procedure TfrmWSClient_FMX.WSClientConnect(Connection: TsgcWSConnection);
begin
  memoLog.Lines.Add('#connected');
end;

procedure TfrmWSClient_FMX.WSClientDisconnect(Connection: TsgcWSConnection;
  Code: Integer);
begin
  memoLog.Lines.Add('#disconnected (' + IntToStr(Code) + ')');
end;

procedure TfrmWSClient_FMX.WSClientError(Connection: TsgcWSConnection;
  const Error: string);
begin
  memoLog.Lines.Add('#error: ' + Error);
end;

procedure TfrmWSClient_FMX.WSClientMessage(Connection: TsgcWSConnection;
  const Text: string);
begin
  memoLog.Lines.Add(Text);
end;

end.
