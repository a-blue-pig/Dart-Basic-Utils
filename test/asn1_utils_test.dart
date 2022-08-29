import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/src/Asn1Utils.dart';
import 'package:pointycastle/asn1/primitives/asn1_octet_string.dart';
import 'package:test/test.dart';

void main() {
  var x509Pem = '''-----BEGIN CERTIFICATE-----
MIIFDTCCA/WgAwIBAgIQBxYr+XmB67PWzCkR7C39iDANBgkqhkiG9w0BAQsFADBA
MQswCQYDVQQGEwJVUzERMA8GA1UEChMIT0VNIFRlc3QxHjAcBgNVBAMTFUZ1bGwg
T0VNIFRlc3QgUlNBIFN1YjAeFw0xOTAzMTEwMDAwMDBaFw0yMDAzMTAxMjAwMDBa
MHsxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIEwZCYXllcm4xEzARBgNVBAcTClJlZ2Vu
c2J1cmcxFzAVBgNVBAoTDkludGVyTmV0WCBHbWJIMRQwEgYDVQQLEwtFbnR3aWNr
bHVuZzEXMBUGA1UEAxMOanVua2RyYWdvbnMuZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDDGv7+2oQyRWvFAt7UxtAQJB6zajegzrlvLLZ4+PhhJt6w
aSDW6IPV7H4uIvgL3cHP68AkATl+2fW0CEPy2i3vO27VDtxMp2oTk/IdPtVbNtZB
sjeFiNVzr7ZaD6z0u41WLEQbR34CmlWbggza3SS0tvPXD02YJpDz/Qm43hz0m+SJ
0IaesAM7b1tTbmlCxg3rm+CViU9wTsI9eUvOCZIjKS3E3MVcRJZTCCaZMp8JMKct
Ae4B90RunGbpvsYvWo4W4UQMFCVYcZp47FFeWcUnqx03nrSdP3LEEPcePVsRxPeB
ptsZzby9Wf7Sc2UNzTZSGjzxlpItgXdsjL4HiR/VAgMBAAGjggHGMIIBwjAfBgNV
HSMEGDAWgBS8odGV3/ZO7g4f11MzIg9X66vlUjAdBgNVHQ4EFgQUTriCU/8x5yQN
BoQPPYQcUVL7FUIwQQYDVR0RBDowOIIOanVua2RyYWdvbnMuZGWCEnd3dy5qdW5r
ZHJhZ29ucy5kZYISYXBpLmp1bmtkcmFnb25zLmRlMA4GA1UdDwEB/wQEAwIFoDAd
BgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwPgYDVR0fBDcwNTAzoDGgL4Yt
aHR0cDovL2NkcC5yYXBpZHNzbC5jb20vRnVsbE9FTVRlc3RSU0FTdWIuY3JsMEwG
A1UdIARFMEMwNwYJYIZIAYb9bAEBMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3
LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQICMHUGCCsGAQUFBwEBBGkwZzAmBggr
BgEFBQcwAYYaaHR0cDovL3N0YXR1cy5yYXBpZHNzbC5jb20wPQYIKwYBBQUHMAKG
MWh0dHA6Ly9jYWNlcnRzLnJhcGlkc3NsLmNvbS9GdWxsT0VNVGVzdFJTQVN1Yi5j
cnQwCQYDVR0TBAIwADANBgkqhkiG9w0BAQsFAAOCAQEAwCJAiSMJSYCIrJZdcLmY
zgH/Hd6VUDQzuo/s8Q+UoqpwyPwGnmNpovvzfjtz2+bF0dCQwUWerm61kYF/3IU6
ucrdTW4uS+T11tipJgDUBU8jEHvASe+QNIP7BiNoXCs10SfI8FQajL0HxnHY0vKC
AAQiFStLngxNYduyz4C3ZUjeNjt/8NhCUhd2GZGA6gveHKvck47ZWFbblecH8Odw
nhzR+ztf+lSGoyQW+egNlPog/OLjr//kKx7kjuuvXa5Os8oPLENu6LAjTZJqGvJP
ga7IcCj2gCeuTdS4Ibhx3hiew7cfuGa9XbVd5JJmV8kIoFlzLrZpKB4eVDKqaNWg
/g==
-----END CERTIFICATE-----''';

  test('Test dump()', () {
    Asn1Utils.dump(x509Pem);
  });

  test('Test complexDumpFromASN1Object()', () {
    var dump = Asn1Utils.complexDump(x509Pem);
    var sb = StringBuffer();
    var length = 0;
    for (var l in dump.lines!) {
      if (length < l.lineInfoToOpenSslString().length) {
        length = l.lineInfoToOpenSslString().length;
      }
    }

    for (var l in dump.lines!) {
      if (sb.isNotEmpty) {
        sb.write('\n');
      }
      sb.write(l.toOpenSslString(
          spacing: (length - l.lineInfoToOpenSslString().length) + 4));
    }
    print(sb.toString());

    // 0:d=0  hl=2 l=  20 prim: OCTET STRING      [HEX DUMP]:03DE503556D14CBB66F0A3E21B1BC397B23DD155
    // 04 14 03 DE 50 35 56 D1  4C BB 66 F0 A3 E2 1B 1B C3 97 B2 3D D1 55

    //0:d=0  hl=2 l=inf  cons: OCTET STRING
    //2:d=1  hl=2 l=   4 prim:  OCTET STRING      [HEX DUMP]:01234567
    //8:d=1  hl=2 l=   4 prim:  OCTET STRING      [HEX DUMP]:89ABCDEF
    //14:d=1  hl=2 l=   0 prim:  EOC
  });
}
