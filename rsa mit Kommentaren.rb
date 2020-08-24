class Integer
    def prim?                                                               #Das Herausfinden, ob eine Zahl prim ist mit dem Miller-Rabin-Test
        p = self.abs()                                                      #Zuerst wird der Betrag der Zahl in "p" gespeichert
        return true if p == 2                                               #Ist die Zahl eine 2, wird vorzeitig "true" zurückgegeben
        d = p - 1                                                           #Die Zahl "d", für die a^((2^s)*d)≡-1(mod p) gilt und die Zahl "s" als Anzahl möglicher Quadrierungen werden berechnet
        s = 0                                                               #Dazu wird "d" mit dem Anfangswert p-1 und "s" mit dem Anfangswert 0 erschaffen
        while d % 2 == 0                                                    #Anschließend wird in einer Schleife geguckt, wie oft sich "d" halbieren lässt ohne einen Rest zu habebn
            d /= 2                                                          #Dabei wird "d" in jedem Durchlauf halbiert
            s += 1                                                          #Und "s" wird in jedem Durchlauf um 1 größer
        end                                                                 #
        20.times do                                                         #An dieser Stelle folgt der eigentliche Test mit in diesem Fall 20 Wiederholungen
            a = 2 + rand(p - 4)                                             #Als erstes wird ein "a" mit einem zufälligen Anfangswert zwischen 2 und p-2 erschaffen
            x = modulare_exponentiation(a, d, p)                            #
            if not (x == 1 || x == p - 1)                                   #Wenn x=1 oder x=p-1 gilt kann das "a" dieses Durchlaufes nicht bezeugen, dass "p" nicht prim ist; der nachfolgende Teil wird nur ausgeführt, wenn dies nicht der Fall ist
                (s-1).times do                                              #Es beginnt hier eine Schleife die (s-1)-mal durchläuft
                    x = modulare_exponentiation(x, 2, p)                    #Es wird "x" quadriert modulo "p"
                    break if x == p - 1                                     #Sollte x=p-1 gelten, kann das derzeitige "a" nicht länger bezeugen, dass "p" prim sei. Deshalb wird in diesem Fall die Schleife vorzeitig abgebrochen
                end                                                         #
                return false if x != p - 1                                  #Sollte am Ende der Schleife gelten x≠p-1, so bezeugt "a", dass "p" nicht prim ist und es wird "false" zurückgegeben
            end                                                             #
        end                                                                 #
        return true                                                         #Sollte nach allen 20 Durchläufen nicht "false" zurückgegebene worden sein, so ist davon auszugehen, da "p" eine Primzahl sei und es wird "true" zurückgegeben
    end
    
    def text!                                                               #Umwandlung einer Zahl in einen entsprechenden Text
        text=""                                                             #
        i=self                                                              #In der Variable "i" wird der Wert der Zahl gespeichert.
        while i>0                                                           #Die Schleife läuft solange, bis die gesamte Zahl in Schrifftzeichen zerlegt ist
            text = (i&0xff).chr + text                                      #In jedem Durchlauf werden die letzten 8 Ziffern (0xff) der Binärdarstellung in ein entsprechendes Zeichen konvertiert
            i >>= 8                                                         #Die Zahl wird durch 2^8=256 geteilt, sodass im nächsten Durchlauf das nächste Zeichen aus der Zahl konvertiert werden kann
        end                                                                 #
        return text                                                         #Der zur Zahl gehörige Text wird zurückgegeben
    end
end

class String
    def zahl!                                                               #Umwandlung eines Textes in eine entsprechende Zahl
        zahl = 0                                                            #Variable "zahl" mit Anfangswert 0 wird erstellt
        self.each_byte do |byte|                                            #Es wird jeder Byte des Textes (Byte = 8 Bits -> 2^8), was einem Textzeichen (char) entspricht, in einer Schleife betrachtet
            zahl = zahl*256+byte                                            #Dabei wird der Wert der Zahl mit 2^8=256 multipliziert und das derzeitige Zeichen als Zahl addiert
        end                                                                 #So entsteht eine Zahl, aus der sich eindeutig die ursprünglichen Zeichen zurückberechnen lassen
        return zahl                                                         #Die Zahl die am Ende der Schleife entstanden ist wird zurückgegeben
    end
end

def modulare_exponentiation(basis, exponent, modul)                         #Berechnet basis^exponent mod modul
    ergebnis = 1                                                            #Es wird eine Variable mit dem Anfangswert 1 erstellt
    while exponent > 0                                                      #Es folgt eine Schleife, die solange läuft, bis der Wert in "exponent" nicht meht > 0 ist
        if exponent % 2 == 1                                                #Ist die letzte Ziffer der Binärdarstellung von "exponent" eine 1, so wird
            ergebnis = (ergebnis * basis) % modul                           #der Wert von Ergebnis neu berechnet als ergebnis*basis mod modul
        end                                                                 #
        basis = (basis * basis) % modul                                     #In jedem Durchlauf wird die "basis" quadriert modulo "modul"
        exponent >>= 1                                                      #Und der "exponent" um die letzte Ziffer der Binärdarstellung gekürzt; "exponent" wird durch 2 geteilt unter Vernachlässigung des Rests
    end                                                                     #
    return ergebnis                                                         #Das "ergebnis" wird zurückgegeben
end

def zufällige_zahl(länge)                                                   #Eine binäre Zahl mit "länge"-Anzahl an bits wird erstellt und dezimal zurückgegeben
    mitte = ""                                                              #Der letzte Bit sollte eine 1 sein, da nur ungerade Zahlen (außer 2) prim sind und der erste Bit muss eine 1 sein, da sonst die Länge ("länge"-1)-Bits wäre
    (länge-2).times do                                                      #Deswegen werden ("länge"-2)-Bits zwischen der 1 am Anfang und Ende in einer Schleife zufällig erstellt
        mitte += rand(2).to_s                                               #Dazu wird der Text in "mitte" in jedem Durchlauf um einen String "0" oder "1" erweitert
    end                                                                     #
    binär_text = "1" + mitte + "1"                                          #Zuletzt wird ein neuer Text "binär_text" erzeugt mit einer 1 vor und nach dem text aus "mitte"
    return binär_text.to_i(2)                                               #Zurückgegeben wird die in eine Dezimalzahl umgewandelte Binärzahl aus dem Text "binär_text"
end

def zufällige_primzahl(länge)                                               #Die Methode erstellt solange zufällige Zahlen der Bit-Anzahl "länge", bis eine Primzahl dabei heraus kommt
    while true                                                              #Solange bis eine entsprechende Primzahl gefunden wurde, iteriert die Schleife unendlich weiter
        zahl = zufällige_zahl(länge)                                        #Eine zufällige Zahl der Bit-Anzahl "länge" wird erstellt und in "zahl" gespeichert
        if zahl.prim?                                                       #
            return zahl                                                     #Wenn die Zahl in "zahl" eine Primzahl ist, wird diese zurück gegeben
        end                                                                 #
    end                                                                     #Ansonsten startet die Schleife von vorne
end

def erweiterter_euklidischer_algorithmus(a, b)                              #Die Methode gibt gemäß dem erweiterten euklidischen Algorithmus die Koeffizienten s und t zurück, für die ggT(a,b)=sa+tb gilt
    if a % b == 0                                                           #Abbruchbedingung
        return [0,1]                                                        #Sobald der ggT gefunden wurde wird t=0 und s=1 zurückgegeben; Beginn des rekursiven Aufstiegs
    end                                                                     #
    t,s = erweiterter_euklidischer_algorithmus(b, a % b)                    #ReKursiver Aufruf/Abstieg, solange der ggT noch nicht gefunden wurde; Aufruf entsprechend dem euklidischen Algorithmus
    return [s, t-s*(a / b)]                                                 #Rekursiver Aufstieg, bei dem wie beschrieben die Koeffizienten s und t berechnet und schlussendlich zurückgegeben werden
end

def berechne_d(p,q,e)                                                       #Es wird der Private Schlüssel/Exponent berechnet
    phi = (p-1)*(q-1)                                                       #Es wird 𝜑(p*q) berechnet und in "phi" gespeichert
    s,t = erweiterter_euklidischer_algorithmus(e,phi)                       #Es werden die Faktoren "s" und "t" berechnet, für die gilt: s*e+t*phi=1
    if s < 0                                                                #
        s += phi                                                            #Sollte der Wert in "s" negativ sein, muss "phi" addiert werden um das modulo multiplikative Inverse zu erhalten
    end                                                                     #
    return s                                                                #Das modulo multiplikative Inverse zu "e" bezüglich 𝜑(N) wird zurückgegeben
end

def verschlüsseln
    puts "Gebe die Bitlänge der Primzahlen ein (übliche Werte: 256, 512, 1024):"
    i = gets.to_i
    p = zufällige_primzahl(i)                                               #Primzahl "p" wird erstellt
    q = zufällige_primzahl(i)                                               #Primzahl "q" wird erstellt
    while p==q                                                              #
        q = zufällige_primzahl(i)                                           #Im nahezu ausgeschlossenen Fall, dass beide Primzahlen die selbe Zahl sind, wird "q" eine neue Primzahl zugewiesen
    end

    n = p*q                                                                 #Öffentlichen Schlüssel n=p*q berechnen
    e = 65537                                                               #Öffentlicher Exponent

    d = berechne_d(p,q,e)                                                   #Privaten Schlüssel/Exponenten berechnen

    puts "Primzahl p:\n#{p}"
    puts "Primzahl q:\n#{q}"
    puts "Exponent:\n#{e}"
    puts "Öffentlicher Schlüssel N:\n#{n}"
    puts "Privater Schlüssel d:\n#{d}"
    puts "Gebe die zu verschlüsselnde Nachricht ein:"
    m = gets.chomp.zahl!
    if m.to_s(2).bytesize > n.to_s(2).bytesize
        puts "Nachricht ist zu lang. (Versuche gegebenenfalls eine größere Bitlänge der Primzahlen oder Teile die Nachricht in kleinere Blöcke auf)"
        return                                                              #Methode abbrechen
    end
    
    c = modulare_exponentiation(m,e,n)                                      #Der Text wird verschlüsselt: c = m^e mod N
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
    a = modulare_exponentiation(c,d,n)                                      #Der Text wird entschlüsselt: m = c^d mod N
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
