# AutoIt Comprehensive Naming Convention Documentation

## 📖 Purpose

This document defines the standardized naming convention used within AutoIt scripts to promote clarity, maintainability, and uniformity across the codebase. The convention provides immediate insights into variable scope, mutability, data type, and more.

---

## 📝 Naming Format

Variables are named according to the following pattern :

```
$<scope><attribute>_<datatype>_<VariableName>
```

**Where**:

- `<scope>`: Scope of the variable  
- `<attribute>`: Attributes such as constancy (optional)  
- `<datatype>`: Type of data the variable stores  
- `<VariableName>`: Descriptive name starting with an uppercase letter using PascalCase  

---

## 📌 Scope Prefixes

| Prefix | Meaning                                       |
|:--------|:-----------------------------------------------|
| `g`      | Global — accessible throughout the entire script |
| `l`      | Local — accessible only within the function/block |
| `s`      | Static — retains its value between function calls |
| `a`      | Argument — function parameter                  |

---

## 📌 Attribute Prefixes

| Prefix | Meaning                      |
|:---------|:-----------------------------|
| `c`        | Constant (value cannot change after initialization) |

Constants should use `UPPERCASE_WITH_UNDERSCORES`.

---

## 📌 Data Type Prefixes

### Basic Types

| Prefix | Type               |
|:----------|:------------------|
| `i`        | Integer (Int32)     |
| `i64`      | 64-bit Integer      |
| `f`        | Float/Double        |
| `s`        | String              |
| `b`        | Boolean             |
| `v`        | Variant (any type)  |
| `n`        | Null/Nothing        |

### Complex Types

| Prefix | Type                        |
|:----------|:-----------------------------|
| `o`        | Object (COM object)            |
| `h`        | Handle (window, file, etc.)    |
| `p`        | Pointer (memory address)       |
| `x`        | Hexadecimal/Binary value       |
| `d`        | DLLStruct/Structure            |
| `t`        | Tag (custom data type)         |
| `m`        | Map (associative array/dictionary) |

### Array Types

| Prefix | Type                            |
|:-----------|:----------------------------------|
| `ai`         | Array of Integers                   |
| `ai64`       | Array of 64-bit Integers            |
| `af`         | Array of Floats                     |
| `as`         | Array of Strings                    |
| `ab`         | Array of Booleans                   |
| `ao`         | Array of Objects                    |
| `ah`         | Array of Handles                    |
| `ap`         | Array of Pointers                   |
| `ax`         | Array of Hexadecimal/Binary values  |
| `ad`         | Array of DLLStructs                 |
| `at`         | Array of Tags                       |
| `av`         | Array of Variants                   |
| `am`         | Array of Maps                       |
| `amx`        | Array of Mixed types                |

### Multidimensional Arrays

Add the dimension count after the array type :

| Prefix | Example                      |
|:----------|:------------------------------|
| `ai2`        | 2D Array of Integers            |
| `as3`        | 3D Array of Strings             |
| `amx2`       | 2D Array of Mixed types         |

---

## 📌 Special Prefixes for Functions

| Prefix | Meaning                       |
|:----------|:----------------------------|
| `fn`        | Function reference/pointer    |
| `cb`        | Callback function             |

---

## 📌 GUI Control Prefixes

| Prefix | Meaning                         |
|:----------|:--------------------------------|
| `id`        | Control ID                        |
| `hnd`       | Control Handle                    |
| `gui`       | GUI Window reference               |
| `cbx`       | GUI Checkbox                       |
| `cb`        | GUI Combo                          |

---

## 📚 Examples

### Constants

```autoit
Global Const $GC_I_MAX_RETRIES = 5
Global Const $GC_S_APP_NAME = "MyApplication"
Global Const $GC_AI_VALUES = [1, 2, 3, 4]
```

### Variables

```autoit
; Basic types
Local $l_i_Counter = 0
Local $l_f_Price = 19.99
Local $l_s_Username = "JohnDoe"
Local $l_b_IsActive = True
Local $l_v_Result = Null

; Complex types
Local $l_h_Window = WinGetHandle("[CLASS:Notepad]")
Local $l_p_Memory = DllStructGetPtr($struct)
Local $l_o_Excel = ObjCreate("Excel.Application")
Local $l_m_Settings = ObjCreate("Scripting.Dictionary")

; Arrays
Local $l_ai_Numbers = [1, 2, 3, 4, 5]
Local $l_as_Names = ["Alice", "Bob", "Carol"]
Local $l_ai2_Matrix = [[1, 2], [3, 4]]
Local $l_amx_Data = [1, "text", True, 3.14]

; Static variables
Static $s_i_CallCount = 0
Static $s_ah_Handles[] = [0]

; Function arguments
Func ProcessData($a_as_InputData, $a_b_Validate = False)
    ; $a_as_InputData - Argument: array of strings
    ; $a_b_Validate - Argument: boolean with default value
EndFunc

; GUI controls
Global $g_id_ButtonOK = GUICtrlCreateButton("OK", 10, 10)
Global $g_hnd_ListView = GUICtrlGetHandle($g_id_ListView)
Global $g_cbx_Checkbox = GUICtrlCreateCheckbox("Standard Checkbox", 10, 10, 185, 25)
Global $g_cb_Combo = GUICtrlCreateCombo("Item 1", 10, 10, 185, 20)
```

### DLLStruct Example

```autoit
Local $l_d_Point = DllStructCreate("int X;int Y")
Local $l_ad_Points[10]
```

### Function References

```autoit
Local $l_fn_Callback = MyCallbackFunction
Local $l_cb_EventHandler = OnButtonClick
```

---

## ✅ Best Practices

- **Consistency**: Always follow the naming convention throughout your codebase.
- **Descriptive Names**: Use meaningful variable names that describe their purpose.
- **Case Sensitivity**: Use PascalCase for variable names, UPPERCASE for constants.
- **Length**: Keep names concise but descriptive.
- **Abbreviations**: Use common abbreviations consistently.
- **Hungarian Notation**: This convention is based on Hungarian notation principles adapted for AutoIt.

---

## 📖 Common Abbreviations

| Abbreviation | Meaning        |
|:-----------------|:----------------|
| Msg              | Message         |
| Btn              | Button          |
| Lbl              | Label           |
| Txt              | Text            |
| Dlg              | Dialog          |
| Win              | Window          |
| Ctrl             | Control         |
| Cfg              | Configuration   |
| Tmp              | Temporary       |
| Idx              | Index           |
| Cnt              | Count           |
| Avg              | Average         |
| Min              | Minimum         |
| Max              | Maximum         |

---

## ⚠️ Special Cases

### Error Codes

```autoit
Global Const $GC_I_ERROR_NONE = 0
Global Const $GC_I_ERROR_FILE_NOT_FOUND = 1
Global Const $GC_I_ERROR_ACCESS_DENIED = 2
```

### Configuration Constants

```autoit
Global Const $GC_S_INI_PATH = @ScriptDir & "\config.ini"
Global Const $GC_I_TIMEOUT_MS = 5000
```

### Temporary Variables

```autoit
Local $l_i_TmpResult = 0
Local $l_s_TmpBuffer = ""
```

---

## 📜 Version History

- **v1.0** — Initial documentation  
- **v2.0** — Added support for all AutoIt data types, GUI controls, and special cases  
