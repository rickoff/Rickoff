Imports System.Net
Imports System.IO
Imports System

Public Class ServeurFR
    Dim MAJ As New WebClient
    Dim client As WebClient = New WebClient
    Dim ListDirectory() As String = File.ReadAllLines("ClientDirectory.txt")
    Dim FirstVersion As String = MAJ.DownloadString(ListDirectory(0).ToString + "\VersionClient.txt")
    Dim OpenMwCfg As String = My.Computer.FileSystem.SpecialDirectories.MyDocuments + "\My Games\OpenMw\Openmw.cfg"
    Dim Updatesetup As String = ListDirectory(0).ToString + "\maj\setup.exe"
    Dim UpdateVersion As String = ListDirectory(0).ToString + "\VersionClient.txt"
    Dim Tes3mpClient As String = ListDirectory(0).ToString + "\tes3mp-client-default.cfg"

    Dim ListLink() As String = File.ReadAllLines("ServerLink.txt")
    Dim Openmwlink As String = ListLink(0).ToString
    Dim Updatelink As String = ListLink(1).ToString
    Dim Versionlink As String = ListLink(2).ToString
    Dim Tes3mplink As String = ListLink(3).ToString

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.StartPosition = FormStartPosition.CenterScreen
        Checkupdates()
    End Sub

    Sub DeleteFolder(ByVal PathOfDirectory As String)
        If My.Computer.FileSystem.DirectoryExists(PathOfDirectory) = True Then
            My.Computer.FileSystem.DeleteDirectory(PathOfDirectory, FileIO.DeleteDirectoryOption.DeleteAllContents)
        End If
    End Sub

    Sub CreateFolder(ByVal PathOfDirectory As String)
        If System.IO.Directory.Exists(PathOfDirectory) = False Then
            System.IO.Directory.CreateDirectory(PathOfDirectory)
        End If
    End Sub

    Sub Checkupdates()
        Dim LastVersion As String = MAJ.DownloadString(Versionlink)

        If FirstVersion = LastVersion Then
            MsgBox("the software is up-to-date")
        Else
            MsgBox("the software is not up-to-date", vbOKOnly + MsgBoxStyle.Critical, "Erreur")
            DeleteFolder(ListDirectory(0).ToString + "\maj\")
            Dim MAJ As New WebClient
            Dim Client As WebClient = New WebClient
            Me.Enabled = False
            My.Computer.Network.DownloadFile(Updatelink, Updatesetup)
            AddHandler Client.DownloadProgressChanged, AddressOf client_ProgressChanged
            AddHandler Client.DownloadFileCompleted, AddressOf client_DownloadCompleted
            Client.DownloadFileAsync(New Uri(Updatelink), Updatesetup)
            Button1.Enabled = False
            Button2.Enabled = False
            Button4.Enabled = False
        End If
    End Sub

    Sub Checkupdates2()
        CreateFolder(My.Computer.FileSystem.SpecialDirectories.MyDocuments + "\My Games\OpenMw\")
        Me.Enabled = False
        ProgressBar1.Value = 0
        Dim client As WebClient = New WebClient
        AddHandler client.DownloadProgressChanged, AddressOf client_ProgressChanged
        AddHandler client.DownloadFileCompleted, AddressOf client_DownloadCompleted1
        client.DownloadFileAsync(New Uri(Openmwlink), OpenMwCfg)
    End Sub

    Sub Checkupdates3()
        Me.Enabled = False
        ProgressBar1.Value = 0
        Dim client As WebClient = New WebClient
        AddHandler client.DownloadProgressChanged, AddressOf client_ProgressChanged
        AddHandler client.DownloadFileCompleted, AddressOf client_DownloadCompleted2
        client.DownloadFileAsync(New Uri(Versionlink), UpdateVersion)
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim MAJ As New WebClient
        Dim Client As WebClient = New WebClient
        Me.Enabled = False
        My.Computer.FileSystem.DeleteFile(Tes3mpClient)
        My.Computer.Network.DownloadFile(Tes3mplink, Tes3mpClient)
        AddHandler Client.DownloadProgressChanged, AddressOf client_ProgressChanged
        AddHandler Client.DownloadFileCompleted, AddressOf client_DownloadCompleted3
        Client.DownloadFileAsync(New Uri(Tes3mplink), Tes3mpClient)
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        Process.Start(ListLink(4).ToString)
    End Sub

    Private Sub Button4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button4.Click
        Process.Start(ListLink(5).ToString)
    End Sub

    Private Sub Button6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Checkupdates()
    End Sub

    Private Sub client_DownloadCompleted(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs)
        Me.Enabled = True
        Checkupdates2()
    End Sub

    Private Sub client_DownloadCompleted1(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs)
        Me.Enabled = True
        Checkupdates3()
    End Sub

    Private Sub client_DownloadCompleted2(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs)
        Me.Enabled = True
        Button1.Enabled = True
        Button2.Enabled = True
        Button4.Enabled = True
        Process.Start(ListDirectory(0).ToString + "\maj\setup.exe")
        Application.Exit()
    End Sub

    Private Sub client_DownloadCompleted3(ByVal sender As Object, ByVal e As System.ComponentModel.AsyncCompletedEventArgs)
        Me.Enabled = True
        Button1.Enabled = True
        Button2.Enabled = True
        Button4.Enabled = True
        Process.Start(ListDirectory(0).ToString + "\tes3mp.exe")
    End Sub


    Private Sub client_ProgressChanged(ByVal sender As Object, ByVal e As DownloadProgressChangedEventArgs)
        Dim bytesIn As Double = Double.Parse(e.BytesReceived.ToString())
        Dim totalBytes As Double = Double.Parse(e.TotalBytesToReceive.ToString())
        Dim percentage As Double = bytesIn / totalBytes * 100
        ProgressBar1.Value = Int32.Parse(Math.Truncate(percentage).ToString())
    End Sub

    Private Sub Button5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button5.Click
        Application.Exit()
    End Sub
End Class
