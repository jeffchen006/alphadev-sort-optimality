# n=5 model=out iset=I1 prefix14_class=9424
mov S0, P3
cmp P3, P0
cmovle P3, P0
cmovl P0, S0
mov S2, P2
cmp P1, S2
cmovge P2, P1
cmovle S2, P1
mov S1, S2
cmp S1, P0
cmovge S1, P0
cmovge P0, S2
cmp P3, P2
cmovle S0, P3
