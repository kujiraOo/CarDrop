if application:getDeviceInfo() == "Android" then
	require 'admob'
	admob.loadAd("ca-app-pub-7537371229001021/9942377794", "interstitial")
end

application:setBackgroundColor(0xffffff)
application:setFps(30)

APP_WIDTH = 480
APP_HEIGHT = 320

DEVICE_WIDTH = application:getDeviceWidth()

DX = application:getLogicalTranslateX() / application:getLogicalScaleX()
DY = application:getLogicalTranslateY() / application:getLogicalScaleY()


print("SCALE X Y", application:getLogicalScaleX(), application:getLogicalScaleY())
print("DX", DX)
print("DY", DY)

Startup_pack = TexturePack.new("gfx/startup.txt", "gfx/startup.png")
