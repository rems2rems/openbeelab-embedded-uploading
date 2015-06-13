
doc = {}
doc.timestamp = "2010-01-02T21:05:11.805Z"

if doc.timestamp.indexOf("2010") != 0

    emit(doc.timestamp,doc)
    return

incorrect_date = new Date(doc.timestamp)

gap=140277288195

correct_date = new Date(incorrect_date.getTime() + gap)


toISODateString = (d)->
    pad = (n)->
        if n < 10 then return '0'+n
        return n

    return d.getUTCFullYear() + '-' + pad(d.getUTCMonth()+1) + '-' + pad(d.getUTCDate()) + 'T' + pad(d.getUTCHours()) + ':' + pad(d.getUTCMinutes()) + ':' + pad(d.getUTCSeconds()) + 'Z'

emit(toISODateString(correct_date),doc)

console.log "time="+toISODateString(correct_date)