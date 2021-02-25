
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end


function GenerateQuadsBricks(atlas)
    bricks = {}
    bricks = table.slice(GenerateQuads(atlas, 32, 32), 1, 10)
    table.insert( bricks, GenerateQuads(atlas, 32, 32)[14])
    table.insert( bricks, GenerateQuads(atlas, 32, 32)[13])
    return bricks
end

function GenerateQuadsBalls(atlas)
    local x = 64
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 64
    y = 72

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
end