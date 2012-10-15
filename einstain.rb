%w(color country drink smoke animal).each_with_index do |attr, index|
  eval <<-RUBY
    #{attr.upcase} = index
    def #{attr}
      WORLD[#{attr.upcase}]
    end
  RUBY
end

def define name, attrs
  eval("#{name} = #{attrs}")
  attrs.each_with_index do |attr, index|
    eval "#{attr} = #{index}"
  end
end

define "COUNTRIES", %w(Sweden Dutch England Norway Germany)
define "COLORS", %w(Red Green White Yellow Blue)
define "ANIMALS", %w(Dog Bird Horse Fish Cat)
define "DRINKS", %w(Tee Milk Beer Water Coffee)
define "SMOKES", %w(Pallmall Dunhill Marlboro Windfield Rothmans)

SIZE = 5

def elig pos, current_pos
  pos <= current_pos
end

def size arg, pos
  SIZE * arg + pos
end

def world_valid? current_pos
  if elig [size(COLOR, White), size(COLOR, Green)].max, current_pos
    return false unless color[White] == color[Green] + 1
  end
  if elig size(COUNTRY, Norway), current_pos
    return false unless 0 == country[Norway]
  end
  if elig [size(COUNTRY, Norway), size(COLOR, Blue)].max, current_pos
    return false unless (country[Norway] - 1 == color[Blue]) || (country[Norway] + 1 == color[Blue])
  end
  if elig [size(COUNTRY, England), size(COLOR, Red)].max, current_pos
    return false unless country[England] == color[Red]
  end
  if elig size(DRINK, Milk), current_pos
    return false unless 2 == drink[Milk]
  end
  if elig [size(COLOR, Green), size(DRINK, Coffee)].max, current_pos
    return false unless color[Green] == drink[Coffee]
  end
  if elig [size(COUNTRY, Dutch), size(DRINK, Tee)].max, current_pos
    return false unless country[Dutch] == drink[Tee]
  end
  if elig [size(SMOKE, Windfield), size(DRINK, Beer)].max, current_pos
    return false unless smoke[Windfield] == drink[Beer]
  end
  if elig [size(COLOR, Yellow), size(SMOKE, Dunhill)].max, current_pos
    return false unless color[Yellow] == smoke[Dunhill]
  end
  if elig [size(COUNTRY, Germany), size(SMOKE, Rothmans)].max, current_pos
    return false unless country[Germany] == smoke[Rothmans]
  end
  if elig [size(SMOKE, Marlboro), size(DRINK, Water)].max, current_pos
    return false unless (smoke[Marlboro] - 1 == drink[Water]) || (smoke[Marlboro] + 1 == drink[Water])
  end
  if elig [size(COUNTRY, Sweden), size(ANIMAL, Dog)].max, current_pos
    return false unless country[Sweden] == animal[Dog]
  end
  if elig [size(SMOKE, Pallmall), size(ANIMAL, Bird)].max, current_pos
    return false unless smoke[Pallmall] == animal[Bird]
  end
  if elig [size(SMOKE, Marlboro), size(ANIMAL, Cat)].max, current_pos
    return false unless (smoke[Marlboro] - 1 == animal[Cat]) || (smoke[Marlboro] + 1 == animal[Cat])
  end
  if elig [size(ANIMAL, Horse), size(COLOR, Blue)].max, current_pos
    return false unless animal[Horse] == color[Blue]
  end
  true
end

WORLD = [[], [], [], [], []]

def gen index
  (0..4).to_a.each do |attr1|
    WORLD[index][0] = attr1
    next unless world_valid? size(index, 0)
    (0..4).to_a.each do |attr2|
      WORLD[index][1] = attr2
      next if attr2 == attr1
      next unless world_valid? size(index, 1)
      (0..4).to_a.each do |attr3|
        WORLD[index][2] = attr3
        next if attr3 == attr2 || attr3 == attr1
        next unless world_valid? size(index, 2)
        (0..4).to_a.each do |attr4|
          WORLD[index][3] = attr4
          next if attr4 == attr3 || attr4 == attr2 || attr4 == attr1
          next unless world_valid? size(index, 3)
          (0..4).to_a.each do |attr5|
          WORLD[index][4] = attr5
            next if attr5 == attr4 || attr5 == attr3 || attr5 == attr2 || attr5 == attr1
            next unless world_valid? size(index, 4)
            yield
          end
        end
      end
    end
  end
end

gen(COLOR) do
  gen(COUNTRY) do
    gen(DRINK) do
      gen(SMOKE) do
        gen(ANIMAL) do
          (0..SIZE - 1).to_a.each do |index|
            puts "In house number #{index + 1} lives #{COUNTRIES[country.index index]} lives in #{COLORS[color.index index]} house, owns #{ANIMALS[animal.index index]}, drinks #{DRINKS[drink.index index]} and smokes #{SMOKES[smoke.index index]}"
          end
        end
      end
    end
  end
end

