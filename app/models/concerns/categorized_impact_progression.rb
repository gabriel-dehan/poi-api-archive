module CategorizedImpactProgression
  MAXIMUM_POINTS_PER_LEVEL = {
    1 => 20,
    2 => 25,
    3 => 30,
    4 => 35,
    5 => 40,
    6 => 45,
    7 => 50,
    8 => 55,
    9 => 60,
    10 => 65,
    11 => 70,
    12 => 75,
    13 => 80,
    14 => 85,
    15 => 90,
    16 => 95,
    17 => 100,
    18 => 105,
    19 => 110,
    20 => 115,
    21 => 120,
    22 => 125,
    23 => 130,
    24 => 135,
    25 => 140,
  }

  def maximum_points_for_level(level)
    MAXIMUM_POINTS_PER_LEVEL[level] * 100
  end
end