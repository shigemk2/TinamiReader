# This file is automatically generated. Do not edit.

if Object.const_defined?('TestFlight') and !UIDevice.currentDevice.model.include?('Simulator')
  NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
  
  TestFlight.takeOff('187f4b17ae020249d7abafe6a47a1ded_MjgyODk4MjAxMy0xMC0wOCAwNjo1MToyMy41MjQ2MjI')
  end)
end