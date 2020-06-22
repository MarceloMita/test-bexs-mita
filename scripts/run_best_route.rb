require_relative '../src//route'

while 1
  print 'please enter the route: '
  route = gets
  begin
    best_route = Route.best_route({ route: route })
    puts "best route: #{best_route}"
  rescue => e
    puts e.message
  end
end
