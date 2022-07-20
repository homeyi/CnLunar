unit ssBasic;

interface

uses
  System.Math, System.Classes, SysUtils, DateUtils;

{
  �O��:
   1..10  ������
   1..12  ������
 }
  //���
  function ISZhiSheng(izhi, byzhi: integer): boolean;
  function ISZhiKe(izhi, byzhi: integer): boolean;
  function ISZhiBi(izhi, byzhi: integer): boolean;

  function ISZhi6He(izhi, byzhi: integer): boolean;
  function ISZhi3He(z1, z2, z3: integer): boolean;
  function ISZhiChong(izhi, byzhi: integer): boolean;
  function ISZhiXing(izhi, byzhi: integer): boolean;
  function ISZhiHai(izhi, byzhi: integer): boolean;
  function ISZhiPo(izhi, byzhi: integer): boolean;

  function ISMu(fdayZhi, byzhi: integer): boolean;
//  function ISJue(habcd1,habcd2: integer): boolean;
  function ISJin(izhi, byzhi: integer): boolean;
  function ISTui(izhi, byzhi: integer): boolean;

{  function ISGuiRen(iday,habcd1: integer): boolean;
  function ISYiMa(iday,habcd1: integer): boolean;
  function ISXianChi(iday,habcd1: integer): boolean;
  function ISLu(iday,habcd1: integer): boolean;
 }

  //��֧
  function idxChangSheng(byzhi, setZhi: integer; isgan: boolean=False): integer;  //����ʮ���L��


  //ȫ�ּ�¼���� crJq����֧���ա������ա�����������˷�ա��·�
  procedure SetChEra(inDate: TDateTime);

  function strCN(): String; //���ڸ�֧
  function strFullKong(): String; //��ֵ����
  function strXun(): string;  //��Ѯ
  function strKong(): String;
  function strLunar(): string;

  //�yԇ---������ɷ��
  function zhiYiMa(izhi: integer): integer;

  //delete
  procedure forgrid(ilist: TStringList; ii: integer);
  function bb1: string;
  function bb2: string;
  function strJq(ch: integer): string;

//����׃��
var
  crDate, crJie, crQi: TDateTime;
  strJie, strQi, strnlYue, strnlRi: string;
  Year, Month, Day, Hour, Mins, Sec, MSec: word;
  gYear, gMonth, gDay, gTime, zYear, zMonth, zDay, zTime: integer;
  ooShou, ooXun, ooKong: integer;

  //delete
  ll: integer;
const
  strTianGan: array of string = ['','��','��','��','��','��','��','��','��','��','��'];
  strDiZhi: array of string = ['','��','��','��','î','��','��','��','δ','��','��','��','��'];

implementation

uses CnLunar;

//�Д�
function ISZhiSheng(izhi, byzhi: integer): boolean;
begin
   //��֧��
   Result := False;
   case izhi of
      12,1 : result := (byzhi = 3) or (byzhi = 4);
      3,4 : result := (byzhi = 6) or (byzhi = 7);
      2,5,8,11 : result := (byzhi = 9) or (byzhi = 10);
      6,7 : result := (byzhi mod 3) = 2;
      9,10: result := (byzhi = 12) or (byzhi = 1);
   end;
end;

function ISZhiKe(izhi, byzhi: integer): boolean;
begin
    //��֧��
    Result := False;
    case izhi of
       12,1 : result := (byzhi = 6) or (byzhi = 7);
       2,5,8,11 : result := (byzhi = 1) or (byzhi = 12);
       3,4 : result := (byzhi mod 3) = 2;
       6,7 : result := (byzhi = 9) or (byzhi = 10);
       9,10: result := (byzhi = 3) or (byzhi = 4);
    end;
end;

function ISZhiBi(izhi, byzhi: integer): boolean;
begin

    //Ϊ12ʱ�������������ȣ��ʸ�Ϊ 0
    if izhi = 12 then izhi := 0;
    if byzhi = 12 then byzhi := 0;

    if (izhi mod 3) = 2 then result := (byzhi mod 3) = 2
    else
       result := (izhi = byzhi) or (byzhi = (izhi + 1)) or (byzhi = (izhi - 1));

end;

function ISZhi6He(izhi, byzhi: integer): boolean;
begin
    //��֧����
    if izhi < 3 then izhi := izhi + 12;
    
    result := (15 - izhi) = byzhi;
end;

function ISZhi3He(z1, z2, z3: integer): boolean;
begin

  //��֧����
  result := ([z1,z2,z3] = [2,6,10]) or ([z1,z2,z3] = [1,5,9]) or
            ([z1,z2,z3] = [3,7,11]) or ([z1,z2,z3] = [4,8,12]);

end;


function ISZhiChong(izhi, byzhi: integer): boolean;
begin
   //��֧��
   result := ((izhi + 6) mod 12) = (byzhi mod 12);
end;

function ISZhiXing(izhi, byzhi: integer): boolean;
begin
    //��֧��
    case izhi of
      1: result := byzhi = 4;
      4: result := byzhi = 1;

      2: result := byzhi = 11;
      11: result := byzhi = 8;
      8: result := byzhi = 2;

      3,6: result := byzhi = (izhi + 3);
      9: result := byzhi = 3;
    else
      result := izhi = byzhi;  //�����Ϻ�����
    end;
end;

function ISZhiHai(izhi, byzhi: integer): boolean;
begin
    //��֧��
    //�ӳ�ϡ���δ�ϣ������n��δ���n������δ�຦������
    if izhi < 9 then result := (9 - izhi) = byzhi
    else result := (21 - izhi) = byzhi;
end;

function ISZhiPo(izhi, byzhi: integer): boolean;
begin
  //��֧��
  //��î��î�硢��������

  {Result := ((izhi=1) and (byzhi=4)) or ((izhi=4) and (byzhi=1));
  Result := ((izhi=7) and (byzhi=4)) or ((izhi=4) and (byzhi=7));
  Result := ((izhi=10) and (byzhi=7)) or ((izhi=7) and (byzhi=10));}

  //2018-11-29
  //�֧���ġ��֧�M�ģ����ϡ�������������î�����ȡ���δ
  if odd(izhi) then
     result := ((izhi+9) mod 12) = (byzhi mod 12)
  else
     result := ((izhi+3) mod 12) = byzhi;
end;

function ISMu(fdayZhi, byzhi: integer): boolean;
begin

  case fdayZhi of
     2: result := (byzhi = 9) or (byzhi = 10);
     5: result := (byzhi = 1) or (byzhi = 12) or ((byzhi mod 3) = 2);
     8: result := (byzhi = 3) or (byzhi = 4);
    11: result := (byzhi = 6) or (byzhi = 7);
  else
    result := False;
  end;

end;

function ISJin(izhi, byzhi: integer): boolean;
begin
   if izhi  = 12 then izhi  := 0;
   if byzhi = 12 then byzhi := 0;

   result := ISZhiBi(izhi, byzhi) and (izhi < byzhi);
end;

function ISTui(izhi, byzhi: integer): boolean;
begin
   if izhi  = 12 then izhi  := 0;
   if byzhi = 12 then byzhi := 0;

   result := ISZhiBi(izhi, byzhi) and (izhi > byzhi);
end;

//ʮ���L��
function idxChangSheng(byzhi, setZhi: integer; isgan: boolean=False): integer;
begin
   if isgan then  //��������

      if (setZhi mod 2) = 0 then
      case setzhi of
       4: result := (20 - byzhi) mod 12;
       6: result := (23 - byzhi) mod 12;
       10:result := (26 - byzhi) mod 12;
      else
          result := (29 - byzhi) mod 12;
      end
      else
      case setzhi of
       3: result := (byzhi + 13) mod 12;
       7: result := (byzhi + 10) mod 12;
       9: result := (byzhi + 7)  mod 12;
      else
          result := (byzhi + 4)  mod 12;
      end
   else
      case setZhi of
       3,4:  result := (byzhi + 13) mod 12;
       6,7:  result := (byzhi + 10) mod 12;
       9,10: result := (byzhi + 7)  mod 12;
      else
          result := (byzhi + 4)  mod 12;
      end;

   if result = 0 then result := 12;
   
end;

//��99�_98��97��96��95(��î�o�Y94���������ф�93������δ�o��92)
function idxkongchong(byzhi, setzhi: integer): string;
begin

end;
//

//���ص�֧��

//��س������ɷ
//�A�R
function zhiYiMa(izhi: integer): integer;
const
  ma: array [0..3] of integer = (6, 3, 12, 9);
begin
  result := ma[izhi mod 4];
end;

//��֧������ʱ
//���֧
procedure yGz(y: integer);
begin

  //�ؼ�ֻ��ݔ�� 1601 ��󣬹ʹ�ʽ��������Ԫ3����
  if Jq[2] > crDate then DEC(y); //�Ƿ�������

  gYear := (y - 3) mod 10;
  zYear := (y - 3) mod 12;

  if gYear = 0 then gYear := 10;
  if zYear = 0 then zYear := 12;
end;

//�¸�֧
procedure mGz();
begin

  if crDate < crJie then zMonth := Month -2 else zMonth := Month -1;

  if zMonth <=0 then zMonth := zMonth + 12;

  gMonth := (12*gYear + zMonth -10) mod 10;
  zMonth := (12*gYear + zMonth -10) mod 12;

  if gMonth = 0 then gMonth := 10;
  if zMonth = 0 then zMonth := 12;

end;

//�ո�֧
procedure dGz();
var
  total: integer;
begin

  total := Trunc(crDate);
  if Hour < 23 then Dec(total);

  gDay := total mod 10;
  zDay := (total - 2) mod 12;

  if gDay = 0 then gDay := 10;
  if zDay = 0 then zDay := 12;

end;

//�r��֧
procedure hGz();
begin

  //�r֧
  if (hour = 0) or (hour = 23) then
     zTime := 1
  else
     zTime := Round((hour + 2.4)/2);

  //�r��
  if gDay >5 then gTime := ((gDay -5)*2 -2 + zTime) mod 10
  else gTime := (gDay*2 -2 + zTime) mod 10;

  if gTime = 0 then gTime := 10;
  if zTime = 0 then zTime := 12;

end;

procedure SetLunar();
const
  jqB: array of String = [ // ������
    '����', '����', '����', '����', 'С��', 'â��', '����', 'С��', '����', '����', '����', '��¶',
    '���', '��¶', '˪��', '����', 'Сѩ', '��ѩ', '����', 'С��', '��', '����', '��ˮ', '����'];

  strnl: array of string = ['һ','��','��','��','��','��','��','��','��'];

var
  dif: integer;
begin
  crJie := jq[Month];
  crQi  := zq[Month];

  strJie := jqB[(Month*2 + 17) mod 24];
  strQi  := jqB[(Month*2 + 18) mod 24];

  if (trunc(crDate) - trunc(hs[Month])) < 0 then begin
    Dif := Month - 1;
    while (trunc(crDate) - trunc(hs[Dif])) < 0 do Dec(Dif);

    strnlYue := syn[Dif];
    dif := trunc(crDate) - trunc(hs[Dif]);
  end
  else begin
    strnlYue := syn[Month];
    dif := trunc(crDate) - trunc(hs[Month]);
  end;

  case dif of
      0,30: strnlRi := '��һ';
      1..8: strnlRi := '��' + strnl[dif];
         9: strnlRi := '��ʮ';
    10..18: strnlRi := 'ʮ' + strnl[dif mod 10];
        19: strnlRi := 'إ';
    20..28: strnlRi := 'إ' + strnl[dif mod 10];
        29: strnlRi := 'ئ';
  end;

end;

procedure SetChEra(inDate: TDateTime);  //����ת��Ϊ��֧
begin

  //��ǰ����
  crDate := inDate;
  DeCodeTime(inDate,Hour,Mins,Sec,MSec);
  DeCodeDate(inDate,Year,Month,Day);

  syn := TStringList.Create;
  paiYue(Year);

  SetLunar;
  ll := syn.Count -1;

  //�����Օr��֧
  yGz(Year);
  mGz();
  dGz();
  hGz();

  //��ʼ����
  case gDay of
    1,2: ooShou := 1;
    3,4: ooShou := 2;
      5: ooShou := 3;
      6: ooShou := 4;
    7,8: ooShou := 5;
    9,10: ooShou := 6;
  end;

  //Ѯ�׿���
  ooXun := (zDay - gDay + 13) mod 12;
  ooKong := (zDay - gDay + 11) mod 12;

end;

//���ظ��ָ�ʽ
function strCN(): String;
begin
   result := format('%s%s %s%s %s%s %s%s',[strTianGan[gYear],strDiZhi[zYear],
     strTianGan[gMonth], strDiZhi[zMonth], strTianGan[gDay], strDiZhi[zDay],
     strTianGan[gTime], strDiZhi[zTime]]);

end;

function strKong(): String;
begin
   result := format('%s%s',[strDiZhi[ooKong],strDiZhi[ooKong + 1]]);
end;

function strFullKong(): String;

   function calcKong(ig, iz: byte): byte;
   begin
      result := (iz - ig + 11) mod 12;
   end;

begin
   result := format('%s%s  %s%s  %s%s  %s%s',[StrDiZhi[calcKong(gYear, zYear)],
     StrDiZhi[calcKong(gYear, zYear) +1],
     StrDiZhi[calcKong(gMonth, zMonth)], StrDiZhi[calcKong(gMonth, zMonth) +1],
     StrDiZhi[ooKong], StrDiZhi[ooKong +1],
     StrDiZhi[calcKong(gTime, zTime)], StrDiZhi[calcKong(gTime, zTime) +1]]);
end;

function strXun(): string;
begin
  result := format('��%sѮ',[strDizhi[ooXun]]);
end;

procedure forgrid(ilist: TStringList; ii: integer);
const
  jqB: array of String = [ // ������
    '����', '����', '����', '����', 'С��', 'â��', '����', 'С��', '����', '����', '����', '��¶',
    '���', '��¶', '˪��', '����', 'Сѩ', '��ѩ', '����', 'С��', '��', '����', '��ˮ', '����'];
begin
  ilist.Append(jqB[(ii*2+17) mod 24]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',jq[ii]));
  ilist.Append(jqB[(ii*2+18) mod 24]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',zq[ii]));
  ilist.Append(syn[ii]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',hs[ii]));
end;

function bb1: string;
begin
  result := strJie + '>' + FormatDateTime('MM��DD hh:nn', crJie) + '  ';
  result := result + strQi + '>' + FormatDateTime('MM��DD hh:nn', crQi)
end;
function bb2: string;
begin
  result := strnlYue + ' ' + strnlRi;
end;

function strJq(ch: integer): string;
begin
  case ch of
   1: result := format('%s: %s',[strJie,formatDateTime('MM��DD�� hh:nn',crJie)]);
   2: result := format('%s: %s',[strQi, formatDateTime('MM��DD�� hh:nn',crQi)]);
   3: result := strnlYue + '  ' + strnlRi;
  end;

end;

function strLunar(): string;
begin
  //result := crJq.nYue + crJq.nRi;
end;

end.
