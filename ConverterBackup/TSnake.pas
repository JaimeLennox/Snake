unit TSnake;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SnakeObjects, Menus;

type
  TfSnake = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure MainMenu;
    procedure NewGame;
    procedure EndGame;
    procedure UpdateHighScore;
    procedure GameMode(mode:integer);
    procedure T1Click(Sender: TObject);
    procedure T2Click(Sender: TObject);
    { Public declarations }
  end;
  snakeoptions = record
    foodmoveable:boolean;
    wallslethal:boolean;
    acceleration:boolean;
    selfcontact:boolean;
    selfremove:boolean;
    powerups:boolean;
    players:integer;   //one or two
    speed:integer;    //between 1 and 8
  end;
var
  fSnake: TfSnake;
  Grid:array[1..20,1..20] of TSnakeGrid;
  title,score,hscore:TLabel;
  foodshowing,fin:boolean;
  x,y,x2,y2,xfood,yfood,x2food,y2food,length,scorer,hscorer:integer;
  SnakeOp:SnakeOptions;
  MMenu:TSnakeMenu;

const
  gridnum:integer=20;

implementation

{$R *.dfm}

procedure TfSnake.GameMode(mode:integer);
begin
  with snakeop do
  begin
    case mode of
      1:begin      // normal single player
          foodmoveable:=false;
          players:=1;
          wallslethal:=false;
          selfcontact:=true;
          selfremove:=false;
          powerups:=false;
          speed:=6;
        end;
      2:begin                    //one player as food
          foodmoveable:=true;
          players:=2;
          wallslethal:=false;
          acceleration:=false;
          selfcontact:=true;
          selfremove:=false;
          powerups:=false;
          speed:=6;
        end;
      3:begin

        end;
      4:begin

        end;
      5:begin

        end;
      6:begin

        end;
      7:begin

        end;
    end;
  end;
end;

procedure TfSnake.UpdateHighScore;
var
  scorecheck:integer;
  scorefile:textfile;
begin
  assignfile(scorefile,'../../highscores.txt');
  if fileexists('../../highscores.txt') then
  begin
    reset(scorefile);
    readln(scorefile,scorecheck);
    if scorer > scorecheck then
    begin
      rewrite(scorefile);
      writeln(scorefile,scorer);
      hscorer:=scorer;
    end
    else hscorer:=scorecheck;
  end
  else
  begin
    rewrite(scorefile);
    write(scorefile,scorer);
    hscorer:=scorer;
  end;
  closefile(scorefile);
end;

procedure TfSnake.T1Click(Sender: TObject);
begin
  GameMode(1);
  NewGame;
end;

procedure TfSnake.T2Click(Sender: TObject);
begin
  GameMode(2);
  NewGame;
end;

procedure TfSnake.MainMenu;
var
  i: integer;
begin
  MMenu:=TSnakeMenu.Create(self,width);
  with Mmenu do
  begin
    for i := 1 to 4 do
      titles[i].Parent:=self;
    titles[1].Caption:='SINGLE PLAYER';
    titles[1].OnClick:=T1Click;
    titles[2].Caption:='TWO PLAYER';
    titles[2].OnClick:=T2Click;

    with maintitle do
    begin
      Parent:=self;
      Caption:='SNAKE';
    end;

  end;

end;

procedure TfSnake.NewGame;
var
  i,j:integer;
begin
  foodshowing:=false;
  fin:=false;
  x:=0;
  y:=0;
  x2:=0;
  y2:=0;

  xfood:=0;
  yfood:=0;
  x2food:=0;
  y2food:=0;

  scorer:=0;

  for i := 1 to gridnum do
  for j := 1 to gridnum do
  begin
    Grid[i,j].Brush.Color:=clWhite;
    Grid[i,j].counter:=0;
    Grid[i,j].Visible:=true;
  end;

  Grid[gridnum div 2,gridnum div 2].Brush.Color:=clLime;
  Grid[gridnum div 2, gridnum div 2].counter:=1;
  length:=1;

  MMenu.Visible:=false;
  title.Visible:=false;
  score.Visible:=true;
  hscore.Visible:=true;
  score.Top:=50;
  hscore.Caption:='High Score: '+inttostr(hscorer);
end;

procedure TfSnake.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  randomize;
  doublebuffered:=true;

  Color:=clDefault;
  Width:=580;
  Height:=700;
  for i := 1 to gridnum do
  for j := 1 to gridnum do
  begin
    Grid[i,j]:=TSnakeGrid.Create(self);
    with Grid[i,j] do
    begin
      Left:=Width*i;
      Top:=Height*j+100;
      parent:=self;
      visible:=false;
    end;
  end;

  title:=TLabel.Create(self);
  with title do
  begin
    parent:=self;
    font.Size:=25;
    font.Color:=clLime;
    Caption:='GAME OVER';
    left:=fsnake.Width div 3- fsnake.Width div 5;
    top:=50;
    visible:=false;
  end;
  score:=TLabel.Create(self);
  with score do
  begin
    parent:=self;
    font.Size:=25;
    font.Color:=clLime;
    left:=fsnake.width div 3-2*width;
    top:=50;
    visible:=false;
  end;
  hscore:=TLabel.Create(self);
  with hscore do
  begin
    parent:=self;
    font.Size:=25;
    font.Color:=clLime;
    left:=fsnake.Width *2 div 3-fsnake.Width div 5;
    top:=50;
    visible:=false;
  end;

  scorer:=0;
  UpdateHighScore;
  MainMenu;
//  NewGame;

end;

procedure TFSnake.EndGame;
begin
  score.Top:=5;
  if not MMenu.Visible then  
  title.visible:=true;
  UpdateHighScore;
end;

procedure TfSnake.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i,j:integer;
begin
  case Key of
    65:   begin //A
            if x2food <> 1 then
              begin
                xfood:=-1;
                yfood:=0;
              end;
          end;
    68:   begin //D
            if x2food <> -1 then
               begin
                 xfood:=1;
                 yfood:=0;
               end;
          end;
    87:   begin  //W
            if y2food <> -1 then          //stop reversing on self
            begin
              xfood:=0;
              yfood:=1;
            end;
          end;
    83:   begin  //S
            if y2food <> 1 then
              begin
                xfood:=0;
                yfood:=-1;
              end;
          end;
    VK_UP:begin
            if y2 <> -1 then          //stop reversing on self
            begin
              x:=0;
              y:=1;
            end;
          end;
    VK_DOWN:begin
              if y2 <> 1 then
              begin
                x:=0;
                y:=-1;
              end;
            end;
    VK_LEFT:begin
              if x2 <> 1 then
              begin
                x:=-1;
                y:=0;
              end;
            end;
    VK_RIGHT:begin
               if x2 <> -1 then
               begin
                 x:=1;
                 y:=0;
               end;
             end;
    VK_F8:begin
            MMenu.Visible:=true;
            for i := 1 to gridnum do
            for j:= 1 to gridnum do
            Grid[i,j].Visible:=false;

            score.Visible:=false;
            hscore.Visible:=false;
            title.Visible:=false;
          end;
  end;
end;

procedure MoveFood;
var
  i,j,k,l,a,b:integer;
begin
  x2food:=xfood;
  y2food:=yfood;
  for i := 1 to Gridnum do
  for j := 1 to Gridnum do
  if Grid[i,j].brush.color = clYellow then
  begin
    a:=i+xfood;
    b:=j-yfood;
    if (a > gridnum) then
    begin
      a:=1;
    end;
    if (a < 1) then
    begin
      a:=gridnum;
    end;
    if (b > gridnum) then
    begin
      b:=1;
    end;
    if (b < 1) then
    begin
      b:=gridnum;
//      fin:=true;
//      Exit;
    end;
    if Grid[a,b].counter = 1 then
    begin
      inc(scorer);
      for k := 1 to gridnum do
      for l := 1 to gridnum do
        if grid[k,l].counter = length then
        begin
          grid[k+x,l+y].counter:=length+1;
          inc(length);
        end;
    end;
    Grid[i,j].Brush.Color:=clWhite;
    Grid[a,b].Brush.Color:=clYellow;
    Exit;
  end;
end;

procedure MoveSnake;
var
  i,j,a,b:integer;
  k: Integer;
  l: Integer;
begin
  x2:=x;
  y2:=y;
  for i := 1 to Gridnum do
  for j := 1 to Gridnum do
  if Grid[i,j].counter = 1 then
  begin
    a:=i+x;
    b:=j-y;
    if (a > gridnum) then
    begin
      a:=1;
    end;
    if (a < 1) then
    begin
      a:=gridnum;
    end;
    if (b > gridnum) then
    begin
      b:=1;
    end;
    if (b < 1) then
    begin
      b:=gridnum;
//      fin:=true;
//      Exit;
    end;
        if Grid[a,b].Brush.Color = clYellow then
        begin
          for k := 1 to gridnum do
          for l := 1 to gridnum do
          if Grid[k,l].counter <> 0 then
            inc(Grid[k,l].counter);
          inc(length);
          foodshowing:=false;
          inc(scorer);
        end
        else if Grid[a,b].counter <> 0 then
        begin
          fin:=true;
          exit;
        end
        else
          for k := 1 to gridnum do
          for l := 1 to gridnum do
          begin
          if Grid[k,l].counter = length then
            Grid[k,l].counter:=0;
          if Grid[k,l].counter <> 0 then
            inc(Grid[k,l].counter);
          end;
        Grid[a,b].counter:=1;
    Exit;
  end;
end;

procedure TfSnake.Timer1Timer(Sender: TObject);
var
  i,j,checkfood:integer;
begin
  score.Caption:=inttostr(scorer);
  checkfood:=0;
  for i := 1 to gridnum do
    for j := 1 to gridnum do
      if grid[i,j].brush.Color = clYellow then
      checkfood:=1;
  if checkfood <> 1 then
  foodshowing:=false;
  if not fin then
  begin
    if (x <> 0) OR (y <> 0) then
    MoveSnake;
    if snakeop.foodmoveable then
    if (xfood <> 0) OR (yfood <> 0) then
    MoveFood;
    for i := 1 to gridnum do
    for j := 1 to gridnum do
    if Grid[i,j].counter <> 0 then
      Grid[i,j].Brush.Color:=clLime
    else
    if Grid[i,j].Brush.Color <> clYellow then
    Grid[i,j].Brush.Color:=clWhite;
    if not foodshowing then
    begin
      i:=random(20)+1;
      j:=random(20)+1;
      if grid[i,j].counter = 0 then
      Grid[i,j].Brush.Color:=clYellow;
      foodshowing:=true;
    end;
  end
  else
  begin
    EndGame;
  end;
end;

procedure TfSnake.Timer2Timer(Sender: TObject);
begin
  Timer1.Interval:=Timer1.Interval-1;
end;

end.
