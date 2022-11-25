const ENEMY_ID = 1

// LEMBRE-SE QUE ENEMY ID EH HARD CODED, JA QUE AINDA NAO IMPLEMENTAMOS ENEMIES MANAGER

function handlePlayerHits(GameState, payload){
    if(!payload.hasOwnProperty("damage")) return

    GameState.enemies[ENEMY_ID].dealDamage(payload["damage"][ENEMY_ID]) 
    delete payload.damage
}


export {handlePlayerHits}