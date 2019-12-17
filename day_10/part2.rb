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
        return distance(p).angle
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
        return self
    end

    def angle
        return Vector.new(x, y).standardize
    end

    def square_of_length
        return x * x + y * y
    end

    def quadrant
        if x > 0 and y >= 0
            return 2
        end
        if x <= 0 and y > 0
            return 3
        end
        if x < 0 and y <= 0
            return 4
        end
        if x >= 0 and y < 0
            return 1
        end
        return 0
    end
end

class Asteroid
    include Comparable

    def initialize(p, v, cycle)
        @p = p
        @v = v
        @cycle = cycle
    end

    attr_accessor :p
    attr_accessor :v
    attr_accessor :cycle

    def str
        return "#{p.x * 100 + p.y} (#{p.str}; distance=#{v.str} -> quadrant=#{v.quadrant} angle=#{v.angle.str}; cycle=#{cycle})"
    end

    def <=>(o)
        if cycle != o.cycle
            return cycle <=> o.cycle
        end
        q = v.quadrant
        oq = o.v.quadrant
        if q != oq
            return q <=> oq
        end
        return ccw(o.v, v)
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

def ccw(a, b)
    return (a.x * b.y - a.y * b.x) <=> 0
end

if __FILE__ == $0

    positions = []

    ARGF.each_with_index do |line, i|
        for j in 0...line.length-1
            character = line[j].chr
            if character == '#'
                positions << Position.new(j, i)
            end
        end
    end

    best = -1
    sol = nil
    positions.each do |p1|
        s = Set[]
        positions.each do |p2|
            s << p1.angle(p2)
        end
        if s.length > best
            best = s.length
            sol = p1
        end
    end

    # p1 = Position.new(11, 13)
    p1 = sol
    puts p1.str

    h = {}
    positions.each do |p2|
        if p2 == p1
            next
        end
        h[p1.angle(p2)] = []
    end
    positions.each do |p2|
        if p2 == p1
            next
        end
        h[p1.angle(p2)] << Asteroid.new(p2, p2.distance(p1), 0)
    end

    all_asteroids = []
    distance_compare = ->(a, b) { a.v.square_of_length <=> b.v.square_of_length }
    h.each do |(angle, asteroids)|
        asteroids.sort(&distance_compare).each_with_index do |asteroid, idx|
            all_asteroids << Asteroid.new(asteroid.p, asteroid.v, idx)
        end
    end

    all_asteroids = all_asteroids.sort()

    all_asteroids.each_with_index do |asteroid, idx|
        puts "#{idx+1}: #{asteroid.str}"
    end
end
