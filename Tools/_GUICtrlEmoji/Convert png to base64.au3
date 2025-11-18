#include <File.au3>
#include <MsgBoxConstants.au3>

; ===== FONCTION D'ENCODAGE BASE64 =====
Func _Base64Encode($bData)
    Local $tData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
    DllStructSetData($tData, 1, $bData)

    ; Première appel pour obtenir la taille nécessaire
    Local $aCrypt = DllCall("Crypt32.dll", "bool", "CryptBinaryToStringA", _
        "struct*", $tData, _
        "dword", DllStructGetSize($tData), _
        "dword", 1, _ ; CRYPT_STRING_BASE64
        "ptr", 0, _
        "dword*", 0)

    If @error Or Not $aCrypt[0] Then Return SetError(1, 0, "")

    ; Créer le buffer pour recevoir la chaîne Base64
    Local $tBuffer = DllStructCreate("char[" & $aCrypt[5] & "]")

    ; Deuxième appel pour obtenir la chaîne Base64
    $aCrypt = DllCall("Crypt32.dll", "bool", "CryptBinaryToStringA", _
        "struct*", $tData, _
        "dword", DllStructGetSize($tData), _
        "dword", 1, _ ; CRYPT_STRING_BASE64
        "struct*", $tBuffer, _
        "dword*", $aCrypt[5])

    If @error Or Not $aCrypt[0] Then Return SetError(2, 0, "")

    Return DllStructGetData($tBuffer, 1)
EndFunc

; ===== CONVERTIR UN FICHIER PNG EN BASE64 =====
Func ConvertPNGToBase64($sFilePath)
    ; Ouvrir le fichier en mode binaire
    Local $hFile = FileOpen($sFilePath, 16) ; 16 = Mode binaire
    If $hFile = -1 Then
        ConsoleWrite("Erreur: Impossible d'ouvrir " & $sFilePath & @CRLF)
        Return SetError(1, 0, "")
    EndIf

    ; Lire le contenu binaire
    Local $bData = FileRead($hFile)
    FileClose($hFile)

    ; Encoder en Base64
    Local $sBase64 = _Base64Encode($bData)

    ; Nettoyer le Base64 (enlever les retours à la ligne)
    $sBase64 = StringReplace($sBase64, @CRLF, "")
    $sBase64 = StringReplace($sBase64, @CR, "")
    $sBase64 = StringReplace($sBase64, @LF, "")

    Return $sBase64
EndFunc

; ===== PROGRAMME PRINCIPAL =====

; Sélectionner le dossier contenant les emojis
Local $sEmojiFolder = FileSelectFolder("Sélectionnez le dossier contenant les emojis PNG", @ScriptDir)
If @error Then Exit

; Lister tous les fichiers PNG
Local $aFiles = _FileListToArray($sEmojiFolder, "*.png", 1)
If @error Then
    MsgBox($MB_ICONERROR, "Erreur", "Aucun fichier PNG trouvé dans le dossier sélectionné.")
    Exit
EndIf

; Créer le fichier de sortie
Local $sOutputFile = @ScriptDir & "\emojis_base64_code.au3"
Local $hOutput = FileOpen($sOutputFile, 2) ; 2 = Mode écriture (écrase le fichier existant)

; Écrire l'en-tête
FileWriteLine($hOutput, "; ===== CODES BASE64 DES EMOJIS =====")
FileWriteLine($hOutput, "; Généré le : " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN)
FileWriteLine($hOutput, "; Nombre d'emojis : " & $aFiles[0])
FileWriteLine($hOutput, "")

; Progress bar
ProgressOn("Conversion Base64", "Conversion en cours...", "0%", -1, -1, 16)

; Convertir chaque fichier PNG
For $i = 1 To $aFiles[0]
    ; Mettre à jour la progression
    Local $iPercent = Round(($i / $aFiles[0]) * 100)
    ProgressSet($iPercent, $aFiles[$i], "Conversion : " & $i & "/" & $aFiles[0])

    ; Chemin complet du fichier
    Local $sFilePath = $sEmojiFolder & "\" & $aFiles[$i]

    ; Obtenir le nom sans extension
    Local $sName = StringReplace($aFiles[$i], ".png", "")
    $sName = StringReplace($sName, " ", "_")
    $sName = StringReplace($sName, "-", "_")

    ; Convertir en Base64
    Local $sBase64 = ConvertPNGToBase64($sFilePath)

    If $sBase64 <> "" Then
        ; Écrire la fonction dans le fichier
        FileWriteLine($hOutput, "; " & $aFiles[$i])
        FileWriteLine($hOutput, "Func _Emoji" & $sName & "()")

        ; Diviser le Base64 en lignes de 100 caractères pour la lisibilité
        FileWriteLine($hOutput, "    Local $bString = _WinAPI_Base64Decode( _")

        Local $iLen = StringLen($sBase64)
        Local $iPos = 1
        While $iPos <= $iLen
            Local $sChunk = StringMid($sBase64, $iPos, 100)
            If $iPos + 100 > $iLen Then
                FileWriteLine($hOutput, '        "' & $sChunk & '")')
            Else
                FileWriteLine($hOutput, '        "' & $sChunk & '" & _')
            EndIf
            $iPos += 100
        WEnd

        FileWriteLine($hOutput, "    Return _GDIPlus_BitmapCreateFromMemory($bString)")
        FileWriteLine($hOutput, "EndFunc")
        FileWriteLine($hOutput, "")

        ConsoleWrite("✓ Converti : " & $aFiles[$i] & @CRLF)
    Else
        ConsoleWrite("✗ Échec : " & $aFiles[$i] & @CRLF)
    EndIf
Next

ProgressOff()
FileClose($hOutput)

; Afficher le résultat
MsgBox($MB_ICONINFORMATION, "Conversion terminée", _
    "Conversion terminée avec succès !" & @CRLF & @CRLF & _
    "Fichier généré : " & @CRLF & $sOutputFile & @CRLF & @CRLF & _
    "Nombre d'emojis convertis : " & $aFiles[0])

; Ouvrir le fichier généré
ShellExecute($sOutputFile)
