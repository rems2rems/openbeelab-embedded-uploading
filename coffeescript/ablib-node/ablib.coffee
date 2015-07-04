# ablib.py 
#
# Python functions collection to easily manage the I/O lines and 
# Daisy modules with the following Acme Systems boards
# ARIETTA G25 SoM (http://www.acmesystems.it/arietta)
# ARIAG25-EK Board (http://www.acmesystems.it/ariag25ek)
# TERRA Board (http://www.acmesystems.it/terra)
# ARIA G25 SoM (http://www.acmesystems.it/aria) 
# ACQUA A5 SoM (http://www.acmesystems.it/acqua)
# FOX Board G20 (http://www.acmesystems.it/FOXG20)
#
# (C) 2014 Sergio Tanzilli <tanzilli@acmesystems.it>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

__version__ = 'v1.0.0'

require 'thread'
require 'select'
require 'math'

if process.platform.contains("Linux-2")
    legacy_id=true
else
    legacy_id=false

#Pin to Kernel ID table
pin2kid = {


#Arietta G25
    'J4.7'   :  55, #PA23
    'J4.8'   :  54, #PA22
    'J4.10'  :  53, #PA21
    'J4.11'  :  56, #PA24
    'J4.12'  :  63, #PA31
    'J4.13'  :  57, #PA25
    'J4.14'  :  62, #PA30
    'J4.15'  :  58, #PA26
    'J4.17'  :  59, #PA27
    'J4.19'  :  60, #PA28
    'J4.21'  :  61, #PA29
    'J4.23'  :  32, #PA0
    'J4.24'  :  33, #PA1
    'J4.25'  :  40, #PA8
    'J4.26'  :  39, #PA7
    'J4.27'  :  38, #PA6
    'J4.28'  :  37, #PA5
    'J4.29'  : 124, #PC28
    'J4.30'  : 123, #PC27
    'J4.31'  : 100, #PC4
    'J4.32'  : 127, #PC31
    'J4.33'  :  99, #PC3
    'J4.34'  :  75, #PB11
    'J4.35'  :  98, #PC2
    'J4.36'  :  76, #PB12
    'J4.37'  :  97, #PC1
    'J4.38'  :  77, #PB13
    'J4.39'  :  96, #PC0
    'J4.40'  :  78  #PB14
}

pinmode = {
    "OUTPUT" : "out",
    "INPUT" : "in",
    "PWM" : "out"
}

pinlevel = {
    "HIGH" : 1,
    "LOW"  : 0
}

pwmIds = {
    "J4.34"   :    0
    "J4.36"   :    1
    "J4.38"   :    2
    "J4.40"   :    3
}

getVersion  = ()->
    return __version__

get_gpio_path = (kernel_id)->

    kernel_id=kernel_id-32  
    
    if (legacy_id==true)
        iopath="/sys/class/gpio/gpio#{kernel_id+32}"
    else
        iopath="/sys/class/gpio/pio" 
        if kernel_id>=0 and kernel_id<=31
            iopath="#{iopath}A#{kernel_id-0}"
        if kernel_id>=32 and kernel_id<=63
            iopath="#{iopath}B#{kernel_id-32}"
        if kernel_id>=64 and kernel_id<=95
            iopath="#{iopath}C#{kernel_id-64}"
        if kernel_id>=96 and kernel_id<=127
            iopath="#{iopath}D#{kernel_id-96}"
        if kernel_id>=128 and kernel_id<=159
            iopath="#{iopath}E#{kernel_id-128}"
    return iopath       


get_kernel_id = (connector_name,pin_number)->
    return pinname2kernelid(connector_name + "." +pin_number)


_export = (kernel_id)->

    iopath=get_gpio_path(kernel_id)
    if not fs.existsSync(iopath)
        f = open('/sys/class/gpio/export','w')
        if (legacy_id==true)
            f.write(str(kernel_id))
        else
            f.write(str(kernel_id-32))
        f.close()

unexport = (kernel_id)->

    iopath=get_gpio_path(kernel_id)
    if fs.existsSync(iopath)
        f = open('/sys/class/gpio/unexport','w')
        if (legacy_id==true)
            f.write(str(kernel_id))
        else
            f.write(str(kernel_id-32))
        f.close()

direction = (kernel_id,direct)->
    iopath=get_gpio_path(kernel_id)
    if fs.existsSync(iopath)
        f = open(iopath + '/direction','w')
        f.write(direct)
        f.close()

set_value = (kernel_id,value)->
    iopath=get_gpio_path(kernel_id)
    if fs.existsSync(iopath)
        f = open(iopath + '/value','w')
        f.write(str(value))
        f.close()

get_value = (kernel_id)->
    if kernel_id != -1
        iopath=get_gpio_path(kernel_id)
        if fs.existsSync(iopath)
            f = open(iopath + '/value','r')
            a=f.read()
            f.close()
            return parseInt(a,10)

set_edge = (kernel_id,value)->
    iopath=get_gpio_path(kernel_id)
    if fs.existsSync(iopath)
        if value in ['none', 'rising', 'falling', 'both']
            f = open(iopath + '/edge','w')
            f.write(value)
            f.close()

soft_pwm_export = (kernel_id)->
    iopath='/sys/class/soft_pwm/pwm' + str(kernel_id)
    if not fs.existsSync(iopath)
        f = open('/sys/class/soft_pwm/export','w')
        f.write(str(kernel_id))
        f.close()

soft_pwm_period = (kernel_id,value)->
    iopath='/sys/class/soft_pwm/pwm' + str(kernel_id)
    if fs.existsSync(iopath)
        f = open(iopath + '/period','w')
        f.write(str(value))
        f.close()

soft_pwm_pulse = (kernel_id,value)->
    iopath='/sys/class/soft_pwm/pwm' + str(kernel_id)
    if fs.existsSync(iopath)
        f = open(iopath + '/pulse','w')
        f.write(str(value))
        f.close()

soft_pwm_steps = (kernel_id,value)->
    iopath='/sys/class/soft_pwm/pwm' + str(kernel_id)
    if fs.existsSync(iopath)
        f = open(iopath + '/pulses','w')
        f.write(str(value))
        f.close()

class Pin
    """
    FOX and AriaG25 pins related class
    """
    kernel_id=null
    fd=null

    constructor = (pin,mode)->

        @kernel_id=pin2kid[pin]
        direction(@kernel_id,pinmode[mode])

        if mode in ["INPUT","OUTPUT"]
            _export(@kernel_id)

            iopath=get_gpio_path(@kernel_id)
            if fs.existsSync(iopath)
                @fd = open(iopath + '/value','r')
        else
            soft_pwm_export(@kernel_id)

    high = ()->
        set_value(@kernel_id,1)
        
    low = ()->
        set_value(@kernel_id,0)

    digitalWrite = (level)->
        set_value(@kernel_id,pinlevel[level])

    digitalRead = ()->
        return get_value(@kernel_id)


    wait_edge = (fd,callback,debouncingtime)->
        debouncingtime=debouncingtime/1000.0 # converto in millisecondi
        timestampprec=Math.floor(Date.now() / 1000)
        counter=0
        po = select.epoll()
        po.register(fd,select.EPOLLET)
        while true
            events = po.poll()
            timestamp=Math.floor(Date.now() / 1000)
            if (timestamp-timestampprec>debouncingtime) and counter>0
                callback()
            counter=counter+1
            timestampprec=timestamp

    set_edge = (value,callback,debouncingtime=0)->
        if @fd!=null
            set_edge(@kernel_id,value)
            thread.start_new_thread(@wait_edge,[@fd,callback,debouncingtime])
            return
        else
            thread.exit()