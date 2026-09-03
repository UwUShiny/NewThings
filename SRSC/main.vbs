Option Explicit

' ===== 引导代码（纯 ASCII，无中文，兼容 UTF-8 无 BOM）=====
If IsEmpty(ExecuteBootstrap) Then
    ExecuteBootstrap = True
    Dim _fso, _stream, _code
    Set _fso = CreateObject("Scripting.FileSystemObject")
    Set _stream = CreateObject("ADODB.Stream")
    _stream.Type = 2
    _stream.Charset = "utf-8"
    _stream.Open
    _stream.LoadFromFile WScript.ScriptFullName
    _code = _stream.ReadText
    _stream.Close
    ExecuteGlobal _code
    Call Main
    WScript.Quit
End If

' ===== 主程序 =====
Sub Main()
    If Not WScript.Arguments.Named.Exists("admin") Then
        CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & """ /admin", "", "runas", 0
        WScript.Quit
    End If

    Dim fso, cfg, content, GAME_DIR

    GAME_DIR = "C:\Program Files\miHoYo Launcher\games\Star Rail Game"
    cfg = GAME_DIR & "\config.ini"

    Set fso = CreateObject("Scripting.FileSystemObject")

    If Not fso.FileExists(cfg) Then
        MsgBox "找不到 config.ini", vbCritical, "错误"
        WScript.Quit
    End If

    content = fso.OpenTextFile(cfg, 1).ReadAll

    Dim current
    If InStr(content, "bilibili_PC") > 0 Then current = "B服" Else current = "官服"

    Dim input, failCount, low
    failCount = 0

    Do
        input = InputBox("当前：" & current & vbCrLf & vbCrLf & "1 = 官服" & vbCrLf & "2 = B服", "崩铁快速切服(VBS版)")

        If input = "" Then WScript.Quit

        low = LCase(Trim(input))

        ' 隐藏彩蛋直接触发
        If low = "0" Or low = "rick" Or low = "roll" Or low = "rickroll" Then
            Call TriggerEgg
            WScript.Quit
        End If

        If input = "1" Or input = "2" Then
            Exit Do
        End If

        ' 输错静默计数，满3次触发彩蛋
        failCount = failCount + 1
        If failCount >= 3 Then
            Call TriggerEgg
            WScript.Quit
        End If

    Loop

    Dim cps, ch, subch
    If input = "1" Then
        cps = "gw_PC" : ch = "1" : subch = "1"
    ElseIf input = "2" Then
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
End Sub

' ===== 彩蛋过程 =====
Sub TriggerEgg()
    Dim wsEgg
    Set wsEgg = CreateObject("WScript.Shell")
    MsgBox "Never gonna give you up~" & vbCrLf & "Never gonna let you down~", vbInformation, "彩蛋"
    wsEgg.Run "https://www.bilibili.com/video/BV1GJ411x7h7/", 1, False
    Set wsEgg = Nothing
End Sub
