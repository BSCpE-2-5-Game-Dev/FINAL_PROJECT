
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

SOLID = 1          
ALTERNATE = 2       
SKIP = 3            
NONE = 4            

LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(2, 4)

    local numCols = 9 
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    local highestColor = math.random(1, 10)

    for y = 1, numRows do
        local skipPattern = math.random(1, 2) == 1 and true or false

        local alternatePattern = math.random(1, 2) == 1 and true or false
        
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)

        local skipFlag = math.random(2) == 1 and true or false

        local alternateFlag = math.random(2) == 1 and true or false

        local solidColor = math.random(1, highestColor)

        for x = 1, numCols do
            if skipPattern and skipFlag then
                
                skipFlag = not skipFlag

                goto continue
            else
               
                skipFlag = not skipFlag
            end

            b = Brick(
                
                (x-1)                   
                * 32                    
                
                + (9 - numCols) * 32,  
                
                y * 32,                  
                level
            )

            
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                
                alternateFlag = not alternateFlag
            end

            if not alternatePattern then
                b.color = solidColor
                
            end 

            if (level % 3) == 0 then
                if math.random(5) == 1 then                   
                    b.portal = true
                
                end
            end

            if (level % 4) == 0 then
                if math.random(6) == 1 then                   
                    b.hollow = true
                end
            end

            table.insert(bricks, b)

            ::continue::
        end
    end 

    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end