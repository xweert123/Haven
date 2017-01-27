#include "threatcheck.as"

void Init() {
    SavedLevel @level = save_file.GetSavedLevel("haven_campaign");
    level.SetValue("current_level",GetCurrLevel());
    save_file.WriteInPlace();
}

void Dispose() {
}

float blackout_amount = 0.0;
float ko_time = -1.0;
float win_time = -1.0;
bool sent_level_complete_message = false;

void Update() {
    int player_id = GetPlayerCharacterID();
	
	blackout_amount = 0.0;
	if(player_id != -1 && ObjectExists(player_id)){
		MovementObject@ char = ReadCharacter(player_id);
		if(char.GetIntVar("knocked_out") != _awake){
			if(ko_time == -1.0f){
				ko_time = the_time;
			}
			if(ko_time < the_time - 1.0){
				if(GetInputPressed(0, "attack") || ko_time < the_time - 5.0){
	            	level.SendMessage("reset"); 				
				}
			}
            blackout_amount = 0.2 + 0.6 * (1.0 - pow(0.5, (the_time - ko_time)));
		} else {
			ko_time = -1.0f;
		}
	}
}

void PreDraw(float curr_game_time) {
    camera.SetTint(camera.GetTint() * (1.0 - blackout_amount));
}

void Draw(){
    if(EditorModeActive()){
        Object@ obj = ReadObjectFromID(hotspot.GetID());
        DebugDrawBillboard("Data/Custom/xweert123/haven/UI/nutshack.png",
                           obj.GetTranslation(),
                           obj.GetScale()[1]*2.0,
                           vec4(vec3(0.5), 1.0),
                           _delete_on_draw);
    }
}