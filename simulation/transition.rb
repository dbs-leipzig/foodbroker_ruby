class Transition
  def Transition.happens? conf, mdos
    prob = conf['base'] 
    infl = conf['infl']
      
    mdos.each do |mdo|
      prob += infl if mdo.kind == :good
      prob -= infl if mdo.kind == :bad
    end
    
    prob = 0.0 if prob < 0
    prob = 1.0 if prob > 1
    
    prob >= rand(0.0..1.0)      
  end  
  
  def Transition.delay conf, mdos
    min = conf['min']
    max = conf['max']
    infl = conf['infl']
    
    delay = rand(min..max)
    
    mdos.each do |mdo|
      delay -= infl if mdo.kind == :good
      delay += infl if mdo.kind == :bad
    end
    
    delay = 0 if delay < 0
    
    delay
  end
  
  def Transition.variation conf, mdos
    
    base = conf['base']
    infl = conf['infl']
    
    mdos.each do |mdo|
      base += infl if mdo.kind == :good
      base -= infl if mdo.kind == :bad
    end  
    
    base.round 2
  end
  
  def Transition.random conf
    min = conf['min']
    max = conf['max']
    rand(min..max)
  end
end