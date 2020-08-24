class Integer
    def prim?
        p = self.abs()
        return true if p == 2
        d = p - 1
        s = 0
        while d % 2 == 0
            d /= 2
            s += 1
        end
        20.times do
            a = 2 + rand(p - 4)
            x = modulare_exponentiation(a, d, p)
            if not (x == 1 || x == p - 1)
                (s-1).times do
                    x = modulare_exponentiation(x, 2, p)
                    break if x == p - 1
                end
                return false if x != p - 1
            end
        end
        return true
    end
    
    def text!
        text=""
        i=self
        while i>0
            text = (i&0xff).chr + text
            i >>= 8
        end
        return text
    end
end

class String
    def zahl!
        zahl = 0
        self.each_byte do |byte|
            zahl = zahl*256+byte
        end
        return zahl
    end
end

def modulare_exponentiation(basis, exponent, modul)
    ergebnis = 1
    while exponent > 0
        if exponent % 2 == 1
            ergebnis = (ergebnis * basis) % modul
        end
        basis = (basis * basis) % modul
        exponent >>= 1
    end
    return ergebnis
end

def zufällige_zahl(länge)
    mitte = ""
    (länge-2).times do
        mitte += rand(2).to_s
    end
    binär_text = "1" + mitte + "1"
    return binär_text.to_i(2)
end

def zufällige_primzahl(länge)
    while true
        zahl = zufällige_zahl(länge)
        if zahl.prim?
            return zahl
        end
    end
end

def erweiterter_euklidischer_algorithmus(a, b)
    if a % b == 0
        return [0,1]
    end
    t,s = erweiterter_euklidischer_algorithmus(b, a % b)
    return [s, t-s*(a / b)]
end

def berechne_d(p,q,e)
    phi = (p-1)*(q-1)
    s,t = erweiterter_euklidischer_algorithmus(e,phi)
    if s < 0
        s += phi
    end
    return s
end

def verschlüsseln
    puts "Gebe die Bitlänge der Primzahlen ein (übliche Werte: 256, 512, 1024):"
    i = gets.to_i
    p = zufällige_primzahl(i)
    q = zufällige_primzahl(i)
    while p==q
        q = zufällige_primzahl(i)
    end

    n = p*q
    e = 65537

    d = berechne_d(p,q,e)

    puts "Primzahl p:\n#{p}"
    puts "Primzahl q:\n#{q}"
    puts "Exponent:\n#{e}"
    puts "Öffentlicher Schlüssel N:\n#{n}"
    puts "Privater Schlüssel d:\n#{d}"
    puts "Gebe die zu verschlüsselnde Nachricht ein:"
    m = gets.chomp.zahl!
    if m.to_s(2).bytesize > n.to_s(2).bytesize
        puts "Nachricht ist zu lang. (Versuche gegebenenfalls eine größere Bitlänge der Primzahlen oder Teile die Nachricht in kleinere Blöcke auf)"
        return
    end
    
    c = modulare_exponentiation(m,e,n)
    puts "Nachricht als Zahl:\n#{m}"
    puts "Verschlüsselt als Zahl:\n#{c}"
    
    puts "Verschlüsselte Nachricht: "
    puts c.text!
end

def entschlüsseln
    puts "Gebe den öffentlichen Schlüssel N ein:"
    n = gets.to_i
    puts "Gebe den privaten Schlüssel d ein:"
    d = gets.to_i
    puts "Gebe die zu entschlüsselnde Nachricht als Zahl ein:"
    c = gets.to_i
    a = modulare_exponentiation(c,d,n)
    puts "Entschlüsselte Nachricht:"
    puts a.text!
end

nicht_beenden = true
while nicht_beenden
    puts "Gebe die \"1\" ein zum Verschlüsseln, die \"2\" zum Entschlüsseln oder die \"3\" zum Beenden:"
    case gets.to_i
    when 1
        verschlüsseln
    when 2
        entschlüsseln
    when 3
        nicht_beenden = false
    end
    puts "\n\n"
end
