CombatUI = {}

function CombatUI:renderCombatReport(playerId, combatData)
    -- Exemplo: Apresentação de texto básico no HUD
    local x, y = 0.5, 0.5 -- Posição no HUD

    for i, combat in ipairs(combatData.caused) do
        DrawText(string.format("Dano causado: %d | Nick: %s | Arma: %s",
            combat.damage,
            combat.targetNick,
            Config.WeaponNames[combat.weapon] or "Unknown"), x, y)
        y = y + 0.02 -- Incrementa para próxima linha
    end

    for i, combat in ipairs(combatData.received) do
        DrawText(string.format("Dano recebido: %d | Nick: %s | Arma: %s",
            combat.damage,
            combat.attackerNick,
            Config.WeaponNames[combat.weapon] or "Unknown"), x, y)
        y = y + 0.02
    end
end
