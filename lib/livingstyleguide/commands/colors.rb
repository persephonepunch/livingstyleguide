LivingStyleGuide.command :colors do |arguments, options, content|
  colors = content.split(/\n+/).map{ |l| l.strip.split(/\s+/) }
  columns = colors.map{ |l| l.size }.max
  colors = colors.flatten

  document.scss << <<-SCSS
    $lsg--variables: () !default;
    $lsg--variables: join(
      $lsg--variables, (#{
        colors.reject{ |c| c == '-' }.map do |variable|
          %Q("#{variable}": #{variable})
        end.join(', ')
      })
    );
  SCSS

  colors_html = colors.map do |variable|
    if variable == "-"
      css_class = "-lsg-empty"
    end
    %Q(<li class="lsg--color-swatch #{css_class || variable}"><span>#{variable =~ /^(#[0-9a-f]{3,6}|[a-z]+)$/ ? "&nbsp;" : variable}</span></li>\n)
  end.join("\n")
  %(<ul class="lsg--color-swatches -lsg-#{columns}-columns">\n#{colors_html}\n</ul>\n)
end
