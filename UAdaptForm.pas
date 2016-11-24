unit UAdaptForm;

interface
Uses
  SysUtils,Windows,Classes,Graphics, Controls,Forms,Dialogs, Math, TypInfo;

Const   //��¼���ʱ����Ļ�ֱ���
  OriWidth=1366;
  OriHeight=768;

Type

  TfmForm=Class(TForm)   //ʵ�ִ�����Ļ�ֱ��ʵ��Զ�����
  Private
    fScrResolutionRateW: Double;
    fScrResolutionRateH: Double;
    fIsFitDeviceDone: Boolean;
    procedure FitDeviceResolution;
  Protected
    Property IsFitDeviceDone:Boolean Read fIsFitDeviceDone;
    Property ScrResolutionRateH:Double Read fScrResolutionRateH;
    Property ScrResolutionRateW:Double Read fScrResolutionRateW;
  Public
    Constructor Create(AOwner: TComponent); Override;
  End;

  TfdForm=Class(TfmForm)   //���ӶԻ�������޸�ȷ��
  Protected
    fIsDlgChange:Boolean;
  Public
  Constructor Create(AOwner: TComponent); Override;
  Property IsDlgChange:Boolean Read fIsDlgChange default false;
 End;

implementation

constructor TfmForm.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);
  fScrResolutionRateH:=1;
  fScrResolutionRateW:=1;
  Try
    if Not fIsFitDeviceDone then
    Begin
      FitDeviceResolution;
   fIsFitDeviceDone:=True;
    End;
  Except
  fIsFitDeviceDone:=False;
  End;
end;

procedure TfmForm.FitDeviceResolution;
Var
  LocList:TList;
  LocFontRate:Double;
  LocFontSize:Integer;
  LocFont:TFont;
  locK:Integer;

  function PropertyExists(const AObject : TObject;const APropName : String):Boolean;
  var
    PropInfo:PPropInfo;
  begin
    PropInfo:=GetPropInfo(AObject.ClassInfo,APropName);
    Result:=Assigned(PropInfo);
  end;

  function GetObjectProperty(const AObject : TObject;const APropName : string):TObject;
  var
    PropInfo:PPropInfo;
  begin
    Result := nil;
    PropInfo:=GetPropInfo(AObject.ClassInfo,APropName);
    if Assigned(PropInfo) and
    (PropInfo^.PropType^.Kind = tkClass) then
    Result := GetObjectProp(AObject,PropInfo);
  end;

{����߶ȵ����Ļ�������}
  Procedure CalBasicScalePars;
  Begin
    try
      Self.Scaled:=False;
      fScrResolutionRateH:=screen.height/OriHeight;
      fScrResolutionRateW:=screen.Width/OriWidth;
      LocFontRate:=Min(fScrResolutionRateH,fScrResolutionRateW);
    except
      Raise;
    end;
  End;

{����ԭ������λ�ã����õݹ鷨��������������Ŀؼ���ֱ�����һ��}
  Procedure ControlsPostoList(vCtl:TControl;vList:TList);
  Var
    locPRect:^TRect;
    i:Integer;
    locCtl:TControl;
  Begin
    try
      New(locPRect);
      locPRect^:=vCtl.BoundsRect;
      vList.Add(locPRect);
      If vCtl Is TWinControl Then
        For i:=0 to TWinControl(vCtl).ControlCount-1 Do
        begin
          locCtl:=TWinControl(vCtl).Controls[i];
          ControlsPosToList(locCtl,vList);
        end;
    except
      Raise;
    end;
  End;

{�����µ�����λ�ã����õݹ鷨��������������Ŀؼ���ֱ�����һ�㡣
 ��������ʱ�ȼ��㶥���������ģ�Ȼ���𼶵ݽ�}
  Procedure AdjustControlsScale(vCtl:TControl;vList:TList;Var vK:Integer);
  Var
    locOriRect,LocNewRect:TRect;
    i:Integer;
    locCtl:TControl;
  Begin
    try
      If vCtl.Align<>alClient Then
      Begin
        locOriRect:=TRect(vList.Items[vK]^);
        With locNewRect Do
        begin
           Left:=Round(locOriRect.Left*fScrResolutionRateW);
           Right:=Round(locOriRect.Right*fScrResolutionRateW);
           Top:=Round(locOriRect.Top*fScrResolutionRateH);
           Bottom:=Round(locOriRect.Bottom*fScrResolutionRateH);
           vCtl.SetBounds(Left,Top,Right-Left,Bottom-Top);
        end;
      End;
      Inc(vK);
      If vCtl Is TWinControl Then
        For i:=0 to TwinControl(vCtl).ControlCount-1 Do
        begin
          locCtl:=TWinControl(vCtl).Controls[i];
          AdjustControlsScale(locCtl,vList,vK);
        end;
    except
      Raise;
    end;
  End;

{�����µı�����ƴ����и����������}
  Procedure AdjustComponentFont(vCmp:TComponent);
  Var
    i:Integer;
    locCmp:TComponent;
  Begin
    try
      For i:=vCmp.ComponentCount-1 Downto 0 Do
      Begin
        locCmp:=vCmp.Components[i];
        If PropertyExists(LocCmp,'FONT') Then
        Begin
          LocFont:=TFont(GetObjectProperty(LocCmp,'FONT'));
          LocFontSize := Round(LocFontRate*LocFont.Size);
          LocFont.Size:=LocFontSize;
        End;
      End;
    except
      Raise;
    end;
  End;

{�ͷ�����λ��ָ����б����}
  Procedure FreeListItem(vList:TList);
  Var
    i:Integer;
  Begin
    For i:=0 to vList.Count-1 Do
      Dispose(vList.Items[i]);
    vList.Free;
  End;

begin
  LocList:=TList.Create;
  Try
    Try
      if (Screen.width<>OriWidth)OR(Screen.Height<>OriHeight) then
      begin
        CalBasicScalePars;
        AdjustComponentFont(Self);
        ControlsPostoList(Self,locList);
        locK:=0;
        AdjustControlsScale(Self,locList,locK);
      End;
    Except on E:Exception Do
        Raise Exception.Create('������Ļ�ֱ�������Ӧ����ʱ���ִ���'+E.Message);
    End;
  Finally
    FreeListItem(locList);
  End;
end;


{ TfdForm }

constructor TfdForm.Create(AOwner: TComponent);
begin
  inherited;
  fIsDlgChange:=False;
end;

end.
