function out = crc_12_gsm(message, check)
%--settings-------
% width   = 12
% poly    = 0xd31
% init    = 0x000
% refin   = false
% refout  = false
% xorout  = 0xfff
% check   = 0xb34 for ASCII:"123456789"
% residue = 0x178
% name    = "CRC-12/GSM"
% Class: academic
% ETSI TS 100 909 version 8.9.0 (January 2005)
% - Full mathematical description (Section 5.1.5.1.4, p.72 — Section 5.1.6.1.4, p.75 —
%   Section 5.1.7.1.4, p.77 — Section 5.1.8.1.4, p.78 — Section 5.1.9.1.4, p.81 —
%   Section 5.1.10.1.4, p.85 — Section 5.1.11.1.4, p.87 — Section 5.1.12.1.4, p.91 — Section 5.1.13.1.4, p.93)

crc.width   = 12;
crc.poly    = [1 1 0 1   0 0 1 1   0 0 0 1];% x^12 + x^11 + x^10 + x^8 + x^5 + x^4 + x^0(0xd31)
crc.init    = false(1,length(crc.poly));% [0 0 0 0   0 0 0 0   0 0 0 0];% (0x000)
crc.residue = [0 0 0 1   0 1 1 1   1 0 0 0];% (0x178)
crc.refin   = false;
crc.refout  = false;
crc.xorout  = true(1,length(crc.poly));% [1 1 1 1   1 1 1 1   1 1 1 1];% (0xfff)
crc.mode    = check;
crc.message = message;

crc.calc_bin = crc_uni(crc.width, crc.poly, crc.init, crc.residue, crc.refin, crc.refout, crc.xorout, crc.mode, crc.message);

out = dec2hex(bin2dec(num2str((crc.calc_bin))),4);

end
