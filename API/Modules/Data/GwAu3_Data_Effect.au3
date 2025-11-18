#include-once

Func Effect_GetEffectArg($a_i_SkillID, $a_s_Argument = "", $a_i_HeroNumber = 0)
	Switch $a_s_Argument
		Case "Duration"
			Local $l_i_Duration0 = Skill_GetSkillInfo($a_i_SkillID, "Duration0")
			Local $l_i_Duration15 = Skill_GetSkillInfo($a_i_SkillID, "Duration15")
			Local $l_i_AttrID = Skill_GetSkillInfo($a_i_SkillID, "Attribute")
			If Not $a_i_HeroNumber Then
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(-2, $a_i_SkillID, "AttributeLevel")
			Else
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_SkillID, "AttributeLevel")
			EndIf

			Return Round($l_i_Duration0 + (($l_i_Duration15 - $l_i_Duration0) / 15) * $l_i_AttrLevel)
		Case "Scale"
			Local $l_i_Scale0 = Skill_GetSkillInfo($a_i_SkillID, "Scale0") / 65536
			Local $l_i_Scale15 = Skill_GetSkillInfo($a_i_SkillID, "Scale15") / 65536
			Local $l_i_AttrID = Skill_GetSkillInfo($a_i_SkillID, "Attribute")
			If Not $a_i_HeroNumber Then
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(-2, $a_i_SkillID, "AttributeLevel")
			Else
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_SkillID, "AttributeLevel")
			EndIf

			Return Floor($l_i_Scale0 + (($l_i_Scale15 - $l_i_Scale0) / 15) * $l_i_AttrLevel)
		Case "BonusScale"
			Local $l_i_BonusScale0 = Skill_GetSkillInfo($a_i_SkillID, "BonusScale0") / 65536
			Local $l_i_BonusScale15 = Skill_GetSkillInfo($a_i_SkillID, "BonusScale15") / 65536
			Local $l_i_AttrID = Skill_GetSkillInfo($a_i_SkillID, "Attribute")
			If Not $a_i_HeroNumber Then
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(-2, $a_i_SkillID, "AttributeLevel")
			Else
				Local $l_i_AttrLevel = Agent_GetAgentEffectInfo(Party_GetMyPartyHeroInfo($a_i_HeroNumber, "AgentID"), $a_i_SkillID, "AttributeLevel")
			EndIf

			Return Floor($l_i_BonusScale0 + (($l_i_BonusScale15 - $l_i_BonusScale0) / 15) * $l_i_AttrLevel)
		Case Else
			Return 0
	EndSwitch
EndFunc