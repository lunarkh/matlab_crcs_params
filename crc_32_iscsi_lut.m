function crc = crc_32_iscsi_lut(message)
%--settings-------
% width   = 32
% poly    = 0x1EDC6F41
% init    = 0xFFFFFFFF
% refin   = true
% refout  = true
% xorout  = 0xFFFFFFFF
% check   = 0xE3069283 for ASCII:"123456789"
% residue = 0xB798B438
% name    = "CRC-32/ISCSI"
% Class: attested
% Alias: CRC-32/BASE91-C, CRC-32/CASTAGNOLI, CRC-32/INTERLAKEN, CRC-32C
% IETF RFC 7143 (April 2014)
% - Full definition (except Check) (Section 13.1, pp.230–1)
% The Interlaken Alliance (7 October 2008), Interlaken Protocol Definition, version 1.2
% - Definition: Width, Poly (Section 5.4.6, p.33)
% - Definition: Init, RefIn, RefOut, XorOut (Appendix B, p.48)
% Dipl. Inf. Johann F. Löfflmann (30 July 2006), Jacksum 1.7.0
% - Implementation
% Greg Cook (30 December 2018), Base91 level 1 version 3.01
% - Implementation
% - Full mathematical description
% - All parameters
% - Code: C
% Mark Bakke, Julian Satran, Venkat Rangan (May–June 2001), IP Storage Mailing List thread
% - All parameters (except Residue) (Bakke, Rangan)
% - Definition: Width, Poly, Init, XorOut (Satran)
% - Code: C (Rangan)
% - 3 codewords (Bakke)
%   - 00000000​00000000​00000000​00000000​00000000​00000000​00000000​00000000​AA36918A
%   - FFFFFFFF​FFFFFFFF​FFFFFFFF​FFFFFFFF​FFFFFFFF​FFFFFFFF​FFFFFFFF​FFFFFFFF​43ABA862
%   - 00010203​04050607​08090A0B​0C0D0E0F​10111213​14151617​18191A1B​1C1D1E1F​4E79DD46

info_len = length(message);
vbit = 4;%hex(4bit)

bit_vector = false(1, (vbit*info_len));
for i = 1:info_len
    bit_vector(1, (1+(vbit*(i-1))):vbit*i) = decimalToBinaryVector(hex2dec(message(i)), vbit);
end

crc_t  = true(1, 32); %init = 0xFFFFFFFF

crc_tbl = (['00000000' 'f26b8303' 'e13b70f7' '1350f3f4' 'c79a971f' '35f1141c' '26a1e7e8' 'd4ca64eb' ...%8
            '8ad958cf' '78b2dbcc' '6be22838' '9989ab3b' '4d43cfd0' 'bf284cd3' 'ac78bf27' '5e133c24' ...%16
            '105ec76f' 'e235446c' 'f165b798' '030e349b' 'd7c45070' '25afd373' '36ff2087' 'c494a384' ...%24
            '9a879fa0' '68ec1ca3' '7bbcef57' '89d76c54' '5d1d08bf' 'af768bbc' 'bc267848' '4e4dfb4b' ...%32
            '20bd8ede' 'd2d60ddd' 'c186fe29' '33ed7d2a' 'e72719c1' '154c9ac2' '061c6936' 'f477ea35' ...%40
            'aa64d611' '580f5512' '4b5fa6e6' 'b93425e5' '6dfe410e' '9f95c20d' '8cc531f9' '7eaeb2fa' ...%48
            '30e349b1' 'c288cab2' 'd1d83946' '23b3ba45' 'f779deae' '05125dad' '1642ae59' 'e4292d5a' ...%56
            'ba3a117e' '4851927d' '5b016189' 'a96ae28a' '7da08661' '8fcb0562' '9c9bf696' '6ef07595' ...%64
            '417b1dbc' 'b3109ebf' 'a0406d4b' '522bee48' '86e18aa3' '748a09a0' '67dafa54' '95b17957' ...%72
            'cba24573' '39c9c670' '2a993584' 'd8f2b687' '0c38d26c' 'fe53516f' 'ed03a29b' '1f682198' ...%80
            '5125dad3' 'a34e59d0' 'b01eaa24' '42752927' '96bf4dcc' '64d4cecf' '77843d3b' '85efbe38' ...%88
            'dbfc821c' '2997011f' '3ac7f2eb' 'c8ac71e8' '1c661503' 'ee0d9600' 'fd5d65f4' '0f36e6f7' ...%96
            '61c69362' '93ad1061' '80fde395' '72966096' 'a65c047d' '5437877e' '4767748a' 'b50cf789' ...%104
            'eb1fcbad' '197448ae' '0a24bb5a' 'f84f3859' '2c855cb2' 'deeedfb1' 'cdbe2c45' '3fd5af46' ...%112
            '7198540d' '83f3d70e' '90a324fa' '62c8a7f9' 'b602c312' '44694011' '5739b3e5' 'a55230e6' ...%120
            'fb410cc2' '092a8fc1' '1a7a7c35' 'e811ff36' '3cdb9bdd' 'ceb018de' 'dde0eb2a' '2f8b6829' ...%128
            '82f63b78' '709db87b' '63cd4b8f' '91a6c88c' '456cac67' 'b7072f64' 'a457dc90' '563c5f93' ...%136
            '082f63b7' 'fa44e0b4' 'e9141340' '1b7f9043' 'cfb5f4a8' '3dde77ab' '2e8e845f' 'dce5075c' ...%144
            '92a8fc17' '60c37f14' '73938ce0' '81f80fe3' '55326b08' 'a759e80b' 'b4091bff' '466298fc' ...%152
            '1871a4d8' 'ea1a27db' 'f94ad42f' '0b21572c' 'dfeb33c7' '2d80b0c4' '3ed04330' 'ccbbc033' ...%160
            'a24bb5a6' '502036a5' '4370c551' 'b11b4652' '65d122b9' '97baa1ba' '84ea524e' '7681d14d' ...%168
            '2892ed69' 'daf96e6a' 'c9a99d9e' '3bc21e9d' 'ef087a76' '1d63f975' '0e330a81' 'fc588982' ...%176
            'b21572c9' '407ef1ca' '532e023e' 'a145813d' '758fe5d6' '87e466d5' '94b49521' '66df1622' ...%184
            '38cc2a06' 'caa7a905' 'd9f75af1' '2b9cd9f2' 'ff56bd19' '0d3d3e1a' '1e6dcdee' 'ec064eed' ...%192
            'c38d26c4' '31e6a5c7' '22b65633' 'd0ddd530' '0417b1db' 'f67c32d8' 'e52cc12c' '1747422f' ...%200
            '49547e0b' 'bb3ffd08' 'a86f0efc' '5a048dff' '8ecee914' '7ca56a17' '6ff599e3' '9d9e1ae0' ...%208
            'd3d3e1ab' '21b862a8' '32e8915c' 'c083125f' '144976b4' 'e622f5b7' 'f5720643' '07198540' ...%216
            '590ab964' 'ab613a67' 'b831c993' '4a5a4a90' '9e902e7b' '6cfbad78' '7fab5e8c' '8dc0dd8f' ...%224
            'e330a81a' '115b2b19' '020bd8ed' 'f0605bee' '24aa3f05' 'd6c1bc06' 'c5914ff2' '37faccf1' ...%232
            '69e9f0d5' '9b8273d6' '88d28022' '7ab90321' 'ae7367ca' '5c18e4c9' '4f48173d' 'bd23943e' ...%240
            'f36e6f75' '0105ec76' '12551f82' 'e03e9c81' '34f4f86a' 'c69f7b69' 'd5cf889d' '27a40b9e' ...%248
            '79b737ba' '8bdcb4b9' '988c474d' '6ae7c44e' 'be2da0a5' '4c4623a6' '5f16d052' 'ad7d5351' ]);%256

for i = 1:8:length(bit_vector)
    table_index = bitxor(crc_t(25:32), bit_vector(i:i+7));% index calculator
    start_index = binaryVectorToDecimal(table_index) + 1;%  ^
    table_val = zeros(1,32);

    for j = 1:8% hex 2 bin array
        table_val(1, (1+(vbit*(j-1))):vbit*j) = decimalToBinaryVector(hex2dec(crc_tbl((((start_index*8)-7)+(j-1)))), vbit);
    end

    crc_t = ([0 0 0 0 0 0 0 0 crc_t(1:24)]);% (crc_t >> 8)
    crc_t = xor(crc_t, table_val);% crc32 xor table
end

crc = binaryVectorToHex(xor(crc_t, true(1,32)));% xorout = 0xFFFFFFFF
