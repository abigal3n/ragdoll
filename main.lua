armMass = 10
legMass = 20
armWidth = 20
armLength = 120
legWidth = 20
legLength = 200
gravity = 9.8
alpha1 = 0
alpha2 = 0
omega1 = 0
omega2 = 0
alpha3 = 0
alpha4 = 0
omega3 = 0
omega4 = 0
headAlpha = 0
headOmega = 0
armFg = armMass*gravity
headWidth = 200
headHeight = 200
headMass = 50

function getTorque(dist,force,theta)
    angle = math.sin(-theta)
    T = force*dist*angle
    return T
end

function getInertia(mass, L)
    I = (1/3)*mass*L*L
    return I
end

function getAlpha(dist, theta, mass, length)
    Fg = mass * gravity
    T = getTorque(dist,Fg,theta)
    I = getInertia(mass, length)
    alpha = T/I
    return alpha
end

torso = {mode = "fill", x=300, y=300, width=80, height=80, theta=math.rad(0)}
arm1 = {mode="fill", x=torso.x-armWidth, y=torso.y, width=armWidth, height=armLength, theta=math.rad(-20)}
arm2 = {mode="fill", x=torso.x+torso.width, y=torso.y, width=armWidth, height=armLength, theta=math.rad(20)}
leg1 = {mode="fill", x=torso.x, y=torso.y+torso.height, width=legWidth, height=legLength, theta= math.rad(-20)}
leg2 = {mode="fill", x=torso.x+torso.width-legWidth, y=torso.y+torso.height, width=legWidth, height=legLength, theta=math.rad(20)}
catObj = {img = "scaredcat.png", x=(torso.x+(torso.width/2)-70),y=torso.y-80, width=headWidth, height=headHeight, theta=math.rad(-20)}
function drawRotatedRectangle(mode,x,y,w,h,theta)
    love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(theta)
	love.graphics.rectangle(mode, 0, 0, w, h)
    love.graphics.pop()
end
function drawRotatedImage(img,x,y,theta, w)
    love.graphics.push()
    love.graphics.translate(x+(w/2)-30,y)
    love.graphics.rotate(theta)
    love.graphics.draw(img, (-w/2)+30, 0, 0, 0.2, 0.2)
    love.graphics.pop()
end

function drawLeftArm(mode,x,y,w,h,theta)
    love.graphics.push()
    love.graphics.translate(x+w,y)
    love.graphics.rotate(theta)
    love.graphics.rectangle(mode, -w, 0, w, h)
    love.graphics.pop()
end
function drawRightArm(mode,x,y,w,h,theta)
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(theta)
    love.graphics.rectangle(mode, 0, 0, w, h)
    love.graphics.pop()
end
function love.load()
    cat = love.graphics.newImage(catObj.img)
    love.graphics.setBackgroundColor(0.7,0.3,0.1)
    font = love.graphics.newFont(30)
    smallFont = love.graphics.newFont(10)
end
function love.update(dt)
    if love.keyboard.isDown("w") then
        torso.y = torso.y - 10 *dt
    end
    if love.keyboard.isDown("s") then
        torso.y = torso.y + 10 *dt
    end
    if love.keyboard.isDown("r") then
        arm1.theta = arm1.theta + omega * dt
    end
    T = getTorque(arm1.height/2, armFg, arm1.theta)
    I = getInertia(armMass,arm1.height)
    alpha1 = getAlpha(armLength/2, arm1.theta, armMass, armLength)
    omega1 = omega1 + alpha1 * dt
    alpha2 = getAlpha(armLength/2, arm2.theta, armMass, armLength)
    omega2 = omega2 + alpha2 * dt
    alpha3 = getAlpha(legLength/2, leg1.theta, legMass, legLength)
    omega3 = omega3 + alpha3 * dt
    alpha4 = getAlpha(legLength/2, leg2.theta, legMass, legLength)
    omega4 = omega4 + alpha4 * dt
    headAlpha = getAlpha(headWidth/2, catObj.theta, headMass, headWidth)
    headOmega = headOmega + headAlpha * dt
    arm1.theta = arm1.theta + omega1* dt
    arm2.theta = arm2.theta + omega2* dt
    leg1.theta = leg1.theta + omega3* dt
    leg2.theta = leg2.theta + omega4* dt
    catObj.theta = catObj.theta + headOmega* dt
    sin = math.sin(-arm1.theta)
end
function love.draw()
    love.graphics.setFont(smallFont)
    love.graphics.print(tostring(T), 300,300)
    love.graphics.print(tostring(sin), 500,300)
    love.graphics.setFont(font)
    love.graphics.print("GRAVITY CAT", 100,100)
    drawRotatedRectangle(torso.mode,torso.x,torso.y,torso.width,torso.height,torso.theta)
    drawLeftArm(arm1.mode,arm1.x,arm1.y,arm1.width,arm1.height,arm1.theta)
    drawRightArm(arm2.mode,arm2.x,arm2.y,arm2.width,arm2.height,arm2.theta)
    drawRotatedRectangle(leg1.mode,leg1.x,leg1.y,leg1.width,leg1.height,leg1.theta)
    drawRotatedRectangle(arm2.mode,leg2.x,leg2.y,leg2.width,leg2.height,leg2.theta)
    drawRotatedImage(cat, catObj.x, catObj.y, catObj.theta, headWidth)
    --love.graphics.draw(cat, catObj.x, catObj.y, 0, 0.2, 0.2)
end