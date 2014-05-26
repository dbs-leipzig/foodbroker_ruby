class BusinessProcess
  
  def happens? conf_path, mdos
    prob = conf_path['base'] 
    infl = conf_path['infl']
      
    mdos.each do |mdo|
      prob += infl if mdo.kind == :good
      prob -= infl if mdo.kind == :bad
    end
    
    prob = 0.0 if prob < 0
    prob = 1.0 if prob > 1
    
    prob >= rand(0.0..1.0)      
  end  
  
  def delay conf_path, mdos
    min = conf_path['min']
    max = conf_path['max']
    infl = conf_path['infl']
    
    delay = rand(min..max)
    
    mdos.each do |mdo|
      delay -= infl if mdo.kind == :good
      delay += infl if mdo.kind == :bad
    end
    
    delay = 0 if delay < 0
    
    delay
  end
  
  def variation conf_path, mdos
    
    base = conf_path['base']
    infl = conf_path['infl']
    
    mdos.each do |mdo|
      base += infl if mdo.kind == :good
      base -= infl if mdo.kind == :bad
    end  
    
    base.round 2
  end
  
  def random conf_path
    min = conf_path['min']
    max = conf_path['max']
    rand(min..max)
  end
end