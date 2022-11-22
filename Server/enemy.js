function createEnemy(life){
    let enemy = {}
    enemy.life = life
    enemy.dealDamage = dealDamage
    return enemy
}


function dealDamage(damage){
    this.life -= damage
}

export {createEnemy}