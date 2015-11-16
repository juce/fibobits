-- Fibobits

displayMode(OVERLAY)
displayMode(FULLSCREEN)

-- Use this function to perform your initial setup
function setup()
    A,B = 0,WIDTH
    mult = 1
    i = 0

    nums = {{ 1 }, { 1 }}
    for i=3,B do
        nums[i] = add(nums[i-2], nums[i-1])
    end
    print("prepped: " .. B)
    
    FPS()
end

function add(a, b)
    local c = {}
    local n = math.max(#a,#b)
    local carry = 0
    for i=1,n do
        c[i] = (a[i] or 0) + (b[i] or 0) + carry
        if c[i] > 1 then
            carry = 1
            c[i] = c[i] - 2
        else
            carry = 0 
        end
    end
    if carry > 0 then
        c[n+1] = 1
    end
    return c
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(2)

    -- Do your drawing here
    if fibImg then
        translate(WIDTH/2, HEIGHT/2)
        sprite(fibImg)
    else
        pushStyle()
        text("Preparing image ...", WIDTH/2, HEIGHT/2)
        stroke(85, 83, 140, 255)
        noFill()
        rect(WIDTH/2 - 150, HEIGHT/2 - 50, 300, 20)
        fill(95, 92, 111, 255)
        noStroke()
        rect(WIDTH/2 - 150, HEIGHT/2 - 50, 300*i/(B-A), 20)
        popStyle()

        co = co or coroutine.create(function()
            local img = image(WIDTH, HEIGHT)
            local count = 0
            local s = mult
            setContext(img)
            i = 1
            while i<=B-A do
                local b = nums[i+A]
                for j=1,#b do
                    count = count + 1 
                    if b[j] == 1 then
                        rect(i*s,j*s,s,s)
                    end
                    if count % 1000 == 0 then
                        setContext()
                        coroutine.yield()
                        setContext(img)
                    end
                end
                i = i + 1 
            end
            fibImg = img
            setContext()
        end)
        coroutine.resume(co)
    end
end

