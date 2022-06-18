extends Node

func get_children():
	"""
	Only return the skills that a party member has learned according to
	their level
	"""
	var all_skills = .get_children()
	if len(all_skills) == 0:
		return []
		
	var character = get_parent() as Character
	var stats = character.stats as CharacterStats
	
	var learned = []
	for i in range(len(all_skills)):
		var skill = all_skills[i] as LearnedSkill
		if skill.level <= stats.level:
			learned.append(skill.skill)
	return learned
