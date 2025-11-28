#include-once

; Script Start - Add your code below here
Func Cache_SkillBar()
	If Map_GetInstanceInfo("Type") = 2 Then Return

	UAI_CacheSkillBar()

	For $l_i_i = 1 To 8
		$g_as_BestTargetCache[$l_i_i] = UAI_GetBestTargetFunc($l_i_i)
	Next

	For $l_i_i = 1 To 8
		$g_as_CanUseCache[$l_i_i] = UAI_GetCanUseFunc($l_i_i)
	Next

	For $l_i_i = 1 To 8
		Local $l_i_SkillID = UAI_GetStaticSkillInfo($l_i_i, $GC_UAI_STATIC_SKILL_SkillID)
		Out("Skill Name:          " & $GC_AMX2_SKILL_DATA[$l_i_SkillID][1])
		Out("    - SkillID:           " & $l_i_SkillID)
		Out("    - BestTarget:    " & $g_as_BestTargetCache[$l_i_i])
		Out("    - CanUse:         " & $g_as_CanUseCache[$l_i_i] & @CRLF)
	Next

	If $g_b_CacheWeaponSet Then UAI_DeterminateWeaponSets()
EndFunc   ;==>Cache_SkillBar

Func Cache_FormChangeBuild($a_i_SkillSlot)
	Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID)
		Case $GC_I_SKILL_ID_URSAN_BLESSING, $GC_I_SKILL_ID_VOLFEN_BLESSING, $GC_I_SKILL_ID_RAVEN_BLESSING
			UAI_CacheSkillBar()
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

Func Cache_EndFormChangeBuild($a_i_SkillSlot)
	Switch UAI_GetStaticSkillInfo($a_i_SkillSlot, $GC_UAI_STATIC_SKILL_SkillID)
		Case $GC_I_SKILL_ID_URSAN_STRIKE, $GC_I_SKILL_ID_URSAN_RAGE, $GC_I_SKILL_ID_URSAN_ROAR, $GC_I_SKILL_ID_URSAN_FORCE, $GC_I_SKILL_ID_Totem_of_Man
			Return False
		Case $GC_I_SKILL_ID_RAVEN_TALONS, $GC_I_SKILL_ID_RAVEN_SWOOP, $GC_I_SKILL_ID_RAVEN_SHRIEK, $GC_I_SKILL_ID_Raven_Flight
			Return False
		Case $GC_I_SKILL_ID_VOLFEN_CLAW, $GC_I_SKILL_ID_VOLFEN_POUNCE, $GC_I_SKILL_ID_VOLFEN_BLOODLUST, $GC_I_SKILL_ID_VOLFEN_AGILITY
			Return False
		Case Else
			UAI_CacheSkillBar()
			Return True
	EndSwitch
EndFunc

Func UAI_UpdateCache($a_f_AggroRange)
	UAI_UpdateAgentCache($a_f_AggroRange + 100)
	UAI_CacheAgentEffects()
	UAI_CacheAgentBuffs()
	UAI_CacheAgentVisibleEffects()
	UAI_UpdateDynamicSkillbarCache()
EndFunc
