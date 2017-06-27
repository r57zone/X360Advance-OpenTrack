library Project1;

uses
  Windows, IdSocketHandle, SysUtils,
  IdUDPServer, Classes, IniFiles;
  //Messages, Forms for SendLog 

{$R *.res}

const
  // Constants for gamepad buttons
  XINPUT_GAMEPAD_DPAD_UP          = 1;
  XINPUT_GAMEPAD_DPAD_DOWN        = 2;
  XINPUT_GAMEPAD_DPAD_LEFT        = 4;
  XINPUT_GAMEPAD_DPAD_RIGHT       = 8;
  XINPUT_GAMEPAD_START            = 16;
  XINPUT_GAMEPAD_BACK             = 32;
  XINPUT_GAMEPAD_LEFT_THUMB       = 64;
  XINPUT_GAMEPAD_RIGHT_THUMB      = 128;
  XINPUT_GAMEPAD_LEFT_SHOULDER    = 256;
  XINPUT_GAMEPAD_RIGHT_SHOULDER   = 512;
  XINPUT_GAMEPAD_A                = 4096;
  XINPUT_GAMEPAD_B                = 8192;
  XINPUT_GAMEPAD_X                = 16384;
  XINPUT_GAMEPAD_Y                = 32768;

  //Flags for battery status level
  BATTERY_TYPE_DISCONNECTED       = $00;

  //User index definitions
  XUSER_MAX_COUNT                 = 4;
  XUSER_INDEX_ANY                 = $000000FF;

  //Other
  ERROR_DEVICE_NOT_CONNECTED = 1167;
  ERROR_SUCCESS = 0;

  //Types and headers taken from XInput.pas
  //https://casterprojects.googlecode.com/svn/Delphi/XE2/Projects/DX/DirectXHeaders/Compact/XInput.pas

  type
  //Structures used by XInput APIs
    PXInputGamepad = ^TXInputGamepad;
    _XINPUT_GAMEPAD = record
    wButtons: Word;
    bLeftTrigger: Byte;
    bRightTrigger: Byte;
    sThumbLX: Smallint;
    sThumbLY: Smallint;
    sThumbRX: Smallint;
    sThumbRY: Smallint;
  end;
  XINPUT_GAMEPAD = _XINPUT_GAMEPAD;
  TXInputGamepad = XINPUT_GAMEPAD;

  PXInputState = ^TXInputState;
  _XINPUT_STATE = record
    dwPacketNumber: DWORD;
    Gamepad: TXInputGamepad;
  end;
  XINPUT_STATE = _XINPUT_STATE;
  TXInputState = XINPUT_STATE;

  PXInputVibration = ^TXInputVibration;
  _XINPUT_VIBRATION = record
    wLeftMotorSpeed:  word;
    wRightMotorSpeed: word;
  end;
  XINPUT_VIBRATION = _XINPUT_VIBRATION;
  TXInputVibration = _XINPUT_VIBRATION;

  PXInputCapabilities = ^TXInputCapabilities;
  _XINPUT_CAPABILITIES = record
    _Type: Byte;
    SubType: Byte;
    Flags: Word;
    Gamepad: TXInputGamepad;
    Vibration: TXInputVibration;
  end;
  XINPUT_CAPABILITIES = _XINPUT_CAPABILITIES;
  TXInputCapabilities = _XINPUT_CAPABILITIES;

  PXInputBatteryInformation = ^TXInputBatteryInformation;
  _XINPUT_BATTERY_INFORMATION = record
    BatteryType: Byte;
    BatteryLevel: Byte;
  end;
  XINPUT_BATTERY_INFORMATION = _XINPUT_BATTERY_INFORMATION;
  TXInputBatteryInformation = _XINPUT_BATTERY_INFORMATION;

  PXInputKeystroke = ^TXInputKeystroke;
  _XINPUT_KEYSTROKE = record
    VirtualKey: Word;
    Unicode: WideChar;
    Flags: Word;
    UserIndex: Byte;
    HidCode: Byte;
  end;
  XINPUT_KEYSTROKE = _XINPUT_KEYSTROKE;
  TXInputKeystroke = _XINPUT_KEYSTROKE;

type
  TUDPServer = class
  private
  IdUDPServer: TIdUDPServer;
  procedure IdUDPServerUDPRead(ASender: TObject; AData: TStream; ABinding: TIdSocketHandle);
  public
  constructor Create; reintroduce;
  destructor Destroy; override;
end;

type TOpenTrackPacket = record
    X: double;
    Y: double;
    Z: double;
    Yaw: double;
    Pitch: double;
    Roll: double;
end;

var
  Yaw, Pitch, Roll: double;
  GameMode: Byte;
  WheelAngle: integer;

//Example https://github.com/r57zone/Standard-modular-program
{function SendLog(str:string):boolean;
var
  CDS: TCopyDataStruct;
begin
  CDS.dwData:=0;
  CDS.cbData:=(length(str)+ 1)*sizeof(char);
  CDS.lpData:=PChar(str);
  SendMessage(FindWindow(nil, 'Show Xinput'), WM_COPYDATA, Integer(Application.Handle), Integer(@CDS));
end;  }

function DllMain(inst:LongWord; reason:DWORD; const reserved): boolean;
begin
  Result:=true;
end;

function ToLeftStick(Data: double): integer;
begin
  Result:=Round(32767 / WheelAngle * Data);
  if Result < -32767 then Result:=-32767;
  if Result > 32767 then Result:=32767;
end;

function ThumbFix(n: double): integer;
begin
  Result:=Round(n);
  if n > 32767 then Result:=32767;
  if n < -32767 then Result:=-32767;
end;

function MyXInputGetState(dwUserIndex: DWORD; out pState: TXInputState): DWORD; Stdcall; External 'C:\Windows\System32\xinput1_3.dll' name 'XInputGetState';

function XInputGetState(
    dwUserIndex: DWORD;      //Index of the gamer associated with the device
    out pState: TXInputState //Receives the current state
 ): DWORD; stdcall;
var
  MyState: TXInputState;            //keys: DWORD;
begin
  pState.Gamepad.bRightTrigger:=0;
  pState.Gamepad.bLeftTrigger:=0;
  pState.Gamepad.sThumbLX:=0;
  pState.Gamepad.sThumbLY:=0;
  pState.Gamepad.sThumbRX:=0;
  pState.Gamepad.sThumbRY:=0;
 // keys:=0;

  MyXInputGetState(0, MyState);
  if MyState.Gamepad.bLeftTrigger > 0 then pState.Gamepad.bLeftTrigger:=MyState.Gamepad.bLeftTrigger;
  if MyState.Gamepad.bRightTrigger > 0 then pState.Gamepad.bRightTrigger:=MyState.Gamepad.bRightTrigger;

  //if (MyState.Gamepad.wButtons and XINPUT_GAMEPAD_A) <> 0 then keys:=keys+XINPUT_GAMEPAD_A; //Проброс кнопки A.
  //if (MyState.Gamepad.wButtons and XINPUT_GAMEPAD_X) <> 0 then keys:=keys+XINPUT_GAMEPAD_X; //Проброс кнопки X.
  //if (MyState.Gamepad.wButtons and XINPUT_GAMEPAD_Y) <> 0 then keys:=keys+XINPUT_GAMEPAD_Y; //Проброс кнопки Y.
  //if (MyState.Gamepad.wButtons and XINPUT_GAMEPAD_B) <> 0 then keys:=keys+XINPUT_GAMEPAD_B; //Проброс кнопки B.
  pState.Gamepad.wButtons:=MyState.Gamepad.wButtons;


  //FPS
  if ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_LEFT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_RIGHT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_BACK)<>0) then GameMode:=1;

  //Wheel
  if ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_LEFT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_RIGHT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_START) <> 0) then GameMode:=2;

  //GameMode default
  if ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_LEFT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_RIGHT_SHOULDER) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_BACK) <> 0) and
     ((MyState.Gamepad.wButtons and XINPUT_GAMEPAD_START) <> 0) then GameMode:=0;


  case GameMode of
    0: begin
      pState.Gamepad.sThumbLX:=MyState.Gamepad.sThumbLX;
      pState.Gamepad.sThumbLY:=MyState.Gamepad.sThumbLY;
      pState.Gamepad.sThumbRX:=MyState.Gamepad.sThumbRX;
      pState.Gamepad.sThumbRY:=MyState.Gamepad.sThumbRY;
    end;

    1: begin
      pState.Gamepad.sThumbRX:=ThumbFix(MyState.Gamepad.sThumbRX + (Pitch*-1));
      pState.Gamepad.sThumbRY:=ThumbFix(MyState.Gamepad.sThumbRY + (Roll*-1));
      pState.Gamepad.sThumbLX:=MyState.Gamepad.sThumbLX;
      pState.Gamepad.sThumbLY:=MyState.Gamepad.sThumbLY;
    end;

    2: begin
      pState.Gamepad.sThumbLX:=ToLeftStick(Pitch*-1);
      pState.Gamepad.sThumbLY:=MyState.Gamepad.sThumbLY;
      pState.Gamepad.sThumbRX:=MyState.Gamepad.sThumbRX;
      pState.Gamepad.sThumbRY:=MyState.Gamepad.sThumbRY;
    end;

  end;

  pState.dwPacketNumber:=GetTickCount;
  //SendLog('XInputGetState '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function MyXInputSetState(dwUserIndex: DWORD; const pVibration: TXInputVibration): DWORD; stdcall; External 'C:\Windows\System32\xinput1_3.dll' name 'XInputSetState';

function XInputSetState(
    dwUserIndex: DWORD;
    const pVibration: TXInputVibration  //The vibration information to send to the controller
 ): DWORD; stdcall;
begin
  //SendLog('XInputSetState '+IntToStr(dwUserIndex));
  MyXInputSetState(dwUserIndex, pVibration);
  //Temporary solution
  //if (pVibration.wLeftMotorSpeed<>0) and (pVibration.wRightMotorSpeed<>0) then
  //Send vibration true or false to other devices
  //SendLog('Motor L='+IntToStr(Integer(pVibration.wLeftMotorSpeed))+' R='+IntToStr(Integer(pVibration.wRightMotorSpeed))); //incorrect data

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetCapabilities(
    dwUserIndex: DWORD;
    dwFlags: DWORD;                         //Input flags that identify the device type
    out pCapabilities: TXInputCapabilities  //Receives the capabilities
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetCapabilities '+IntToStr(dwUserIndex)+' '+IntToStr(dwFlags));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

procedure XInputEnable(
    enable: BOOL     //Indicates whether xinput is enabled or disabled.
); stdcall;
begin
  //if enable then
  //SendLog('XInputEnable true') else SendLog('XInputEnable false');
end;

function XInputGetDSoundAudioDeviceGuids(
    dwUserIndex: DWORD;
    out pDSoundRenderGuid: TGUID; //DSound device ID for render
    out pDSoundCaptureGuid: TGUID //DSound device ID for capture
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetDSoundAudioDeviceGuids '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetBatteryInformation(
    dwUserIndex: DWORD;
    devType: Byte;               //Which device on this user index
    out pBatteryInformation: TXInputBatteryInformation //Contains the level and types of batteries
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetBatteryInformation '+IntToStr(dwUserIndex)+' '+IntToStr(devType));
  Result:=BATTERY_TYPE_DISCONNECTED;
end;

function XInputGetKeystroke(
    dwUserIndex: DWORD;
    dwReserved: DWORD;                // Reserved for future use
    var pKeystroke: TXInputKeystroke  //Pointer to an XINPUT_KEYSTROKE structure that receives an input event.
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetKeystroke '+IntToStr(dwUserIndex)+' '+IntToStr(dwReserved));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputGetStateEx(
    dwUserIndex: DWORD;
    out pState: TXInputState
 ): DWORD; stdcall;
begin
  //SendLog('XInputGetStateEx '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then result:=ERROR_SUCCESS
  else result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputWaitForGuideButton(
    dwUserIndex: DWORD;
    dwFlags: DWORD;
    const LPVOID
 ): DWORD; stdcall;
begin
  //SendLog('XInputWaitForGuideButton '+IntToStr(dwUserIndex)+' '+IntToStr(dwFlags));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputCancelGuideButtonWait(
    dwUserIndex: DWORD               
): DWORD; stdcall;
begin
  //SendLog('XInputCancelGuideButtonWait '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

function XInputPowerOffController(
    dwUserIndex: DWORD
): DWORD; stdcall;
begin
  //SendLog('XInputPowerOffController '+IntToStr(dwUserIndex));

  if dwUserIndex=0 then Result:=ERROR_SUCCESS
  else Result:=ERROR_DEVICE_NOT_CONNECTED;
end;

exports
  //XInput 1.3
  DllMain index 1, XInputGetState index 2, XInputSetState index 3, XInputGetCapabilities index 4, XInputEnable index 5,
  XInputGetDSoundAudioDeviceGuids index 6, XInputGetBatteryInformation index 7, XInputGetKeystroke index 8,
  //XInput 1.3 undocumented
  XInputGetStateEx index 100, XInputWaitForGuideButton index 101, XInputCancelGuideButtonWait index 102, XInputPowerOffController index 103;
{ TUDPServer }

constructor TUDPServer.Create;
begin
  idUDPServer:=TIdUDPServer.Create(nil);
  idUDPServer.DefaultPort:=4242;
  idUDPServer.BufferSize:=8192;
  idUDPServer.BroadcastEnabled:=false;
  idUDPServer.OnUDPRead:=IdUDPServerUDPRead;
  IdUDPServer.ThreadedEvent:=true;
  IdUDPServer.Active:=true;
end;

destructor TUDPServer.Destroy;
begin
  IdUDPServer.Active:=false;
  IdUDPServer.Free;
  inherited destroy;
end;

procedure TUDPServer.IdUDPServerUDPRead(ASender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  Packet: TOpenTrackPacket;
begin
  Adata.Read(Packet, SizeOf(Packet));
  Yaw:=Packet.Yaw;
  Pitch:=Packet.Pitch;
  Roll:=Packet.Roll;
end;

var
  Ini: TIniFile;
begin
  TUDPServer.Create;
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'WheelSetup.ini');
  WheelAngle:=Ini.ReadInteger('Main', 'WheelAngle', 50);
  Ini.Free;
end.
