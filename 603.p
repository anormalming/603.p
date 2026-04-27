<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>火柴人語文跑酷 - 完整動作版</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-color: #f4f4f4;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            touch-action: manipulation;
        }
        #game-container {
            position: relative;
            width: 100vw;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }
        canvas {
            background-color: #ffffff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border-radius: 12px;
            max-width: 95%;
            touch-action: none;
        }
        .ui-overlay {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
            pointer-events: none;
            user-select: none;
            z-index: 5;
        }
        #menu-trigger {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 100;
            background: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            cursor: pointer;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        #menu-trigger span {
            display: block;
            width: 20px;
            height: 2px;
            background: #333;
        }
        #admin-trigger {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 100;
            background: white;
            padding: 8px;
            border-radius: 50%;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            cursor: pointer;
        }
        #lesson-menu {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 150;
        }
        .menu-content {
            background: white;
            padding: 2rem;
            border-radius: 1.5rem;
            width: 340px;
            max-height: 80vh;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            display: flex;
            flex-direction: column;
        }
        #lesson-list {
            overflow-y: auto;
            margin-bottom: 1rem;
        }
        #admin-panel {
            position: absolute;
            top: 0;
            right: 0;
            width: 360px;
            height: 100%;
            background: white;
            box-shadow: -5px 0 20px rgba(0,0,0,0.2);
            z-index: 101;
            display: none;
            flex-direction: column;
            padding: 20px;
            overflow-y: auto;
        }
        #quiz-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.95);
            display: none;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 20;
            padding: 20px;
        }
        #game-over, #win-screen {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.95);
            padding: 2.5rem;
            border-radius: 1.5rem;
            text-align: center;
            display: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            z-index: 30;
        }
        .option-btn, .menu-btn {
            background: white;
            border: 2px solid #e2e8f0;
            padding: 12px 20px;
            margin: 6px 0;
            border-radius: 12px;
            width: 100%;
            font-weight: bold;
            transition: all 0.2s;
            cursor: pointer;
            text-align: center;
        }
        .menu-btn:hover { background: #f1f5f9; border-color: #3b82f6; }
        .menu-btn.active { background: #3b82f6; color: white; border-color: #3b82f6; }
        .admin-input, .admin-select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .label-text {
            font-size: 12px;
            color: #666;
            font-weight: bold;
            margin-bottom: 2px;
            display: block;
        }
        .admin-lesson-item {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f9fafb;
            padding: 8px;
            border-radius: 8px;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

<div id="game-container">
    <div id="menu-trigger" onclick="toggleLessonMenu()">
        <span></span><span></span><span></span>
    </div>
    <div id="admin-trigger" onclick="toggleAdminPanel()">⚙️</div>

    <div id="lesson-menu" onclick="toggleLessonMenu()">
        <div class="menu-content" onclick="event.stopPropagation()">
            <h2 class="text-2xl font-black mb-4 text-gray-800">選擇課程</h2>
            <div id="lesson-list"></div>
            <button onclick="toggleLessonMenu()" class="mt-2 text-gray-400 text-sm underline">關閉</button>
        </div>
    </div>

    <div id="admin-panel" onmousedown="event.stopPropagation()" ontouchstart="event.stopPropagation()">
        <div class="flex justify-between items-center mb-4">
            <h3 class="font-black text-xl text-gray-800">管理者模式</h3>
            <button onclick="closeAdminPanel()" class="text-gray-400 hover:text-black">✕</button>
        </div>
        <div id="admin-auth-section">
            <p class="text-sm mb-2 text-gray-500">請輸入密碼：</p>
            <input type="password" id="admin-password" class="admin-input" placeholder="Password">
            <button onclick="authAdmin()" class="w-full bg-blue-600 text-white py-2 rounded font-bold">登入</button>
        </div>
        <div id="admin-controls" style="display: none;">
            <div class="mb-6 p-4 bg-blue-50 rounded-xl border border-blue-100">
                <h4 class="font-bold mb-3 text-blue-700">課程管理</h4>
                <div id="admin-lesson-manager" class="mb-4"></div>
                <div class="flex gap-2">
                    <input type="text" id="new-lesson-name" class="admin-input mb-0" placeholder="新課程名稱">
                    <button onclick="addNewLesson()" class="bg-blue-600 text-white px-3 py-1 rounded font-bold text-sm">新增</button>
                </div>
            </div>
            <div class="mb-6 p-4 bg-green-50 rounded-xl border border-green-100">
                <h4 class="font-bold mb-3 text-green-700">新增題目</h4>
                <label class="label-text">目標課程:</label>
                <select id="q-lesson-target" class="admin-select"></select>
                <label class="label-text">問題內容:</label>
                <input type="text" id="q-text" class="admin-input" placeholder="問題文字">
                <label class="label-text">選項 A (正確):</label>
                <input type="text" id="q-opt0" class="admin-input">
                <label class="label-text">其餘錯誤選項:</label>
                <input type="text" id="q-opt1" class="admin-input" placeholder="錯誤 1">
                <input type="text" id="q-opt2" class="admin-input" placeholder="錯誤 2">
                <input type="text" id="q-opt3" class="admin-input" placeholder="錯誤 3">
                <button onclick="addNewQuizForm()" class="w-full bg-green-600 text-white py-2 rounded font-bold">確認新增</button>
            </div>
        </div>
    </div>

    <div class="ui-overlay">
        <div id="current-lesson-badge" class="text-[10px] bg-white px-3 py-1 rounded-full mb-1 inline-block shadow-sm font-bold text-blue-600">尚未選擇課程</div>
        <div class="text-4xl font-black text-gray-800" id="score-display">0</div>
        <div class="text-[10px] text-amber-600 font-bold mt-2" id="progress-display">試煉進度: 0 / 0</div>
    </div>

    <canvas id="gameCanvas"></canvas>

    <div id="quiz-overlay">
        <p id="quiz-question" class="text-2xl font-black mb-8 text-center text-gray-800">問題載入中...</p>
        <div id="quiz-options" class="grid grid-cols-1 md:grid-cols-2 gap-2"></div>
    </div>

    <div id="game-over">
        <h1 class="text-4xl font-black text-red-600 mb-2">挑戰失敗</h1>
        <p id="fail-msg" class="mb-6 text-gray-500"></p>
        <button onclick="resetGame()" class="bg-black text-white px-10 py-3 rounded-full font-bold">重試</button>
    </div>
    <div id="win-screen">
        <h1 class="text-4xl font-black text-green-600 mb-6">本課達成！</h1>
        <button onclick="resetGame()" class="bg-green-600 text-white px-10 py-3 rounded-full font-bold">再玩一次</button>
    </div>
</div>

<script>
    const canvas = document.getElementById('gameCanvas');
    const ctx = canvas.getContext('2d');
    
    let GRAVITY = 0.65, JUMP_FORCE = -13, BASE_SPEED = 7, IS_INVINCIBLE = false;
    
    // 預設題目已根據要求修改
    let lessonData = {
        "l1": { 
            name: "第一課：語文基礎", 
            quizzes: [
                { q: "下列哪個是纖的造詞？", options: ["纖細", "祖纖", "纖人掌", "優纖"], correct: 0 }
            ]
        }
    };
    let activeLessonId = "l1";
    let isMenuOpen = false, isQuizActive = false, isGameOver = false;

    // --- 管理者功能 ---
    function authAdmin() {
        if (document.getElementById('admin-password').value === 'XU3TP6BJO4') {
            document.getElementById('admin-auth-section').style.display = 'none';
            document.getElementById('admin-controls').style.display = 'block';
            refreshAdminLessonUI();
        } else alert('密碼錯誤！');
    }

    function refreshAdminLessonUI() {
        const manager = document.getElementById('admin-lesson-manager');
        const select = document.getElementById('q-lesson-target');
        manager.innerHTML = '';
        select.innerHTML = '';
        Object.keys(lessonData).forEach(id => {
            const item = document.createElement('div');
            item.className = 'admin-lesson-item';
            item.innerHTML = `<input type="text" class="admin-input mb-0 flex-1" value="${lessonData[id].name}" onchange="renameLesson('${id}', this.value)">
                <button onclick="deleteLesson('${id}')" class="text-red-500 font-bold px-2">✕</button>`;
            manager.appendChild(item);
            const opt = document.createElement('option');
            opt.value = id; opt.innerText = lessonData[id].name;
            select.appendChild(opt);
        });
        refreshPlayerMenuUI();
    }

    function addNewLesson() {
        const name = document.getElementById('new-lesson-name').value.trim();
        if (!name) return;
        const id = "l" + Date.now();
        lessonData[id] = { name: name, quizzes: [] };
        document.getElementById('new-lesson-name').value = '';
        refreshAdminLessonUI();
    }

    function renameLesson(id, newName) {
        if (!newName.trim()) return;
        lessonData[id].name = newName;
        refreshAdminLessonUI();
        if (id === activeLessonId) updateBadge();
    }

    function deleteLesson(id) {
        if (!confirm('確定要刪除這堂課及其所有題目嗎？')) return;
        delete lessonData[id];
        if (activeLessonId === id) {
            const keys = Object.keys(lessonData);
            activeLessonId = keys.length > 0 ? keys[0] : null;
            updateBadge();
        }
        refreshAdminLessonUI();
    }

    function addNewQuizForm() {
        const id = document.getElementById('q-lesson-target').value;
        if (!id || !lessonData[id]) return alert('請先選擇或新增課程！');
        const qText = document.getElementById('q-text').value.trim();
        const opts = [
            document.getElementById('q-opt0').value.trim(),
            document.getElementById('q-opt1').value.trim(),
            document.getElementById('q-opt2').value.trim(),
            document.getElementById('q-opt3').value.trim()
        ];
        if (!qText || opts.some(o => !o)) return alert('請填寫完整題目！');
        lessonData[id].quizzes.push({ q: qText, options: opts, correct: 0 });
        alert('題目已新增！');
        document.getElementById('q-text').value = '';
        if (id === activeLessonId) resetGame();
    }

    function refreshPlayerMenuUI() {
        const list = document.getElementById('lesson-list');
        list.innerHTML = '';
        Object.keys(lessonData).forEach(id => {
            const btn = document.createElement('button');
            btn.className = `menu-btn ${id === activeLessonId ? 'active' : ''}`;
            btn.innerText = lessonData[id].name;
            btn.onclick = () => selectLesson(id);
            list.appendChild(btn);
        });
    }

    function toggleLessonMenu() {
        isMenuOpen = !isMenuOpen;
        document.getElementById('lesson-menu').style.display = isMenuOpen ? 'flex' : 'none';
        if (!isMenuOpen && !isGameOver && !isQuizActive) requestAnimationFrame(gameLoop);
    }

    function selectLesson(id) {
        activeLessonId = id;
        isMenuOpen = false;
        document.getElementById('lesson-menu').style.display = 'none';
        updateBadge();
        resetGame();
    }

    function updateBadge() {
        document.getElementById('current-lesson-badge').innerText = activeLessonId ? lessonData[activeLessonId].name : "尚未選擇課程";
    }

    // --- 遊戲邏輯核心 ---
    const GROUND_HEIGHT = 80;
    let score = 0, gameSpeed = BASE_SPEED, frameCount = 0, currentQuizIdx = 0;
    let stickman, obstacles, lightWalls, banners;
    let nextWallFrame = 0, nextBannerFrame = 0, bannerToggle = 0;

    class Stickman {
        constructor() {
            this.x = 100; this.y = 0; this.dy = 0;
            this.isGrounded = true; this.animFrame = 0;
            this.headRadius = 9; this.torsoLen = 28; this.limbLen = 22;
        }
        jump() { if (this.isGrounded) { this.dy = JUMP_FORCE; this.isGrounded = false; } }
        update() {
            this.dy += GRAVITY; this.y += this.dy;
            if (this.y > 0) { this.y = 0; this.dy = 0; this.isGrounded = true; }
            this.animFrame += 0.22 * (gameSpeed / 7);
        }
        draw() {
            const groundY = canvas.height - GROUND_HEIGHT;
            const currentY = groundY + this.y;
            ctx.strokeStyle = '#000'; ctx.lineWidth = 4; ctx.lineCap = 'round';
            const cycle = this.animFrame;
            
            // 身體重心起伏
            const hipX = this.x; 
            const hipY = currentY - this.torsoLen + 10 - (this.isGrounded ? Math.abs(Math.sin(cycle * 2)) * 4 : 0);
            const neckX = hipX + Math.sin(0.22) * this.torsoLen;
            const neckY = hipY - Math.cos(0.22) * this.torsoLen;

            // 關節角度計算
            let armAngleL = Math.sin(cycle) * 0.8, armAngleR = -Math.sin(cycle) * 0.8;
            let legAngleL = -Math.sin(cycle) * 0.9, legAngleR = Math.sin(cycle) * 0.9;
            if (!this.isGrounded) { armAngleL = 0.5; armAngleR = -1.2; legAngleL = -0.4; legAngleR = 0.6; }

            // 畫軀幹與頭
            ctx.beginPath(); ctx.moveTo(hipX, hipY); ctx.lineTo(neckX, neckY); ctx.stroke();
            ctx.beginPath(); ctx.arc(neckX + 3, neckY - this.headRadius, this.headRadius, 0, Math.PI * 2); ctx.stroke();

            // 畫肢體 (手跟腳都回來了)
            this.drawLimb(neckX, neckY, armAngleL - 0.2, this.limbLen, false);
            this.drawLimb(neckX, neckY, armAngleR - 0.2, this.limbLen, false);
            this.drawLimb(hipX, hipY, legAngleL, this.limbLen, true);
            this.drawLimb(hipX, hipY, legAngleR, this.limbLen, true);
        }
        drawLimb(startX, startY, angle, length, isLeg) {
            const midX = startX + Math.sin(angle) * length;
            const midY = startY + Math.cos(angle) * length;
            const flex = isLeg ? (angle < 0 ? -0.7 : 0.2) : 1;
            const endX = midX + Math.sin(angle + flex) * length;
            const endY = midY + Math.cos(angle + flex) * length;
            ctx.beginPath(); ctx.moveTo(startX, startY); ctx.lineTo(midX, midY); ctx.lineTo(endX, endY); ctx.stroke();
        }
    }

    class Obstacle {
        constructor() { this.x = canvas.width + 50; this.w = 30; this.h = 40+Math.random()*20; }
        update() { this.x -= gameSpeed; }
        draw() { ctx.fillStyle = IS_INVINCIBLE ? '#4ade80' : '#333'; ctx.fillRect(this.x, canvas.height-GROUND_HEIGHT-this.h, this.w, this.h); }
    }

    class LightWall {
        constructor() { this.x = canvas.width + 100; this.w = 80; }
        update() { this.x -= gameSpeed; }
        draw() {
            const g = ctx.createLinearGradient(this.x, 0, this.x+this.w, 0);
            g.addColorStop(0,'transparent'); g.addColorStop(0.5,'rgba(255,215,0,0.5)'); g.addColorStop(1,'transparent');
            ctx.fillStyle = g; ctx.fillRect(this.x, 0, this.w, canvas.height-GROUND_HEIGHT);
        }
    }

    class Banner {
        constructor(ti) {
            this.msg = ["學習是為了更遠的路", "這不是單純的遊戲，這是進步的過程"][ti%2];
            this.x = canvas.width+100; this.y = 100;
        }
        update() { this.x -= gameSpeed*0.5; }
        draw() {
            ctx.fillStyle = 'rgba(59,130,246,0.05)'; ctx.font = 'bold 20px sans-serif';
            const tw = ctx.measureText(this.msg).width;
            ctx.fillRect(this.x-10, this.y-25, tw+20, 35);
            ctx.fillStyle = '#3b82f6'; ctx.fillText(this.msg, this.x, this.y);
        }
    }

    function resetGame() {
        stickman = new Stickman(); obstacles = []; lightWalls = []; banners = [];
        score = 0; gameSpeed = BASE_SPEED; isGameOver = false; isQuizActive = false;
        frameCount = 0; currentQuizIdx = 0;
        nextWallFrame = 180; nextBannerFrame = 360; 
        document.getElementById('game-over').style.display = 'none';
        document.getElementById('win-screen').style.display = 'none';
        document.getElementById('quiz-overlay').style.display = 'none';
        const qCount = (activeLessonId && lessonData[activeLessonId]) ? lessonData[activeLessonId].quizzes.length : 0;
        document.getElementById('progress-display').innerText = `試煉進度: 0 / ${qCount}`;
        requestAnimationFrame(gameLoop);
    }

    function gameLoop() {
        if (isGameOver || isQuizActive || isMenuOpen) return;
        ctx.clearRect(0,0,canvas.width,canvas.height);
        ctx.strokeStyle = '#ddd'; ctx.beginPath(); ctx.moveTo(0, canvas.height-GROUND_HEIGHT); ctx.lineTo(canvas.width, canvas.height-GROUND_HEIGHT); ctx.stroke();

        if (frameCount >= nextBannerFrame) {
            banners.push(new Banner(bannerToggle++));
            nextBannerFrame = frameCount + 400 + Math.random()*100;
        }
        banners.forEach((b,i) => { b.update(); b.draw(); if(b.x < -500) banners.splice(i,1); });

        const bank = activeLessonId ? lessonData[activeLessonId].quizzes : [];
        if (frameCount >= nextWallFrame && currentQuizIdx < bank.length && lightWalls.length === 0) {
            lightWalls.push(new LightWall());
        }
        lightWalls.forEach((w,i) => {
            w.update(); w.draw();
            if (stickman.x > w.x + w.w/2) { isQuizActive = true; showQuiz(bank[currentQuizIdx]); }
        });

        if (frameCount % 100 === 0 && lightWalls.length === 0) obstacles.push(new Obstacle());
        obstacles.forEach((obs,i) => {
            obs.update(); obs.draw();
            if (!IS_INVINCIBLE && stickman.x+10 > obs.x && stickman.x < obs.x+obs.w && (canvas.height-GROUND_HEIGHT+stickman.y) > canvas.height-GROUND_HEIGHT-obs.h) {
                isGameOver = true; document.getElementById('fail-msg').innerText = "撞到了！再接再厲。";
                document.getElementById('game-over').style.display = 'block';
            }
            if (obs.x < -50) { obstacles.splice(i,1); score++; document.getElementById('score-display').innerText = score; }
        });

        stickman.update(); stickman.draw();
        frameCount++;
        requestAnimationFrame(gameLoop);
    }

    function showQuiz(qData) {
        document.getElementById('quiz-overlay').style.display = 'flex';
        document.getElementById('quiz-question').innerText = qData.q;
        const container = document.getElementById('quiz-options');
        container.innerHTML = '';
        const shuffled = qData.options.map((o,i) => ({text:o, correct:i===0})).sort(()=>Math.random()-0.5);
        shuffled.forEach(item => {
            const b = document.createElement('button'); b.className = 'option-btn'; b.innerText = item.text;
            b.onclick = () => {
                if (item.correct) {
                    currentQuizIdx++;
                    const bank = lessonData[activeLessonId].quizzes;
                    document.getElementById('progress-display').innerText = `試煉進度: ${currentQuizIdx} / ${bank.length}`;
                    isQuizActive = false; document.getElementById('quiz-overlay').style.display = 'none';
                    lightWalls = []; nextWallFrame = frameCount + 180 + Math.random()*100;
                    if (currentQuizIdx >= bank.length) { isGameOver = true; document.getElementById('win-screen').style.display = 'block'; }
                    else requestAnimationFrame(gameLoop);
                } else {
                    isGameOver = true; document.getElementById('fail-msg').innerText = "答錯了！請重新挑戰該課程。";
                    document.getElementById('game-over').style.display = 'block';
                    document.getElementById('quiz-overlay').style.display = 'none';
                }
            };
            container.appendChild(b);
        });
    }

    function closeAdminPanel() { document.getElementById('admin-panel').style.display = 'none'; }
    function toggleAdminPanel() {
        const p = document.getElementById('admin-panel');
        p.style.display = p.style.display === 'flex' ? 'none' : 'flex';
    }
    function resize() { canvas.width = Math.min(window.innerWidth*0.95, 800); canvas.height = 400; }
    window.addEventListener('resize', resize); resize();
    
    const handleInput = (e) => {
        if (isQuizActive || isMenuOpen || e.target.closest('#admin-panel')) return;
        if (e.type === 'touchstart' || e.code === 'Space' || (e.type === 'mousedown' && e.button === 0)) {
            stickman.jump();
            if(e.cancelable) e.preventDefault();
        }
    };
    window.addEventListener('keydown', handleInput);
    window.addEventListener('touchstart', handleInput, {passive:false});
    window.addEventListener('mousedown', handleInput);

    refreshPlayerMenuUI();
    updateBadge();
    resetGame();
</script>
</body>
</html>
