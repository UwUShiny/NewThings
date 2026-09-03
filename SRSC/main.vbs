Option Explicit

If Not WScript.Arguments.Named.Exists("admin") Then
    CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & """ /admin", "", "runas", 0
    WScript.Quit
End If

Dim fso, cfg, content

Set fso = CreateObject("Scripting.FileSystemObject")
cfg = "C:\Program Files\miHoYo Launcher\games\Star Rail Game\config.ini"

If Not fso.FileExists(cfg) Then
    MsgBox "找不到 config.ini", vbCritical, "错误"
    WScript.Quit
End If

content = fso.OpenTextFile(cfg, 1).ReadAll

Dim current
If InStr(content, "bilibili_PC") > 0 Then current = "B服" Else current = "官服"

Dim result
result = MsgBox("当前：" & current & vbCrLf & "是 = 官服" & vbCrLf & "否 = B服", vbYesNo + vbQuestion, "崩铁快速切服(VBS版)")

If result = vbNo Then WScript.Quit

Dim cps, ch, subch
If result = vbYes Then
    cps = "gw_PC" : ch = "1" : subch = "1"
Else
    cps = "bilibili_PC" : ch = "14" : subch = "0"
End If

Dim lines, i, out, inGen, done
lines = Split(content, vbCrLf)
out = "" : inGen = False : done = False

For i = 0 To UBound(lines)
    If Trim(lines(i)) = "[General]" Then
        inGen = True : done = True
        out = out & "[General]" & vbCrLf & "channel=" & ch & vbCrLf & "cps=" & cps & vbCrLf & "sub_channel=" & subch & vbCrLf
    ElseIf inGen And (Left(Trim(lines(i)), 8) = "channel=" Or Left(Trim(lines(i)), 4) = "cps=" Or Left(Trim(lines(i)), 12) = "sub_channel=") Then
        ' skip
    Else
        out = out & lines(i) & vbCrLf
        If Trim(lines(i)) <> "" And Left(Trim(lines(i)), 1) = "[" Then inGen = False
    End If
Next

fso.OpenTextFile(cfg, 2, True).Write out

Dim verify
verify = fso.OpenTextFile(cfg, 1).ReadAll
If InStr(verify, "bilibili_PC") > 0 Then current = "B服" Else current = "官服"

MsgBox "已切换为：" & current, vbInformation, "崩铁快速切服(VBS版)"