import sys
import pyotherside
# We use a custom location
sys.path.append("/usr/share/harbour-sailmilight/python-milight/")
import milight


def setcolorWhite(ip, port, zone):
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.white(int(zone)))
    pyotherside.send('result', '[INFO] white = ON')


def setcolor(ip, port, zone, red, green, blue):
    red = int(red)
    green = int(green)
    blue = int(blue)
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0.025)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.color(milight.color_from_rgb(red, green, blue), int(zone)))
    pyotherside.send('result', '[INFO] RED=' + str(red) + ' GREEN=' + str(green) + ' BLUE=' + str(blue))


def switchoff(ip, port, zone):
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.off(int(zone)))
    pyotherside.send('result', '[INFO] light off')


def switchon(ip, port, zone):
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.on(int(zone)))
    pyotherside.send('result', '[INFO] light on')


def brightness(ip, port, zone, brightness):
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.brightness(brightness, int(zone)))
    pyotherside.send('result', '[INFO] brightness ' + str(brightness) + ' %')


def party(ip, port, zone, party_type):
    controller = milight.MiLight({'host': ip, 'port': int(port)}, wait_duration=0.025)  # Create a controller with 0 wait between commands
    light = milight.LightBulb(['rgbw'])  # Can specify which types of bulbs to use
    controller.send(light.party(party_type, int(zone)))
    pyotherside.send('result', '[INFO] party type ' + party_type + ' set')


def bridges():
    import bridges
    # find the wifi bridges
    dg = bridges.DiscoverBridge(port=48899).discover()
    addr = "not found"
    mac = "not found"
    for (addr, mac) in dg:
        print(' - ip address :' + addr + '\tmac: ' + mac)
    return addr, mac
