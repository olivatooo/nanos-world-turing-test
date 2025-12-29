// Page Management
let currentPage = 'gameUI';
let isTransitioning = false;
let currentGameStage = null; // Track current game stage

function showPage(pageName, skipTransition = false) {
    if (isTransitioning && !skipTransition) return;

    const pages = document.querySelectorAll('.page');
    const targetPage = document.getElementById(pageName);

    if (!targetPage || currentPage === pageName) return;

    // Play page transition sound
    if (!skipTransition) {
        playRandomUISound(0.12, 'page-transition');
    }

    // Instant transition - no delays
    pages.forEach(page => page.classList.remove('active', 'fade-out'));
    targetPage.classList.add('active');
    currentPage = pageName;
    updateTabNavigation();
    isTransitioning = false;
}

// Update tab navigation visibility and active states
function updateTabNavigation() {
    return
    const tabNav = document.getElementById('tabNav');
    const tabButtons = document.querySelectorAll('.tab-button');

    // Show tab nav only on gameUI, scorePage, and shopPage
    if (['gameUI', 'scorePage', 'shopPage'].includes(currentPage)) {
        tabNav.style.display = 'flex';

        // Update active tab
        tabButtons.forEach(button => {
            button.classList.remove('active');
            const buttonText = button.textContent.toLowerCase();
            if (
                (currentPage === 'gameUI' && buttonText === 'game') ||
                (currentPage === 'scorePage' && buttonText === 'score') ||
                (currentPage === 'shopPage' && buttonText === 'shop')
            ) {
                button.classList.add('active');
            }
        });
    } else {
        tabNav.style.display = 'none';
    }
}


// Game UI Theme Switching
current_theme = 'blue';

function setTheme(theme) {
    if (current_theme === theme) return;
    current_theme = theme;
    const gameUI = document.getElementById('gameUI');
    // const tabNav = document.getElementById('tabNav');
    const roleText = document.getElementById('roleText');
    const body = document.body;
    const howToPlayFaker = document.getElementById('howToPlayFaker');
    const howToPlayHunter = document.getElementById('howToPlayHunter');

    // Play theme change sound
    playRandomUISound(0.15, 'theme-change');

    // Apply theme to game UI
    gameUI.classList.remove('theme-blue', 'theme-red');
    gameUI.classList.add(`theme-${theme}`);

    // Apply theme to body (affects all pages via CSS variables)
    body.classList.remove('theme-blue', 'theme-red');
    if (theme === 'red') {
        body.classList.add('theme-red');
    }

    // Apply theme to tab navigation
    // if (tabNav) {
    //     tabNav.classList.remove('theme-blue', 'theme-red');
    //     tabNav.classList.add(`theme-${theme}`);
    // }

    // Update role text based on theme
    if (roleText) {
        if (theme === 'blue') {
            roleText.textContent = 'FAKER';
        } else if (theme === 'red') {
            roleText.textContent = 'HUNTER';
        }
    }

    // Update how-to pages theme
    if (howToPlayFaker) {
        howToPlayFaker.classList.remove('theme-blue', 'theme-red');
        howToPlayFaker.classList.add('theme-blue');
    }
    if (howToPlayHunter) {
        howToPlayHunter.classList.remove('theme-blue', 'theme-red');
        howToPlayHunter.classList.add('theme-red');
    }

    // Update skill icons based on theme
    updateSkillIcons(theme);

    // If in PreparingMatch stage, update the how-to page to show the correct theme
    if (currentGameStage === 2) {
        showHowToPlayByStage(2);
    }
}

// Update skill icons based on theme
function updateSkillIcons(theme) {
    const skills = document.querySelectorAll('.skill');
    skills.forEach(skill => {
        const icon = skill.querySelector('.skill-icon');
        if (icon) {
            const iconAttr = theme === 'blue' ? 'data-icon-blue' : 'data-icon-red';
            const newIconSrc = skill.getAttribute(iconAttr);
            if (newIconSrc) {
                icon.src = newIconSrc;
            }
        }
        // Update cooldown attribute for activateSkill function
        const cooldownAttr = theme === 'blue' ? 'data-cooldown-blue' : 'data-cooldown-red';
        const cooldown = skill.getAttribute(cooldownAttr);
        if (cooldown) {
            skill.setAttribute('data-cooldown', cooldown);
        }
    });
}


// Show the appropriate How To Play page based on current theme
function showHowToPlay() {
    if (current_theme === 'red') {
        showPage('howToPlayHunter');
    } else {
        showPage('howToPlayFaker');
    }
}

// Show how-to pages based on game stage
function showHowToPlayByStage(stage) {
    currentGameStage = stage;

    if (stage === 1) {
        // WaitingForPlayers: Show both side by side
        showPage('howToPlayBoth');
    } else if (stage === 2) {
        // PreparingMatch: Show only the appropriate theme
        if (current_theme === 'red') {
            showPage('howToPlayHunter');
        } else {
            showPage('howToPlayFaker');
        }
    }
}

// Health Management
function setHealth(current, max) {
    const healthFill = document.getElementById('healthFill');
    const percentage = (current / max) * 100;

    healthFill.style.width = percentage + '%';
}

// Timer Management
function setTimer(seconds) {
    const timerValue = document.getElementById('timerValue');
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    timerValue.textContent = `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

// Objectives Management
function setObjectives(objectives) {
    const objectivesList = document.getElementById('objectivesList');
    objectivesList.innerHTML = '';
    objectives.forEach(obj => {
        const div = document.createElement('div');
        div.className = 'objective-item';
        div.textContent = '• ' + obj;
        objectivesList.appendChild(div);
    });
}

// Progress Objectives Management
function updateObjectivesProgress(amountOfTotalFakers, amountOfFakersKilled, amountOfTotalProps, amountOfPropsDelivered) {
    // Update Fakers Progress
    const fakersProgress = document.getElementById('fakersProgress');
    fakersProgress.innerHTML = '';

    for (let i = 0; i < amountOfTotalFakers; i++) {
        const icon = document.createElement('img');
        icon.src = 'Icons/domino-mask.svg';
        icon.classList.add('objectives-progress-icon');

        if (i < amountOfFakersKilled) {
            icon.classList.add('completed-red');
        } else {
            icon.classList.add('pending');
        }

        fakersProgress.appendChild(icon);
    }

    // Update Props Progress
    const propsProgress = document.getElementById('propsProgress');
    propsProgress.innerHTML = '';

    for (let i = 0; i < amountOfTotalProps; i++) {
        const icon = document.createElement('img');
        icon.src = 'Icons/hand-truck.svg';
        icon.classList.add('objectives-progress-icon');

        if (i < amountOfPropsDelivered) {
            icon.classList.add('completed-blue');
        } else {
            icon.classList.add('pending');
        }

        propsProgress.appendChild(icon);
    }
}

// Skills System with Cooldown
const skillCooldowns = {};

function activateSkill(skillElement) {
    const skillId = skillElement.getAttribute('data-skill');

    // Get cooldown based on current theme
    let cooldownTime = parseInt(skillElement.getAttribute('data-cooldown'), 10);

    // If data-cooldown is not set or is NaN, get it from theme-specific attribute
    if (isNaN(cooldownTime) || cooldownTime <= 0) {
        const cooldownAttr = current_theme === 'blue' ? 'data-cooldown-blue' : 'data-cooldown-red';
        cooldownTime = parseInt(skillElement.getAttribute(cooldownAttr), 10);
        if (isNaN(cooldownTime) || cooldownTime <= 0) {
            console.warn('Skill cooldown not found for skill', skillId);
            return;
        }
    }

    if (skillElement.classList.contains('on-cooldown')) {
        return;
    }


    // Start cooldown
    startCooldown(skillElement, cooldownTime);
}

function startCooldown(skillElement, duration) {
    duration = parseInt(duration, 10);
    if (isNaN(duration) || duration <= 0) {
        console.error('Invalid cooldown duration:', duration);
        return;
    }
    skillElement.classList.add('on-cooldown');

    const cooldownDiv = document.createElement('div');
    cooldownDiv.className = 'skill-cooldown';
    cooldownDiv.textContent = duration;
    skillElement.appendChild(cooldownDiv);

    let remaining = duration;
    const interval = setInterval(() => {
        remaining--;
        cooldownDiv.textContent = remaining;

        if (remaining <= 0) {
            clearInterval(interval);
            skillElement.classList.remove('on-cooldown');
            if (cooldownDiv.parentNode === skillElement) {
                skillElement.removeChild(cooldownDiv);
            }
        }
    }, 1000);
}

// Activate skill by theme and index
function activateSkillByTheme(theme, index) {
    // Validate theme
    if (theme !== 'blue' && theme !== 'red') {
        console.error('Invalid theme. Use "blue" or "red"');
        return;
    }

    // Validate index
    const skillIndex = parseInt(index, 10);
    if (isNaN(skillIndex) || skillIndex < 1 || skillIndex > 4) {
        console.error('Invalid skill index. Use 1, 2, 3, or 4');
        return;
    }

    // Find skill element by data-skill attribute
    const skillElement = document.querySelector(`.skill[data-skill="${skillIndex}"]`);
    if (!skillElement) {
        console.error(`Skill with index ${skillIndex} not found`);
        return;
    }

    // Early return if skill is already on cooldown
    if (skillElement.classList.contains('on-cooldown')) {
        return;
    }

    // Set theme if needed
    if (current_theme !== theme) {
        setTheme(theme);
    }

    // Activate the skill
    activateSkill(skillElement);
    Events.Call("Skill", theme, index);
}

// Add click handlers to skills
document.querySelectorAll('.skill').forEach(skill => {
    skill.addEventListener('click', function() {
        activateSkill(this);
    });
});

// Scoreboard Management
function updateScoreboard(players) {
    // Handle JSON string input
    if (typeof players === 'string') {
        try {
            players = JSON.parse(players);
        } catch (e) {
            console.error('Invalid JSON string for scoreboard:', e);
            return;
        }
    }

    // Ensure players is an array
    if (!Array.isArray(players)) {
        console.error('Scoreboard data must be an array');
        return;
    }

    const playerList = document.getElementById('playerList');
    if (!playerList) {
        console.error('Player list element not found');
        return;
    }

    playerList.innerHTML = '';

    // Sort players by score (descending)
    const sortedPlayers = [...players].sort((a, b) => {
        const scoreA = parseInt(a.score) || 0;
        const scoreB = parseInt(b.score) || 0;
        return scoreB - scoreA;
    });

    sortedPlayers.forEach((player, index) => {
        const div = document.createElement('div');
        div.className = 'player-item';

        // Handle avatar - check if it's a URL or emoji/text
        let avatarContent = '👤'; // Default fallback
        if (player.avatar) {
            avatarContent = `<img src="${player.avatar}" alt="${player.name || 'Player'}" class="player-avatar-img" onerror="this.parentElement.textContent='👤'">`;
        }

        div.innerHTML = `
            <div class="player-rank">#${index + 1}</div>
            <div class="player-avatar">${avatarContent}</div>
            <div class="player-info">
                <div class="player-name">${player.name || 'Unknown'}</div>
                <div class="player-stats">
                    <span>K/D: ${player.kills || 0}/${player.deaths || 0}</span>
                    <span>Deliveries: ${player.deliveries || 0}</span>
                </div>
            </div>
            <div class="player-score">${player.score || 0}</div>
            <div class="player-ping">${player.ping || 0}ms</div>
        `;
        playerList.appendChild(div);
    });
}

// Update scoreboard from JSON string or object
function updateScoreboardFromJSON(jsonData) {
    updateScoreboard(jsonData);
}

// End Screen Management
function setEndScreen(winner, stats) {
    document.getElementById('winnerText').textContent = winner;
    document.getElementById('endScore').textContent = stats.score || '0';
    document.getElementById('endKills').textContent = stats.kills || '0';
    document.getElementById('endDeaths').textContent = stats.deaths || '0';
    document.getElementById('endAccuracy').textContent = (stats.accuracy || '0') + '%';
}

// Show end page with winner, player stats, and scoreboard
function showEndPage(winner_team, my_team, number_of_objectives, score, amount_of_used_skills, round_scoreboard_json) {
    // Validate teams
    if (winner_team !== 'blue' && winner_team !== 'red') {
        console.error('Invalid winner_team. Use "blue" or "red"');
        return;
    }
    if (my_team !== 'blue' && my_team !== 'red') {
        console.error('Invalid my_team. Use "blue" or "red"');
        return;
    }

    const endScreen = document.getElementById('endScreen');
    const endContainer = document.querySelector('.end-container');
    const winnerText = document.getElementById('winnerText');
    const endConclusion = document.getElementById('endConclusion');
    const endScore = document.getElementById('endScore');
    const endObjectives = document.getElementById('endObjectives');
    const endObjectivesLabel = document.getElementById('endObjectivesLabel');
    const endSkillsUsed = document.getElementById('endSkillsUsed');

    // Set theme colors based on winner for end screen
    endScreen.classList.remove('theme-blue', 'theme-red');
    endScreen.classList.add(`theme-${winner_team}`);

    // Set conclusion theme based on player's team color (legacy support)
    endContainer.classList.remove('conclusion-blue', 'conclusion-red');
    endContainer.classList.add(`conclusion-${my_team}`);

    // Update winner announcement
    const winnerTeamName = winner_team === 'blue' ? 'FAKER' : 'HUNTER';
    winnerText.textContent = `${winnerTeamName} WINS!`;

    // Update conclusion based on whether player won - with win/loss styling
    const playerWon = winner_team === my_team;
    endConclusion.textContent = playerWon ? 'YOU WON' : 'YOU LOST';
    endConclusion.classList.remove('won', 'lost');
    endConclusion.classList.add(playerWon ? 'won' : 'lost');

    // Update score
    endScore.textContent = score || '0';

    // Update objectives based on player's team
    if (my_team === 'blue') {
        endObjectivesLabel.textContent = 'DELIVERIES';
    } else {
        endObjectivesLabel.textContent = 'BOTS KILLED';
    }
    endObjectives.textContent = number_of_objectives || '0';

    // Update skills used
    endSkillsUsed.textContent = amount_of_used_skills || '0';

    // Copy current scoreboard to end screen (overall scoreboard)
    const playerList = document.getElementById('playerList');
    const endScreenPlayerList = document.getElementById('endScreenPlayerList');
    if (playerList && endScreenPlayerList) {
        endScreenPlayerList.innerHTML = playerList.innerHTML;
    }

    // Update round scoreboard
    updateRoundScoreboard(round_scoreboard_json);

    // Show end screen page
    showPage('endScreen');
}

// Update round scoreboard
function updateRoundScoreboard(round_scoreboard_json) {
    const roundScoreboardList = document.getElementById('roundScoreboardList');
    if (!roundScoreboardList) {
        console.error('Round scoreboard list element not found');
        return;
    }

    // Parse JSON string
    let roundScoreboard = [];
    if (round_scoreboard_json && typeof round_scoreboard_json === 'string') {
        try {
            roundScoreboard = JSON.parse(round_scoreboard_json);
        } catch (e) {
            console.error('Failed to parse round scoreboard JSON:', e);
            return;
        }
    } else if (Array.isArray(round_scoreboard_json)) {
        roundScoreboard = round_scoreboard_json;
    }

    // Clear existing content
    roundScoreboardList.innerHTML = '';

    // Build round scoreboard
    roundScoreboard.forEach((player, index) => {
        const playerItem = document.createElement('div');
        playerItem.className = 'player-item';

        const rank = document.createElement('div');
        rank.className = 'player-rank';
        rank.textContent = `#${index + 1}`;

        const avatar = document.createElement('div');
        avatar.className = 'player-avatar';
        if (player.avatar) {
            const img = document.createElement('img');
            img.src = player.avatar;
            img.className = 'player-avatar-img';
            img.alt = player.name;
            avatar.appendChild(img);
        } else {
            avatar.textContent = '👤';
        }

        const info = document.createElement('div');
        info.className = 'player-info';

        const name = document.createElement('div');
        name.className = 'player-name';
        name.textContent = player.name || 'Unknown';

        const stats = document.createElement('div');
        stats.className = 'player-stats';
        const kdSpan = document.createElement('span');
        kdSpan.textContent = `K/D: ${player.kills || 0}/${player.deaths || 0}`;
        const deliveriesSpan = document.createElement('span');
        deliveriesSpan.textContent = `Deliveries: ${player.deliveries || 0}`;
        stats.appendChild(kdSpan);
        stats.appendChild(deliveriesSpan);

        info.appendChild(name);
        info.appendChild(stats);

        const score = document.createElement('div');
        score.className = 'player-score';
        score.textContent = player.score || 0;

        playerItem.appendChild(rank);
        playerItem.appendChild(avatar);
        playerItem.appendChild(info);
        playerItem.appendChild(score);

        roundScoreboardList.appendChild(playerItem);
    });

    // If no players, show message
    if (roundScoreboard.length === 0) {
        const noPlayersMsg = document.createElement('div');
        noPlayersMsg.className = 'no-players-message';
        noPlayersMsg.textContent = 'No players in this round';
        noPlayersMsg.style.textAlign = 'center';
        noPlayersMsg.style.padding = '20px';
        noPlayersMsg.style.color = '#b0b0b0';
        roundScoreboardList.appendChild(noPlayersMsg);
    }
}

// Shop Management
function buyItem(itemId) {
    playRandomUISound(0.3, 'purchase');
    // This can be hooked to Lua to handle the purchase
    // You can trigger an event here that Lua can listen to
}

function setShopItems(items) {
    const shopGrid = document.getElementById('shopGrid');
    shopGrid.innerHTML = '';

    items.forEach(item => {
        const div = document.createElement('div');
        div.className = 'shop-item';
        div.setAttribute('data-item-id', item.id);
        div.innerHTML = `
            <div class="shop-item-icon">${item.icon || '📦'}</div>
            <div class="shop-item-name">${item.name}</div>
            <div class="shop-item-price">$${item.price}</div>
            <div class="shop-item-description">${item.description}</div>
            <button class="shop-item-buy" onclick="buyItem(${item.id})">BUY NOW</button>
        `;
        shopGrid.appendChild(div);
    });
}

// Example usage and testing functions
function testUI() {
    // Test health
    setHealth(75, 100);

    // Test timer
    let time = 0;
    setInterval(() => {
        time++;
        setTimer(time);
    }, 1000);

    // Test objectives
    setObjectives([
        'Eliminate 5 enemies',
        'Capture point A',
        'Survive for 3 minutes'
    ]);
}

// Sound System
const uiSounds = [
    'SFX/1.ogg',
    'SFX/2.ogg'
];

let lastHoverSound = 0;
let hoverSoundCooldown = false;

// Play a random UI sound
function playRandomUISound(volume = 0.15, type = 'click') {
    try {
        const randomIndex = Math.floor(Math.random() * uiSounds.length);
        const soundPath = uiSounds[randomIndex];
        const audio = new Audio(soundPath);
        audio.volume = volume;
        audio.play().catch(err => {});
    } catch (err) {}
}

// Sound feedback hook (can be connected to Lua)
function playUISound(soundType) {
    // This can be hooked to play sounds via Lua
    playRandomUISound(0.15, soundType);
}

// Play hover sound with cooldown to avoid spam
function playHoverSound() {
    if (!hoverSoundCooldown) {
        playRandomUISound(0.08, 'hover');
        hoverSoundCooldown = true;
        setTimeout(() => {
            hoverSoundCooldown = false;
        }, 150); // 150ms cooldown between hover sounds
    }
}

// Enhanced button click handlers with sound
document.addEventListener('click', (e) => {
    // Check for clickable elements
    if (e.target.classList.contains('nav-button') ||
        e.target.classList.contains('tab-button') ||
        e.target.classList.contains('shop-item-buy') ||
        e.target.closest('.shop-item') ||
        e.target.closest('.player-item') ||
        e.target.classList.contains('skill')) {
        playRandomUISound(0.2, 'click');
    }
});

// Add hover sound effects
document.addEventListener('mouseover', (e) => {
    // Check for hoverable elements
    if (e.target.classList.contains('nav-button') ||
        e.target.classList.contains('tab-button') ||
        e.target.classList.contains('shop-item-buy') ||
        e.target.closest('.shop-item') ||
        e.target.closest('.player-item') ||
        e.target.classList.contains('skill')) {
        playHoverSound();
    }
});

// Play sound when activating skills
const originalActivateSkill = activateSkill;
activateSkill = function(skillElement) {
    playRandomUISound(0.25, 'skill');
    return originalActivateSkill.call(this, skillElement);
};

// Blindfold Management
let blindfoldInterval = null;
let blindfoldTimer = null;

function Blindfold(time_in_seconds) {
    const blindfoldOverlay = document.getElementById('blindfoldOverlay');
    const blindfoldProgressFill = document.getElementById('blindfoldProgressFill');
    
    if (!blindfoldOverlay || !blindfoldProgressFill) {
        console.error('Blindfold overlay elements not found');
        return;
    }

    // Clear any existing blindfold timer
    if (blindfoldInterval) {
        clearInterval(blindfoldInterval);
        blindfoldInterval = null;
    }
    if (blindfoldTimer) {
        clearTimeout(blindfoldTimer);
        blindfoldTimer = null;
    }

    // Validate time
    const duration = parseFloat(time_in_seconds);
    if (isNaN(duration) || duration <= 0) {
        console.error('Invalid blindfold duration:', time_in_seconds);
        return;
    }

    // Show overlay
    blindfoldOverlay.classList.add('active');
    
    // Reset progress bar
    blindfoldProgressFill.style.width = '100%';
    
    let remaining = duration;
    const updateInterval = 0.1; // Update every 100ms for smooth progress
    
    // Update progress bar
    blindfoldInterval = setInterval(() => {
        remaining -= updateInterval;
        if (remaining <= 0) {
            remaining = 0;
        }
        
        const percentage = (remaining / duration) * 100;
        blindfoldProgressFill.style.width = percentage + '%';
        
        if (remaining <= 0) {
            clearInterval(blindfoldInterval);
            blindfoldInterval = null;
        }
    }, updateInterval * 1000);

    // Hide overlay after duration
    blindfoldTimer = setTimeout(() => {
        blindfoldOverlay.classList.remove('active');
        if (blindfoldInterval) {
            clearInterval(blindfoldInterval);
            blindfoldInterval = null;
        }
        blindfoldTimer = null;
    }, duration * 1000);
}

// Expose functions to window for Lua integration
window.TuringTestUI = {
    showPage,
    showHowToPlay,
    showHowToPlayByStage,
    setTheme,
    setHealth,
    setTimer,
    setObjectives,
    updateObjectivesProgress,
    activateSkill,
    activateSkillByTheme,
    startCooldown,
    updateScoreboard,
    updateScoreboardFromJSON,
    setEndScreen,
    showEndPage,
    buyItem,
    setShopItems,
    playUISound,
    playRandomUISound,
    Blindfold
};

Events.Subscribe("playRandomUISound", playRandomUISound);
Events.Subscribe("playUISound", playUISound);
Events.Subscribe("setShopItems", setShopItems);
Events.Subscribe("buyItem", buyItem);
Events.Subscribe("setEndScreen", setEndScreen);
Events.Subscribe("showEndPage", showEndPage);
Events.Subscribe("updateScoreboard", updateScoreboard);
Events.Subscribe("updateScoreboardFromJSON", updateScoreboardFromJSON);
Events.Subscribe("startCooldown", startCooldown);
Events.Subscribe("activateSkill", activateSkill);
Events.Subscribe("activateSkillByTheme", activateSkillByTheme);
Events.Subscribe("setObjectives", setObjectives);
Events.Subscribe("updateObjectivesProgress", updateObjectivesProgress);
Events.Subscribe("setTimer", setTimer);
Events.Subscribe("setHealth", setHealth);
Events.Subscribe("setTheme", setTheme);
Events.Subscribe("showPage", showPage);
Events.Subscribe("showHowToPlay", showHowToPlay);
Events.Subscribe("showHowToPlayByStage", showHowToPlayByStage);
Events.Subscribe("Blindfold", Blindfold);


// Initialize themes for how-to pages
function initializeHowToPages() {
    const howToPlayFaker = document.getElementById('howToPlayFaker');
    const howToPlayHunter = document.getElementById('howToPlayHunter');

    if (howToPlayFaker) {
        howToPlayFaker.classList.remove('theme-blue', 'theme-red');
        howToPlayFaker.classList.add('theme-blue');
    }
    if (howToPlayHunter) {
        howToPlayHunter.classList.remove('theme-blue', 'theme-red');
        howToPlayHunter.classList.add('theme-red');
    }
}

// Initialize with gameUI page when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        showPage('gameUI', true);
        initializeHowToPages();
        updateSkillIcons(current_theme); // Initialize skill icons
    });
} else {
    // DOM already loaded
    showPage('gameUI', true);
    initializeHowToPages();
    updateSkillIcons(current_theme); // Initialize skill icons
}
