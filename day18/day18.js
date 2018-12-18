const readline = require('readline');

class Grid
{
    constructor(lines)
    {
        this.grid = lines;
        this.width = this.grid[0].length;
        this.height = this.grid.length;
    }

    cellAt(point)
    {
        return this.grid[point.y][point.x];
    }

    setCell(point, value)
    {
        this.grid[point.y][point.x] = value;
    }

    withinBounds(point)
    {
        return 0 <= point.x && point.x < this.width && 0 <= point.y && point.y < this.height;
    }

    countNeighbors(point)
    {
        let neighbors = {
            '#': 0,
            '|': 0,
            '.': 0
        };
        for(let y = point.y - 1; y <= point.y + 1; y++)
        {
            for(let x = point.x - 1; x <= point.x + 1; x++)
            {
                if((x != point.x || y != point.y) && this.withinBounds({ x: x, y: y }))
                {
                    //console.log("Neighbor :", this.cellAt({ x: x, y: y }));
                    neighbors[this.cellAt({ x: x, y: y })]++;
                }
            }
        }
        return neighbors;
    }

    clone()
    {
        const grid = JSON.parse(JSON.stringify(this.grid));
        return new Grid(grid);
    }

    toString()
    {
        return this.grid.map(row => row.join('')).join("\n");
    }

    resourceValue()
    {
        let count = {
            '#': 0,
            '|': 0
        };

        for(const row of this.grid)
        {
            for(const cell of row)
            {
                count[cell]++;
            }
        }
        return count['#'] * count['|'];
    }

    equals(other)
    {
        /*if(other.width != this.width)
        {
            return false;
        }
        if(other.height != this.height)
        {
            return false;
        }*/

        for(let y = 0; y < this.height; y++)
        {
            if(JSON.stringify(other.grid[y]) != JSON.stringify(this.grid[y]))
            {
                return false;
            }
        }
        return true;
    }
}

class Game
{
    constructor()
    {
        this.grid = {};
        this.history = [];
    }

    run(minutes)
    {
        let lines = [];
        const reader = readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            terminal: false
        });

        reader.on('line', line => {
            lines.push(line.split(''));
        });

        reader.on('close', () => {
            this.grid = new Grid(JSON.parse(JSON.stringify(lines)));
            this.solve(minutes);
        });
    }

    detectCycle(history)
    {
        const recent = history[history.length - 1];
        const length = history.length - 1;
        for(let i = 0; i < length; i++)
        {
            if(history[i].equals(recent))
            {
                return i;
            }
        }
        return -1;
    }

    solve(minutes)
    {
        //console.log(this.grid.toString());
        //console.log("\n");
        let history = [];
        let minute, cycleIndex = -1;

        for(minute = 0; minute < minutes; minute++)
        {
            let copy = this.grid.clone();
            history.push(copy);
            this.nextIteration(copy)

            cycleIndex = this.detectCycle(history);
            if(cycleIndex != -1)
            {
                console.log("Cycle detected : ", cycleIndex, " and ", minute);
                console.log(this.resolveCycle(history, cycleIndex, minute, minutes));
                return;
            }
        }
        console.log(this.grid.resourceValue());
    }

    resolveCycle(history, startedAt, detectedAt, minutes)
    {
        let resolvedAt = startedAt;
        let minute = detectedAt;
        for(let minute = detectedAt; minute < minutes; minute++)
        {
            if(++resolvedAt == detectedAt)
            {
                resolvedAt = startedAt;
            }
        }
        return history[resolvedAt].resourceValue();
    }

    nextIteration(current)
    {
        for(let y = 0; y < this.grid.height; y++)
        {
            for(let x = 0; x < this.grid.width; x++)
            {
                const currentPosition = { x: x, y: y };
                const neighbors = current.countNeighbors(currentPosition);
                switch(current.cellAt(currentPosition))
                {
                    case '|':
                        if(neighbors['#'] >= 3)
                        {
                            this.grid.setCell(currentPosition, '#');
                        }
                        break;
                    case '#':
                        this.grid.setCell(currentPosition, neighbors['#'] >= 1 && neighbors['|'] >= 1 ? '#' : '.');
                        break;
                    default:
                        if(neighbors['|'] >= 3)
                        {
                            this.grid.setCell(currentPosition, '|');
                        }
                        break;
                }
            }
        }
    }
}


const game = new Game();
game.run(10);
