require 'set'
require 'matrix'

def readFile(path)
  file = File.open(path)
  lines = file.readlines.map(&:chomp)
  n = lines.size  # Ukuran matriks
  adjMatrix = Array.new(n) { Array.new(n, Float::INFINITY) }

  lines.each_with_index do |line, i|
    val = line.split.map { |x| x == "infinity" ? Float::INFINITY : x.to_f } # Ubah infinity ke Float::INFINITY
    adjMatrix[i] = val
  end

  [n, adjMatrix]
end

def TSP(i, s, adjMatrix, memo, startIdx)
  if s.empty?
    return adjMatrix[i][startIdx]  # Pastikan balik ke titik awal
  end
  return memo[[i, s]] if memo.key?([i, s])

  minCost = Float::INFINITY
  s.each do |j|
    next if adjMatrix[i][j] == Float::INFINITY

    s_ = s.dup
    s_.delete(j)
    cost = adjMatrix[i][j] + TSP(j, s_, adjMatrix, memo, startIdx)
    minCost = [minCost, cost].min
  end

  memo[[i, s]] = minCost
  minCost
end

def getPath(i, s, adjMatrix, memo, startIdx)
  if s.empty?
    return [startIdx]  # Pastikan balik ke titik awal
  end

  minCost = Float::INFINITY
  minPath = []

  s.each do |j|
    next if adjMatrix[i][j] == Float::INFINITY

    s_ = s.dup
    s_.delete(j)
    cost = adjMatrix[i][j] + TSP(j, s_, adjMatrix, memo, startIdx)
    if cost < minCost
      minCost = cost
      minPath = [j, *getPath(j, s_, adjMatrix, memo, startIdx)]
    end
  end

  minPath
end

def getRoute(start, n, adjMatrix, memo)
  s = Set.new(1...n) - [start]
  path = getPath(start, s, adjMatrix, memo, start)
  [start, *path]
end

title = <<ART
 ___  ___  ___    ___  ___  _    _ _  ___  ___ 
|_ _|/ __]| . \\  / __]| . || |  | | || __]| . \\
 | | \\__ \\|  _/  \\__ \\| | || |_ | | || _] |   /
 |_| [___/|_|    [___/`___'|___||__/ |___]|_\\_\\

                  13522053
                  
                                               
ART

puts title

puts "Input the file that want to be loaded (e.g., tes.txt):"
fileName = gets.chomp
file = File.join("..", "test", fileName)

n, adjMatrix = readFile(file)

puts "Enter the starting city index (1 to #{n}):"
startIdx = gets.to_i - 1

memo = {}
minCost = TSP(startIdx, Set.new((0...n).to_a - [startIdx]), adjMatrix, memo, startIdx)
route = getRoute(startIdx, n, adjMatrix, memo)
route = route.map { |x| x + 1 } 

puts "Most optimal TSP route is [ #{route.join(' - ')} ] with cost #{minCost}"
