#!/usr/bin/env ruby
require 'set'


class Position
    def initialize(x, y)
        @x = x
        @y = y
    end
    attr_accessor :x
    attr_accessor :y

    def str
        return "(#{@x},#{@y})"
    end

    def distance(p)
        return Vector.new(x - p.x, y - p.y)
    end

    def angle(p)
        v = distance(p)
        v.standardize
        return v
    end

    def ==(o)
        o.class == self.class && o.state == state
    end

    def eql?(o)
        self == o
    end

    def hash
        state.hash
    end

    def state
        [@x, @y]
    end
end

class Vector < Position
    def standardize
        g = gcd(@x.abs(), @y.abs())
        if g != 0
            @x = x / g
            @y = y / g
        end
    end
end

def gcd(a, b)
    if a == 0
        return b
    end
    if b == 0
        return a
    end
    return gcd(b, a % b)
end

if __FILE__ == $0

    positions = []

    ARGF.each_with_index do |line, i|
        for j in 0...line.length-1
            character = line[j].chr
            if character == '#'
                positions << Position.new(i, j)
            end
        end
    end

    best = -1
    positions.each do |p1|
        s = Set[]
        positions.each do |p2|
            s << p1.angle(p2)
        end
        if s.length > best
            best = s.length
        end
    end

    puts best - 1
end
