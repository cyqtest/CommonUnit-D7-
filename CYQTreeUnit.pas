{*********************************************************************}
{                                                                     }
{     CYQTreeUnit v1.0  Create By cyq                                 }
{                                                                     }
{                                                                     }
{     ��Ԫ���ܣ��������������ؼ�ΪRZTreeView                          }
{     ���ݿ�ṹ��                                                    }
{               TreeID varchar(20), TreeName varchar(50),             }
{               PrtID varchar(20), TreLevel int                       }
{���α�ʾ�����ڵ�ID�����ڵ����ƣ����ڵ�ID����ǰ���ڵ㼶��0�����      }
{*********************************************************************}
{���ڵ�������Ψһ�ԣ�������������}
//�´��޸ģ�RzCheckTree��RzTreeView������ʹ�����ء����ٴ�����
//2014-01-05 �������ݿ��������

unit CYQTreeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, DB, ADODB, DBCtrls,
  StdCtrls, DBSumLst, Spin, RzTreeVw;

Type
  TTreeNodeDate = record    //����һ����¼�������ṹ
    //BH:string;            //�ڵ���Ŀ���
    TreeID: Integer;        //���ڵ����
    NodeName: String;       //���ڵ�����
    TreLevel:Integer;       //�ڵ�ȼ�
    ImgIndex: Integer;      //��ͼ��Index �����ⲿ�������Ҫ���ò������ʼ����ʱ���롣�Ƚ���׸
    FolderType: Boolean;    //��¼������,true Ϊ�ڵ�,���������滹�нڵ���¼,false Ϊ��¼,�����������Ѿ�û������,Ҳ��������һ��
  end;
  NodeData = ^TTreeNodeDate;

var
  Node  : TTreeNode;
  PNode : NodeData;
  //��ʼ�����ṹ
  procedure IniTreeData(Tree: TRzCheckTree; SourceSQL: string; qryTemp: TADOQuery); overload
  procedure IniTreeData(Tree: TRzTreeView; SourceSQL: string; qryTemp: TADOQuery);  overload
  procedure IniTreeData(Tree: TRzTreeView; qryTemp: TADOQuery);  overload
  //������
  function CheckNullTree(Tree: TRzCheckTree): Boolean; overload
  procedure CheckNoTree(Tree: TRzCheckTree); //ȡ��ѡ���κ����ڵ�
  function GetMaxTreeID(ATreeView: TRzTreeView): Integer;  //��ȡ�������
  function GetCurTreeLevel(ATreeView: TRzTreeView):Integer;//��ȡ��ǰ�ڵ㼶��
  function GetCurTreeID(ATreeView: TRzTreeView):Integer; overload  //��ȡ��ǰ���ڵ�ID
  function GetCurTreeID(ATreeView: TRzCheckTree):Integer; overload  //��ȡ��ǰ���ڵ�ID
  function SelectedTree(ATreeView: TRzTreeView):Boolean;   //������Ƿ���ѡ��

  function IsExistsChildNode(ATreeView: TRzTreeView):Boolean; overload
  function IsExistsChildNode(ATreeNode: TTreeNode):Boolean; overload
  //������ͬ���ڵ�
  function AddTreeNode(NodeName: string; ATreeView: TRzTreeView;
    ANode: TTreeNode; TableName: string; qryTemp: TADOQuery):Boolean;
  //�����ӽڵ�
  function AddTreeChildNode(NodeName: string; ATreeView: TRzTreeView;
    ANode: TTreeNode; TableName: string; qryTemp: TADOQuery):Boolean;
  //ɾ��ѡ�нڵ㣨֧�����ӽڵ㣩
  function DeleteTree(ATreeView: TRzTreeView; ANode: TTreeNode; TableName: string ;
    qryTemp: TADOQuery): Boolean;
  //�޸Ľڵ�����
  function ModifyNodeName(NewNodeName: string;ANode: TTreeNode;
    TableName:string;qryTemp: TADOQuery): Boolean;
  //����Ƿ����ͬ���ڵ�
  function CheckSameTreeName(NodeName: string;ANode: TTreeNode; TableName: string; qryTemp: TADOQuery): Boolean;
  function CheckChildTreeName(NodeName: string;ANode: TTreeNode):Boolean;

  //���ȫ�����ڵ�
  function GetRootNodes(ATreeView: TRzTreeView): TStringList;
  //���ĳ�ڵ�ȫ���ӽڵ�
  function GetChildNodes(ATreeNode: TTreeNode): TStringList;
  //���ĳ�ڵ�ȫ���ӽڵ�
  procedure GetAllChildNodes(ATreeNode: TTreeNode; AStringList: TStringList);

implementation

uses
  CYQCommonUnit;

procedure IniTreeData(Tree: TRzCheckTree; SourceSQL: string; qryTemp: TADOQuery);
  procedure FillOneNode(qry:TADOQuery; TreeName:TRzCheckTree; ParentNode:TTreeNode);
  begin
    with qry do
    begin
      New(PNode);
      //PNode.BH :=Trim(FieldByName('jcxmbh').AsString);
      PNode.TreLevel :=FieldByName('TreLevel').asInteger;
      PNode.TreeID :=FieldByName('TreeID').asInteger;
      PNode.NodeName :=Trim(FieldByName('TreeName').AsString);
      PNode.ImgIndex := FieldByName('TreLevel').asInteger;
//      if FieldByName('TreLevel').asInteger=3 then
//        PNode.FolderType := false
//      else
//        PNode.FolderType := True;
      Node:=TreeName.Items.AddChildObject(parentNode,PNode.NodeName,PNode);
      Node.ImageIndex := PNode.ImgIndex;
      Node.SelectedIndex:=0;
    end;
  end;

  function FindNode(TreeName:TRzCheckTree; TreeID: string): TTreeNode;
    function FindChildNode(TreeName:TRzCheckTree; TreeID: string; CurrNode: TTreeNode): TTreeNode;
    var
      Node: TTreeNode;
    begin
      Result := nil;
      Node := CurrNode;
      if Assigned(Node.Data) and SameText(IntToStr(NodeData(Node.Data).TreeID), TreeID) then
      begin
        Result := Node;
        Exit;
      end;
      Node := Node.getFirstChild;
      while Assigned(Node) do
      begin
        //�ݹ����¼��ڵ�
        Result := FindChildNode(TreeName, TreeID, Node);
        if Assigned(Result) then Exit;
        Node := Node.getNextSibling;
      end;
    end;
  var
    RootNode: TTreeNode;
  begin
    RootNode := TreeName.Items.GetFirstNode;
    while Assigned(RootNode) do
    begin
      Result := FindChildNode(TreeName, TreeID, RootNode);
      if Assigned(Result) then Exit;
      RootNode := RootNode.getNextSibling;
    end;
  end;
var
  iLevel:Integer;
begin
  //������
  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    with qryTemp do
    begin
      Close;
      SQL.Text := SourceSQL;//'Exec sp_ReturnXMLXTree2';
      Open;
      First;
      iLevel := 0;
      while Locate('TreLevel', iLevel, []) do
      begin
        while not Eof do
        begin
          if FieldByName('TreLevel').AsInteger = iLevel then
          begin
            if iLevel = 0 then
              FillOneNode(qryTemp, Tree, nil)
            else
              FillOneNode(qryTemp, Tree, FindNode(Tree, FieldByName('PrtID').AsString));
          end;
          Next;
        end;
        Inc(iLevel);
      end;
      Close;
    end;
  finally
    Tree.Items.EndUpdate;
  end;
//  if Tree.Items.Count > 0 then
//    Tree.Items[0].Expanded := True;   //չ���ⲿ����
    //Tree.Items[0].ImageIndex := 1;   ͼ���ⲿ����
end;

procedure IniTreeData(Tree: TRzTreeView; SourceSQL: string; qryTemp: TADOQuery);
  procedure FillOneNode(qry:TADOQuery; TreeName:TRzTreeView; ParentNode:TTreeNode);
  begin
    with qry do
    begin
      New(PNode);
      //PNode.BH :=Trim(FieldByName('jcxmbh').AsString);
      PNode.TreLevel :=FieldByName('TreLevel').asInteger;
      PNode.TreeID :=FieldByName('TreeID').AsInteger;
      PNode.NodeName :=Trim(FieldByName('TreeName').AsString);
      PNode.ImgIndex := FieldByName('TreLevel').asInteger;
//      if FieldByName('TreLevel').asInteger=3 then  //���չ����Ĭ��չ������
//        PNode.FolderType := false
//      else
//        PNode.FolderType := True;
      Node:=TreeName.Items.AddChildObject(parentNode,PNode.NodeName,PNode);
      Node.ImageIndex := PNode.ImgIndex;
      Node.SelectedIndex:=0;
    end;
  end;

  function FindNode(TreeName:TRzTreeView; TreeID: string): TTreeNode;
    function FindChildNode(TreeName:TRzTreeView; TreeID: string; CurrNode: TTreeNode): TTreeNode;
    var
      Node: TTreeNode;
    begin
      Result := nil;
      Node := CurrNode;
      if Assigned(Node.Data) and SameText(IntToStr(NodeData(Node.Data).TreeID), TreeID) then
      begin
        Result := Node;
        Exit;
      end;
      Node := Node.getFirstChild;
      while Assigned(Node) do
      begin
        //�ݹ����¼��ڵ�
        Result := FindChildNode(TreeName, TreeID, Node);
        if Assigned(Result) then Exit;
        Node := Node.getNextSibling;
      end;
    end;
  var
    RootNode: TTreeNode;
  begin
    RootNode := TreeName.Items.GetFirstNode;
    while Assigned(RootNode) do
    begin
      Result := FindChildNode(TreeName, TreeID, RootNode);
      if Assigned(Result) then Exit;
      RootNode := RootNode.getNextSibling;
    end;
  end;
var
  iLevel:Integer;
begin
  //������
  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    with qryTemp do
    begin
      Close;
      SQL.Text := SourceSQL;//'Exec sp_ReturnXMLXTree2';
      Open;
      First;
      iLevel := 0;
      while Locate('TreLevel', iLevel, []) do
      begin
        while not Eof do
        begin
          if FieldByName('TreLevel').AsInteger = iLevel then
          begin
            if iLevel = 0 then
              FillOneNode(qryTemp, Tree, nil)
            else
              FillOneNode(qryTemp, Tree, FindNode(Tree, FieldByName('PrtID').AsString));
          end;
          Next;
        end;
        Inc(iLevel);
      end;
      Close;
    end;
  finally
    Tree.Items.EndUpdate;
  end;
end;

procedure IniTreeData(Tree: TRzTreeView; qryTemp: TADOQuery);
  procedure FillOneNode(qry:TADOQuery; TreeName:TRzTreeView; ParentNode:TTreeNode);
  begin
    with qry do
    begin
      New(PNode);
      //PNode.BH :=Trim(FieldByName('jcxmbh').AsString);
      PNode.TreLevel :=FieldByName('TreLevel').asInteger;
      PNode.TreeID :=FieldByName('TreeID').asInteger;
      PNode.NodeName :=Trim(FieldByName('TreeName').AsString);
      PNode.ImgIndex := FieldByName('TreLevel').asInteger;
//      if FieldByName('TreLevel').asInteger=3 then
//        PNode.FolderType := false
//      else
//        PNode.FolderType := True;
      Node:=TreeName.Items.AddChildObject(parentNode,PNode.NodeName,PNode);
      Node.ImageIndex := PNode.ImgIndex;
      Node.SelectedIndex:=0;
    end;
  end;

  function FindNode(TreeName:TRzTreeView; TreeID: string): TTreeNode;
    function FindChildNode(TreeName:TRzTreeView; TreeID: string; CurrNode: TTreeNode): TTreeNode;
    var
      Node: TTreeNode;
    begin
      Result := nil;
      Node := CurrNode;
      if Assigned(Node.Data) and SameText(IntToStr(NodeData(Node.Data).TreeID), TreeID) then
      begin
        Result := Node;
        Exit;
      end;
      Node := Node.getFirstChild;
      while Assigned(Node) do
      begin
        //�ݹ����¼��ڵ�
        Result := FindChildNode(TreeName, TreeID, Node);
        if Assigned(Result) then Exit;
        Node := Node.getNextSibling;
      end;
    end;
  var
    RootNode: TTreeNode;
  begin
    RootNode := TreeName.Items.GetFirstNode;
    while Assigned(RootNode) do
    begin
      Result := FindChildNode(TreeName, TreeID, RootNode);
      if Assigned(Result) then Exit;
      RootNode := RootNode.getNextSibling;
    end;
  end;
begin
  //������
  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    with qryTemp do
    begin
      First;
      while not Eof do
      begin
        if FieldByName('TreLevel').AsInteger = 0 then
          FillOneNode(qryTemp, Tree, nil)
        else
          FillOneNode(qryTemp, Tree, FindNode(Tree, FieldByName('PrtID').AsString));
        Next;
      end;
      Close;
    end;
  finally
    Tree.Items.EndUpdate;
  end;
end;

function CheckNullTree(Tree: TRzCheckTree): Boolean;
var
  iNode: Integer;
begin
  Result := False;
  if Assigned(Tree) then
  if Tree.Items.Count = 0 then Exit;
  for iNode := 0 to Tree.Items.Count - 1 do
  if Tree.ItemState[iNode] = csChecked then
  begin
    Result := True;
    Exit;
  end;
end;

procedure CheckNoTree(Tree: TRzCheckTree);
var
  iNode: Integer;
begin
  if Assigned(Tree) then
  if Tree.Items.Count = 0 then Exit;
  for iNode := 0 to Tree.Items.Count - 1 do
  Tree.ItemState[iNode] := csUnchecked;
  //Tree.ItemState[iNode] := csUnknown;
  //Tree.ItemState[iNode] := csPartiallyChecked;
end;

function GetMaxTreeID(ATreeView: TRzTreeView): Integer;
var
  i: integer;
  TempNode: NodeData;
begin
  Result := 0;
  for i := 0 to ATreeView.Items.Count - 1 do
  begin
    TempNode := NodeData(ATreeView.Items.Item[i].Data);
    if Result <= TempNode.TreeID then
      Result := TempNode.TreeID;
  end;
end;

function GetCurTreeLevel(ATreeView: TRzTreeView):Integer;
var
  TempNode: NodeData;
begin
  TempNode := NodeData(ATreeView.Selected.Data);
  Result := TempNode.TreLevel;
end;

function GetCurTreeID(ATreeView: TRzTreeView):Integer;
var
  TempNode: NodeData;
begin
  TempNode := NodeData(ATreeView.Selected.Data);
  Result := TempNode.TreeID;
end;

function GetCurTreeID(ATreeView: TRzCheckTree):Integer;
var
  TempNode: NodeData;
begin
  TempNode := NodeData(ATreeView.Selected.Data);
  Result := TempNode.TreeID;
end;

function SelectedTree(ATreeView: TRzTreeView):Boolean;
begin
  Result := True;
  if not Assigned(ATreeView.Selected) then
  begin
    Result := False;
    raise Exception.Create('��ѡ����Ӧ�����ڵ㣡');
  end;
end;

// Added by CYQ 2014-01-08 15:47:35
//����ͬ�����ڵ�
function AddTreeNode(NodeName: string; ATreeView: TRzTreeView;
  ANode: TTreeNode; TableName: string; qryTemp: TADOQuery):Boolean;
var
  NewNode: TTreeNode;
  strSQL: string;
begin
  Result := False;
  if NodeName = '' then begin ShowMsbInfo('���������ڵ����ƣ�','info'); Exit; end;
  if TableName = '' then begin ShowMsbInfo('�޷���ȡ������','info'); Exit; end;

  if not SelectedTree(ATreeView) then Exit;
  try
    try
      ATreeView.Items.BeginUpdate;

      Result := True;
      New(PNode);
      PNode.TreeID := GetMaxTreeID(ATreeView)+1;
      PNode.NodeName := NodeName;
      PNode.TreLevel := GetCurTreeLevel(ATreeView);

      strSQL := 'Insert Into ' + TableName + ' (TreeID, PrtID, TreeName, TreLevel)'
        + ' values(' + IntToStr(PNode.TreeID) + ',';
      if ANode = nil then ANode := ATreeView.Items.Item[0];
      if ANode.Level = 0 then
        strSQL := strSQL + 'null,' + QuotedStr(NodeName) + ', 0)'
      else
        strSQL := strSQL + IntToStr(NodeData(ANode.Parent.Data).TreeID) + ',' + QuotedStr(NodeName)
          + ','+ IntToStr(PNode.TreLevel)+')';

      if not CheckSameTreeName(NodeName,ANode, TableName, qryTemp) then Exit;
      if not CheckChildTreeName(NodeName ,ANode) then
      if ExecuteSQL(qryTemp,strSQL) then
      begin
        if Node.Level = 0 then
          NewNode := ATreeView.Items.AddChildObject(ANode, NodeName, PNode)
        else NewNode := ATreeView.Items.AddObject(ANode, NodeName, PNode);
        NewNode.ImageIndex := 0;
        NewNode.SelectedIndex := 2;   //�ⲿ����
      end;
    finally
      ATreeView.Items.EndUpdate;
    end;
  except
    Result := False;
  end;
  ATreeView.Refresh;
end;

//����ָ���ڵ��ӽڵ�
function AddTreeChildNode(NodeName: string; ATreeView: TRzTreeView;
  ANode: TTreeNode; TableName: string; qryTemp: TADOQuery):Boolean;
var
  NewNode: TTreeNode;
  strSQL: string;
begin
  Result := False;
  if NodeName = '' then begin ShowMsbInfo('���������ڵ����ƣ�','info'); Exit; end;
  if TableName = '' then begin ShowMsbInfo('�޷���ȡ������','info'); Exit; end;
  if not SelectedTree(ATreeView) then Exit;
  try
    try
      ATreeView.Items.BeginUpdate;

      Result := True;
      New(PNode);
      PNode.TreeID := GetMaxTreeID(ATreeView)+1;
      PNode.NodeName := NodeName;
      PNode.TreLevel := GetCurTreeLevel(ATreeView)+1;

      strSQL := 'Insert Into ' + TableName + ' (TreeID, PrtID, TreeName, TreLevel)'
        + ' Values(' + IntToStr(PNode.TreeID) + ',';
      if ANode = nil then ANode := ATreeView.Items.Item[0];
      strSQL := strSQL + IntToStr(NodeData(ANode.Data).TreeID) + ',' + QuotedStr(NodeName)
        + ','+ IntToStr(PNode.TreLevel)+ ')';
      if not CheckChildTreeName(NodeName ,ANode) then
      if ExecuteSQL(qryTemp,strSQL) then
        NewNode := ATreeView.Items.AddChildObject(ANode, NodeName, PNode);
      NewNode.ImageIndex := 1;
      NewNode.SelectedIndex := 2;   //�ⲿ����
    finally
      ATreeView.Items.EndUpdate;
    end;
  except
    Result := False;
  end;
  ATreeView.Refresh;
end;

//�޸����ڵ�����
function ModifyNodeName(NewNodeName: string;ANode: TTreeNode;
  TableName:string;qryTemp: TADOQuery): Boolean;
var
  NewNode: TTreeNode;
  strSQL: string;
begin
  strSQL := ' Update ' + TableName + ' Set TreeName = ' + QuotedStr(NewNodeName)
    + ' Where TreeID = ' + IntToStr(NodeData(ANode.Data).TreeID);
  if ExecuteSQL(qryTemp, strSQL) then
  begin
    ANode.Text := NewNodeName;
    NodeData(ANode.Data).NodeName := NewNodeName;
  end;
end;

function IsExistsChildNode(ATreeView: TRzTreeView):Boolean; overload;
var
  Node: TTreeNode;
begin
  Result := False;
  if not SelectedTree(ATreeView) then Exit;
  Node := ATreeView.Selected;
  Result := Node.HasChildren;
end;

function IsExistsChildNode(ATreeNode: TTreeNode):Boolean; overload;
begin
  Result := ATreeNode.HasChildren;
end;

//ɾ��ѡ�����ڵ㣨���������ӽڵ㣩
function DeleteTree(ATreeView: TRzTreeView; ANode: TTreeNode;TableName: string ; qryTemp: TADOQuery): Boolean;
  function DelTreeDataByID(TreeID: integer): boolean;
  var
    strSQL: string;
  begin
    Result := False;
    strSQL := 'Delete From ' + TableName + ' Where TreeID = ' + IntToStr(TreeID);
    if ExecuteSQL(qryTemp, strSQL) then Result := True;
  end;

  function DelTreeNode(ParentID: integer): Boolean;
  var
    qryExecSQL: TADOQuery;
    strSQL, FErrorInfo: string;
    TreeID: Integer;
  begin
    Result := False;
    try
      qryExecSQL := TADOQuery.Create(nil);
      qryExecSQL.Connection := qryTemp.Connection;
      strSQL := 'Select * From ' + TableName + ' Where  PrtID = ' + IntToStr(ParentID);
      OpenDataSet(qryExecSQL,strSQL);
      with qryExecSQL do
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          TreeID := FieldByName('TreeID').AsInteger;
          DelTreeNode(TreeID);
          Result := DelTreeDataByID(TreeID);
          Next;
        end;
      end;
      qryExecSQL.Free;
    except
      on e: Exception do
      begin
        Result := False;
        FErrorInfo := e.Message;
        FErrorInfo := GetSQLErrorChineseInfo(FErrorInfo);
        Application.MessageBox(PChar(FErrorInfo), '����', MB_ICONERROR);
        Exit;
      end;
    end;
    Result := DelTreeDataByID(ParentID);
  end;
begin
  Result := False;

  if ANode.AbsoluteIndex = 0 then
  begin
    raise Exception.Create('��ֹɾ����߸��ڵ�');
    Exit;
  end;

//  if IsExistsChildNode(ATreeView) then
//    if not ShowMsbInfo('�ýڵ�����ӽڵ㣬ȷ��ɾ����', 'ask') then Exit;

  if DelTreeNode(NodeData(ANode.Data).TreeID) then
  begin
    ATreeView.Items.Delete(ANode);
    Result := True;
  end;
end;

//�ж�ͬͬ���ڵ��Ƿ����ظ�
function CheckSameTreeName(NodeName: string;ANode: TTreeNode; TableName: string; qryTemp: TADOQuery): Boolean;
var
  strSQL: string;
begin
  Result := True;
  strSQL := 'Select * From '+ TableName + ' Where TreLevel = '
    +IntToStr(NodeData(ANode.Data).TreLevel) +' and TreeName = '
    +QuotedStr(NodeName);
  with qryTemp do
  begin
    OpenDataSet(qryTemp, strSQL);
    if RecordCount > 0 then
    begin
      ShowMsbInfo('�ü��Ѿ�������ͬ�Ľڵ����ƣ����飡','info');
      Result := False;
      Exit;
    end;
  end;
end;

//����ӽڵ��Ƿ����ظ����������ӽڵ���ӽڵ㣩
//function CheckChildTreeName(NodeName: string;ANode: TTreeNode; TableName: string; qryTemp: TADOQuery): Boolean;
//begin
////
//end;

function CheckChildTreeName(NodeName: string;ANode: TTreeNode):Boolean;
var
 i:integer;
 strTemp, strNodeName:string;
begin
  Result := False;
  strNodeName := NodeName;
  for i:=0 to ANode.Count-1 do
  begin
    strTemp:=trim(Trim(ANode[i].Text));
    if SameText(UpperCase(Trim(strNodeName)), UpperCase(Trim(strTemp))) then
    begin
      Result := True;
      ShowMsbInfo('������ͬ�ӽڵ㣬���飡', 'info');
      Exit;
    end;
    if ANode[i].HasChildren then
    Result := CheckChildTreeName(strNodeName,ANode[i]);
  end;
end;

function GetRootNodes(ATreeView: TRzTreeView): TStringList;
var
  TempNode: TTreeNode;
begin
  Result := TStringList.Create;
  TempNode := ATreeView.Items.GetFirstNode;
  if Assigned(TempNode) then
  While TempNode <> nil do
  begin
    Result.Add(IntToStr(NodeData(TempNode.Data).TreeID));
    TempNode:= TempNode.getNextSibling;
  end else Result.Text := '';
end;

function GetChildNodes(ATreeNode: TTreeNode): TStringList;
var
  TempNode: TTreeNode;
begin
  Result := TStringList.Create;
  if ATreeNode.HasChildren then begin
    TempNode := ATreeNode.getFirstChild;
    if Assigned(TempNode) then
    While TempNode <> nil do
    begin
      Result.Add(IntToStr(NodeData(TempNode.Data).TreeID));
      TempNode:= TempNode.GetNextChild(TempNode);
    end;
    end else Result.Text := '';
end;

procedure GetAllChildNodes(ATreeNode: TTreeNode; AStringList: TStringList);
var
  TempNode: TTreeNode;
begin
  TempNode := ATreeNode.getFirstChild;
  if Assigned(TempNode) then
  While TempNode <> nil do
  begin
    AStringList.Add(IntToStr(NodeData(TempNode.Data).TreeID));
    GetAllChildNodes(TempNode, AStringList);
    TempNode:= TempNode.GetNextChild(TempNode);
  end;
  AStringList.Sort;
end;

end.

