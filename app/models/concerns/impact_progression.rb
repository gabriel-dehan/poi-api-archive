module ImpactProgression
  MAXIMUM_POINTS_PER_LEVEL = {
    1	=> 30,
    2	=> 50,
    3	=> 70,
    4	=> 90,
    5	=> 110,
    6	=> 140,
    7	=> 160,
    8	=> 180,
    9	=> 200,
    10 =>	220,
    11 =>	240,
    12 =>	270,
    13 =>	300,
    14 =>	330,
    15 =>	360,
    16 =>	400,
    17 =>	440,
    18 =>	490,
    19 =>	560,
    20 =>	630,
    21 =>	720,
    22 =>	820,
    23 =>	930,
    24 =>	1060,
    25 =>	1200
  }

  def maximum_points_for_level(level)
    MAXIMUM_POINTS_PER_LEVEL[level] * 100
  end
end