#include-once

;~ Description: Drop a buff with specific skill ID targeting a specific agent
Func Effect_DropBuff($a_i_SkillID, $a_v_AgentID, $a_i_HeroNumber = 0)
    Return Core_SendPacket(0x8, $GC_I_HEADER_BUFF_DROP, Agent_GetAgentBuffInfo(Agent_ConvertID($a_v_AgentID), $a_i_SkillID, "BuffID"))
EndFunc   ;==>DropBuff