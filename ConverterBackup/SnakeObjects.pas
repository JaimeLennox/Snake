unit SnakeObjects;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Extctrls, Forms, Dialogs, StdCtrls;

type
  TSnakeGrid = class(TShape)
    public
      counter:integer;
      constructor Create(AOwner: TComponent); override;
  end;
  TSnakeMenu = class
    public
      MainTitle:TLabel;
      titles:array[1..4] of TLabel;
      constructor Create(AOwner: TComponent; FormWidth: Integer);
      destructor Destroy;
      function GetVisible:boolean;
      procedure SetVisible(new:boolean);
      property Visible:boolean read GetVisible write SetVisible;
  end;

const
  size:integer=25;

implementation

{TSnakeGrid}

constructor TSnakeGrid.Create(AOwner: TComponent);
begin
  inherited;
  shape:=stSquare;
  width:=size;
  height:=size;
  counter:=0;
end;

{TMainMenu}

constructor TSnakeMenu.Create(AOwner: TComponent; FormWidth: Integer);
var
  i: integer;
begin
  MainTitle:=TLabel.Create(application);
  with MainTitle do
  begin
    left:=FormWidth div 2 - 2*Width;
    font.Size:=40;
    top:=50;
    font.Color:=clLime;
  end;
  for i := 1 to 4 do
  begin
    titles[i]:=TLabel.Create(application);
    with titles[i] do
    begin
      left:=FormWidth div 2 - 3*width;
      font.Size:=30;
      if i = 1 then
        top:=maintitle.Top+100
      else
        top:=titles[i-1].Top+30*i;
      font.Color:=clLime;
    end;
  end;
end;

destructor TSnakeMenu.Destroy;
var
  i: integer;
begin
  MainTitle.Free;
  for i := 1 to 4 do
  titles[i].Free;
end;

function TSnakeMenu.GetVisible:boolean;
begin
  GetVisible:=MainTitle.Visible;
end;

procedure TSnakeMenu.SetVisible(new:boolean);
var
  i:integer;
begin
  MainTitle.Visible:=new;
  for i := 1 to 4 do
    titles[i].Visible:=new;
end;

end.
